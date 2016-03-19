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

@property (readwrite, nonatomic, strong) UIImage *randomImage;
@property (readwrite, nonatomic, strong) NSString *randomString;

@property (nonatomic, strong) NSTimer *generateTimer;
@property (nonatomic, strong) RHIHashDataSource *hashDataSource;
@property (nonatomic, strong) RHIRequestManager *userRequestManager;
@property (nonatomic, strong) RHIRequestManager *randomRequestManager;

@end

@implementation RHIImageProxy

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static RHIImageProxy *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] __init];
    });
    
    return sharedInstance;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Only SINGLE instance available through -sharedInstance"
                                 userInfo:nil];
    return nil;
}

- (id)__init
{
    if (self = [super init])
    {
        self.hashDataSource = [RHIHashDataSource new];
        self.userRequestManager = [RHIRequestManager new];
        self.randomRequestManager = [RHIRequestManager new];
    }
    return self;
}

- (void)startGenerating
{
    if (self.generateTimer.isValid)
        return;
    
    [self __generateRandomHash:nil];
    
    self.generateTimer = [NSTimer scheduledTimerWithTimeInterval:RHIHashGenerateInterval target:self selector:@selector(__generateRandomHash:) userInfo:nil repeats:YES];
}

- (void)stopGenerating
{
    [self.generateTimer invalidate];
}

- (void)requestImageNamed:(NSString *)name withCompletion:(void(^)(UIImage *, NSString *))completion
{
    [self.hashDataSource loadFileNamed:name withRequestManager:self.userRequestManager requestType:RHIRequestTypeUser withCompletion:^(UIImage *image, NSString *requestedString) {
       
        if (completion)
            completion(image, requestedString);
    }];
}

- (void)__generateRandomHash:(NSTimer *)timer
{
    self.randomString = [NSString randomStringWithLength:RHIMaxRandomStringLength];
    
    __weak typeof (self)weakSelf = self;
    
    [self.hashDataSource loadFileNamed:self.randomString withRequestManager:self.randomRequestManager requestType:RHIRequestTypeRandom withCompletion:^(UIImage *image, NSString *requestedString) {
       
        typeof (weakSelf)strongSelf = weakSelf;
        if (![requestedString isEqualToString:strongSelf.randomString] && requestedString)
            return;
        
        strongSelf.randomImage = image ?: [UIImage imageNamed:RHIOfflineIcon];
    }];
}

@end
