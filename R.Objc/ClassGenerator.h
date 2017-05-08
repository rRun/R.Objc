//
//  ClassGenerator.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/4/19.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IndentLine;
@class IndentedLines;
@class MethodGenerator;
@interface ClassGenerator : NSObject

@property(nonatomic, retain) NSString *className;
@property(nonatomic, retain) NSString *inheritClassName;

@property(nonatomic, retain) NSMutableDictionary *declarations;
@property(nonatomic, strong) NSMutableDictionary *properties;
@property(nonatomic, retain) NSMutableDictionary *methods;

- (id)initWithClassName:(NSString *)aClassName
            inheritName:(NSString *)aInheritClassName;

- (void)addPropertyName:(NSString *)aName
                   line:(NSString *)aFormatLine, ...;
- (MethodGenerator *)addMethodName:(NSString *)aName
                       declaration:(BOOL)isDeclaration
                         signature:(NSString *)aFormatSignature, ...;
- (MethodGenerator *)addMethodName:(NSString *)aName
                           comment:(NSString *)aComment
                       declaration:(BOOL)isDeclaration
                         signature:(NSString *)aFormatSignature, ...;
//配置完成后调用，返回正确代码
- (NSString *)header;
- (NSString *)implementation;

@end



@interface MethodGenerator : NSObject

@property(nonatomic, strong) NSString *comment;
@property(nonatomic, strong) NSString *signature;
@property(nonatomic, strong) IndentedLines *lines;

- (id)initWithSignature:(NSString *)aSignature comment:(NSString *)aComment;
- (id)initWithSignature:(NSString *)aSignature;
- (void)addLineIndent:(NSUInteger)aIndent format:(NSString *)aFormat, ...;
@end

@interface IndentLine : NSObject

@property(nonatomic, assign) NSUInteger indent;
@property(nonatomic, strong) NSString *text;

@end

@interface IndentedLines : NSObject
@property(nonatomic, strong) NSMutableArray *indentedLines;
@end
