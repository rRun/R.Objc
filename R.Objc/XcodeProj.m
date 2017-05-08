//
//  XcodeProj.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/4/19.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "XcodeProj.h"
#import "PJFile.h"
#import "XCodeGroup.h"
#import "PJDictionary.h"
#import "XcodeFile.h"

@interface XcodeProj()


@end

@implementation XcodeProj

- (id)initWithPath:(NSString *)aPath
       environment:(NSDictionary *)anEnvironment {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager]
         fileExistsAtPath:aPath isDirectory:&isDir] && isDir) {
        aPath = [aPath stringByAppendingPathComponent:@"project.pbxproj"];
    }
    
    if (![aPath isAbsolutePath]) {
        NSMutableArray *components = [NSMutableArray array];
        [components addObject:[[NSFileManager defaultManager]
                               currentDirectoryPath]];
        [components addObject:aPath];
        aPath = [[NSString pathWithComponents:components]
                 stringByStandardizingPath];
    }
    
    self.pjFile = [[PJFile alloc]initWithProjectFile:aPath];
    if (self.pjFile == nil) {
        return nil;
    }
    
    // setup source tree paths by first checking the environment then fallback
    // to guessing based on project path
    
    self.sourceRoot = [anEnvironment objectForKey:@"SOURCE_ROOT"];
    if (self.sourceRoot == nil) {
        self.sourceRoot = [[self.pjFile.pjFilePath
                            stringByDeletingLastPathComponent]
                           stringByDeletingLastPathComponent];
    }
    
    self.buildProductDir = [anEnvironment
                            objectForKey:@"BUILT_PRODUCTS_DIR"];
    if (self.buildProductDir == nil) {
        self.buildProductDir = [NSString pathWithComponents:
                                [NSArray arrayWithObjects:
                                 self.sourceRoot, @"build", @"dummy", nil]];
    }
    
    self.developerDir = [anEnvironment objectForKey:@"DEVELOPER_DIR"];
    if (self.developerDir == nil) {
        self.developerDir = [NSString pathWithComponents:
                             [NSArray arrayWithObjects:@"/", @"Developer", nil]];
    }
    
    self.sdkRoot = [anEnvironment objectForKey:@"DEVELOPER_DIR"];
    if (self.sdkRoot == nil) {
        self.sdkRoot = @"/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.2.sdk";
    }
    
    self.sourceTrees = [NSDictionary dictionaryWithObjectsAndKeys:
                        self.sourceRoot, @"SOURCE_ROOT",
                        @"/", @"<absolute>",
                        self.buildProductDir, @"BUILT_PRODUCTS_DIR",
                        self.developerDir, @"DEVELOPER_DIR" ,
                        self.sdkRoot, @"SDKROOT",
                        nil];
    
    self.nodeRefs = [NSMutableDictionary dictionary];
    
    return self;
}

- (XCodeGroup *)loadGroup:(PJDictionary *)group {
    XCodeGroup *xcodeGroup = [[XCodeGroup alloc]
                               initFromPJDictionary:group
                               xcodeProj:self
                               parent:nil];
    if (xcodeGroup == nil) {
        [self raiseFormat:@"Failed to create group for %@", group.rootObject];
    }
    
    NSArray *children = [group refDictArrayForKey:@"children"];
    if (children == nil) {
        [self raiseFormat:@"Failed to read children array"];
    }
    for (PJDictionary *child in children) {
        NSString *childIsa = [child objectForKey:@"isa"];
        XCodeNode *childXcodeNode = nil;
        
        if (childIsa != nil && [childIsa isKindOfClass:[NSString class]]) {
            if ([childIsa isEqualToString:@"PBXGroup"] ||
                [childIsa isEqualToString:@"PBXVariantGroup"]) {
                
                childXcodeNode = (XCodeNode *)[self loadGroup:child];
                childXcodeNode.parent = xcodeGroup;
            } else if ([childIsa isEqualToString:@"PBXFileReference"]) {
                childXcodeNode = (XCodeNode *)[[XcodeFile alloc]
                                                initFromPJDictionary:child
                                                xcodeProj:self
                                                parent:xcodeGroup];
                if (childXcodeNode == nil) {
                    [self raiseFormat:@"Failed to create file reference for %@",
                     child.rootObject];
                }
            }
            
            if (childXcodeNode != nil) {
                [xcodeGroup.children addObject:childXcodeNode];
                [self.nodeRefs setObject:childXcodeNode
                                  forKey:childXcodeNode.objectId];
            }
        }
    }
    
    return xcodeGroup;
}

