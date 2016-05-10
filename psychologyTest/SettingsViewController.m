//
//  SettingsViewController.m
//  MyOne
//
//  Created by HelloWorld on 8/2/15.
//  Copyright (c) 2015 melody. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

#define DawnViewBGColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1] // #EBEBEB
#define DawnCellBGColor [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1] // #F9F9F9
#define NightCellBGColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1] // #323232
#define NightCellTextColor [UIColor colorWithRed:111 / 255.0 green:111 / 255.0 blue:111 / 255.0 alpha:1] // #6F6F6F
#define NightCellHeaderTextColor [UIColor colorWithRed:75 / 255.0 green:75 / 255.0 blue:75 / 255.0 alpha:1] // #4B4B4B

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *CellHasSwitchID = @"HasSwitchCell";
static NSString *CellHasDIID = @"HasDICell";// DI -> DisclosureIndicator
static NSString *CellHasSecondLabelID = @"HasSecondLabelCell";
static NSString *CellLogOutID = @"LogOutCell";

@implementation SettingsViewController {
    NSArray *sectionHeaderTexts;
    NSArray *dataSource;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    
    [self setTitleView];
    [self setUpViews];
    sectionHeaderTexts = @[@"缓存设置", @"更多", @""];
    
    dataSource = @[@[@"清除缓存"],
                   @[@"去评分", @"反馈", @"用户协议", @"版本号"],
                   @[@"退出当前账号"]];
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
    titleLabel.text = @"设置";
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
    return 3;
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
    cell.textLabel.text = dataSource[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1 && indexPath.row == 3) {
        UILabel *versionLabel = [UILabel new];
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        versionLabel.text = version;
        versionLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [versionLabel sizeToFit];
        cell.accessoryView = versionLabel;
    } else if (indexPath.section == 2) {// 退出当前账号
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.backgroundColor = DawnCellBGColor;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 2)
        return 28;
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headerView.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(headerView.frame) - 40, CGRectGetHeight(headerView.frame))];
    headerLabel.text = sectionHeaderTexts[section];
    headerLabel.textColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13];
    [headerView addSubview:headerLabel];
    return headerView;
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
