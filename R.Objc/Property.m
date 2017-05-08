//
//  Property.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "Property.h"

NSComparator propertySortBlock = ^(id a, id b) {
    return [((NSString *)[a valueForKey:@"name"])
            compare:[b valueForKey:@"name"]];
};


@implementation Property

- (id)initWithName:(NSString *)aName
              path:(NSString *)aPath {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.name = aName;
    self.path = aPath;
    
    return self;
}

- (void)generate:(ClassGenerator *)classGenerator
       generator:(ResourcesGenerator *)generator {
}

@end
