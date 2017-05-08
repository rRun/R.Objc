//
//  PathsProperty.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "PathsProperty.h"
#import "PathProperty.h"

#import "ClassGenerator.h"
#import "ResourcesGenerator.h"

#import "NSString+R.h"
@implementation PathsProperty

+ (ClassGenerator *)descriptionStringClass {
    static ClassGenerator *c = nil;
    if (c == nil) {
        c = [[ClassGenerator alloc]
              initWithClassName:@"DescriptionString"
              inheritName:@"NSString"];
        [[c addMethodName:@"length"
              declaration:NO
                signature:@"- (NSUInteger)length"]
         addLineIndent:1
         format:@"return [[self description] length];"];
        [[c addMethodName:@"characterAtIndex:"
              declaration:NO
                signature:@"- (unichar)characterAtIndex:(NSUInteger)index"]
         addLineIndent:1
         format:@"return [[self description] characterAtIndex:index];"];
        [[c addMethodName:@"getCharacters:range:"
              declaration:NO
                signature:@"- (void)getCharacters:(unichar *)buffer range:(NSRange)aRange"]
         addLineIndent:1
         format:@"return [[self description] getCharacters:buffer range:aRange];"];
    }
    
    return c;
}

- (NSString *)headerProlog:(ResourcesGenerator *)generator {
    return [NSString stringWithFormat:
            @"%@"
            @"\n"
            @"%@ *paths;\n",
            [[[self class] descriptionStringClass] header],
            self.className];
}

- (NSString *)implementationProlog:(ResourcesGenerator *)generator {
    MethodGenerator *pMethod = [[MethodGenerator alloc]
                                 initWithSignature:@"static NSString *p(NSString *path)"];
    [pMethod addLineIndent:1 format:@"static NSString *resourcePath = nil;"];
    [pMethod addLineIndent:1 format:@"if (resourcePath == nil) {"];
    [pMethod addLineIndent:2 format:@"resourcePath = [[NSBundle mainBundle] resourcePath];"];
    [pMethod addLineIndent:1 format:@"}"];
    [pMethod addLineIndent:1 format:@"return [resourcePath stringByAppendingPathComponent:path];"];
    
    return [NSString stringWithFormat:
            @"%@"
            @"\n"
            @"%@"
            @"\n"
            @"%@ *rPaths;\n",
            pMethod,
            [[[self class] descriptionStringClass] implementation],
            self.className];
}


- (NSString *)inheritClassName {
    return @"DescriptionString";
}

- (void)generate:(ClassGenerator *)classGenerator
       generator:(ResourcesGenerator *)generator {
    if (self.parent == nil) {
        MethodGenerator *loadMethod = [classGenerator addMethodName:@"0load"
                                                        declaration:NO
                                                          signature:@"+ (void)load"];
        [loadMethod
         addLineIndent:1
         format:@"rPaths = [[%@ alloc] init];", self.className];
    }
    
    if ([self countPropertiesOfClass:[self class]] > 0) {
        MethodGenerator *initMethod = [classGenerator addMethodName:@"1init"
                                                        declaration:NO
                                                          signature:@"- (id)init"];
        [initMethod addLineIndent:1 format:@"self = [super init];"];
        [self forEachPropertyOfClass:[PathsProperty class] block:^(Property *property) {
            PathsProperty *pathsProperty = (PathsProperty *)property;
            
            
            [classGenerator
             addPropertyName:pathsProperty.name
             line:@"@property(nonatomic, readonly) %@ *%@; //!< %@",
             pathsProperty.className,
             pathsProperty.name,
             pathsProperty.path];
            
            [initMethod
             addLineIndent:1
             format:@"_%@ = [[%@ alloc] init];",
             pathsProperty.name,
             pathsProperty.className];
        }];
        [initMethod addLineIndent:1 format:@"return self;"];
    };
    
    MethodGenerator *descriptionMethod = [classGenerator
                                          addMethodName:@"2description"
                                          declaration:NO
                                          signature:@"- (NSString *)description"];  
    [descriptionMethod
     addLineIndent:1
     format:@"return p(@\"%@\");",
     [self.path escapeCString]];
    
    [self forEachPropertyOfClass:[PathProperty class] block:^(Property *property) {
        [((PathProperty *)property) generate:classGenerator generator:generator];
    }];
}



@end
