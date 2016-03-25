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
#import "RHIRoboHash.h"
#import "RHICoreDataManager.h"

@interface RHIHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *hashButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

@property (strong, nonatomic) NSManagedObjectContext *context;

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup
{
    [self.hashButton corneredWithRadius:5.0 borderColor:nil borderWidth:0.0];
    [self.historyButton corneredWithRadius:5.0 borderColor:nil borderWidth:0.0];
    
    [self.navigationController.navigationBar transparentBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRequestsInfo:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.context.persistentStoreCoordinator = [RHICoreDataManager sharedInstance].persistentStoreCoordinator;
    
    [self executeFetch];
}

- (void)updateRequestsInfo:(NSNotification *)notification
{
    __weak typeof(self)weakSelf = self;
    [self.context performBlock:^{
        
        typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf.context mergeChangesFromContextDidSaveNotification:notification];
        [strongSelf executeFetch];
    }];
}

- (void)executeFetch
{
    __weak typeof(self)weakSelf = self;
    
    [self.context performBlockAndWait:^{
        
        typeof(weakSelf)strongSelf = weakSelf;
        NSError *error = nil;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([RHIRoboHash class])];
        NSArray *hashes = [strongSelf.context executeFetchRequest:request error:&error];
        
        if (error)
            NSLog(@"Error merging home context : %@", error.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.historyButton setTitle:[NSString stringWithFormat:@"%@ (%lu)", NSLocalizedString(@"Requests History", nil), (unsigned long)hashes.count] forState:UIControlStateNormal];
        });
    }];
}

@end
