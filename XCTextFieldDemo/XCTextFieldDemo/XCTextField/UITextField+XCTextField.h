//
//  UITextField+XCTextField.h
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

/**
 * @brief 由于好多项目都用到这些字段检查，本地收纳差点丢失，出于个人便利原因，开了此仓库。
 * @remarks 由于在类目中创建属性通常是创建 *id 类型，对于 常量、结构体 等值类型会有一些坑。
 * @see https://github.com/XenonChau/XCTextField
 * @todo 1 现在是pre-release版本，正式投产之前，要将UI动画换成CG动画。
 * @todo 2 现在还有一些内存暴增的情况，模拟器下稳定在48.4M，说不过去啊。
 */

#import <UIKit/UIKit.h>
#import "XCTextFieldProtocol.h"

typedef NS_ENUM(NSInteger, XCTextFieldType) {
    XCTextFieldTypeDefault             = 0,
    XCTextFieldTypeCellphone        = 1,
    XCTextFieldTypeEmail                = 2,
    XCTextFieldTypePassword         = 3,
    XCTextFieldTypeCAPTCHA        = 4,
    XCTextFieldTypeCreditCard       = 5,
    XCTextFieldTypeIDCard             = 6,
    XCTextFieldTypeCurrency          = 7,
};

@interface UITextField (XCTextField)

@property(nonatomic, strong) id<XCTextFieldConfiguration> configuration;

@property(nonatomic, assign) id<XCTextFieldValidator>validator;//TODO:weak
@property(nonatomic, assign) id<XCTextFieldInputTraits>inputTraits;//TODO:weak

/**
    @todo Control the style using only this property.
 */
@property (assign, nonatomic) XCTextFieldType fieldType;

/**
    @result The error reason or correct message.
 */
@property (copy   , nonatomic) NSString *checkResult;

/**
    @brief Set up Customized TextField
    @param type Factory partten control
 */
- (void)configurationWithType:(XCTextFieldType)type;

/**
    @brief For text checking according to the rules.
    @param flag TextField become first responder if it's true.
 */
- (void)inputCheckForceCorrect:(BOOL)flag;

@end
