//
//  XCTextField.h
//  XCTextFieldDemo
//
//  Created by imeng on 6/20/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface XCTextField : UITextField

/// @brief To save the origin layer.borderColor;
@property (readwrite, nonatomic) CGColorRef borderColor;
/// @brief To save the origin layer.borderWidth;
@property (readwrite, nonatomic) CGFloat borderWidth;
/// @brief To save the origin layer.cornerRadius;
@property (readwrite, nonatomic) CGFloat corprenerRadius;
/// @brief When correct is true, border color will not change again.
@property (readwrite, nonatomic) BOOL correct;

/**
 @result The error reason or correct message.
 */
@property (copy   , nonatomic) NSString *checkResult;
/**
 @todo Control the style using only this property.
 */
@property (assign, nonatomic) XCTextFieldType fieldType;

/**
 @brief Set up Customized TextField
 @param type Factory partten control
 */
- (void)configurationWithType:(XCTextFieldType)type;

- (void)inputCheckForceCorrect:(BOOL)flag;

@end
