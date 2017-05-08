//
//  NSString+R.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (R)

- (NSString *)toCamelCase:(NSCharacterSet *)charSet;
- (NSString *)charSetNormalize:(NSCharacterSet *)charSet;
- (NSString *)stripSuffix:(NSArray *)suffixes;
- (NSString *)escapeCString;
- (BOOL)isReservedRgenName;
- (BOOL)isSupportedImageExtByIOS;
- (NSString *)normalizeIOSPath:(BOOL)ipadSuffix;
- (NSString *)propertyName;
- (NSString *)imagePropertyName:(BOOL)ipadSuffix;
- (NSString *)dirPropertyName;

@end
