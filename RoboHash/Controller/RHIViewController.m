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

- (void)sendFinalRequest
{
    if (self.robotTextField.text.length == 0)
    {
        self.robotImageView.image = nil;
        return;
    }
    
    [self obtainRobotForString:self.robotTextField.text];
    [self.inputTimer invalidate];
}

#pragma mark - Image obtain request

- (void)obtainRobotForString:(NSString *)requestString
{
    UIImage *cachedImage = [self.cache objectForKey:requestString];
    if (cachedImage)
    {
        self.robotImageView.image = cachedImage;
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [[RHIRequestManager sharedInstance] obtainRobotImageForString:requestString withCompletion:^(UIImage *robotImage, NSString *robotString) {
        
        typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.cache setObject:robotImage forKey:robotString];
        
        if (![robotString isEqualToString:strongSelf.robotTextField.text])
            return;
        
        strongSelf.robotImageView.image = robotImage;
    }];
}

#pragma mark - UITextFiledDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    CGFloat typeInterval = fabs([self.currentTime timeIntervalSinceNow]);
    self.currentTime = [NSDate date];
    
    if (typeInterval < RHIMinimumTypeInterval)
    {
        self.inputTimer = [NSTimer scheduledTimerWithTimeInterval:RHIMinimumTypeInterval target:self selector:@selector(sendFinalRequest) userInfo:nil repeats:NO];
        return YES;
    }
    
    NSString *requestString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (requestString.length == 0)
    {
        self.robotImageView.image = nil;
        return YES;
    }
    
    [self obtainRobotForString:requestString];
    return YES;
}

#pragma mark - Tap gesture

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

@end
