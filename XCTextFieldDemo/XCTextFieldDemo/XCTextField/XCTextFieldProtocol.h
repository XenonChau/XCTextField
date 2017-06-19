//
//  XCTextFieldValidatorProtocol.h
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const XTTextFieldValidatorErrorDomain = @"com.xctextfield.error.validator";

@protocol XCTextFieldValidator <NSObject>

@required
- (BOOL)isValidTextField:(nullable UITextField *)textField
                  error:(NSError * _Nullable __autoreleasing *)error;

@optional

- (BOOL)textFieldShouldValidator:(UITextField *)textField;

- (void)willValidatorTextField:(nullable UITextField *)textField;
- (void)didEndValidatorTextField:(nullable UITextField *)textField;

@end

@protocol XCTextFieldInputTraits <UITextInputTraits>

@end

@protocol XCTextFieldConfiguration <XCTextFieldValidator,XCTextFieldInputTraits>

@end

@protocol XCTextFieldTextDisplay <NSObject>



@end



NS_ASSUME_NONNULL_END
