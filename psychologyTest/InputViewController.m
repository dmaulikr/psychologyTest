//
//  InputViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 3/17/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import "InputViewController.h"
#import "MBProgressHUD+NJ.h"

#define DawnViewBGColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1] // #EBEBEB
#define DawnCellBGColor [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1] // #F9F9F9
#define NightCellBGColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1] // #323232
#define NightCellTextColor [UIColor colorWithRed:111 / 255.0 green:111 / 255.0 blue:111 / 255.0 alpha:1] // #6F6F6F
#define NightCellHeaderTextColor [UIColor colorWithRed:75 / 255.0 green:75 / 255.0 blue:75 / 255.0 alpha:1] // #4B4B4B

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width


@interface InputViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) NSMutableArray    *selectIndex;

@property (nonatomic, strong) NSNumber          *userId;

@end

static NSString *CellHasSwitchID = @"HasSwitchCell";
static NSString *CellHasDIID = @"HasDICell";// DI -> DisclosureIndicator
static NSString *CellHasSecondLabelID = @"HasSecondLabelCell";
static NSString *CellLogOutID = @"LogOutCell";

@implementation InputViewController {
    NSArray *sectionHeaderTexts;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    self.selectIndex = [[NSMutableArray alloc] init];
    [self setTitleView];
    [self setUpViews];
    NSUserDefaults* cache = [NSUserDefaults standardUserDefaults];
    self.userId = [cache objectForKey:@"userId"];
    sectionHeaderTexts = @[@"", @""];
    
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
    titleLabel.text = self.title;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID;
    cellID = CellHasDIID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (indexPath.section == 0 && indexPath.row == 0){
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.backgroundColor = [UIColor whiteColor];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 1.0f, self.tableView.frame.size.width-20, 44.0f)];
        textField.returnKeyType = UIReturnKeyDone;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.tag = 100;
        if([self.isNumberInput intValue] == 1) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        } else {
            textField.keyboardType = UIKeyboardTypeDefault;
        }
        [cell addSubview:textField];
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"保 存";
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.section == 0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.selectIndex removeAllObjects];
        [self.selectIndex addObject:indexPath];
        [self.tableView reloadData];
    } else {
        [self saveInput];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        return 38;
    }
    return 44;
}


// 保存输入值
- (void)saveInput
{
    UITextField *textField = [self.tableView viewWithTag:100];
    if(![textField.text isEqualToString:@""]){
        [self saveObject];
        [MBProgressHUD showSuccess:@"已保存"];
    } else {
        [MBProgressHUD showError:@"输入不得为空"];
    }
}


- (void)saveObject
{
    UITextField *textField = [self.tableView viewWithTag:100];
    switch ([self.rowID intValue]) {
        case 101:
            self.familyInfo.father_age = [NSNumber numberWithInt:[textField.text intValue]];
            break;
        case 102:
            self.familyInfo.father_profession = textField.text;
            break;
        case 103:
            self.familyInfo.father_telephone = textField.text;
            break;
        case 104:
            self.familyInfo.father_education = textField.text;
            break;
        case 111:
            self.familyInfo.mother_age = [NSNumber numberWithInt:[textField.text intValue]];
            break;
        case 112:
            self.familyInfo.mother_profession = textField.text;
            break;
        case 113:
            self.familyInfo.mother_telephone = textField.text;
            break;
        case 114:
            self.familyInfo.mother_education = textField.text;
            break;
        case 120:
            self.familyInfo.brother_sister_count = [NSNumber numberWithInt:[textField.text intValue]];
            break;
        case 121:
            self.familyInfo.family_rank = [NSNumber numberWithInt:[textField.text intValue]];
            break;
        case 123:
            self.familyInfo.emergency_name = textField.text;
            break;
        case 124:
            self.familyInfo.emergency_relation = textField.text;
            break;
        case 125:
            self.familyInfo.emergency_telephone = textField.text;
        case 204:
            self.detailsInfo.telephone = textField.text;
            break;
        case 205:
            self.detailsInfo.address = textField.text;
            break;
        case 206:
            self.detailsInfo.zip_code = textField.text;
            break;
        case 207:
            self.detailsInfo.dormetry = textField.text;
            break;
        case 208:
            self.detailsInfo.mail = textField.text;
            break;
        default:
            break;
    }
    
    if ([self.rowID intValue] < 200) {
        [self.familyInfo commit];
    } else {
        [self.detailsInfo commit];
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