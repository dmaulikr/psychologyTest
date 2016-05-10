//
//  DetailInfoViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 3/17/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import "FamilyInfoViewController.h"
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


@interface FamilyInfoViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *CellHasSwitchID = @"HasSwitchCell";
static NSString *CellHasDIID = @"HasDICell";// DI -> DisclosureIndicator
static NSString *CellHasSecondLabelID = @"HasSecondLabelCell";
static NSString *CellLogOutID = @"LogOutCell";

@implementation FamilyInfoViewController {
    NSArray *sectionHeaderTexts;
    NSArray *dataSource;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    [self setTitleView];
    [self setUpViews];
    sectionHeaderTexts = @[@"", @"", @""];
    dataSource = @[@[@"父亲状态", @"父亲年龄", @"父亲职业", @"父亲联系电话", @"父亲学历"],
                   @[@"母亲状态", @"母亲年龄", @"母亲职业", @"母亲联系电话", @"母亲学历"],
                   @[@"兄弟姐妹数量", @"家中排行", @"父母婚姻状况", @"紧急联系人姓名", @"紧急联系人与本人关系", @"紧急联系人电话"]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNumber* userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    self.familyInfo = [[[[FamilyInfo query] where:[NSString stringWithFormat:@"user_id = %@", userId]] fetch] objectAtIndex:0];
    [self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Private


//返回按钮action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setTitleView {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"家庭信息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
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
    cellID = CellHasDIID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = dataSource[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *accessoryLabel = [UILabel new];
    accessoryLabel.textAlignment = UITextAlignmentRight;
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    if(indexPath.section == 0 && indexPath.row == 0){
        
        NSString *accessoryLabelText = self.familyInfo.father_status;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        NSString *accessoryLabelText = [NSString stringWithFormat:@"%@", self.familyInfo.father_age];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        NSString *accessoryLabelText = self.familyInfo.father_profession;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        
        NSString *accessoryLabelText = self.familyInfo.father_telephone;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 0 && indexPath.row == 4) {
        
        NSString *accessoryLabelText = self.familyInfo.father_education;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        NSString *accessoryLabelText = self.familyInfo.mother_status;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        NSString *accessoryLabelText = [NSString stringWithFormat:@"%@", self.familyInfo.mother_age];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        
        NSString *accessoryLabelText = self.familyInfo.mother_profession;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        
        NSString *accessoryLabelText = self.familyInfo.mother_telephone;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 1 && indexPath.row == 4) {
        
        NSString *accessoryLabelText = self.familyInfo.mother_education;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        
        NSString *accessoryLabelText = [NSString stringWithFormat:@"%@", self.familyInfo.brother_sister_count];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        
        NSLog(@"%@", self.familyInfo.family_rank);
        NSString *accessoryLabelText = [NSString stringWithFormat:@"%@", self.familyInfo.family_rank];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        
        NSString *accessoryLabelText = [NSString stringWithFormat:@"%@", self.familyInfo.parents_marriage_status];
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 2 && indexPath.row == 3) {
        
        NSString *accessoryLabelText = self.familyInfo.emergency_name;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 2 && indexPath.row == 4) {
        
        NSString *accessoryLabelText = self.familyInfo.emergency_relation;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    } else if (indexPath.section == 2 && indexPath.row == 5) {
        
        NSString *accessoryLabelText = self.familyInfo.emergency_telephone;
        accessoryLabel.text = accessoryLabelText;
        accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
        [accessoryLabel sizeToFit];
        accessoryLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryView = accessoryLabel;
        
    }
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
    if(indexPath.section == 0 && indexPath.row == 4){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:104];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 3){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.isNumberInput = [[NSNumber alloc] initWithInt:1];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:103];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 2){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:102];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.isNumberInput = [[NSNumber alloc] initWithInt:1];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:101];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 0){
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        [selectArray addObject:@"在世"];
        [selectArray addObject:@"离世"];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"local_options";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 4){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:114];
        [self.navigationController pushViewController:inputViewController animated:YES];

    }
    else if (indexPath.section == 1 && indexPath.row == 3){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.isNumberInput = [[NSNumber alloc] initWithInt:1];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:113];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 2){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:112];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.isNumberInput = [[NSNumber alloc] initWithInt:1];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:111];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        [selectArray addObject:@"在世"];
        [selectArray addObject:@"离世"];
        selectViewController.dataSource = selectArray;
        selectViewController.optionsFilter = @"local_options";
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:120];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 1){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.isNumberInput = [[NSNumber alloc] initWithInt:1];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:121];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 2){
        SelectViewController *selectViewController = [SelectViewController new];
        NSMutableArray *selectArray = [[NSMutableArray alloc] init];
        selectViewController.title = dataSource[indexPath.section][indexPath.row];
        selectViewController.optionsFilter = @"parents_marriage";
        [self.navigationController pushViewController:selectViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 3){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:123];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 4){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:124];
        [self.navigationController pushViewController:inputViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 5){
        InputViewController *inputViewController = [InputViewController new];
        inputViewController.title = dataSource[indexPath.section][indexPath.row];
        inputViewController.isNumberInput = [[NSNumber alloc] initWithInt:1];
        inputViewController.familyInfo = self.familyInfo;
        inputViewController.rowID = [NSNumber numberWithInt:125];
        [self.navigationController pushViewController:inputViewController animated:YES];
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