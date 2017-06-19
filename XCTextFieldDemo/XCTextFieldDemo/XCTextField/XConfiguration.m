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

#pragma mark - XCTextFieldInputTraits

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
