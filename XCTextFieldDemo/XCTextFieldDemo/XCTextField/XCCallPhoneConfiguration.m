//
//  XCCallPhoneConfiguration.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XCCallPhoneConfiguration.h"
#import "NSString+XCValidator.h"

static NSString *const kCallPhonefailureReason = @"Phone number in invalid format.";

@implementation XCCallPhoneConfiguration

#pragma mark - XCTextFieldValidator

-(BOOL)isValidTextField:(nullable UITextField *)textField
                  error:(NSError * _Nullable __autoreleasing *)error {
    BOOL valid = [textField.text callPhoneValid];
    if (valid) return YES;
    
    *error = XCTextFieldErrorFromString(kCallPhonefailureReason);
    return NO;
}

#pragma mark - UITextInputTraits

- (UIKeyboardType)keyboardType{
    return UIKeyboardTypePhonePad;
}

- (UITextContentType)textContentType {
    return UITextContentTypeTelephoneNumber;
} 

@end
