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
#import "RHIDirectoryManager.h"

@interface RHIViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *robotImageView;
@property (weak, nonatomic) IBOutlet UITextField *robotTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSCache *cache;
@property (nonatomic, strong) RHIDirectoryManager *directoryManager;
@property (strong, nonatomic) NSTimer *inputTimer;

@end

@implementation RHIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cache = [NSCache new];
    self.directoryManager = [RHIDirectoryManager new];
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
    UIImage *savedImage = [self.directoryManager loadFileWithName:requestString];
    
    UIImage *cachedImage = [self.cache objectForKey:requestString];
    if (cachedImage)
        self.robotImageView.image = cachedImage;
    else if (savedImage)
        self.robotImageView.image = savedImage;
    else
        [self fireRequestFor:requestString];
}

- (void)fireRequestFor:(NSString *)requestString
{
    NSLog(@"Obtaining image for : %@", requestString);
    [self.activityIndicator startAnimating];
    
    __weak typeof(self)weakSelf = self;
    
    [[RHIRequestManager sharedInstance] obtainRobotImageForString:requestString withCompletion:^(NSData *imageData, NSString *robotString) {
        
        typeof(weakSelf)strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.activityIndicator stopAnimating];
            
            UIImage *robotImage = [UIImage imageWithData:imageData];
            [strongSelf.cache setObject:robotImage forKey:robotString];
            
            if ([robotString isEqualToString:strongSelf.robotTextField.text])
                strongSelf.robotImageView.image = robotImage;
        });
    }];
}

#pragma mark - UITextFiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
