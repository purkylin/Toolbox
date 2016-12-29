//
//  SudoHelper.h
//  PriviliegeSample
//
//  Created by Purkylin King on 2016/12/22.
//  Copyright © 2016年 Purkylin King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SudoHelper : NSObject

+ (instancetype)sharedInstance;

- (void)config;

- (void)install;

- (void)runCommand:(NSString *)cmd completion: (void (^)(NSString *output, BOOL success))block;
@end
