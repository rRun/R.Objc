//
//  Property.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassGenerator;
@class ResourcesGenerator;

extern NSComparator propertySortBlock;

@interface Property : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *path;


-(id)initWithName:(NSString *)aName
path:(NSString *)aPath;
-(void)generate:(ClassGenerator *)classGenerator
       generator:(ResourcesGenerator *)generator;

@end
