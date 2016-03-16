//
//  ViewController.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/10/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIViewController.h"
#import "RHIConstants.h"
#import "RHIHashDataSource.h"

@interface RHIViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *robotImageView;
@property (weak, nonatomic) IBOutlet UITextField *robotTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) RHIHashDataSource *hashDataSource;
@property (strong, nonatomic) NSTimer *inputTimer;

@end

@implementation RHIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hashDataSource = [RHIHashDataSource new];
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
    [self.activityIndicator startAnimating];
    
    __weak typeof (self)weakSelf = self;
    
    [self.hashDataSource loadFileNamed:requestString withCompletion:^(UIImage *image, NSString *requestedString) {
        
        typeof (weakSelf)strongSelf = weakSelf;
        
        [strongSelf.activityIndicator stopAnimating];
        
        if (![strongSelf.robotTextField.text isEqualToString:requestString])
            return;
        
        strongSelf.robotImageView.image = image;
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
