//
//  UITextField+XCTextField.h
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

/**
  * @todo 创建可以用于保存用户自定义的layer.borderColor layer.borderWidth layer.cornerRadius.
  * @remarks 由于在类目中创建属性通常是创建 *id 类型，对于 常量、结构体 等值类型会有一些坑。
 */

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

- (void)inputCheckForceCorrect:(BOOL)flag;

@end
