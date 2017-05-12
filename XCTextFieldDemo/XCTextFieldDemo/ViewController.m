//
//  ViewController.m
//  XCTextFieldDemo
//
//  Created by xenon on 17/5/12.
//  Copyright © 2017年 Code 1 Bit Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+XCTextField.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UITextField *cellPhoneTF;
    UITextField *emailTF;
    UITextField *pwdTF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    cellPhoneTF = [[UITextField alloc] initWithFrame:(CGRect){20, 100, 230, 30}];
    cellPhoneTF.placeholder = @"请输入手机号";
    [cellPhoneTF configurationWithType:ECTextFieldTypeCellphone];
    [self.view addSubview:cellPhoneTF];
    
    emailTF = [[UITextField alloc] initWithFrame:(CGRect){20, 140, 230, 30}];
    emailTF.placeholder = @"请输入Email";
    [emailTF configurationWithType:ECTextFieldTypeEmail];
    [self.view addSubview:emailTF];
    
    pwdTF = [[UITextField alloc] initWithFrame:(CGRect){20, 180, 230, 30}];
    pwdTF.placeholder = @"请输入密码";
    [pwdTF configurationWithType:ECTextFieldTypePassword];
    [self.view addSubview:pwdTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = (CGRect){ 20, 220, 90, 30};
    [btn setTitle:@"字段检查" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)btnAct:(UIButton *)btn {
    [cellPhoneTF fieldTypeCheck];
    [emailTF fieldTypeCheck];
    [pwdTF fieldTypeCheck];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
