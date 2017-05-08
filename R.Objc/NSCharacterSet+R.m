//
//  NSCharacterSet+R.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "NSCharacterSet+R.h"

@implementation NSCharacterSet (R)

+ (NSCharacterSet *)propertyNameCharacterSet {
    static NSCharacterSet *charSet = nil;
    if (charSet == nil) {
        charSet = [NSCharacterSet characterSetWithCharactersInString:
                    @"abcdefghijklmnopqrstuvwxyz"
                    @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    @"_0123456789"];
    }
    
    return charSet;
}

+ (NSCharacterSet *)propertyNameStartCharacterSet {
    static NSCharacterSet *charSet = nil;
    if (charSet == nil) {
        charSet = [NSCharacterSet characterSetWithCharactersInString:
                    @"abcdefghijklmnopqrstuvwxyz"
                    @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    @"_"];
    }
    
    return charSet;
}

+ (NSCharacterSet *)classNameCharacterSet {
    return [self propertyNameCharacterSet];
}

+ (NSCharacterSet *)classNameStartCharacterSet {
    return [self propertyNameStartCharacterSet];
}



@end
