//
//  RHIHistoryViewController.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/18/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIHistoryViewController.h"
#import "RHIHashHistoryStack.h"
#import "RHIRoboHash.h"
#import "UITableViewCell+RoboHash.h"

NSString * const RHIHistoryCellIdentifier = @"HistoryCell";

@interface RHIHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RHIHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
}

- (void)setup
{
    [self.contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RHIHistoryCellIdentifier];
    
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = [[RHICoreDataManager sharedInstance] persistentStoreCoordinator];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([RHIRoboHash class])];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(requestTime)) ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((id<NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections.firstObject) numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RHIHistoryCellIdentifier forIndexPath:indexPath];
    
    RHIRoboHash *roboHash = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCellWithRoboHash:roboHash];
    return cell;
}

@end
