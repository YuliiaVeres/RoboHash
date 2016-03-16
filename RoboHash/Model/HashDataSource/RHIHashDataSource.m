//
//  RHIHashDataSource.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/15/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIHashDataSource.h"
#import "RHIRequestManager.h"
#import "RHIDirectoryManager.h"

@interface RHIHashDataSource ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation RHIHashDataSource

- (id)init
{
    if (self = [super init])
    {
        self.cache = [NSCache new];
    }
    
    return self;
}

#pragma mark - Load File

- (void)loadFileNamed:(NSString *)name withCompletion:(void (^)(UIImage *, NSString *))completion
{
    UIImage *cachedImage = [self.cache objectForKey:[name uppercaseString]];
    if (cachedImage && completion)
    {
        NSLog(@"<C> Cached with name: %@. \n", name);
        completion(cachedImage, name);
        return;
    }
    
    [self requestNotCachedImageNamed:name withCompletion:^(UIImage *image, NSString *requestedName) {
        
        if (completion)
            completion(image, requestedName);
    }];
}

#pragma mark - Fetch image from Web or Directory

- (void)requestNotCachedImageNamed:(NSString *)name withCompletion:(void(^)(UIImage *, NSString *))completion
{
    RHIDirectoryManager *directoryManager = [RHIDirectoryManager new];
    NSURL *filePath = [directoryManager pathForFileWithName:name];
    
    UIImage *directoryImage = [UIImage imageWithContentsOfFile:[filePath path]];
    if (directoryImage && completion)
    {
        NSLog(@"<F> Loaded from *DIRECTORY* , named: %@. \n", name);
        
        [self.cache setObject:directoryImage forKey:[name uppercaseString]];
        completion(directoryImage, name);
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    
    [[RHIRequestManager sharedInstance] obtainRobotImageForString:name withCompletion:^(NSData *imageData, NSString *requestedString) {
        
        typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"<N> From *NETWORK* , named: %@. \n", requestedString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:imageData];
            if (image)
                [strongSelf.cache setObject:image forKey:[requestedString uppercaseString]];
            
            if (completion)
                completion(image, requestedString);
        });
    }];
}

@end
