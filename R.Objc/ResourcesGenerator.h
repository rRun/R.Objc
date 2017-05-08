//
//  ResourcesGenerator.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XcodeProj.h"
#import "PJFile.h"

@interface ResourcesGenerator : NSObject

@property(nonatomic, assign) BOOL optionGenerateImages;//是否生成图片类
@property(nonatomic, assign) BOOL optionGeneratePaths;//是否生成路径类
@property(nonatomic, assign) BOOL optionGenerateStringKeys;//是否生成字符串类
@property(nonatomic, assign) BOOL optionLoadImages;
@property(nonatomic, assign) BOOL optionIpadImageSuffx;
@property(nonatomic, assign) BOOL optionIpad2xImageSuffx;


- (id)initWithProjectFile:(NSString *)aPath;
- (void)writeResoucesTo:(NSString *)outputDir
              className:(NSString *)className
              forTarget:(NSString *)targetName;

@end


@interface ResourcesGeneratorException : NSException
@end
