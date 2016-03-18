//
//  RHIImageProxy.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/18/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RHIImageProxy : NSObject

@property (nonatomic, strong) UIImage *randomImage;
@property (nonatomic, strong) NSString *randomString;

- (void)startGenerating;
- (void)stopGenerating;
- (void)requestImageNamed:(NSString *)name withCompletion:(void(^)(UIImage *, NSString *))completion;

@end
