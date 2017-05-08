//
//  ClassGenerator.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/4/19.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "ClassGenerator.h"


static NSString *const oneIndent = @"  ";

@interface ClassGenerator()

@end

@implementation ClassGenerator

- (id)initWithClassName:(NSString *)aClassName
            inheritName:(NSString *)aInheritClassName {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.className = aClassName;
    self.inheritClassName = aInheritClassName;
    self.properties = [NSMutableDictionary dictionary];
    self.declarations = [NSMutableDictionary dictionary];
    self.methods = [NSMutableDictionary dictionary];
    
    return self;
}


//添加属性
- (void)addPropertyName:(NSString *)aName
                   line:(NSString *)aFormatLine, ... {
    va_list va;
    va_start(va, aFormatLine);
    [self.properties setObject:[[NSString alloc]
                                 initWithFormat:aFormatLine
                                 arguments:va]
                        forKey:aName];
    va_end(va);
}

//添加方法生产器
- (MethodGenerator *)addMethodName:(NSString *)aName
                           comment:(NSString *)aComment
                       declaration:(BOOL)isDeclaration
                         signature:(NSString *)aFormatSignature
                            vaList:(va_list)va {
    MethodGenerator *method = [[MethodGenerator alloc]
                                initWithSignature:[[NSString alloc]
                                                    initWithFormat:aFormatSignature
                                                    arguments:va]
                                comment:aComment];
    [self.methods setObject:method forKey:aName];
    
    if (isDeclaration) {
        [self.declarations setObject:method forKey:aName];
    }
    
    return method;
}

- (MethodGenerator *)addMethodName:(NSString *)aName
                           comment:(NSString *)aComment
                       declaration:(BOOL)isDeclaration
                         signature:(NSString *)aFormatSignature, ... {
    va_list va;
    va_start(va, aFormatSignature);
    MethodGenerator *method = [self addMethodName:aName
                                          comment:aComment
                                      declaration:isDeclaration
                                        signature:aFormatSignature
                                           vaList:va];
    va_end(va);
    return method;
}

- (MethodGenerator *)addMethodName:(NSString *)aName
                       declaration:(BOOL)isDeclaration
                         signature:(NSString *)aFormatSignature, ... {
    va_list va;
    va_start(va, aFormatSignature);
    MethodGenerator *method = [self addMethodName:aName
                                          comment:nil
                                      declaration:isDeclaration
                                        signature:aFormatSignature
                                           vaList:va];
    va_end(va);
    return method;
}

- (NSString *)header {
    NSMutableString *s = [NSMutableString string];
    
    [s appendFormat:@"@interface %@ : %@",
     self.className, self.inheritClassName];
    
    [s appendString:@"\n"];
    
    if ([self.properties count] > 0) {
        for(id key in [[self.properties allKeys]
                       sortedArrayUsingSelector:@selector(compare:)]) {
            NSString *line = [self.properties objectForKey:key];
            [s appendFormat:@"%@\n", line];
        }
        [s appendString:@"\n"];
    }
    
    if ([self.declarations count] > 0) {
        for(id key in [[self.declarations allKeys]
                       sortedArrayUsingSelector:@selector(compare:)]) {
            MethodGenerator *method = [self.declarations objectForKey:key];
            if (method.comment != nil) {
                [s appendFormat:@"%@\n", method.comment];
            }
            [s appendFormat:@"%@;\n", method.signature];
        }
        [s appendString:@"\n"];
    }
    
    [s appendString:@"@end\n"];
    
    return s;
}

- (NSString *)implementation {
    NSMutableString *s = [NSMutableString string];
    
    [s appendFormat:@"@implementation %@\n", self.className];
    
    if ([self.methods count] > 0) {
        for(id key in [[self.methods allKeys]
                       sortedArrayUsingSelector:@selector(compare:)]) {
            MethodGenerator *method = [self.methods objectForKey:key];
            [s appendFormat:@"%@\n", method];
        }
    }
    
    [s appendString:@"@end\n"];
    
    return s;
}


@end


@implementation MethodGenerator

- (id)initWithSignature:(NSString *)aSignature comment:(NSString *)aComment {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.comment = aComment;
    self.signature = aSignature;
    self.lines = [[IndentedLines alloc] init];
    
    return self;
}

- (id)initWithSignature:(NSString *)aSignature {
    return [self initWithSignature:aSignature comment:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"%@ {\n"
            @"%@"
            @"}\n",
            self.signature,
            self.lines];
}

- (void)addLineIndent:(NSUInteger)aIndent format:(NSString *)aFormat, ... {
    IndentLine *line = [[IndentLine alloc] init];
    line.indent = aIndent;
    va_list va;
    va_start(va, aFormat);
    line.text = [[NSString alloc] initWithFormat:aFormat arguments:va];
    va_end(va);
    [self.lines.indentedLines addObject:line];
}



@end
@implementation IndentLine
@end

@implementation IndentedLines


- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.indentedLines = [NSMutableArray array];
    
    return self;
}

- (NSString *)description {
    NSMutableString *s = [NSMutableString string];
    
    for (IndentLine *line in self.indentedLines) {
        for (int i = 0; i < line.indent ; i++) {
            [s appendString:oneIndent];
        }
        [s appendString:line.text];
        [s appendString:@"\n"];
    }
    
    return s;
}


@end
