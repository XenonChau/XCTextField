//
//  XCCreditCardConfiguration.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XCCreditCardConfiguration.h"
#import "NSString+XCValidator.h"

static NSString *const kCreditCardfailureReason = @"Credit card number in invalid format.";

@implementation XCCreditCardConfiguration

-(BOOL)isValidTextField:(nullable UITextField *)textField
                  error:(NSError * _Nullable __autoreleasing *)error {
    BOOL valid = [textField.text creditCardluhmValid1];
    if (valid) return YES;
    
    *error = XCTextFieldErrorFromString(kCreditCardfailureReason);
    return NO;
}

#pragma mark - UITextInputTraits

- (UIKeyboardType)keyboardType{
    return UIKeyboardTypeNumberPad;
}

- (UITextContentType)textContentType {
    return UITextContentTypeCreditCardNumber;
}

@end
