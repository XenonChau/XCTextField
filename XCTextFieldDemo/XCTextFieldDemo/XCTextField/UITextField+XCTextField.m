//
//  UITextField+XCTextField.m
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "UITextField+XCTextField.h"
#import <objc/runtime.h>

@implementation UITextField (XCTextField)

#pragma mark - update

- (void)updateConfiguration:(id<XCTextFieldConfiguration>)configuration {
    id<XCTextFieldValidator> validator = configuration;
    id<UITextInputTraits> inputTraits = configuration;
    
    self.validator = validator;
    self.inputTraits = inputTraits;
}

- (void)updateValidator:(id<XCTextFieldValidator>)validator {
    [self removeTarget:self action:@selector(xc_textFieldEditingChange:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(xc_textFieldEditingChange:) forControlEvents:UIControlEventEditingChanged];
    
    BOOL responds = [validator respondsToSelector:@selector(isValidTextField:error:)];
    NSAssert(responds, @"validator: %@ must implementation isValidTextField:error: method", validator);
    if (!responds) return;
}

- (void)updateInputTraits:(id<UITextInputTraits>)inputTraits {
    UITextAutocapitalizationType autocapitalizationType = [inputTraits respondsToSelector:@selector(autocapitalizationType)] ? [inputTraits autocapitalizationType] : self.autocapitalizationType;
    self.autocapitalizationType = autocapitalizationType;
    
    UITextAutocorrectionType autocorrectionType = [inputTraits respondsToSelector:@selector(autocorrectionType)] ? [inputTraits autocorrectionType] : self.autocorrectionType;
    self.autocorrectionType = autocorrectionType;
    
    UITextSpellCheckingType spellCheckingType = [inputTraits respondsToSelector:@selector(spellCheckingType)] ? [inputTraits spellCheckingType] : self.spellCheckingType;
    self.spellCheckingType = spellCheckingType;
    
    UIKeyboardType keyboardType = [inputTraits respondsToSelector:@selector(keyboardType)] ? [inputTraits keyboardType] : self.keyboardType;
    self.keyboardType = keyboardType;
    
    UIKeyboardAppearance keyboardAppearance = [inputTraits respondsToSelector:@selector(keyboardAppearance)] ? [inputTraits keyboardAppearance] : self.keyboardAppearance;
    self.keyboardAppearance = keyboardAppearance;
    
    UIReturnKeyType returnKeyType = [inputTraits respondsToSelector:@selector(returnKeyType)] ? [inputTraits returnKeyType] : self.returnKeyType;
    self.returnKeyType = returnKeyType;
    
    BOOL enablesReturnKeyAutomatically = [inputTraits respondsToSelector:@selector(enablesReturnKeyAutomatically)] ? [inputTraits enablesReturnKeyAutomatically] : self.enablesReturnKeyAutomatically;
    self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
    
    BOOL secureTextEntry = [inputTraits respondsToSelector:@selector(isSecureTextEntry)] ? [inputTraits isSecureTextEntry] : self.secureTextEntry;
    self.secureTextEntry = secureTextEntry;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UITextContentType textContentType = [inputTraits respondsToSelector:@selector(textContentType)] ? [inputTraits textContentType] : self.textContentType;
    self.textContentType = textContentType;
#endif
}

#pragma mark - Public

- (void)xc_doValidation {
    BOOL canResponds = NO;
    
    canResponds = [self.validator respondsToSelector:@selector(textFieldShouldValidator:)];
    BOOL shouldValidator = canResponds ? [self.validator textFieldShouldValidator:self] : YES;
    if (!shouldValidator) return;
    
    [self doValidation:self];
}

#pragma mark - private

- (void)xc_textFieldEditingChange:(UITextField *)textField {
    BOOL canResponds = NO;
    
    canResponds = [self.validator respondsToSelector:@selector(textFieldShouldValidator:)];
    BOOL shouldValidator = canResponds ? [self.validator textFieldShouldValidator:textField] : YES;
    if (!shouldValidator) return;

    [self doValidation:textField];
}

- (void)doValidation:(UITextField *)textField {
    BOOL canResponds = NO;
    
    canResponds = [self.validator respondsToSelector:@selector(willValidatorTextField:)];
    canResponds ? [self.validator willValidatorTextField:textField] : nil;
    
    canResponds = [self.validator respondsToSelector:@selector(isValidTextField:error:)];
    NSError *error;
    BOOL isValidator = canResponds ? [self.validator isValidTextField:textField error:&error] : NO;
    if (isValidator) {
        canResponds = [self.textFieldDisplay respondsToSelector:@selector(correctTextField:)];
        canResponds ? [self.textFieldDisplay correctTextField:textField] : nil;
    } else {
        canResponds = [self.textFieldDisplay respondsToSelector:@selector(incorrectTextField:error:)];
        canResponds ? [self.textFieldDisplay incorrectTextField:textField error:error] : nil;
    }
    
    canResponds = [self.validator respondsToSelector:@selector(didEndValidatorTextField:error:)];
    canResponds ? [self.validator didEndValidatorTextField:textField error:error] : nil;
}

#pragma mark - #### BEGIN Properties setter getter ####

- (void)setConfiguration:(id<XCTextFieldConfiguration>)configuration {
    BOOL conforms = [configuration conformsToProtocol:@protocol(XCTextFieldConfiguration)];
    NSAssert(conforms, @"configuration: %@ must conforms XCTextFieldConfiguration Protocol", configuration);
    if (!conforms) return;
    
    objc_setAssociatedObject(self,
                             @selector(configuration),
                             configuration,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateConfiguration:configuration];
}

- (id<XCTextFieldConfiguration>)configuration {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setValidator:(id<XCTextFieldValidator>)validator {
    BOOL conforms = [validator conformsToProtocol:@protocol(XCTextFieldValidator)];
    NSAssert(conforms, @"validator: %@ must conforms XCTextFieldValidator Protocol", validator);
    if (!conforms) return;
    
    objc_setAssociatedObject(self,
                             @selector(validator),
                             validator,
                             OBJC_ASSOCIATION_ASSIGN);
    [self updateValidator:validator];
}

- (id<XCTextFieldValidator>)validator {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setInputTraits:(id<UITextInputTraits>)inputTraits {
    BOOL conforms = [inputTraits conformsToProtocol:@protocol(UITextInputTraits)];
    NSAssert(conforms, @"inputTraits: %@ must conforms UITextInputTraits Protocol", inputTraits);
    if (!conforms) return;
    
    objc_setAssociatedObject(self,
                             @selector(inputTraits),
                             inputTraits,
                             OBJC_ASSOCIATION_ASSIGN);
    [self updateInputTraits:inputTraits];
}

- (id<UITextInputTraits>)inputTraits {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTextFieldDisplay:(id<XCTextFieldTextDisplay>)textFieldDisplay {
    BOOL conforms = [textFieldDisplay conformsToProtocol:@protocol(XCTextFieldTextDisplay)];
    NSAssert(conforms, @"textFieldDisplay: %@ must conforms XCTextFieldTextDisplay Protocol", textFieldDisplay);
    if (!conforms) return;
    
    objc_setAssociatedObject(self,
                             @selector(textFieldDisplay),
                             textFieldDisplay,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (id<XCTextFieldTextDisplay>)textFieldDisplay {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark #### END Properties setter getter ####

@end
