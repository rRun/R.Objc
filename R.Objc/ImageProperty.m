//
//  ImageProperty.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "ImageProperty.h"

#import "ClassGenerator.h"
#import "ResourcesGenerator.h"

#import "NSString+R.h"

@implementation ImageProperty

- (void)generate:(ClassGenerator *)classGenerator
       generator:(ResourcesGenerator *)generator {
    [classGenerator
     addPropertyName:self.name
     line:@"@property(nonatomic,strong, readonly) UIImage *%@; //!< %@",
     self.name,
     self.path];
    
    MethodGenerator *method = [classGenerator
                               addMethodName:self.name
                               declaration:NO
                               signature:@"- (UIImage *)%@", self.name];
    if (generator.optionLoadImages) {
        [method
         addLineIndent:1
         format:
         @"return self.%@ == nil ? i(@\"%@\") : self.%@;",
         self.name,
         [self.path escapeCString],
         self.name];
    } else {
        [method
         addLineIndent:1
         format:
         @"return i(@\"%@\");",
         [self.path escapeCString]];
    }
}

@end
