//
//  NSString+XCValidator.m
//  XCTextFieldDemo
//
//  Created by imeng on 6/16/17.
//  Copyright © 2017 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "NSString+XCValidator.h"

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

@implementation NSString (XCValidator)

- (BOOL)isValidWithRegex:(NSString *)regex {
    BOOL isValid = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return isValid;
}

- (BOOL)creditCardluhmValid0 {
    NSString *text = self;
    /** Luhn algorithm
     @see https://en.wikipedia.org/wiki/Luhn_algorithm
     */
    //取出最后一个字符
    NSString *lastCharacter = [text substringFromIndex:[text length] - 1];
    //取出前15/18个字符
    NSString *preStr = [text substringToIndex:[text length] - 1];
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
    
    return ([lastCharacter integerValue] != result);
}

- (BOOL)creditCardluhmValid1 {
    NSString *text = self;
    NSString *formattedString = [text formattedStringForProcessing];
    if (formattedString == nil || formattedString.length < 9) {
        return NO;
    }
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[formattedString length]];
    
    [formattedString enumerateSubstringsInRange:NSMakeRange(0, [formattedString length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    
    NSUInteger oddSum = 0, evenSum = 0;
    
    for (NSUInteger i = 0; i < [reversedString length]; i++) {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0) {
            evenSum += digit;
        }
        else {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }
    return (oddSum + evenSum) % 10 == 0;
}

- (BOOL)IDCardValid0 {
    NSString *text = self;
    if (text.length != 18) {
        return NO;
    }
    
    return (checkIDCard(text.UTF8String));
}

- (BOOL)IDCardValid1 {
    //精确的身份证号码有效性检测
    NSString *value = self;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

- (BOOL)callPhoneValid {
    NSString *text = self;
    
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
    
    if (text.length != 11) {
        result = NO;
    }
    
    if (([regextestmobile evaluateWithObject:text])
        || ([regextestcm evaluateWithObject:text])
        || ([regextestct evaluateWithObject:text])
        || ([regextestcu evaluateWithObject:text])
        || ([regextestvno evaluateWithObject:text])) {
        result = YES;
    } else {
        result = NO;
    }
    
    return result;
}

#pragma mark - Helper

- (NSString *) formattedStringForProcessing {
    NSCharacterSet *illegalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [self componentsSeparatedByCharactersInSet:illegalCharacters];
    return [components componentsJoinedByString:@""];
}

@end
