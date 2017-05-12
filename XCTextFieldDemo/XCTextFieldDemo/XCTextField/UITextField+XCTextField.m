//
//  UITextField+XCTextField.m
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "UITextField+XCTextField.h"
#import <objc/runtime.h>

@interface UITextField ()
@property (readwrite, nonatomic) CGColorRef borderColor;
@property (readwrite, nonatomic) CGFloat borderWidth;
@property (readwrite, nonatomic) CGFloat cornerRadius;
@property (readwrite, nonatomic) BOOL correct;
@end

@implementation UITextField (XCTextField)
@dynamic fieldType;
@dynamic checkResult;

- (void)setFieldType:(XCTextFieldType)newFieldType {
    objc_setAssociatedObject(self, @selector(fieldType), @(newFieldType), OBJC_ASSOCIATION_ASSIGN);
}

- (XCTextFieldType)fieldType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setCheckResult:(NSString *)newCheckResult {
    objc_setAssociatedObject(self,
                             @selector(checkResult),
                             newCheckResult,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)checkResult {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBorderColor:(CGColorRef)newBorderColor {
    objc_setAssociatedObject(self,
                             @selector(borderColor),
                             [UIColor colorWithCGColor:newBorderColor], // <- 这个地方存不住
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGColorRef)borderColor {
    return [objc_getAssociatedObject(self, _cmd) CGColor];
}

- (void)setBorderWidth:(CGFloat)newBorderWidth {
    objc_setAssociatedObject(self,
                             @selector(borderWidth),
                             @(newBorderWidth),//[NSNumber numberWithFloat:newBorderWidth],
                             OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)borderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCornerRadius:(CGFloat)newCornerRadius {
    objc_setAssociatedObject(self,
                             @selector(cornerRadius),
                             @(newCornerRadius), // <- 语法糖强制舍去小数点后面数字
                             OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCorrect:(BOOL)correct {
    objc_setAssociatedObject(self, @selector(correct), @(correct), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)correct {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)becomeFirstResponderWhenFirstIncorrect {
    
    for (UIView *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subview;
            if (!textField.correct) {
                [textField becomeFirstResponder];
                break;
            }
        }
    }
//    [[self class] howCanIUseSelfInClassMethod];
}

+ (void)howCanIUseSelfInClassMethod {
    
    for (UIView *subview in [(__bridge UIView *)class_getProperty([UIView class], "superview") subviews]) {
        if ([subview isKindOfClass:self]) {
            UITextField *textField = (UITextField *)subview;
            if (!textField.correct) {
                [textField becomeFirstResponder];
                break;
            }
        }
    }
    NSLog(@"%@", self);
}

- (void)fieldTypeCheck {
    
    if (!self.text.length) {
        self.checkResult = [NSString stringWithFormat:@"%@, Empty textField.", self];
        [self incorrectAnimation];
        [self becomeFirstResponderWhenFirstIncorrect];
        return;
    }
    
    switch (self.fieldType) {
        case XCTextFieldTypeEmail: {
            [self emailCheck];
            break;
        }
        case XCTextFieldTypeIDCard: {
            [self IDCardCheck];
            break;
        }
//        case XCTextFieldTypePassword: {
//            
//            break;
//        }
        default: {
            [self correctAnimation];
            break;
        }
    }
    
    [self becomeFirstResponderWhenFirstIncorrect];
}

- (void)correctAnimation {
    //    NSLog(@"get radius = %f", self.cornerRadius);
    //    NSLog(@"get width = %f", self.borderWidth);
    //    NSLog(@"get color = %@", self.borderColor);
    self.correct = YES;
    self.checkResult = @"Correct textField.";
    
    [UIView animateWithDuration:1.5f delay:2.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [[self layer] setBorderColor:[[UIColor greenColor] CGColor]];
        //        [[self layer] setBorderWidth:self.borderWidth];
        [[self layer] setCornerRadius:self.cornerRadius];
        [[self layer] setBorderWidth:0.5f];
    } completion:^(BOOL finished) {
        [[self layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    }];
}

- (void)incorrectAnimation {
    NSLog(@"%zi", self.fieldType);
    self.correct = NO;
    [UIView animateWithDuration:0.9f animations:^{
        [[self layer] setBorderColor:[[UIColor redColor] CGColor]];
        [[self layer] setBorderWidth:0.5f];
        [[self layer] setCornerRadius:self.frame.size.height/7.5f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)configurationWithType:(XCTextFieldType)type {
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.fieldType = type;
    
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (!self.layer.borderColor) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (!self.layer.borderWidth) {
        self.layer.borderWidth = 0.5f;
    }
    
    if (!self.layer.cornerRadius) {
        self.layer.cornerRadius = self.frame.size.height / 7.5f;
    }
    
    self.layer.masksToBounds = YES;
    
    self.cornerRadius = self.layer.cornerRadius;
    //    self.borderWidth = self.layer.borderWidth;
    self.borderColor = self.layer.borderColor;
    
    NSLog(@"set radius = %f", self.cornerRadius);
    //    NSLog(@"set width = %f", self.borderWidth);
    //    NSLog(@"set color = %@", [UIColor colorWithCGColor:self.borderColor]);
    
    switch (type) {
        case XCTextFieldTypeCellphone: {
            self.keyboardType  = UIKeyboardTypePhonePad;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            self.textContentType = UITextContentTypeTelephoneNumber;
#endif
            break;
        }
        case XCTextFieldTypePassword: {
            self.secureTextEntry = YES;
            self.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        }
        case XCTextFieldTypeEmail: {
            self.keyboardType = UIKeyboardTypeEmailAddress;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            self.textContentType = UITextContentTypeEmailAddress;
#endif
            break;
        }
        case XCTextFieldTypeCAPTCHA: {
            self.keyboardType = UIKeyboardTypeNamePhonePad;
            break;
        }
        case XCTextFieldTypeCreditCard: {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            self.textContentType = UITextContentTypeCreditCardNumber;
#else
            self.keyboardType = UIKeyboardTypeNumberPad;
#endif
            break;
        }
        case XCTextFieldTypeIDCard: {
            self.keyboardType = UIKeyboardTypeNamePhonePad;
            break;
        }
        default: {
            // default type.
            break;
        }
    }
}

#pragma mark - Text Field Check

- (void)emailCheck {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if (![emailTest evaluateWithObject:self.text]) {
        self.checkResult = @"Email Address in invalid format.";
        [self incorrectAnimation];
    } else {
        [self correctAnimation];
    }
}

- (void)creditCardCheck {
    /** Luhn algorithm
        @see https://en.wikipedia.org/wiki/Luhn_algorithm
     */
}

- (void)IDCardCheck {
    /**
        @brief 中国大陆居民身份证算法
        地址码: 前六位
        生日期码: 七到十四位
        顺序码: 十五到十七位（17位：奇数为男性，偶数为女性）
        校验码: 最后一位 ISO 7064:1983.MOD 11-2
        前十七位系数: {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2}
        每位的数字和对应的系数相乘后相加，后对11取余。
        余数对照表: {"1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"}
     */
    
    if (self.text.length != 18) {
        [self incorrectAnimation];
        return;
    }
    
    if (checkIDCard(self.text.UTF8String)) {
        [self correctAnimation];
    } else {
        [self incorrectAnimation];
    }
}

bool checkIDCard(const char *idCardString) {
    
    long long strLen = strlen(idCardString);
    char lastChar = idCardString[strLen - 1];
    int factors[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
    char * retrieve[] = {"1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"};
    
    long long sum = 0;
    for (int i = 0; i < strLen - 1; i ++) {
        char c = idCardString[i];
        sum += (c - 48) * factors[i];
    }
    
    int position = sum % 11;
    char code = *retrieve[position];
    
    if (code == lastChar) {
        return true;
    } else {
        return false;
    }
    
}

@end
