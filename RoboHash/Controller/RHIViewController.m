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
    UIImage *cachedImage = [self.cache objectForKey:requestString];
    if (cachedImage)
    {
        NSLog(@"Retrieving image from cache for: %@", requestString);
        
        self.robotImageView.image = cachedImage;
        return;
    }
    
    NSLog(@"Obtaining image for : %@", requestString);
    
    [self.activityIndicator startAnimating];
    
    __weak __typeof(self)weakSelf = self;
    
    [[RHIRequestManager sharedInstance] obtainRobotImageForString:requestString withCompletion:^(UIImage *robotImage, NSString *robotString) {
        
        typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.cache setObject:robotImage forKey:robotString];
        
        if (![robotString isEqualToString:strongSelf.robotTextField.text] && robotImage)
            return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.activityIndicator stopAnimating];
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
