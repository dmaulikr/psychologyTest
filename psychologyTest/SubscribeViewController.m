
//
//  SubscribeViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 4/26/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//


#import "SubscribeViewController.h"
#import "ArrangeViewController.h"

@interface SubscribeViewController()

@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;

@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = false;
    [self.subscribeBtn setBackgroundColor:[UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1.0]];
    self.subscribeBtn.layer.cornerRadius = 5.0;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Lifecycle

- (void)dealloc {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)setTitleView {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"心理咨询预约";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [titleLabel sizeToFit];
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}


- (IBAction)subscribeTapped:(id)sender {
    ArrangeViewController *arrangeViewController = [ArrangeViewController new];
    [self.navigationController pushViewController:arrangeViewController animated:YES];
}



@end
