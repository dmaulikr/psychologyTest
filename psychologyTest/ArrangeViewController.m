//
//  SettingsViewController.m
//  MyOne
//
//  Created by HelloWorld on 8/2/15.
//  Copyright (c) 2015 melody. All rights reserved.
//

#import "ArrangeViewController.h"
#import "LoginViewController.h"
#import "SubscribeRstViewController.h"

#define DawnViewBGColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1] // #EBEBEB
#define DawnCellBGColor [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1] // #F9F9F9
#define NightCellBGColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1] // #323232
#define NightCellTextColor [UIColor colorWithRed:111 / 255.0 green:111 / 255.0 blue:111 / 255.0 alpha:1] // #6F6F6F
#define NightCellHeaderTextColor [UIColor colorWithRed:75 / 255.0 green:75 / 255.0 blue:75 / 255.0 alpha:1] // #4B4B4B

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

@interface ArrangeViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *CellHasSwitchID = @"HasSwitchCell";
static NSString *CellHasDIID = @"HasDICell";// DI -> DisclosureIndicator
static NSString *CellHasSecondLabelID = @"HasSecondLabelCell";
static NSString *CellLogOutID = @"LogOutCell";

@implementation ArrangeViewController {
    NSArray *sectionHeaderTexts;
    NSArray *dataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    
    [self setTitleView];
    [self setUpViews];
    
    dataSource = @[@[@"去评分", @"反馈", @"用户协议", @"版本号"],@[@"去评分", @"反馈", @"用户协议", @"版本号"]];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Lifecycle

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
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
    self.navigationItem.titleView = titleLabel;
}

- (void)setUpViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 44;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellHasSwitchID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellHasDIID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellHasSecondLabelID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellLogOutID];
    self.tableView.backgroundColor = DawnViewBGColor;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowsData = dataSource[section];
    return rowsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID;
    
    switch (indexPath.section) {
        case 0:{
            cellID = CellHasDIID;
            break;
        }
        case 1: {
            if (indexPath.row < 3) {
                cellID = CellHasDIID;
            } else {
                cellID = CellHasSecondLabelID;
            }
            break;
        }
        case 2:
            cellID = CellLogOutID;
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    UILabel* tip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, cell.frame.size.height)];
    tip1.textColor = [UIColor blackColor];
    tip1.font = [UIFont systemFontOfSize:12];
    tip1.text = @"上午";
    tip1.textAlignment = UITextAlignmentCenter;
    
    UILabel* tip2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, cell.frame.size.height)];
    tip2.textColor = [UIColor blackColor];
    tip2.font = [UIFont systemFontOfSize:12];
    tip2.text = @"9:30-10:00";
    tip2.textAlignment = UITextAlignmentCenter;
    
    UILabel* tip3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, cell.frame.size.height)];
    tip3.textColor = [UIColor blackColor];
    tip3.font = [UIFont systemFontOfSize:12];
    tip3.text = @"王某某";
    tip3.textAlignment = UITextAlignmentCenter;
    
    [cell addSubview:tip1];
    [cell addSubview:tip2];
    [cell addSubview:tip3];
    if((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 1 && indexPath.row == 2)){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(SCREEN_WIDTH/4*3 + 20, 10, SCREEN_WIDTH/4-40, cell.frame.size.height-20);
        [btn setBackgroundColor:[UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1.0]];
        [btn setTitle:@"预约" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [btn.titleLabel setTextColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(subscribeRstTapped) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5.0;
        btn.tintColor = [UIColor whiteColor];
        [cell addSubview:btn];
    } else {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(SCREEN_WIDTH/4*3 + 20, 10, SCREEN_WIDTH/4-40, cell.frame.size.height-20);
        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:@"已满" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [btn.titleLabel setTextColor:[UIColor whiteColor]];
        btn.layer.cornerRadius = 5.0;
        btn.tintColor = [UIColor whiteColor];
        [cell addSubview:btn];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    

    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    if(section == 0){
        UILabel* tip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, 30)];
        tip1.textColor = [UIColor grayColor];
        tip1.font = [UIFont systemFontOfSize:12];
        tip1.text = @"";
        tip1.textAlignment = UITextAlignmentCenter;
    
        UILabel* tip2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 30)];
        tip2.textColor = [UIColor grayColor];
        tip2.font = [UIFont systemFontOfSize:12];
        tip2.text = @"时间段";
        tip2.textAlignment = UITextAlignmentCenter;
    
        UILabel* tip3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/4, 30)];
        tip3.textColor = [UIColor grayColor];
        tip3.font = [UIFont systemFontOfSize:12];
        tip3.text = @"咨询师";
        tip3.textAlignment = UITextAlignmentCenter;
    
        UILabel* tip4 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 0, SCREEN_WIDTH/4, 30)];
        tip4.textColor = [UIColor grayColor];
        tip4.font = [UIFont systemFontOfSize:12];
        tip4.text = @"操作";
        tip4.textAlignment = UITextAlignmentCenter;
    
        [headerView addSubview:tip1];
        [headerView addSubview:tip2];
        [headerView addSubview:tip3];
        [headerView addSubview:tip4];
    } else {
        
    }
    return headerView;
}



- (void)subscribeRstTapped
{
//    SubscribeRstViewController *subscribeRstViewController = [SubscribeRstViewController new];
//    [self.navigationController pushViewController:subscribeRstViewController animated:YES];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2){
        NSUserDefaults* cache = [NSUserDefaults standardUserDefaults];
        [cache setObject:nil forKey:@"apiKey"];
        [cache setObject:nil forKey:@"secretKey"];
        [cache setObject:nil forKey:@"userId"];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentModalViewController:loginViewController animated:true];
    }
}


#pragma mark - Private

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
