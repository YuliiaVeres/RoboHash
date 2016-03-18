//
//  RHIImageProxy.m
//  RoboHash
//
//  Created by Yuliia Veresklia on 3/18/16.
//  Copyright © 2016 Yuliia Veresklia. All rights reserved.
//

#import "RHIImageProxy.h"
#import "RHIHashDataSource.h"
#import "RHIConstants.h"
#import "NSString+Random.h"

@interface RHIImageProxy ()

@property (nonatomic, strong) NSTimer *generateTimer;
@property (nonatomic, strong) RHIHashDataSource *hashDataSource;
@property (nonatomic, strong) RHIRequestManager *userRequestManager;
@property (nonatomic, strong) RHIRequestManager *randomRequestMamager;

@end

@implementation RHIImageProxy

- (id)init
{
    if (self = [super init])
    {
        self.hashDataSource = [RHIHashDataSource new];
        self.userRequestManager = [RHIRequestManager new];
        self.randomRequestMamager = [RHIRequestManager new];
    }
    return self;
}

- (void)startGenerating
{
    [self __generateRandomHash];
    
    self.hashDataSource = [RHIHashDataSource new];
    self.generateTimer = [NSTimer scheduledTimerWithTimeInterval:RHIHashGenerateInterval target:self selector:@selector(__generateRandomHash) userInfo:nil repeats:YES];
}

- (void)stopGenerating
{
    [self.generateTimer invalidate];
}

- (void)requestImageNamed:(NSString *)name withCompletion:(void(^)(UIImage *, NSString *))completion
{
    [self.hashDataSource loadFileNamed:name withRequestManager:self.userRequestManager withCompletion:^(UIImage *image, NSString *requestedString) {
        
        if (completion)
            completion(image, requestedString);
    }];
}

- (void)__generateRandomHash
{
    self.randomString = [NSString randomStringWithLength:RHIMaxRandomStringLength];
    NSLog(@"---Generating RANDOM for : %@", self.randomString);
    
    __weak typeof (self)weakSelf = self;
    
    [self.hashDataSource loadFileNamed:self.randomString withRequestManager:self.randomRequestMamager withCompletion:^(UIImage *image, NSString *requestedString) {
        
        typeof (weakSelf)strongSelf = weakSelf;
        if (![requestedString isEqualToString:strongSelf.randomString])
            return;
        
        strongSelf.randomImage = image;
    }];
}

@end
