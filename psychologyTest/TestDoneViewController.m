//
//  TestDoneViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 12/20/15.
//  Copyright © 2015 stanley_Hwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestDoneViewController.h"

@interface TestDoneViewController()


@property (weak, nonatomic) IBOutlet UIButton *testDoneBtn;


@end

@implementation TestDoneViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)dismissMyView {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.testDoneBtn.layer.cornerRadius = 5.0;
    self.testDoneBtn.backgroundColor = [UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"night_icon_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissView)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)dismissView {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)checkResultTapped:(id)sender {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITableViewController *mainView = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TestResultViewController"];
    [self.navigationController pushViewController:mainView animated:YES];

}



@end