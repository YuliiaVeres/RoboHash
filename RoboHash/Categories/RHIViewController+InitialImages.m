//
//  RHIViewController+InitialImages.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIViewController+InitialImages.h"
#import "RHIConstants.h"
#import "RHIRequestManager.h"
#import "NSObject+BackgroundOperation.h"

@implementation RHIViewController (InitialImages)

- (void)trackInitialLaunch
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:RHIInitiallyLaunched])
        return;
    
    [self prefetchInitialImages];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RHIInitiallyLaunched];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prefetchInitialImages
{
    [self readInitialStringsWithCompletion:^(NSArray *strings) {
    
        for (NSString *string in strings)
        {
            [[RHIRequestManager sharedInstance] downloadRobotImageForString:string];
        }
    }];
}

- (void)readInitialStringsWithCompletion:(void(^)(NSArray *))completion
{
    __weak typeof (self)weakSelf = self;
    [self executeOnBackground:^{
        
        NSError *error;
        typeof(weakSelf)strongSelf = weakSelf;
        
        NSString *stringContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                      pathForResource: RHISringsFileName ofType: @"txt"] encoding:NSUTF8StringEncoding error:&error];
        
        if(error)
            [strongSelf showErrorWithMessage:RHIStringsFileErrorMessage handler:nil];
        
        NSArray *strings = [stringContent componentsSeparatedByString:@"\n"];
        strings = [NSArray arrayWithArray:[[NSSet setWithArray:strings] allObjects]];
        
        if (completion)
            completion(strings);
    }];
}

- (void)loadImageFromDirectoryForString:(NSString *)requestString withCompletion:(void(^)(UIImage *))completion
{
    [self executeOnBackground:^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png", requestString]];
        
        UIImage* image = [UIImage imageWithContentsOfFile:path];
        if (completion)
            completion(image);
    }];
}

@end
