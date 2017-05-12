//
//  UITextField+XCTextField.h
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XCTextFieldType) {
    ECTextFieldTypeDefault = 0,
    ECTextFieldTypeCellphone = 1,
    ECTextFieldTypeEmail = 2,
    ECTextFieldTypePassword = 3,
    ECTextFieldTypeCAPTCHA = 4,
};

@interface UITextField (XCTextField)

@property (assign, nonatomic) XCTextFieldType fieldType;
@property (copy   , nonatomic) NSString *checkResult;


- (void)configurationWithType:(XCTextFieldType)type;

- (void)fieldTypeCheck;
- (void)incorrectTextField;
- (void)correctTextField;

@end
