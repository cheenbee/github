//
//  JRClearCache.m
//  JRTescoToday
//
//  Created by apple on 2017/11/2.
//  Copyright © 2017年 Beijing today Tesco Agel Ecommerce Ltd. All rights reserved.
//

#import "JRClearCache.h"
#import "SDImageCache.h"

@implementation JRClearCache
//
+ (void)clearAppCache {
    CGFloat folderSize = [JRClearCache caculateFolderSize];
    if (folderSize > 0) [JRClearCache removeFolderCache];
    NSUInteger imageSize = [JRClearCache caculateSDWebImageCacheSize];
    if (imageSize) [JRClearCache removeSDWebImageCache];
}
//
+ (NSUInteger)caculateAppAllCacheSize {
    CGFloat folderSize = [JRClearCache caculateFolderSize];
    NSUInteger imageSize = [JRClearCache caculateSDWebImageCacheSize];
    NSUInteger size = folderSize + imageSize;
    return size;
}
#pragma mark - UIWebView缓存
+ (void)removeUIWebViewCache {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
#pragma mark - SDWebImage图片缓存
+ (CGFloat)caculateSDWebImageCacheSize {
   NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    return size/1024.0/1024.0;
}
+ (void)removeSDWebImageCache {
    [[SDImageCache sharedImageCache] clearDisk];
}
#pragma mark - 文件缓存
+ (CGFloat)caculateFolderSize {
    unsigned long long folderSize = 0;
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    NSLog(@"文件数：%ld",files.count);
    for(NSString *path in files) {
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
    
}
+ (void)removeFolderCache {
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    //返回路径文件数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    //遍历文件获取路径
    for (NSString *path in files) {
        NSString *filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", path]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
          BOOL isRemove = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            if (isRemove) DLog(@"removeSuccess");
        }
    }
    
}
@end
