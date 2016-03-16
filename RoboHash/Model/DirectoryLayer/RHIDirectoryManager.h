//
//  RHIDirectoryManager.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RHIDirectoryManager : NSObject

- (NSURL *)pathForFileWithName:(NSString *)fileName;
- (void)saveDocumentWithName:(NSString *)name fromTempLocation:(NSURL *)location;;
- (void)checkForInitialImages;

@end
