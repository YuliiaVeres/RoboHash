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
#import "RHIHashHistoryStack.h"

@interface RHIHashDataSource ()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) RHIHashHistoryStack *hashStack;

@end

@implementation RHIHashDataSource

- (id)init
{
    if (self = [super init])
    {
        self.cache = [NSCache new];
        self.hashStack = [RHIHashHistoryStack new];
    }
    
    return self;
}

#pragma mark - Load File

- (void)loadFileNamed:(NSString *)name withRequestManager:(RHIRequestManager *)requestManager requestType:(RHIRequestType)requestType withCompletion:(void (^)(UIImage *, NSString *))completion
{
    if ([self checkForImageInCache:name completion:completion] ||
        [self checkForImageInDirectory:name completion:completion])
        return;

    __weak typeof(self)weakSelf = self;
    
    [requestManager obtainRobotImageForString:name withCompletion:^(NSData *imageData, NSString *requestedString) {

        NSLog(@"<N> From *NETWORK* , named: %@. \n", requestedString);

        typeof(weakSelf)strongSelf = weakSelf;
        
        if (requestType == RHIRequestTypeUser && imageData)
            [strongSelf saveRoboHashWithTitle:requestedString imageData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:imageData];
            if (image)
                [strongSelf.cache setObject:image forKey:[requestedString uppercaseString]];
            
            if (completion)
                completion(image, requestedString);
        });
    }];
}

#pragma mark - Check for cached or bundled image

- (UIImage *)checkForImageInCache:(NSString *)imageName completion:(void(^)(UIImage *, NSString *))completion
{
    UIImage *cachedImage = [self.cache objectForKey:[imageName uppercaseString]];
    if (cachedImage && completion)
    {
        NSLog(@"From *CACHE* , named: %@. \n", imageName);
        completion(cachedImage, imageName);
    }
    return cachedImage;
}

- (UIImage *)checkForImageInDirectory:(NSString *)imageName completion:(void(^)(UIImage *, NSString *))completion
{
    NSURL *filePath = [RHIDirectoryManager pathForFileWithName:imageName];
    
    UIImage *directoryImage = [UIImage imageWithContentsOfFile:[filePath path]];
    if (directoryImage && completion)
    {
        NSLog(@"From *DIRECTORY* , named: %@. \n", imageName);
        
        [self.cache setObject:directoryImage forKey:[imageName uppercaseString]];
        completion(directoryImage, imageName);
    }
    return directoryImage;
}

#pragma mark - Save user requested Robo Hash

- (void)saveRoboHashWithTitle:(NSString *)title imageData:(NSData *)imageData
{
    NSTimeInterval requestTime = [[NSDate date] timeIntervalSince1970];
    [self.hashStack saveRoboHashWithImageData:imageData title:title requestTime:requestTime];
}

@end
