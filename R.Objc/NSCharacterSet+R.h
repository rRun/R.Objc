//
//  NSCharacterSet+R.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCharacterSet (R)

+ (NSCharacterSet *)propertyNameCharacterSet;
+ (NSCharacterSet *)propertyNameStartCharacterSet;
+ (NSCharacterSet *)classNameCharacterSet;
+ (NSCharacterSet *)classNameStartCharacterSet;

@end
