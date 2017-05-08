//
//  CPrint.h
//  R.Objc
//
//  Created by 何霞雨 on 2017/5/4.
//  Copyright © 2017年 何霞雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <getopt.h>

static BOOL verbose = NO;

void ptrace(NSString *format, ...);
void error(NSString *format, ...);

@interface CPrint : NSObject

@end
