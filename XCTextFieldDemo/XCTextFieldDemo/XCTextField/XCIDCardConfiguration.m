//
//  XCIDCardConfiguration.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XCIDCardConfiguration.h"
#import "NSString+XCValidator.h"

static NSString *const kIDCardfailureReason = @"ID card number in invalid format.";

@implementation XCIDCardConfiguration

#pragma mark - XCTextFieldValidator

-(BOOL)isValidTextField:(nullable UITextField *)textField
                  error:(NSError * _Nullable __autoreleasing *)error {
    BOOL valid = [textField.text IDCardValid0];
    if (valid) return YES;
    
    *error = XCTextFieldErrorFromString(kIDCardfailureReason);
    return NO;
}

#pragma mark - XCTextFieldInputTraits

- (UIKeyboardType)keyboardType{
    return UIKeyboardTypeNamePhonePad;
}

@end
