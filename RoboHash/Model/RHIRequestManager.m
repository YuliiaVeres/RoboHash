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

@interface RHIRequestManager ()

@property (nonatomic, strong) NSURLSessionDataTask *imageObtainTask;

@end

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
    
    [self.imageObtainTask cancel];
    
    self.imageObtainTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *requestedRobot = response.URL.pathComponents.lastObject;
        
        if (completion)
            completion(data, requestedRobot);
    }];
    [self.imageObtainTask resume];
}

- (void)downloadRobotImageForString:(NSString *)requestString handler:(void(^)(NSURL *))handler
{
    NSString *requestUrlString = [NSString stringWithFormat:@"%@%@", RHIBaseUrl, requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrlString]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session downloadTaskWithRequest:request
                    completionHandler:
      ^(NSURL *location, NSURLResponse *response, NSError *error) {
          
          if (handler)
              handler(location);
          
      }] resume];
}

@end
