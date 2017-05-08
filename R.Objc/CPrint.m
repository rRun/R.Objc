//
//  CPrint.m
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import "CPrint.h"


void fprintf_nsstring(FILE *stream, NSString *format, va_list va) {
    fprintf(stream, "%s\n",
            [[[NSString alloc] initWithFormat:format arguments:va]
             cStringUsingEncoding:NSUTF8StringEncoding]);
}
void ptrace(NSString *format, ...) {
    if (!verbose) {
        return;
    }
    
    va_list va;
    va_start(va, format);
    fprintf_nsstring(stdout, format, va);
    va_end(va);
}
void error(NSString *format, ...) {
    va_list va;
    va_start(va, format);
    fprintf_nsstring(stderr, [@"error: " stringByAppendingString:format], va);
    va_end(va);
}

@implementation CPrint

@end
