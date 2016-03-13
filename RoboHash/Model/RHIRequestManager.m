//
//  RHIRequestManager.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/10/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHIRequestManager.h"
#import "RHIConstants.h"

@implementation RHIRequestManager

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static RHIRequestManager *sharedInstance = nil;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)obtainRobotImageForString:(NSString *)requestString withCompletion:(void(^)(NSData *, NSString *))completion
{
    NSString *requestUrlString = [NSString stringWithFormat:@"%@%@", RHIBaseUrl, requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrlString]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *requestedRobot = response.URL.pathComponents.lastObject;
        
        if (completion)
            completion(data, requestedRobot);
    }] resume];
}

- (void)downloadRobotImageForString:(NSString *)requestString
{
    NSLog(@"Writing to directory image named %@", requestString);
    
    NSString *requestUrlString = [NSString stringWithFormat:@"%@%@", RHIBaseUrl, requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrlString]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session downloadTaskWithRequest:request
                    completionHandler:
      ^(NSURL *location, NSURLResponse *response, NSError *error) {
          
          NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
          NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
          
          NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:[response
                                                                                   suggestedFilename]];
          [[NSFileManager defaultManager] moveItemAtURL:location toURL:documentURL error:nil];
          
          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:requestString];
          [[NSUserDefaults standardUserDefaults] synchronize];
      }] resume];
}

@end
