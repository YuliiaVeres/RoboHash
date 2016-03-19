//
//  RHIHashDataSource.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/15/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RHIRequestManager.h"

@interface RHIHashDataSource : NSObject

- (void)loadFileNamed:(NSString *)name withRequestManager:(RHIRequestManager *)requestManager requestType:(RHIRequestType)requestType withCompletion:(void (^)(UIImage *, NSString *))completion;

@end
