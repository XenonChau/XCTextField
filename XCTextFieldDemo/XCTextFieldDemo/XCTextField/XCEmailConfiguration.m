//
//  XCEmailConfiguration.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XCEmailConfiguration.h"

static NSString *const kEmailValidRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
static NSString *const kEmailfailureReason = @"Email Address in invalid format.";

@implementation XCEmailConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.regex = kEmailValidRegex;
        self.failureReason = kEmailfailureReason;
    }
    return self;
}

#pragma mark - UITextInputTraits

- (UIKeyboardType)keyboardType{
    return UIKeyboardTypeEmailAddress;
}

- (UITextContentType)textContentType {
    return UITextContentTypeEmailAddress;
}

@end
