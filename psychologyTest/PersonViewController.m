
//
//  PersonViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 3/14/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import "PersonViewController.h"
#import "SettingsViewController.h"
#import "InfoViewController.h"

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

@interface PersonViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *AccountCellID = @"HasDICell";
static NSString *OtherCellID = @"HasDICell";

@implementation PersonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = false;
}

#pragma mark - Pirvate

- (void)setUpViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - CGRectGetHeight(self.tabBarController.tabBar.frame))];
    // 不显示空 cell
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 设置 cell 的行高，固定为69
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 设置 tableView 的 分割线
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AccountCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:OtherCellID];
    self.tableView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    [self.view addSubview:self.tableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headerView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(headerView.frame) - 40, CGRectGetHeight(headerView.frame))];
    headerLabel.textColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    [headerView addSubview:headerLabel];
    return headerView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 1;
    } else {
        return 2;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 75.0;
    }else{
        return 50.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果是第一行，则使用 AccountCellID，否则使用 OtherCellID
    NSString *cellID = indexPath.section == 0 ? AccountCellID : OtherCellID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"黄欣宇";
        cell.imageView.image = [UIImage imageNamed:@"person_icon"];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"设置";
//        cell.imageView.image = [UIImage imageNamed:@"setting"];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = @"关于我们";
//        NSString *imageName = @"copyright_nt";
//        cell.imageView.image = [UIImage imageNamed:imageName];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {// 点击进入个人中心
        InfoViewController *infoViewController = [[InfoViewController alloc] init];
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {// 点击进入设置
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {// 点击进入关于界面
        
    }
}

@end