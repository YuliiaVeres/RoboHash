//
//  RHICoreDataManager.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/19/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RHICoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;

@end
