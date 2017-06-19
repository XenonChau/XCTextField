//
//  XCRegexConfiguration.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XCRegexConfiguration.h"

@implementation XCRegexConfiguration

#pragma mark - XCTextFieldValidator

- (BOOL)isValidTextField:(UITextField *)textField error:(NSError *__autoreleasing  _Nullable *)error {
    NSString *textFieldText = textField.text;
    BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex] evaluateWithObject:[textFieldText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if (isValid) return YES;
    
    NSString *failureReason = self.failureReason;
    if (!failureReason) failureReason = @"TextField text Not Match";
    
    *error = XCTextFieldErrorFromString(failureReason);
    return NO;
}

@end
