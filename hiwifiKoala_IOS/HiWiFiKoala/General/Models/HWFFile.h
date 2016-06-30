//
//  HWFFile.h
//  HiWiFiKoala
//
//  Created by dp on 14/10/27.
//  Copyright (c) 2014年 Beijing Geek-Geek Technology Co., Ltd. All rights reserved.
//

#import "HWFObject.h"

#define ROOT_PATH @"/"

// 支持的视频格式
#define VIDEO_SUPPORT @"MP4|M4V|MOV|"
// 支持的音频格式
#define AUDIO_SUPPORT @"MP3|M4A|AAC|ALAC|"
// 支持的图片格式
#define IMAGE_SUPPORT @"PNG|JPG|JPEG|GIF|"
// 支持的文档格式
#define DOCUMENT_SUPPORT @"PDF|TXT|DOC|DOCX|XLS|XLSX|PPT|PPTX|"

typedef NS_ENUM(NSUInteger, MediaType) {
    MediaTypeUnknown = 0,
    MediaTypeVideo,
    MediaTypeAudio,
    MediaTypeImage,
    MediaTypeDocument,
};

@interface HWFFile : HWFObject

@property (strong, nonatomic) NSString *identity; // path+name
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *accessPath; // 文件访问地址，用于拼URL
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *type; // "reg":常规文件, 包括软链接  "dir":文件夹, 包括软连接
@property (strong, nonatomic) NSString *URL; // http:// dl.hiwifi.com/$accessPath/$name
@property (strong, nonatomic) NSDate *createTime;
@property (strong, nonatomic) NSDate *updateTime;
@property (assign, nonatomic) double size; // 文件大小， 单位：B
@property (assign, nonatomic) NSInteger mode; // e.g. 755
@property (strong, nonatomic) NSString *modeDesc; // e.g. rwxr-xr-x
@property (readonly) MediaType mediaType; // 媒体格式

/**
 *  @brief  返回格式化后的文件大小
 *
 *  @return 用于显示的文件大小
 */
- (NSString *)displaySize;

@end
