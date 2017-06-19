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
/// @brief To save the origin layer.borderColor;
@property (readwrite, nonatomic) CGColorRef borderColor;
/// @brief To save the origin layer.borderWidth;
@property (readwrite, nonatomic) CGFloat borderWidth;
/// @brief To save the origin layer.cornerRadius;
@property (readwrite, nonatomic) CGFloat corprenerRadius;
/// @brief When correct is true, border color will not change again.
@property (readwrite, nonatomic) BOOL correct;
@end

@implementation UITextField (XCTextField)
@dynamic fieldType;
@dynamic checkResult;


@dynamic configuration;

- (void)updateConfiguration:(id<XCTextFieldConfiguration>)configuration {
    id<XCTextFieldValidator> validator = configuration;
    id<XCTextFieldInputTraits> inputTraits = configuration;
    
    self.validator = validator;
    self.inputTraits = inputTraits;
}

- (void)updateValidator:(id<XCTextFieldValidator>)validator {
    BOOL responds = [validator respondsToSelector:@selector(isValidTextField:error:)];
    NSAssert(responds, @"validator: %@ must implementation isValidTextField:error: method", validator);
    if (!responds) return;
    
    NSError *error;
    BOOL isValid = [validator isValidTextField:self error:&error];
    
//    willValidatorTextField
//    derive inspiration (from sb./sth.)
}

