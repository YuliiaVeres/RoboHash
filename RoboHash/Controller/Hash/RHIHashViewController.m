//
//  RHIHashViewController.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/10/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIHashViewController.h"
#import "RHIConstants.h"
#import "RHIImageProxy.h"

@interface RHIHashViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *robotImageView;
@property (weak, nonatomic) IBOutlet UITextField *robotTextField;
@property (weak, nonatomic) IBOutlet UIImageView *demoImageView;
@property (weak, nonatomic) IBOutlet UILabel *demoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *demoActivityIndicator;

@property (strong, nonatomic) RHIImageProxy *imageProxy;
@property (strong, nonatomic) NSTimer *inputTimer;

@end

@implementation RHIHashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.imageProxy startGenerating];
}

- (void)setup
{
    self.imageProxy = [RHIImageProxy sharedInstance];
    [self.imageProxy addObserver:self forKeyPath:NSStringFromSelector(@selector(randomString)) options:NSKeyValueObservingOptionNew context:nil];
    [self.imageProxy addObserver:self forKeyPath:NSStringFromSelector(@selector(randomImage)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self.imageProxy removeObserver:self forKeyPath:NSStringFromSelector(@selector(randomString))];
    [self.imageProxy removeObserver:self forKeyPath:NSStringFromSelector(@selector(randomImage))];
    [self.imageProxy stopGenerating];
}

#pragma mark - Random results observing and processing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object != self.imageProxy)
        return;
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(randomString))])
        [self displayStartGeneration];
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(randomImage))])
        [self displayGenerateResult];
}

- (void)displayStartGeneration
{
    [self.demoActivityIndicator startAnimating];
    self.demoImageView.image = nil;
    self.demoLabel.text = self.imageProxy.randomString;
}

- (void)displayGenerateResult
{
    [self.demoActivityIndicator stopAnimating];
    self.demoImageView.image = self.imageProxy.randomImage;
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
    
    [self.imageProxy requestImageNamed:requestString withCompletion:^(UIImage *image, NSString *requestString) {
        
        typeof (weakSelf)strongSelf = weakSelf;
        [strongSelf.activityIndicator stopAnimating];
        
        if (![strongSelf.robotTextField.text isEqualToString:requestString] && requestString)
            return;
        
        strongSelf.robotImageView.image = image ?: [UIImage imageNamed:RHIOfflineIcon];
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
