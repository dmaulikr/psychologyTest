//
//  LoginViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 1/1/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "HttpRequestHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD+NJ.h"
#import "WPTabBarController.h"


#define ACCOUNT_LOGIN_API   @"http://101.200.132.161:90/psycloud_backend/index.php/Home/User/login"

@interface LoginViewController()


@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeField;

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.loginBtn.layer.cornerRadius = 5.0;
    UIImage *image = [UIImage imageNamed:@"touxiang"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-image.size.width/2)/2, 100, image.size.width/2, image.size.height/2)];
    imageView.image = image;
    [self setUpTextField];
    [self.view addSubview:imageView];
}


- (void)setUpTextField
{
    self.passwordField.secureTextEntry = true;
    self.usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
}


- (IBAction)loginTapped:(id)sender {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if([username isEqualToString:@""] || [password isEqualToString:@""]){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"输入不得为空"];
    } else {
        [self loginEventRequest];
    }
}

- (void)loginEventRequest
{
    [MBProgressHUD showMessage:@"正在加载数据中....."];
    
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setValue:self.usernameField.text forKey:@"username"];
    [requestBody setValue:[self md5:[NSString stringWithFormat:@"ThisIsPsyCloudBackEnd%@", self.passwordField.text]] forKey:@"password"];
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    
    HttpRequestHelper *httpRequestHelper = [[HttpRequestHelper alloc] init];
    [httpRequestHelper PostRequestUrl:ACCOUNT_LOGIN_API SetParams:[requestBody copy] didFinish:^(id json, NSError *error) {
        NSDictionary *dataObject = [json objectForKey:@"data"];
        NSDictionary *errorObject = [json objectForKey:@"meta"];
        [MBProgressHUD hideHUD];
        if([errorObject isEqual:[NSNull null]] || errorObject != nil)
        {
            NSNumber* code = (NSNumber *)[errorObject objectForKey:@"code"];
            if(code != nil && [code intValue] == 0){
                [MBProgressHUD showSuccess:@"登陆成功"];
                NSString* apiKey = [dataObject objectForKey:@"api_key"];
                NSString* secretKey = [dataObject objectForKey:@"secret_key"];
                NSNumber* userId = [dataObject objectForKey:@"id"];
                NSLog(@"%@ %@ %@", apiKey, secretKey, userId);
                NSUserDefaults* cache = [NSUserDefaults standardUserDefaults];
                [cache setObject:apiKey forKey:@"apiKey"];
                [cache setObject:secretKey forKey:@"secretKey"];
                [cache setObject:userId forKey:@"userId"];
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WPTabBarController *tabBarViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                [self presentModalViewController:tabBarViewController animated:true];
            } else {
                [MBProgressHUD showError:@"用户名或密码错误"];
            }
        }
        else
        {
            [MBProgressHUD showError:@"登陆失败"];
        }
    }];
}


//md5 32位 加密 （小写）
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



@end