//
//  HWFFile.m
//  HiWiFiKoala
//
//  Created by dp on 14/10/27.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFFile.h"

@implementation HWFFile

// Override
// MTLJSONSerializing
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identity" : @"identity",
             @"path" : @"path",
             @"accessPath" : @"access_path",
             @"name" : @"file",
             @"displayName" : @"file_name",
             @"type" : @"type",
             @"URL" : @"url",
             @"createTime" : @"ctime",
             @"updateTime" : @"mtime",
             @"size" : @"size",
             @"mode" : @"modedec",
             @"modeDesc" : @"modestr",
             };
}

- (NSString *)displaySize {
    return [HWFTool displaySizeWithUnitB:self.size];
}

// 根据扩展名判断(可播放)文件类型
- (MediaType)mediaType {
    NSString *ext = [[self extensionName] uppercaseString];
    
    MediaType type = MediaTypeUnknown;
    if (ext && [[VIDEO_SUPPORT componentsSeparatedByString:@"|"] containsObject:ext]) {
        type = MediaTypeVideo;
    } else if (ext && [[AUDIO_SUPPORT componentsSeparatedByString:@"|"] containsObject:ext]) {
        type = MediaTypeAudio;
    } else if (ext && [[IMAGE_SUPPORT componentsSeparatedByString:@"|"] containsObject:ext]) {
        type = MediaTypeImage;
    } else if (ext && [[DOCUMENT_SUPPORT componentsSeparatedByString:@"|"] containsObject:ext]) {
        type = MediaTypeDocument;
    }
    
    return type;
}

// 取文件扩展名
- (NSString *)extensionName {
    NSRange range = [self.name rangeOfString:@"." options:NSBackwardsSearch];
    
    NSString *ext = nil;
    if (range.location != NSNotFound) {
        ext = [self.name substringFromIndex:range.location+1];
    }

    return ext;
}

@end
