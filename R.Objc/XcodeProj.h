//
//  XcodeProj.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/4/19.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PJFile;
@class XCodeNode;
@class XCodeGroup;
@interface XcodeProj : NSObject

@property(nonatomic, strong) PJFile *pjFile;
@property(nonatomic, retain) XCodeGroup *mainGroup;

@property(nonatomic, strong) NSString *sourceRoot;
@property(nonatomic, strong) NSString *buildProductDir;
@property(nonatomic, strong) NSString *developerDir;
@property(nonatomic, strong) NSString *sdkRoot;
@property(nonatomic, strong) NSDictionary *sourceTrees;

@property(nonatomic, strong) NSMutableDictionary *nodeRefs;

- (id)initWithPath:(NSString *)aPath
       environment:(NSDictionary *)anEnvironment;

- (NSString *)projectName;
- (NSString *)absolutePath:(NSString *)path
                sourceTree:(NSString *)sourceTree
                 groupPath:(NSString *)groupPath;

- (void)forEachBuildResource:(void (^)(NSString *buildTargetName,
                                       XCodeNode *xcodeNode))block;
@end
