//
//  RHIHomeViewController.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/18/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIHomeViewController.h"
#import "UIView+Cornered.h"
#import "UINavigationBar+RoboHash.h"
#import "RHIHistoryViewController.h"

@interface RHIHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *hashButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

@end

@implementation RHIHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setup
{
    [self.hashButton corneredWithRadius:5.0 borderColor:nil borderWidth:0.0];
    [self.historyButton corneredWithRadius:5.0 borderColor:nil borderWidth:0.0];
    
    [self.navigationController.navigationBar transparentBar];
}

@end
