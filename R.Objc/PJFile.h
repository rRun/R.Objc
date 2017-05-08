//
//  PJFile.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PJDictionary;
@interface PJFile : NSObject

@property(nonatomic, strong) NSString *pjFilePath;
@property(nonatomic, strong) NSDictionary *objects;
@property(nonatomic, strong) PJDictionary *rootDictionary;

- (id)initWithProjectFile:(NSString *)aPath;

@end
