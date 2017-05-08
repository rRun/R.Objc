//
//  XCodeGroup.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "XCodeGroup.h"

@implementation XCodeGroup

- (id)initFromPJDictionary:(PJDictionary *)pbxDict
                  xcodeProj:(XcodeProj *)anXCodeProj
                     parent:(XCodeGroup *)anParent {
    self = [super initFromPJDictionary:pbxDict
                              xcodeProj:anXCodeProj
                                 parent:anParent];
    if (self == nil) {
        return nil;
    }
    
    self.children = [NSMutableArray array];
    
    return self;
}


@end
