//
//  PJDictionary.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/4/24.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "PJDictionary.h"
#import "PJFile.h"

@implementation PJDictionary
- (id)initWithRoot:(NSDictionary *)rootObject
            pjFile:(PJFile *)pjFile
          objectId:(NSString *)objectId{
    
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.rootObject = rootObject;
    self.pjFile = pjFile;
    self.objectId = objectId;
    
    return self;
}

- (PJDictionary *)refDictForObjectId:(NSString *)anObjectId {
    if (anObjectId == nil || ![anObjectId isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSDictionary *newRootObject = [self.pjFile.objects objectForKey:anObjectId];
    if (newRootObject == nil ||
        ![newRootObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[PJDictionary alloc]
             initWithRoot:newRootObject
             pjFile:self.pjFile
             objectId:anObjectId];
}

- (PJDictionary *)refDictForKey:(NSString *)key {
    return [self refDictForObjectId:[self objectForKey:key]];
}

- (NSArray *)refDictArrayForKey:(NSString *)key {
    NSArray *objectIdArray = [self objectForKey:key];
    if (objectIdArray == nil ||
        ![objectIdArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *pbxDictObjects = [NSMutableArray array];
    for (NSString *anObjectId in objectIdArray) {
        PJDictionary *dict = [self refDictForObjectId:anObjectId];
        if (dict == nil) {
            return nil;
        }
        
        [pbxDictObjects addObject:dict];
    }
    
    return pbxDictObjects;
}

- (id)objectForKey:(NSString *)key {
    return [self.rootObject objectForKey:key];
}

@end
