//
//  UITextField+XCTextField.h
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XCTextFieldType) {
    XCTextFieldTypeDefault = 0,
    XCTextFieldTypeCellphone = 1,
    XCTextFieldTypeEmail = 2,
    XCTextFieldTypePassword = 3,
    XCTextFieldTypeCAPTCHA = 4,
    XCTextFieldTypeCreditCard = 5,
    XCTextFieldTypeIDCard = 6,
};

@interface UITextField (XCTextField)

@property (assign, nonatomic) XCTextFieldType fieldType;
@property (copy   , nonatomic) NSString *checkResult;


- (void)configurationWithType:(XCTextFieldType)type;

- (void)fieldTypeCheck;

@end
