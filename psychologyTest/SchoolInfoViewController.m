//
//  DetailInfoViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 3/17/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import "SchoolInfoViewController.h"
#import "SelectViewController.h"
#import "InputViewController.h"

#define DawnViewBGColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1] // #EBEBEB
#define DawnCellBGColor [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1] // #F9F9F9
#define NightCellBGColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1] // #323232
#define NightCellTextColor [UIColor colorWithRed:111 / 255.0 green:111 / 255.0 blue:111 / 255.0 alpha:1] // #6F6F6F
#define NightCellHeaderTextColor [UIColor colorWithRed:75 / 255.0 green:75 / 255.0 blue:75 / 255.0 alpha:1] // #4B4B4B

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width


@interface SchoolInfoViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *CellHasSwitchID = @"HasSwitchCell";
static NSString *CellHasDIID = @"HasDICell";// DI -> DisclosureIndicator
static NSString *CellHasSecondLabelID = @"HasSecondLabelCell";
static NSString *CellLogOutID = @"LogOutCell";

@implementation SchoolInfoViewController {
    NSArray *sectionHeaderTexts;
    NSArray *dataSource;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    [self setTitleView];
    [self setUpViews];
    sectionHeaderTexts = @[@"", @""];
    
    dataSource = @[@[@"宗教信仰", @"政治面貌", @"户口所在地", @"籍贯", @"电话", @"通信地址", @"邮编", @"宿舍地址", @"电子邮件"],
                   @[@"是否是推荐生", @"是否是竞赛报送", @"是否是艺术特长生", @"是否是贫困生"]];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber* userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    self.detailInfo = [[[[DetailsInfo query] where:[NSString stringWithFormat:@"user_id = %@", userId]] fetch] objectAtIndex:0];
    NSLog(@"%@", self.detailInfo.is_poor_student);
    [self.tableView reloadData];
}


#pragma mark - Lifecycle

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}


- (void)setUpViews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    // 不显示空 cell
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 设置 cell 的行高，固定为 44
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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    // Back Button
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 25)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setFont:[UIFont systemFontOfSize:15]];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.view addSubview:self.tableView];
}



//返回按钮action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private

- (void)setTitleView {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"学业信息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
    cellID = CellHasDIID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = dataSource[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *accessoryLabel = [UILabel new];
    accessoryLabel.textAlignment = UITextAlignmentRight;
    if(indexPath.section == 0 && indexPath.row == 0){
        
        NSString *accessoryLabelText = self.detailInfo.religion_name;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
     
        NSString *accessoryLabelText = self.detailInfo.political_status;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 2){
        
        NSString *accessoryLabelText = self.detailInfo.source_area_province;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 3){
        
        NSString *accessoryLabelText = self.detailInfo.native_place_province;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 4){
        
        NSString *accessoryLabelText = self.detailInfo.telephone;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 5){
        
        NSString *accessoryLabelText = self.detailInfo.address;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 6){
     
        NSString *accessoryLabelText = self.detailInfo.zip_code;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 7){
        
        NSString *accessoryLabelText = self.detailInfo.dormetry;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 8){
        
        NSString *accessoryLabelText = self.detailInfo.mail;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        
    }
    else if (indexPath.section == 1 && indexPath.row == 2){
        
        NSString *accessoryLabelText = [NSString stringWithFormat:@"%@", [self.detailInfo.is_art_student intValue] == 1 ? @"是" : @"不是"];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
    }
    else if (indexPath.section == 1 && indexPath.row == 3){
        NSString *accessoryLabelText =  [NSString stringWithFormat:@"%@", [self.detailInfo.is_poor_student intValue] == 1 ? @"是" : @"不是"];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        NSString *accessoryLabelText =  [NSString stringWithFormat:@"%@", [self.detailInfo.is_recommended intValue] == 1 ? @"是" : @"不是"];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
//        NSLog(@"Is recommend by contest = %@", self.detailInfo.is_recommended_by_contest);
        NSString *accessoryLabelText =  [NSString stringWithFormat:@"%@", [self.detailInfo.is_recommended_by_contest intValue] == 1 ? @"是" : @"不是"];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
    }
//    NSLog(@"%@ %@ %@ %@", self.detailInfo.is_art_student, self.detailInfo.is_poor_student, self.detailInfo.is_recommended_by_contest, self.detailInfo.is_recommended);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
    if(indexPath.section == 0 && indexPath.row == 0){
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"religion";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"political_status";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 2){
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"source_area";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 3){
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"native_place";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 4){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.isNumberInput = [NSNumber numberWithInt:1];
        inputViewController.rowID = [NSNumber numberWithInt:204];
        inputViewController.detailsInfo = self.detailInfo;
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 5){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.rowID = [NSNumber numberWithInt:205];
        inputViewController.detailsInfo = self.detailInfo;
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 6){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.rowID = [NSNumber numberWithInt:206];
        inputViewController.detailsInfo = self.detailInfo;
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 7){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.rowID = [NSNumber numberWithInt:207];
        inputViewController.detailsInfo = self.detailInfo;
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 8){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.rowID = [NSNumber numberWithInt:208];
        inputViewController.detailsInfo = self.detailInfo;
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        [selectArray addObject:@"是"];
        [selectArray addObject:@"否"];
        selectViewController.dataSource = selectArray;
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        selectViewController.optionsFilter = @"is_recommended";
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        [selectArray addObject:@"是"];
        [selectArray addObject:@"否"];
        selectViewController.dataSource = selectArray;
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        selectViewController.optionsFilter = @"is_recommended_by_contest";
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        [selectArray addObject:@"是"];
        [selectArray addObject:@"否"];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"is_art_student";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        [selectArray addObject:@"是"];
        [selectArray addObject:@"否"];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"is_poor_student";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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