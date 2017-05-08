//
//  XCodeNode.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XcodeProj;
@class XCodeGroup;
@class PJDictionary;
@interface XCodeNode : NSObject

@property(nonatomic, weak) XcodeProj *xcodeProj;
@property(nonatomic, weak) XCodeGroup *parent;

@property(nonatomic, strong) NSString *objectId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *path;
@property(nonatomic, strong) NSString *sourceTree;

- (id)initFromPJDictionary:(PJDictionary *)pjDict
                  xcodeProj:(XcodeProj *)anXCodeProj
                     parent:(XCodeGroup *)anParent;
- (NSString *)absolutePath;


@end
