//
//  NSString+XCValidator.h
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XCValidator)

- (BOOL)isValidWithRegex:(NSString *)regex;

- (BOOL)creditCardluhmValid0;
- (BOOL)creditCardluhmValid1;

- (BOOL)IDCardValid0;
- (BOOL)IDCardValid1;

- (BOOL)callPhoneValid;

@end
