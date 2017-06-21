//
//  XCTextField.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/20/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "XCTextField.h"
#import <objc/runtime.h>

#import "UITextField+XCTextField.h"

#import "XCEmailConfiguration.h"
#import "XCCallPhoneConfiguration.h"
#import "XCCreditCardConfiguration.h"
#import "XCIDCardConfiguration.h"

@interface XCTextField () <XCTextFieldTextDisplay>

@end

@implementation XCTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.textFieldDisplay = self;
    
    // Give self a default type, if user does NOT setup.
    if (!self.layer.borderColor) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    if (!self.layer.borderWidth) {
        self.layer.borderWidth = 1.5f;
    }
    if (!self.layer.cornerRadius) {
        self.layer.cornerRadius = self.frame.size.height / 7.5f;
    }
    
    // Save the origin border style.
    self.corprenerRadius = self.layer.cornerRadius;
    self.borderWidth = self.layer.borderWidth;
    self.borderColor = self.layer.borderColor;
}

#pragma mark - Initialiaze Configuration
- (void)configurationWithType:(XCTextFieldType)type {
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    /*!
     @todo HOW can I use only one enum property to control this TF?
     */
    self.fieldType = type;
    self.secureTextEntry = NO;

    // Configure each type as well.
    switch (type) {
        case XCTextFieldTypeCellphone: {
            self.configuration = [XCCallPhoneConfiguration configuration];
            break;
        }
        case XCTextFieldTypeEmail: {
            self.configuration = [XCEmailConfiguration configuration];
            break;
        }
        case XCTextFieldTypeCreditCard: {
            self.configuration = [XCCreditCardConfiguration configuration];
            break;
        }
        case XCTextFieldTypeIDCard: {
            self.configuration = [XCIDCardConfiguration configuration];
            break;
        }
        case XCTextFieldTypePassword: {
            self.secureTextEntry = YES;
        }
            break;
        case XCTextFieldTypeCAPTCHA:
        default: {
            // default type.
            break;
        }
    }
}

#pragma mark - Public method

- (void)inputCheckForceCorrect:(BOOL)flag {
    
    // Check the text according to the rules.
    
    if (!self.text.length) {
        // Verfy empty string.
        self.checkResult = [NSString stringWithFormat:@"%@, Empty textField.", self];
        [self incorrectAnimation];
        !flag ? : [self becomeFirstResponderWhenFirstIncorrect];
        return;
    }
    
    // Rules:
    [self xc_doValidation];
    !flag ? : [self becomeFirstResponderWhenFirstIncorrect];
}


#pragma mark - Field Animation

- (void)correctTextField:(nullable __kindof UITextField *)textField {
    [self correctAnimation];
}

- (void)incorrectTextField:(nullable __kindof UITextField *)textField error:(NSError *)error {
    [self incorrectAnimation];
}


- (void)correctAnimation {
    
//    NSLog(@"get radius = %f", self.corprenerRadius);
//    NSLog(@"get width = %f", self.borderWidth);
//    NSLog(@"get color = %@", self.borderColor);
    
    self.correct = YES;
//    self.checkResult = @"Correct textField.";
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1.5f animations:^{
            self.layer.borderColor = [[UIColor greenColor] CGColor];
            self.layer.borderWidth = self.layer.borderWidth ? : 0.5f;
            self.layer.cornerRadius = self.layer.cornerRadius ? : self.frame.size.height / 7.5;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(1.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.layer.cornerRadius = self.corprenerRadius;
                           self.layer.borderWidth = self.borderWidth;
                           self.layer.borderColor = self.borderColor;
                       });
    });
    
}

- (void)incorrectAnimation {
//    NSLog(@"%zi", self.fieldType);
    self.correct = NO;
    [UIView animateWithDuration:0.9f animations:^{
        self.layer.borderColor = [[UIColor redColor] CGColor];
        self.layer.borderWidth = self.layer.borderWidth ? : 0.5f;
        self.layer.cornerRadius = self.layer.cornerRadius ? : self.frame.size.height / 7.5;
    }];
}

#pragma mark - Field Action
- (void)becomeFirstResponderWhenFirstIncorrect {
    
    for (UIView *subview in self.superview.subviews) {
        if ([subview isKindOfClass:[XCTextField class]]) {
            XCTextField *textField = (XCTextField *)subview;
            if (!textField.correct) {
                [textField becomeFirstResponder];
                break;
            }
        }
    }
    //    [[self class] howCanIUseSelfInClassMethod];
}

#pragma mark - Test Method
+ (void)howCanIUseSelfInClassMethod {
    
    /**
     * 一个科学试验：在 + 方法中找到 self 的对象指针。
     *
     */
    
    
    for (UIView *subview in [(__bridge UIView *)class_getProperty([UIView class], "superview") subviews]) {
        if ([subview isKindOfClass:self]) {
            XCTextField *textField = (XCTextField *)subview;
            if (!textField.correct) {
                [textField becomeFirstResponder];
                break;
            }
        }
    }
    NSLog(@"%@", self);
}

@end
