//
//  ViewController.m
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "XCTextField.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet XCTextField *cellPhoneTextField;
@property (weak, nonatomic) IBOutlet XCTextField *IDCardTextField;
@property (weak, nonatomic) IBOutlet XCTextField *emailTextField;
@property (weak, nonatomic) IBOutlet XCTextField *creditCardTextField;
@property (weak, nonatomic) IBOutlet XCTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet XCTextField *CAPTCHATextField;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_cellPhoneTextField configurationWithType:XCTextFieldTypeCellphone];
    [_IDCardTextField configurationWithType:XCTextFieldTypeIDCard];
    [_emailTextField configurationWithType:XCTextFieldTypeEmail];
    [_creditCardTextField configurationWithType:XCTextFieldTypeCreditCard];
    [_passwordTextField configurationWithType:XCTextFieldTypePassword];
    [_CAPTCHATextField configurationWithType:XCTextFieldTypeCAPTCHA];
}

- (IBAction)checkButtonAction:(UIButton *)button {
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[XCTextField class]]) {
            [(XCTextField *)subview inputCheckForceCorrect:YES];
        }
    }
    
}

- (void)textFieldDidEndEditing:(XCTextField *)textField {
    [textField inputCheckForceCorrect:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [(UITextField *)subview resignFirstResponder];
        }
    }
}


@end
