//
//  DetailInfoViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 3/17/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import "SelectViewController.h"
#import "HttpRequestHelper.h"
#import "FamilyInfo.h"
#import "detailsInfo.h"
#import <CommonCrypto/CommonDigest.h>

#define DawnViewBGColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1] // #EBEBEB
#define DawnCellBGColor [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1] // #F9F9F9
#define NightCellBGColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1] // #323232
#define NightCellTextColor [UIColor colorWithRed:111 / 255.0 green:111 / 255.0 blue:111 / 255.0 alpha:1] // #6F6F6F
#define NightCellHeaderTextColor [UIColor colorWithRed:75 / 255.0 green:75 / 255.0 blue:75 / 255.0 alpha:1] // #4B4B4B

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

#define GET_OPTIONS_API       @"http://101.200.132.161:90/psycloud_backend/index.php/Home/General/getOptions"

@interface SelectViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *selectIndex;

@end

static NSString *CellHasSwitchID = @"HasSwitchCell";
static NSString *CellHasDIID = @"HasDICell";// DI -> DisclosureIndicator
static NSString *CellHasSecondLabelID = @"HasSecondLabelCell";
static NSString *CellLogOutID = @"LogOutCell";

@implementation SelectViewController {
    NSArray *sectionHeaderTexts;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = true;
    self.selectIndex = [[NSMutableArray alloc] init];
    [self setTitleView];
    [self setUpViews];
    
    sectionHeaderTexts = @[@"", @""];
    
    if(self.dataSource == nil || [self.dataSource count] == 0){
        self.dataSource = [[NSMutableArray alloc] init];
        [self getOptions];
    }
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


- (void)getOptions
{
//    self.optionsFilter = @"religion";
    NSString *timestampData = [NSString stringWithFormat:@"%f", ([[NSDate date] timeIntervalSince1970]-600)];
    NSString *timestamp = [[timestampData componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
    NSString* apiKey = [cache objectForKey:@"apiKey"];
    NSString* secretKey = [cache objectForKey:@"secretKey"];
    
    NSString* sign = [self md5:[NSString stringWithFormat:@"ThisIsPsyCloudBackEnd%@%@%@", apiKey, timestamp, secretKey]];
    
    HttpRequestHelper *httpRequestHelper = [[HttpRequestHelper alloc] init];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@?api_key=%@&timestamp=%@&sign=%@&model=%@", GET_OPTIONS_API, apiKey, timestamp, sign, self.optionsFilter];
    
    NSLog(@"request url = %@", requestUrl);
    [httpRequestHelper GetRequestUrl:requestUrl didFinish:^(id json, NSError *error) {
        NSLog(@"json=%@", json);
        NSDictionary *responseBody = [json objectForKey:@"meta"];
        NSNumber *code = [responseBody objectForKey:@"code"];
        if(code != nil && [code intValue] == 0){
            if ([self.optionsFilter isEqualToString:@"parents_marriage"]){
                NSArray* list = [json objectForKey:@"data"];
                for(NSDictionary* dic in list){
                    NSString* name = [dic objectForKey:@"marriage"];
                    [self.dataSource addObject:name];
                }
                [self.tableView reloadData];
            } else if ([self.optionsFilter isEqualToString:@"religion"]){
                NSArray* list = [json objectForKey:@"data"];
                for(NSDictionary* dic in list){
                    NSString* name = [dic objectForKey:@"name"];
                    [self.dataSource addObject:name];
                }
                [self.tableView reloadData];
            } else if ([self.optionsFilter isEqualToString:@"source_area"]){
                NSArray* list = [json objectForKey:@"data"];
                for(NSDictionary* dic in list){
                    NSString* name = [dic objectForKey:@"province"];
                    [self.dataSource addObject:name];
                }
                [self.tableView reloadData];
            } else if ([self.optionsFilter isEqualToString:@"native_place"]) {
                NSArray* list = [json objectForKey:@"data"];
                for(NSDictionary* dic in list){
                    NSString* name = [dic objectForKey:@"province"];
                    [self.dataSource addObject:name];
                }
                [self.tableView reloadData];
            } else if ([self.optionsFilter isEqualToString:@"political_status"]) {
                NSArray* list = [json objectForKey:@"data"];
                for(NSDictionary* dic in list){
                    NSString* name = [dic objectForKey:@"political_status"];
                    [self.dataSource addObject:name];
                }
                [self.tableView reloadData];
            }
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
}


#pragma mark - Private

- (void)setTitleView {
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID;
    cellID = CellHasDIID;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    if([self.selectIndex count] > 0){
        NSIndexPath *path = [self.selectIndex objectAtIndex:0];
        if (path == indexPath){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.tableView setTintColor:[UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1]];
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor whiteColor];
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
    [self.selectIndex removeAllObjects];
    [self.selectIndex addObject:indexPath];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    FamilyInfo *familyInfo = [[[[FamilyInfo query] where:[NSString stringWithFormat:@"user_id = %@", userId]] fetch] objectAtIndex:0];
    
    DetailsInfo *detailsInfo = [[[[DetailsInfo query] where:[NSString stringWithFormat:@"user_id = %@", userId]] fetch] objectAtIndex:0];
    
    if([self.optionsFilter isEqualToString:@"parents_marriage"]){
        familyInfo.parents_marriage_status = [NSNumber numberWithInteger:(indexPath.row+1)];
        familyInfo.parents_marriage_id = [NSNumber numberWithInteger:(indexPath.row+1)];
        familyInfo.parents_marriage = [self.dataSource objectAtIndex:indexPath.row];
        [familyInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"religion"]) {
        detailsInfo.religion_id = [NSNumber numberWithInteger:(indexPath.row+1)];
        detailsInfo.religion_name = [self.dataSource objectAtIndex:indexPath.row];
        [detailsInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"source_area"]) {
        detailsInfo.source_area_id = [NSNumber numberWithInteger:(indexPath.row+1)];
        detailsInfo.source_area_province = [self.dataSource objectAtIndex:indexPath.row];
        [detailsInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"native_place"]){
        detailsInfo.native_place_id = [NSNumber numberWithInteger:(indexPath.row+1)];
        detailsInfo.native_place_province = [self.dataSource objectAtIndex:indexPath.row];
        [detailsInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"political_status"]) {
        detailsInfo.political_status_id = [NSNumber numberWithInteger:(indexPath.row+1)];
        detailsInfo.political_status = [self.dataSource objectAtIndex:indexPath.row];
        [detailsInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"is_recommended"]){
        detailsInfo.is_recommended = [NSNumber numberWithInteger:(indexPath.row+1)];
        [detailsInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"is_recommended_by_contest"]){
        detailsInfo.is_recommended_by_contest = [NSNumber numberWithInteger:(indexPath.row+1)];
        [detailsInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"is_art_student"]){
        detailsInfo.is_art_student = [NSNumber numberWithInteger:(indexPath.row+1)];
        [detailsInfo commit];
    } else if ([self.optionsFilter isEqualToString:@"is_poor_student"]){
        detailsInfo.is_poor_student = [NSNumber numberWithInteger:(indexPath.row+1)];
        NSLog(@"%@", detailsInfo.is_poor_student);
        [detailsInfo commit];
    }
    
    [self.tableView reloadData];
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