//
//  DNSConfig.h
//  PacketTunnel
//
//  Created by MrFeng on 2020/10/21.
//  Copyright © 2020 yicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNSConfig : NSObject

+ (NSArray *)getSystemDnsServers;

@end

NS_ASSUME_NONNULL_END
