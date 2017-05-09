//
//  StringKeysProperty.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "StringKeysProperty.h"

#import "ClassGenerator.h"

#import "NSString+R.h"

@implementation StringKeysProperty

- (NSString *)headerProlog:(ResourcesGenerator *)generator {
    return [NSString stringWithFormat:@"%@ *S;\n", self.className];
}

- (NSString *)implementationProlog:(ResourcesGenerator *)generator {
    return [NSString stringWithFormat:@"%@ *S;\n", self.className];
}

- (void)generate:(ClassGenerator *)classGenerator
       generator:(ResourcesGenerator *)generator {
    if (self.parent == nil) {
        MethodGenerator *loadMethod = [classGenerator addMethodName:@"0load"
                                                        declaration:NO
                                                          signature:@"+ (void)load"];
        [loadMethod
         addLineIndent:1
         format:@"S = [[%@ alloc] init];", self.className];
    }
    
    MethodGenerator *initMethod = [classGenerator addMethodName:@"1init"
                                                    declaration:NO
                                                      signature:@"- (id)init"];
    [self forEachProperty:^(Property *property) {

        [classGenerator
         addPropertyName:property.name
         line:@"@property(nonatomic, readonly) NSString *%@; //!< %@",
         property.name,
         property.path]; // path is used for string key
        
        [initMethod
         addLineIndent:1
         format:@"_%@ = @\"%@\";",
         property.name,
         [property.path escapeCString]];
    }];
    
    [initMethod addLineIndent:1 format:@"return self;"];
}


@end
