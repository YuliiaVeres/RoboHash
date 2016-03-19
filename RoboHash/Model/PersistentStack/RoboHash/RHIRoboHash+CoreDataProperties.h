//
//  RHIRoboHash+CoreDataProperties.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RHIRoboHash.h"

NS_ASSUME_NONNULL_BEGIN

@interface RHIRoboHash (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSNumber *requestTime;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
