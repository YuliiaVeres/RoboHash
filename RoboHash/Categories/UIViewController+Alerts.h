//
//  UIViewController+Alerts.h
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alerts)

- (void)showErrorWithMessage:(NSString *)message handler:(void(^)())handler;

@end
