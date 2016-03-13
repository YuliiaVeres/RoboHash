//
//  RHIViewController+InitialImages.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIViewController.h"

@interface RHIViewController (InitialImages)

- (void)trackInitialLaunch;
- (void)prefetchInitialImages;
- (void)loadImageFromDirectoryForString:(NSString *)requestString withCompletion:(void(^)(UIImage *))completion;

@end
