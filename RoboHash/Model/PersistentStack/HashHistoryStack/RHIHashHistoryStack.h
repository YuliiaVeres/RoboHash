//
//  RHIHashHistoryStach.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHICoreDataManager.h"

@interface RHIHashHistoryStack : NSObject

- (void)saveRoboHashWithImageData:(NSData *)imageData title:(NSString *)title requestTime:(NSTimeInterval)requestTime;

@end