- (XCodeGroup *)loadMainGroup {
    if (self.mainGroup == nil) {
        PJDictionary *mainGroupDict = [self.pjFile.rootDictionary
                                        refDictForKey:@"mainGroup"];
        if (mainGroupDict == nil) {
            [self raiseFormat:@"Failed to read mainGroup key"];
        }
        
        self.mainGroup = [self loadGroup:mainGroupDict];
        if (self.mainGroup == nil) {
            [self raiseFormat:@"Failed to load mainGroup"];
        }
    }
    
    return self.mainGroup;
}

- (void)forEachBuildResource:(void (^)(NSString *buildTargetName,
                                       XCodeNode *xcodeNode))block {
    [self loadMainGroup];
    
    NSArray *targets = [self.pjFile.rootDictionary refDictArrayForKey:@"targets"];
    if (targets == nil) {
        [self raiseFormat:@"Failed to read targets array"];
    }
    
    for (PJDictionary *target in targets) {
        NSString *name = [target objectForKey:@"name"];
        if (name == nil || ![name isKindOfClass:[NSString class]]) {
            [self raiseFormat:@"Failed to read target name"];
        }
        
        NSArray *buildPhases = [target refDictArrayForKey:@"buildPhases"];
        if (buildPhases == nil) {
            [self raiseFormat:@"Failed to read buildPhases array for target \"%@\"",
             name];
        }
        
        for (PJDictionary *buildPhase in buildPhases) {
            NSString *buildIsa = [buildPhase objectForKey:@"isa"];
            if (buildIsa == nil || ![buildIsa isKindOfClass:[NSString class]]) {
                [self raiseFormat:
                 @"Failed to read buildIsa for buildPhase for target \"%@\"",name];
            }
            
            if (![buildIsa isEqualToString:@"PBXResourcesBuildPhase"]) {
                continue;
            }
            
            NSArray *files = [buildPhase refDictArrayForKey:@"files"];
            if (files == nil) {
                [self raiseFormat:
                 @"Failed to read files array for resource build phase for target \"%@\"",
                 name];
            }
            
            for (PJDictionary *file in files) {
                PJDictionary *fileRef = [file refDictForKey:@"fileRef"];
                if (fileRef == nil) {
                    [self raiseFormat:
                     @"Failed to read fileRef for file in resource build phase for target \"%@\"",
                     name];
                }
                
                NSString *fileRefIsa = [fileRef objectForKey:@"isa"];
                if ([fileRefIsa isEqualToString:@"PBXVariantGroup"]) {
                    XCodeGroup *variantGroup = [self.nodeRefs objectForKey:fileRef.objectId];
                    if (variantGroup == nil) {
                        [self raiseFormat:
                         @"Could not find variant group %@ for build file", fileRef.objectId];
                        continue;
                    }
                    block(name, variantGroup);
                }
                else {
                    XcodeFile *xcodeNode = [self.nodeRefs objectForKey:fileRef.objectId];
                    if (xcodeNode == nil) {
                        [self raiseFormat:
                         @"Could not find file reference %@ for build file", fileRef.objectId];
                        continue;
                    }
                    block(name, xcodeNode);
                }
            }
        }
    }
}

- (NSString *)projectName {
    NSArray *components = [self.pjFile.pjFilePath pathComponents];
    if ([components count] > 1) {
        return [components objectAtIndex:[components count] - 2];
    } else {
        return self.pjFile.pjFilePath;
    }
}

- (NSString *)absolutePath:(NSString *)path
                sourceTree:(NSString *)sourceTree
                 groupPath:(NSString *)groupPath {
    NSString *treePath;
    
    if ([sourceTree isEqualToString:@"<group>"]) {
        treePath = groupPath;
    } else {
        treePath = [self.sourceTrees objectForKey:sourceTree];
        if (treePath == nil) {
            return nil;
        }
    }
    
    return [[NSString pathWithComponents:
             [NSArray arrayWithObjects:treePath, path, nil]]
            stringByStandardizingPath];
}

- (void)raiseFormat:(NSString *)format, ... {
    va_list va;
    va_start(va, format);
    [NSException raise:@"error" format:format arguments:va];
    va_end(va);
}

@end
