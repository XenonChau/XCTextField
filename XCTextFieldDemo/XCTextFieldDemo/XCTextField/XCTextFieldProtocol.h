//
//  XCTextFieldValidatorProtocol.h
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const XTTextFieldValidatorErrorDomain = @"com.xctextfield.error.validator";

@protocol XCTextFieldValidator <NSObject>

@required
- (BOOL)isValidTextField:(nullable __kindof UITextField *)textField
                  error:(NSError * _Nullable __autoreleasing *)error;

@optional
- (BOOL)textFieldShouldValidator:(UITextField *)textField;

- (void)willValidatorTextField:(nullable __kindof UITextField *)textField;
- (void)didEndValidatorTextField:(nullable __kindof UITextField *)textField error:(NSError *)error;

@end

@protocol XCTextFieldTextDisplay <NSObject>

@optional
- (void)correctTextField:(nullable __kindof UITextField *)textField;
- (void)incorrectTextField:(nullable __kindof UITextField *)textField error:(NSError *)error;

@end

@protocol XCTextFieldConfiguration <XCTextFieldValidator,UITextInputTraits>

@end

NS_ASSUME_NONNULL_END