- (void)updateInputTraits:(id<XCTextFieldInputTraits>)inputTraits {
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
    self.enablesReturnKeyAutomatically = secureTextEntry;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UITextContentType textContentType = [inputTraits respondsToSelector:@selector(textContentType)] ? [inputTraits textContentType] : self.textContentType;
    self.textContentType = textContentType;
#endif
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

- (void)setInputTraits:(id<XCTextFieldInputTraits>)inputTraits {
    BOOL conforms = [inputTraits conformsToProtocol:@protocol(XCTextFieldInputTraits)];
    NSAssert(conforms, @"inputTraits: %@ must conforms XCTextFieldInputTraits Protocol", inputTraits);
    if (!conforms) return;
    
    objc_setAssociatedObject(self,
                             @selector(inputTraits),
                             inputTraits,
                             OBJC_ASSOCIATION_ASSIGN);
    [self updateInputTraits:inputTraits];
}

- (id<XCTextFieldInputTraits>)inputTraits {
    return objc_getAssociatedObject(self, _cmd);
}


#pragma mark - Initialiaze Configuration
- (void)configurationWithType:(XCTextFieldType)type {
    
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    /*!
     @todo HOW can I use only one enum property to control this TF?
     */
    self.fieldType = type;
    
    // Disable Apple auto suggestion as default.
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    
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
    self.cornerRadius = self.layer.cornerRadius;
    self.borderWidth = self.layer.borderWidth;
    self.borderColor = self.layer.borderColor;
    
    // Configure each type as well.
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
    switch (self.fieldType) {
        case XCTextFieldTypeEmail: {
            [self emailCheck];
            break;
        }
        case XCTextFieldTypeIDCard: {
            [self IDCardCheck];
            break;
        }
        case XCTextFieldTypeCellphone: {
            [self cellphoneNumberCheck];
            break;
        }
        case XCTextFieldTypeCreditCard: {
            [self creditCardCheck];
            break;
        }
        case XCTextFieldTypePassword:
        case XCTextFieldTypeCAPTCHA:
        case XCTextFieldTypeCurrency:
        default: {
            self.correct ? : [self correctAnimation];
            break;
        }
    }
    
    !flag ? : [self becomeFirstResponderWhenFirstIncorrect];
}


#pragma mark - #### BEGIN Properties setter getter ####
- (void)setFieldType:(XCTextFieldType)newFieldType {
    objc_setAssociatedObject(self,
                             @selector(fieldType),
                             @(newFieldType),
                             OBJC_ASSOCIATION_ASSIGN);
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
                             CFBridgingRelease(CGColorCreateCopy(newBorderColor)),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (CGColorRef)borderColor {
    return (__bridge CGColorRef)(objc_getAssociatedObject(self, _cmd));
}

- (void)setBorderWidth:(CGFloat)newBorderWidth {
    objc_setAssociatedObject(self,
                             @selector(borderWidth),
                             @(newBorderWidth),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)borderWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCornerRadius:(CGFloat)newCornerRadius {
    objc_setAssociatedObject(self,
                             @selector(cornerRadius),
                             @(newCornerRadius),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setCorrect:(BOOL)correct {
    objc_setAssociatedObject(self,
                             @selector(correct),
                             @(correct),
                             OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)correct {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark #### END Properties setter getter ####
#pragma mark -

#pragma mark - Field Animation
- (void)correctAnimation {
    
    NSLog(@"get radius = %f", self.cornerRadius);
    NSLog(@"get width = %f", self.borderWidth);
    NSLog(@"get color = %@", self.borderColor);
    
    self.correct = YES;
    self.checkResult = @"Correct textField.";
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:1.5f animations:^{
            self.layer.borderColor = [[UIColor greenColor] CGColor];
            self.layer.borderWidth = self.layer.borderWidth ? : 0.5f;
            self.layer.cornerRadius = self.layer.cornerRadius ? : self.frame.size.height / 7.5;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(1.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           self.layer.borderColor = self.borderColor;
                           self.layer.borderWidth = self.borderWidth;
                           self.layer.cornerRadius = self.cornerRadius;
        });
    });
    
}

- (void)incorrectAnimation {
    NSLog(@"%zi", self.fieldType);
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

#pragma mark - Text Check
- (void)cellphoneNumberCheck {
    BOOL result = NO;
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     * 虚拟运营商：170,177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[07])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183，187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    /**
     31         * 虚拟运营商：腾讯大网卡、蚂蚁宝卡、B站小电视卡……
     32         * 170...[176:CU, 177:CT, 178: CM]
     @"^1(70|7[6-8])\\d{8}$"
     33         */
    NSString * VNO = @"^1(7[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestvno = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VNO];
    
    if (self.text.length != 11) {
        result = NO;
    }
    
    if (([regextestmobile evaluateWithObject:self.text])
        || ([regextestcm evaluateWithObject:self.text])
        || ([regextestct evaluateWithObject:self.text])
        || ([regextestcu evaluateWithObject:self.text])
        || ([regextestvno evaluateWithObject:self.text])) {
        result = YES;
    } else {
        result = NO;
    }
    
    if (!result) {
        self.checkResult = @"Phone number in invalid format.";
        [self incorrectAnimation];
    } else {
        self.correct ? : [self correctAnimation];
    }
}

- (void)emailCheck {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if (![emailTest evaluateWithObject:self.text]) {
        self.checkResult = @"Email Address in invalid format.";
        [self incorrectAnimation];
    } else {
        self.correct ? : [self correctAnimation];
    }
}

- (void)passwordCheck {
    
}

- (void)creditCardCheck {
    /** Luhn algorithm
        @see https://en.wikipedia.org/wiki/Luhn_algorithm
     */
    //取出最后一个字符
    NSString *lastCharacter = [self.text substringFromIndex:[self.text length] - 1];
    //取出前15/18个字符
    NSString *preStr = [self.text substringToIndex:[self.text length] - 1];
    //将前15/18个字符反序加进数组
    NSMutableArray *reverseArr = [NSMutableArray array];
    for (NSUInteger index = [preStr length]; index > 0; index--) {
        [reverseArr addObject:[preStr substringWithRange:NSMakeRange(index - 1, 1)]];
    }
    //奇数位*2的乘积 < 9
    NSMutableArray *evenNumberLessThanNineArray = [NSMutableArray array];
    //奇数位*2的乘积 > 9
    NSMutableArray *evenNumberGreaterThanNineArray = [NSMutableArray array];
    
    //偶数位数组
    NSMutableArray *oddNumberArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [reverseArr count]; index++) {
        if ((index + 1) % 2 == 1) {
            //奇数位
            NSUInteger evenNum = [[reverseArr objectAtIndex:index] integerValue];
            if (evenNum * 2 < 9) {
                [evenNumberLessThanNineArray addObject:[NSString stringWithFormat:@"%ld",(long)(evenNum * 2)]];
            } else {
                [evenNumberGreaterThanNineArray addObject:[NSString stringWithFormat:@"%ld",(long)(evenNum * 2)]];
            }
        } else {
            //偶数位
            [oddNumberArray addObject:[reverseArr objectAtIndex:index]];
        }
    }
    
    // ones-place number in evenNumberGreaterThanNineArray
    NSMutableArray *onesPlaceNumArray = [NSMutableArray array];
    
    // tens-place number in evenNumberGreaterThanNineArray
    NSMutableArray *tensPlaceNumArray = [NSMutableArray array];
    
    for (NSUInteger index = 0; index < [evenNumberGreaterThanNineArray count]; index++) {
        @autoreleasepool {
            NSString *onesPlaceStr = [NSString stringWithFormat:@"%ld",(long)[[evenNumberGreaterThanNineArray objectAtIndex:index] integerValue] % 10];
            NSString *tensPlaceStr = [NSString stringWithFormat:@"%ld",(long)[[evenNumberGreaterThanNineArray objectAtIndex:index] integerValue] / 10];
            [onesPlaceNumArray addObject:onesPlaceStr];
            [tensPlaceNumArray addObject:tensPlaceStr];
        }
    }
    
    NSUInteger sumEvenNum = 0;
    NSUInteger sumOddNum = 0;
    NSUInteger sumOnesPlaceNum = 0;
    NSUInteger sumTensPlaceNum = 0;
    NSUInteger totalAmount = 0;
    
    for (NSUInteger index = 0; index < [evenNumberLessThanNineArray count]; index++) {
        //奇数位*2 < 9数组之和
        sumEvenNum += [[evenNumberLessThanNineArray objectAtIndex:index] integerValue];
    }
    
    for (NSUInteger index = 0; index < [oddNumberArray count]; index++) {
        //偶数位之和
        sumOddNum += [[oddNumberArray objectAtIndex:index] integerValue];
    }
    
    for (NSUInteger index = 0; index < [onesPlaceNumArray count]; index++) {
        //奇数位*2 > 9数组 个位数之和
        sumOnesPlaceNum += [[onesPlaceNumArray objectAtIndex:index] integerValue];
    }
    
    for (NSUInteger index = 0; index < [tensPlaceNumArray count]; index++) {
        //奇数位*2 > 9数组 十位数之和
        sumTensPlaceNum += [[tensPlaceNumArray objectAtIndex:index] integerValue];
    }
    
    //计算总和
    totalAmount = sumEvenNum + sumOddNum + sumOnesPlaceNum + sumTensPlaceNum;
    
    //计算Luhm值
    NSUInteger luhm = totalAmount % 10 == 0 ? 10 : totalAmount % 10;
    
    NSUInteger result = 10 - luhm;
    
    if ([lastCharacter integerValue] != result) {
        self.checkResult = @"Credit card number in invalid format.";
        [self incorrectAnimation];
    } else {
        self.correct ? : [self correctAnimation];
    }
    
    
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
        self.correct ? : [self correctAnimation];
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


#pragma mark - Test Method
+ (void)howCanIUseSelfInClassMethod {
    
    /**
     * 一个科学试验：在 + 方法中找到 self 的对象指针。
     *
     */
    
    
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

@end
