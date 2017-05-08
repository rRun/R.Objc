//
//  PJDictionary.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/4/24.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PJFile;
@interface PJDictionary : NSDictionary

@property(nonatomic, strong) PJFile *pjFile;//工程文件
@property(nonatomic, strong) NSDictionary *rootObject;
@property(nonatomic, strong) NSString *objectId;

- (id)initWithRoot:(NSDictionary *)rootObject
           pjFile:(PJFile *)pjFile
          objectId:(NSString *)objectId;


- (PJDictionary *)refDictForKey:(NSString *)key;
- (NSArray *)refDictArrayForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

@end
