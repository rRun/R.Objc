//
//  PJFile.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "PJFile.h"

#import "PJDictionary.h"

@implementation PJFile

- (id)initWithProjectFile:(NSString *)aPath {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    NSDictionary *project = [NSDictionary dictionaryWithContentsOfFile:aPath];
    if (project == nil ||
        ![project isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self.objects = [project objectForKey:@"objects"];
    if (self.objects == nil ||
        ![self.objects isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString *rootObjectId = [project objectForKey:@"rootObject"];
    if (rootObjectId == nil ||
        ![rootObjectId isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSDictionary *rootObject = [self.objects objectForKey:rootObjectId];
    if (rootObject == nil ||
        ![rootObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self.pjFilePath = aPath;
    self.rootDictionary = [[PJDictionary alloc]
                            initWithRoot:rootObject
                            pjFile:self
                            objectId:rootObjectId];
    
    return self;
}

@end
