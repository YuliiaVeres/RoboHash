//
//  ViewController.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/10/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIViewController.h"
#import "RHIConstants.h"
#import "RHIRequestManager.h"
#import "RHIViewController+InitialImages.h"

@interface RHIViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *robotImageView;
@property (weak, nonatomic) IBOutlet UITextField *robotTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSDate *currentTime;
@property (strong, nonatomic) NSTimer *inputTimer;

@end

@implementation RHIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cache = [NSCache new];
    self.currentTime = [NSDate date];
    
    [self trackInitialLaunch];
}

#pragma mark - Timer related

- (void)sendFinalRequest:(NSTimer *)timer
{
    [self.inputTimer invalidate];
    self.robotImageView.image = nil;
    
    BOOL shouldObtainImage = self.robotTextField.text.length > 0;
    if (shouldObtainImage)
        [self obtainRobotForString:self.robotTextField.text];
}

#pragma mark - Image obtain request

- (void)obtainRobotForString:(NSString *)requestString
{
    BOOL loadedAsInitialImage = [[NSUserDefaults standardUserDefaults] boolForKey:requestString];
    
    UIImage *cachedImage = [self.cache objectForKey:requestString];
    if (cachedImage)
        self.robotImageView.image = cachedImage;
    else if (loadedAsInitialImage)
        [self loadInitialImageWithName:requestString];
    else
        [self fireRequestFor:requestString];
}

- (void)loadInitialImageWithName:(NSString *)imageName
{
    NSLog(@"Loading image from directory : %@", imageName);
    
    __weak __typeof(self)weakSelf = self;
    
    NSDate *hey = [NSDate date];
    
    [self loadImageFromDirectoryForString:imageName withCompletion:^(UIImage *loadedImage) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Time passed for load : %f", [hey timeIntervalSinceNow]);
            
            typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.robotImageView.image = loadedImage;
        });
    }];
}

- (void)fireRequestFor:(NSString *)requestString
{
    NSLog(@"Obtaining image for : %@", requestString);
    [self.activityIndicator startAnimating];
    
    __weak typeof(self)weakSelf = self;
    
    [[RHIRequestManager sharedInstance] obtainRobotImageForString:requestString withCompletion:^(NSData *imageData, NSString *robotString) {
        
        typeof(weakSelf)strongSelf = weakSelf;
        
        UIImage *robotImage = [UIImage imageWithData:imageData];
        [strongSelf.cache setObject:robotImage forKey:robotString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.activityIndicator stopAnimating];
            
            if ([robotString isEqualToString:strongSelf.robotTextField.text])
                strongSelf.robotImageView.image = robotImage;
        });
    }];
}

#pragma mark - UITextFiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.currentTime = [NSDate date];
    
    [self.inputTimer invalidate];
    self.inputTimer = [NSTimer scheduledTimerWithTimeInterval:RHIMinimumTypeInterval target:self selector:@selector(sendFinalRequest:) userInfo:nil repeats:NO];
    
    return YES;
}

#pragma mark - Tap gesture

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

@end
