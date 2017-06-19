//
//  XCRegexConfiguration.h
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XConfiguration.h"

@interface XCRegexConfiguration : XConfiguration <XCTextFieldValidator>

@property(nonatomic, copy) NSString *regex;
@property(nonatomic, copy) NSString *failureReason;

@end
