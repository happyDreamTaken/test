//
//  OCUtil.h
//  IvyGate
//
//  Created by MrFeng on 2019/10/25.
//  Copyright © 2019 yicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <ShadowPath/ShadowPath.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HttpProxyCompletion)(int port, NSError *error);

@interface OCUtil : NSObject



+ (NSString *)deviceTokenFromData:(NSData *)deviceToken;

+ (void)_startHttpProxy:(NSString *)confurl andPort:(int)port;

+ (NSArray *)outPutDNSServers;

@property (nonatomic, readonly) int httpProxyPort;

@property (nonatomic, assign) HttpProxyCompletion httpCompletion;

@end

NS_ASSUME_NONNULL_END
