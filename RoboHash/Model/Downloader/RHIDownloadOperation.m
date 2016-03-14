//
//  RHIDownloadOperation.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/14/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIDownloadOperation.h"
#import "RHIRequestManager.h"
#import "RHIDirectoryManager.h"

@interface RHIDownloadOperation()

@property (nonatomic, strong) NSString *imageName;

@end

@implementation RHIDownloadOperation

- (id)initWithImageName:(NSString *)imageName
{
    if (self == [super init])
    {
        self.imageName = imageName;
    }
    
    return self;
}

- (void)main
{
    if (self.isCancelled)
        return;
    
    __weak typeof(self)weakSelf = self;
    
    [[RHIRequestManager sharedInstance] downloadRobotImageForString:self.imageName handler:^(NSURL *tempLocation) {
        
        typeof(weakSelf)strongSelf = weakSelf;
        
        if (!strongSelf.isCancelled)
        {
            RHIDirectoryManager *directoryManager = [RHIDirectoryManager new];
            [directoryManager saveDocumentWithName:strongSelf.imageName fromTempLocation:tempLocation];
        }
    }];
}

@end
