//
//  XCodeNode.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "XCodeNode.h"
#import "XCodeGroup.h"
#import "XcodeProj.h"

#import "PJDictionary.h"

@implementation XCodeNode

- (id)initFromPJDictionary:(PJDictionary *)pjDict
                  xcodeProj:(XcodeProj *)anXCodeProj
                     parent:(XCodeGroup *)anParent{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.objectId = pjDict.objectId;
    self.xcodeProj = anXCodeProj;
    self.parent = anParent;
    self.name = [pjDict objectForKey:@"name"];
    self.sourceTree = [pjDict objectForKey:@"sourceTree"];
    self.path = [pjDict objectForKey:@"path"];
    
    if (self.sourceTree == nil) {
        return nil;
    }
    
    return self;
}

- (NSString *)absolutePath {
    NSString *p;
    NSString *groupPath = nil;
    
    if ([self.sourceTree isEqualToString:@"<group>"]) {
        if (self.parent == nil) {
            groupPath = self.xcodeProj.sourceRoot; // projectDir?
        } else {
            groupPath = [self.parent absolutePath];
        }
    }
    
    p = [self.xcodeProj absolutePath:self.path
                          sourceTree:self.sourceTree
                           groupPath:groupPath];
    
    return p;
}

@end
