//
//  ClassProperty.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "Property.h"

@interface ClassProperty : Property

@property(nonatomic, strong) NSString *className;
@property(nonatomic, assign) ClassProperty *parent;
@property(nonatomic, strong) NSMutableDictionary *properties;

- (NSString *)headerProlog:(ResourcesGenerator *)generator;
- (NSString *)implementationProlog:(ResourcesGenerator *)generator;
- (NSString *)inheritClassName;

- (id)initWithName:(NSString *)aName
            parent:(ClassProperty *)aParent
              path:(NSString *)aPath
         className:(NSString *)aClassName;

- (void)pruneEmptyClasses;
- (void)rescursePreOrder:(void (^)(NSArray *propertyPath,
                                   ClassProperty *classProperty))block;
- (void)rescursePostOrder:(void (^)(NSArray *propertyPath,
                                    ClassProperty *classProperty))block;

- (NSUInteger)countPropertiesOfClass:(Class)cls;
- (void)forEachProperty:(void (^)(Property *property))block ;
- (void)forEachPropertyOfClass:(Class)cls
                         block:(void (^)(Property *property))block;
- (ClassProperty *)lookupPropertyPathFromDir:(NSArray *)dirComponents;
@end
