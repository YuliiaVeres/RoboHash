//
//  NSString+Random.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/18/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "NSString+Random.h"

NSString * const characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation NSString (Random)

+ (NSString *)randomStringWithLength:(NSInteger)length
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++)
    {
        [randomString appendFormat: @"%C", [characters characterAtIndex:arc4random() % [characters length]]];
    }
    return randomString;
}

@end
