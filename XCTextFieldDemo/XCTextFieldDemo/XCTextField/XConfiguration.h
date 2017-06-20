//
//  XConfiguration.h
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCTextFieldProtocol.h"

FOUNDATION_EXPORT NSError * XCTextFieldErrorFromString(NSString *string);

@interface XConfiguration : NSObject <XCTextFieldConfiguration>

+ (instancetype)configuration;

@end
