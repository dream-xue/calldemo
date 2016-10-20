//
//  ViewController.m
//  calldemo
//
//  Created by 陈权斌 on 16/10/20.
//  Copyright © 2016年 陈权斌. All rights reserved.
//

#import "ViewController.h"
#import "CallKit/CallKit.h"


@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberText;

@end

@implementation ViewController

- (IBAction)call:(id)sender {
    NSLog(@"%@", _numberText.text);
    if (_numberText.text.length == 0 || _numberText.text == nil ){
        return;
    }else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_numberText.text]];
//        UIWebView *phoneWebView;
//        if (!phoneWebView) {
//            phoneWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
//        }
//        [phoneWebView loadRequest:[NSURLRequest requestWithURL:url]];
//        [self.view addSubview:phoneWebView];
        //或者采用下面的方法，可能无法通过审核
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
}


- (IBAction)checkPermit:(id)sender {
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    [manager getEnabledStatusForExtensionWithIdentifier:@"com.cqb.calldemo.CallDirectoryExtension" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if(!error){
            NSString *title = nil;
            if (enabledStatus == CXCallDirectoryEnabledStatusDisabled) {
                title = @"未授权，请在设置--电话授权相关权限";
            } else if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
                title = @"已授权";
            } else if(enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
                title = @"未知";
            }


            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:title preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"error" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)updateNumber:(id)sender {
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    __block NSString *message = nil;
    [manager reloadExtensionWithIdentifier:@"com.cqb.calldemo.CallDirectoryExtension" completionHandler:^(NSError * _Nullable error) {
        if(!error){
            message = @"更新成功";
        }else {
            message = @"更新失败";
            NSLog(@"%@", error);
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示信息" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}


- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
