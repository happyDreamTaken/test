//
//  OCUtil.m
//  IvyGate
//
//  Created by MrFeng on 2019/10/25.
//  Copyright © 2019 yicheng. All rights reserved.
//

#import "OCUtil.h"

#import <resolv.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ShadowPath/ShadowPath.h>

@implementation OCUtil

void http_proxy_handler(int fd, void *udata) {
    OCUtil *provider = (__bridge OCUtil *)udata;
    [provider onHttpProxyCallback:fd];
}

int sock_port (int fd) {
    struct sockaddr_in sin;
    socklen_t len = sizeof(sin);
    if (getsockname(fd, (struct sockaddr *)&sin, &len) < 0) {
        NSLog(@"getsock_port(%d) error: %s",
              fd, strerror (errno));
        return 0;
    }else{
        return ntohs(sin.sin_port);
    }
}

- (void)onHttpProxyCallback:(int)fd {
    NSError *error;
    if (fd > 0) {
        _httpProxyPort = sock_port(fd);
        
    }else {
        error = [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:100 userInfo:@{NSLocalizedDescriptionKey: @"Fail to start http proxy"}];
    }
    NSLog(@"onHttpProxyCallback--%d",_httpProxyPort);
    if (self.httpCompletion != nil) {
        self.httpCompletion(self.httpProxyPort, error);
    }
}


+ (NSString *)deviceTokenFromData:(NSData *)deviceToken {
    
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"deviceToken:%@",hexToken);
    return hexToken;
}


// 获取本机DNS服务器
+ (NSArray *)outPutDNSServers
{
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    
    NSMutableArray *dnsArray = @[].mutableCopy;
    
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            
            [dnsArray addObject:s];
        }
    }
    else{
        NSLog(@"%@",@" res_init result != 0");
    }
    
    res_nclose(res);
    
    return dnsArray;
}

+(void)_startHttpProxy:(NSString *)confurl andPort:(int)port{
    NSURL *urlhead = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.ivyGate.http"];
    NSURL *commandUrl = [urlhead URLByAppendingPathComponent:confurl];
    
    //这个port == 9091即传入tun2socks的port
    struct forward_spec *proxy = NULL;
    proxy = calloc(1, sizeof(*proxy));
    proxy->type = SOCKS_5;
    proxy->gateway_host = "127.0.0.1";
    NSLog(@"confURL--%@",confurl);
    NSLog(@"port-%d",port);
    shadowpath_main(strdup([[commandUrl path] UTF8String]), proxy, http_proxy_handler, (__bridge void *)self);
}


@end
