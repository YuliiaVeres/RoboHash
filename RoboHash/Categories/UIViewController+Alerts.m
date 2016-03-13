//
//  UIViewController+Alerts.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/13/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "UIViewController+Alerts.h"

@implementation UIViewController (Alerts)

- (void)showErrorWithMessage:(NSString *)message handler:(void (^)())handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(message, nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
