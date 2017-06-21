//
//  XConfiguration.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XConfiguration.h"

NSError * XCTextFieldErrorFromString(NSString *string) {
    NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(string, @"XCTextField", nil)};
    return [NSError errorWithDomain:XTTextFieldValidatorErrorDomain code:-1 userInfo:userInfo];
}

@implementation XConfiguration

+ (instancetype)configuration {
    return [[self alloc] init];
}

#pragma mark - XCTextFieldValidator

- (BOOL)textFieldShouldValidator:(UITextField *)textField {
    return YES;
}

- (BOOL)isValidTextField:(nullable UITextField *)textField
                   error:(NSError * _Nullable __autoreleasing *)error {
    return YES;
}

#pragma mark - UITextInputTraits

- (UITextAutocapitalizationType)autocapitalizationType{
    return UITextAutocapitalizationTypeNone;
}

- (UITextAutocorrectionType)autocorrectionType{
    return UITextAutocorrectionTypeNo;
}

- (UITextSpellCheckingType)spellCheckingType{
    return UITextSpellCheckingTypeNo;
}

@end
