//
//  main.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/4/19.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPrint.h"

#import "ResourcesGenerator.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        const char * argv0 = argv[0];
        
        BOOL generateImages = NO;
        BOOL generatePaths = NO;
        BOOL generateStringKeys = NO;
        BOOL generateLoadImages = NO;
        BOOL ipadImageSuffx = NO;
        BOOL ipad2xImageSuffx = NO;
        
        static struct option longopts[] = {
            {"images", no_argument, NULL, 'I'},
            {"paths", no_argument, NULL, 'P'},
            {"stringkeys", no_argument, NULL, 'S'},
            {"loadimages", no_argument, NULL, 1},
            {"ipad", no_argument, NULL, 2},
            {"ipad2x", no_argument, NULL, 3},
            {"verbose", no_argument, NULL, 'v'},
            {NULL, 0, NULL, 0}
        };
        
        int c;
        while ((c = getopt_long(argc, argv, "IPSv", longopts, NULL)) != -1) {
            switch (c) {
                case 'v':
                    verbose = YES;
                    break;
                case 'I':
                    generateImages = YES;
                    break;
                case 'P':
                    generatePaths = YES;
                    break;
                case 'S':
                    generateStringKeys = YES;
                    break;
                case 1:
                    generateLoadImages = YES;
                    break;
                case 2:
                    ipadImageSuffx = YES;
                    break;
                case 3:
                    ipad2xImageSuffx = YES;
                    break;
                case '?':
                default:
                    break;
            }
        }
        argc -= optind;
        argv += optind;
        
        if (argc < 1) {
            printf("Usage: %s [-IPSv] xcodeproject [Output path] [Target name]\n"
                   "  -I, --images      Generate I images property tree\n"
                   "  -P, --paths       Generate P paths property tree\n"
                   "  -S, --stringkeys  Generate S localizable string keys class\n"
                   "  --loadimages      Generate loadImages/releaseImages methods\n"
                   "  --ipad            Support @ipad image name scale suffix\n"
                   "  --ipad2x          Support @2x as 1.0 scale image on iPad\n"
                   "  -v, --verbose     Verbose output\n"
                   "",
                   argv0);
            return EXIT_FAILURE;
        }
        
        if (!(generateImages || generatePaths || generateStringKeys)) {
            error(@"Please specify at least -I, -P or -S");
            return EXIT_FAILURE;
        }
        
        NSString *path = [NSString stringWithCString:argv[0]
                                            encoding:NSUTF8StringEncoding];
        NSString *outputDir = @".";
        NSString *className = @"Resources";
        if (argc > 1) {
            NSString *outputBase = [NSString stringWithCString:argv[1]
                                                      encoding:NSUTF8StringEncoding];
            className = [outputBase lastPathComponent];
            outputDir = [outputBase stringByDeletingLastPathComponent];
        }
        
        NSString *targetName = nil;
        if (argc > 2) {
            targetName = [NSString stringWithCString:argv[2]
                                            encoding:NSUTF8StringEncoding];
        }

        @try {
            ResourcesGenerator *gen = [[ResourcesGenerator alloc]
                                        initWithProjectFile:path];
            if (gen == nil) {
                error(@"Failed to read xcode project at path %@", path);
                return EXIT_FAILURE;
            }
            
            gen.optionGenerateImages = generateImages;
            gen.optionGeneratePaths = generatePaths;
            gen.optionGenerateStringKeys = generateStringKeys;
            gen.optionLoadImages = generateLoadImages;
            gen.optionIpadImageSuffx = ipadImageSuffx;
            gen.optionIpad2xImageSuffx = ipad2xImageSuffx;
            
            [gen writeResoucesTo:outputDir
                       className:className
                       forTarget:targetName];
            
        } @catch (ResourcesGeneratorException *exception) {
            error(exception.reason);
            return EXIT_FAILURE;
        }
        
 
    }
    return EXIT_SUCCESS;;
}

