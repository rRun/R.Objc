//
//  PathProperty.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "PathProperty.h"
#import "ClassGenerator.h"

#import "NSString+R.h"

@implementation PathProperty

- (void)generate:(ClassGenerator *)classGenerator
       generator:(ResourcesGenerator *)generator {
    [classGenerator
     addPropertyName:self.name
     line:@"@property(nonatomic,strong, readonly) NSString *%@; //!< %@",
     self.name,
     self.path];
    
    MethodGenerator *method = [classGenerator
                               addMethodName:self.name
                               declaration:NO
                               signature:@"- (NSString *)%@", self.name];
    [method
     addLineIndent:1
     format:
     @"return p(@\"%@\");",
     [self.path escapeCString]];
}



@end
