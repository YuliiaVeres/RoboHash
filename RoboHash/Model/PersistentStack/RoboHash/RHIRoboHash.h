//
//  RHIRoboHash.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface RHIRoboHash : NSManagedObject

+ (instancetype)createRoboHashInContext:(NSManagedObjectContext *)context withImageData:(NSData *)imageData title:(NSString *)title requestTime:(NSTimeInterval)requestTime;

@end

NS_ASSUME_NONNULL_END

#import "RHIRoboHash+CoreDataProperties.h"
