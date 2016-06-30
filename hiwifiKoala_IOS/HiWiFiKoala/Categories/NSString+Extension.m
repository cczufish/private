//
//  NSString+Extension.m
//  HiWiFi
//
//  Created by dp on 14-8-1.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "NSString+Extension.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (NSString *)MD5Encode {
    const char* s = [self UTF8String];
    unsigned char c[CC_MD5_DIGEST_LENGTH];
    CC_MD5(s, (CC_LONG)strlen(s), c);
    NSMutableString *r = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [r appendFormat:@"%02X",c[i]];
    }
    return [r lowercaseString];
}

- (id)JSONObject {
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    
    return result;
}

- (NSString *)URLEncodedString {
    return (NSString *)CFBridgingRelease(
                                         CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                 NULL,
                                                                                 kCFStringEncodingUTF8)
                                         );
}

- (int)sLength {
    int len = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            len++;
        }
        p++;
    }
    return len;
}

@end
