//
//  InfoViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 3/16/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import "InfoViewController.h"
#import "DetailInfoViewController.h"
#import "FamilyInfoViewController.h"
#import "SchoolInfoViewController.h"
#import "SelectViewController.h"
#import "InputViewController.h"
#import "HttpRequestHelper.h"
#import "SettingsViewController.h"
#import "AvatarViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "BasicInfo.h"
#import "FamilyInfo.h"
#import "DetailsInfo.h"


#define GET_USER_INFO      @"http://101.200.132.161:90/psycloud_backend/index.php/Home/Student/getStudentInfo"


#define UPDATE_USER_INFO   @"http://101.200.132.161:90/psycloud_backend/index.php/Home/Student/modifyStudentInfo"


#define DawnViewBGColor [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1] // #EBEBEB
#define DawnCellBGColor [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1] // #F9F9F9
#define NightCellBGColor [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1] // #323232
#define NightCellTextColor [UIColor colorWithRed:111 / 255.0 green:111 / 255.0 blue:111 / 255.0 alpha:1] // #6F6F6F
#define NightCellHeaderTextColor [UIColor colorWithRed:75 / 255.0 green:75 / 255.0 blue:75 / 255.0 alpha:1] // #4B4B4B

#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width

@interface InfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BasicInfo *basicInfo;

@property (nonatomic, strong) FamilyInfo *familyInfo;

@property (nonatomic, strong) DetailsInfo *detailInfo;

@property (nonatomic, strong) NSNumber    *userId;

@end

static NSString *CellHasSwitchID = @"HasSwitchCell";
static NSString *CellHasDIID = @"HasDICell";// DI -> DisclosureIndicator
static NSString *CellHasSecondLabelID = @"HasSecondLabelCell";
static NSString *CellLogOutID = @"LogOutCell";

@implementation InfoViewController {
    NSArray *sectionHeaderTexts;
    NSArray *dataSource;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleView];
    [self setUpViews];
    
    sectionHeaderTexts = @[@"", @"基本信息", @"详细信息", @""];
    
    dataSource = @[@[@"头像"],
                   @[@"学号", @"姓名", @"出生日期", @"性别", @"学生类型", @"院系", @"专业", @"年级"],
                   @[@"学业信息", @"家庭信息"],
                   @[@"设置"]
                   ];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = false;
    NSUserDefaults* cache = [NSUserDefaults standardUserDefaults];
    self.userId = [cache objectForKey:@"userId"];
    [self getUserInfo];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}



- (void)getUserInfo
{
    // 首先从缓存中获取
    if([self getInfoCache]){
        return;
    }
    
    NSString *timestampData = [NSString stringWithFormat:@"%f", ([[NSDate date] timeIntervalSince1970]-600)];
    NSString *timestamp = [[timestampData componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
    NSString* apiKey = [cache objectForKey:@"apiKey"];
    NSString* secretKey = [cache objectForKey:@"secretKey"];
    
    NSLog(@"apiKey=%@ secretKey=%@ timestamp=%@", apiKey, secretKey, timestamp);
    
    NSString* sign = [self md5:[NSString stringWithFormat:@"ThisIsPsyCloudBackEnd%@%@%@", apiKey, timestamp, secretKey]];
    
    HttpRequestHelper *httpRequestHelper = [[HttpRequestHelper alloc] init];
    
    NSString* requestUrl = [NSString stringWithFormat:@"%@?api_key=%@&timestamp=%@&sign=%@", GET_USER_INFO, apiKey, timestamp, sign];
    
    NSLog(@"request url = %@", requestUrl);
    
    [httpRequestHelper GetRequestUrl:requestUrl didFinish:^(id json, NSError *error) {
        NSLog(@"json=%@", json);
        NSDictionary *responseBody = [json objectForKey:@"meta"];
        NSNumber *code = [responseBody objectForKey:@"code"];
        if(code != nil){
            if([code intValue] == 113){
                NSLog(@"%@", [responseBody objectForKey:@"error"]);
                NSLog(@"%@", [responseBody objectForKey:@"info"]);
            } else if ([code intValue] == 0) {
                [self initBasicInfo:[json objectForKey:@"data"]];
                [self initDetailsInfo:[[json objectForKey:@"data"] objectForKey:@"detail"]];
                [self initFamilyInfo:[[json objectForKey:@"data"] objectForKey:@"family"]];
            }
        }
    }];
}



- (BOOL) getInfoCache
{
    DBResultSet* familyInfoResults = [[[FamilyInfo query] where:
                                 [NSString stringWithFormat:@"user_id = %@", self.userId]] fetch];
    
    NSLog(@"%ld", [[[FamilyInfo query] fetch] count]);

    
    NSLog(@"%ld", [familyInfoResults count]);
    DBResultSet* detailInfoResults = [[[DetailsInfo query] where:
                                        [NSString stringWithFormat:@"user_id = %@", self.userId]] fetch];

    DBResultSet* basicInfoResults = [[[BasicInfo query] where:
                                       [NSString stringWithFormat:@"user_id = %@", self.userId]] fetch];
    
    if([familyInfoResults count] > 0 && [detailInfoResults count] > 0
                                     && [basicInfoResults count] > 0){
        self.familyInfo = [familyInfoResults objectAtIndex:0];
        self.detailInfo = [detailInfoResults objectAtIndex:0];
        self.basicInfo = [basicInfoResults objectAtIndex:0];
        return YES;
    } else
        return NO;
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


#pragma mark - Lifecycle

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Private

- (void)setTitleView {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"信息";
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    [titleLabel sizeToFit];
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowsData = dataSource[section];
    return rowsData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID;
    
    switch (indexPath.section) {
        case 0:
            cellID = CellHasDIID;
            break;
        case 1:
            cellID = CellHasDIID;
            break;
        case 2: {
            if (indexPath.row < 3) {
                cellID = CellHasDIID;
            } else {
                cellID = CellHasSecondLabelID;
            }
            break;
        }
        case 3:
            cellID = CellHasDIID;
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = dataSource[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    if (indexPath.section == 0) {
        UIImageView  *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d", ([self.basicInfo.head_pic_id intValue] + 1)]]];
        cell.accessoryView = imageView;
    } else if(indexPath.section == 1){
        // [@"学号", @"姓名", @"出生日期", @"性别", @"学生类型", @"院系", @"专业", @"年级"]
        UILabel *accessoryLabel = [UILabel new];
        accessoryLabel.textAlignment = UITextAlignmentRight;
        if(indexPath.row == 0){
            NSString *accessoryLabelText = self.basicInfo.student_num;
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        } else if (indexPath.row == 1){
            NSString *accessoryLabelText = self.basicInfo.name;
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        } else if (indexPath.row == 2){
            NSString *accessoryLabelText = self.basicInfo.birthday;
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        }  else if (indexPath.row == 3){
            NSString *accessoryLabelText = self.basicInfo.gender;
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        }  else if (indexPath.row == 4){
            NSString *accessoryLabelText = [NSString stringWithFormat:@"%@", self.basicInfo.student_type_id];
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        }  else if (indexPath.row == 5){
            NSString *accessoryLabelText = self.basicInfo.department_name;
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        }  else if (indexPath.row == 6){
            NSString *accessoryLabelText = self.basicInfo.major;
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        }  else if (indexPath.row == 7){
            NSString *accessoryLabelText = self.basicInfo.grade_name;
            accessoryLabel.text = accessoryLabelText;
            accessoryLabel.textColor = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            [accessoryLabel sizeToFit];
            accessoryLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryView = accessoryLabel;
        }
        
    } else if(indexPath.section == 2){
        
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
    if (indexPath.section == 0 && indexPath.row == 0){
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AvatarViewController *avatarViewController = [mainStoryBoard   instantiateViewControllerWithIdentifier:@"AvatarViewController"];
        avatarViewController.basicInfo = self.basicInfo;
        [self.navigationController pushViewController:avatarViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        SchoolInfoViewController* infoViewController = [[SchoolInfoViewController alloc] init];
        infoViewController.detailInfo = self.detailInfo;
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 1) {
        FamilyInfoViewController *familyInfoViewController = [[FamilyInfoViewController alloc] init];
        familyInfoViewController.familyInfo = self.familyInfo;
        [self.navigationController pushViewController:familyInfoViewController animated:YES];
    }
    else if (indexPath.section == 3 && indexPath.row == 0){
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:settingsViewController animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        return 70;
    }
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


- (void)initBasicInfo:(NSDictionary *)json
{
    [[[BasicInfo query] fetch] removeAll];
    
    self.basicInfo = [BasicInfo new];
    
    NSString* school_num = [json objectForKey:@"student_num"];
    NSString* birthday = [json objectForKey:@"birthday"];
    NSDictionary* degree = [json objectForKey:@"degree"];
    NSDictionary* department = [json objectForKey:@"department"];
    NSString* gender = [json objectForKey:@"gender"];
    NSDictionary* grade = [json objectForKey:@"grade"];
    NSDictionary* enrollment = [json objectForKey:@"enrollment"];
    NSString* major = [json objectForKey:@"major"];
    // head_pic_id
    // info_update
    // init_time
    NSString* name = [json objectForKey:@"name"];
    NSDictionary* school = [json objectForKey:@"school"];
    // school_id
    // status
    // student_enrollment_id
    NSString* student_num = [json objectForKey:@"student_num"];
    NSNumber* student_type_id = [json objectForKey:@"student_type_id"];
    NSDictionary* type = [json objectForKey:@"type"];
    NSString* update_time = [json objectForKey:@"update_time"];
    NSNumber* user_id = [json objectForKey:@"user_id"];
    
    // 学生基本信息
    self.basicInfo.student_num = student_num;
    self.basicInfo.student_type_id = student_type_id;
    self.basicInfo.type_id = [type objectForKey:@"id"];
    self.basicInfo.type_name = [type objectForKey:@"name"];
    self.basicInfo.name = name;
    self.basicInfo.head_pic_id = [json objectForKey:@"head_pic_id"];
    self.basicInfo.user_id = user_id;
    self.basicInfo.update_time = update_time;
    self.basicInfo.gender = gender;
    self.basicInfo.birthday = birthday;
    
    // 学生学位信息
    self.basicInfo.degree_id = [degree objectForKey:@"id"];
    self.basicInfo.degree_name = [degree objectForKey:@"name"];
    
    // 学生学院信息
    self.basicInfo.department_id = [department objectForKey:@"id"];
    self.basicInfo.department_name = [department objectForKey:@"name"];
    self.basicInfo.department_num = [department objectForKey:@"num"];
    
    // 学生专业信息
    self.basicInfo.major = major;
    
    // 学术年级信息
    self.basicInfo.grade_id = [grade objectForKey:@"id"];
    self.basicInfo.grade_name = [grade objectForKey:@"name"];

    // 学校信息
    self.basicInfo.school_status = [school objectForKey:@"status"];
    self.basicInfo.school_number = [school objectForKey:@"number"];
    self.basicInfo.school_name = [school objectForKey:@"name"];
    self.basicInfo.school_id = [school objectForKey:@"id"];
    
    self.basicInfo.user_id = self.userId;
    // en
    
    [self.basicInfo commit];
    
    
    NSLog(@"Student Info save success %@", self.basicInfo.user_id);
    [self.tableView reloadData];
}



// 初始化家庭信息
- (void)initFamilyInfo:(NSDictionary *)json
{
    [[[FamilyInfo query] fetch] removeAll];
    
    self.familyInfo = [FamilyInfo new];
    
    NSNumber* brother_sister_count = [json objectForKey:@"brother_sister_count"];
    NSString* emergency_name = [json objectForKey:@"emergency_name"];
    NSString* emergency_relation = [json objectForKey:@"emergency_relation"];
    NSString* emergency_telephone = [json objectForKey:@"emergency_telephone"];
    NSNumber* family_rank = [json objectForKey:@"family_rank"];
    NSNumber* father_age = [json objectForKey:@"father_age"];
    NSString* father_education = [json objectForKey:@"father_education"];
    NSString* father_profession = [json objectForKey:@"father_profession"];
    NSString* father_status = [json objectForKey:@"father_status"];
    NSString* father_telephone = [json objectForKey:@"father_telephone"];
    NSNumber* family_id = [json objectForKey:@"id"];
    NSNumber* mother_age = [json objectForKey:@"mother_age"];
    NSString* mother_education = [json objectForKey:@"mother_education"];
    NSString* mother_profession = [json objectForKey:@"mother_profession"];
    NSString* mother_status = [json objectForKey:@"mother_status"];
    NSString* mother_telephone = [json objectForKey:@"mother_telephone"];
    NSDictionary* parents_marriage_dic = [json objectForKey:@"parents_marriage"];
    NSNumber* parents_marriage_id = [parents_marriage_dic objectForKey:@"id"];
    NSString* parents_marriage = [parents_marriage_dic objectForKey:@"marriage"];
    NSNumber* parents_marriage_status = [parents_marriage_dic objectForKey:@"status"];
    NSNumber* student_id = [json objectForKey:@"student_id"];
    
    self.familyInfo.brother_sister_count = brother_sister_count;
    self.familyInfo.emergency_name = emergency_name;
    self.familyInfo.emergency_telephone = emergency_telephone;
    self.familyInfo.father_age = father_age;
    self.familyInfo.family_rank = family_rank;
    self.familyInfo.father_education = father_education;
    self.familyInfo.father_profession = father_profession;
    self.familyInfo.father_status = father_status;
    self.familyInfo.father_telephone = father_telephone;
    self.familyInfo.mother_age = mother_age;
    self.familyInfo.mother_education = mother_education;
    self.familyInfo.mother_profession = mother_profession;
    self.familyInfo.mother_status = mother_status;
    self.familyInfo.mother_telephone = mother_telephone;
    self.familyInfo.parents_marriage = parents_marriage;
    self.familyInfo.parents_marriage_status = parents_marriage_status;
    self.familyInfo.parents_marriage_id = parents_marriage_id;
    self.familyInfo.student_id = student_id;
    self.familyInfo.family_id = family_id;
    self.familyInfo.emergency_relation = emergency_relation;
    
    self.familyInfo.user_id = self.userId;
    
    [self.familyInfo commit];
    NSLog(@"Family info saved %@", self.familyInfo.user_id);

    
}


// 初始化详细信息
- (void)initDetailsInfo:(NSDictionary *)json
{
    [[[DetailsInfo query] fetch] removeAll];
  
    self.detailInfo = [DetailsInfo new];
    
    NSString* address = [json objectForKey:@"address"];
    NSString* cellphone = [json objectForKey:@"cellphone"];
    NSString* dormetry = [json objectForKey:@"dormetry"];
    NSString* ethnic_group = [json objectForKey:@"ethnic_group"];
    NSString* graduate_school = [json objectForKey:@"graduate_school"];
    NSNumber* is_art_student = [json objectForKey:@"is_art_student"];
    NSNumber* is_poor_student = [json objectForKey:@"is_poor_student"];
    NSNumber* is_recommended = [json objectForKey:@"is_recommended"];
    NSNumber* is_recommended_by_contest = [json objectForKey:@"is_recommended_by_contest"];
    NSString* mail = [json objectForKey:@"mail"];
    
    // Native place
    NSDictionary* native_place = [json objectForKey:@"native_place"];
    NSNumber* native_place_id = [native_place objectForKey:@"id"];
    NSString* native_place_province = [native_place objectForKey:@"province"];
    NSNumber* native_place_status = [native_place objectForKey:@"status"];
    
    NSDictionary* political_status_dic = [json objectForKey:@"political_status"];
    NSNumber* political_status_id = [political_status_dic objectForKey:@"id"];
    NSString* political_status = [political_status_dic objectForKey:@"political_status"];
    NSNumber* political_status_status = [political_status_dic objectForKey:@"status"];
    
    NSDictionary* religion = [json objectForKey:@"religion"];
    NSNumber* religion_id = [religion objectForKey:@"id"];
    NSString* religion_name = [religion objectForKey:@"name"];
    NSNumber* religion_status = [religion objectForKey:@"status"];
    
    NSDictionary* source_area = [json objectForKey:@"source_area"];
    NSNumber* source_area_id = [source_area objectForKey:@"id"];
    NSString* source_area_province = [source_area objectForKey:@"province"];
    NSNumber* source_area_status = [source_area objectForKey:@"status"];
    
    NSString* telephone = [json objectForKey:@"telephone"];
    NSString* zip_code = [json objectForKey:@"zip_code"];
  
    self.detailInfo.address = address;
    self.detailInfo.telephone = telephone;
    self.detailInfo.zip_code = zip_code;
    self.detailInfo.source_area_id = source_area_id;
    self.detailInfo.source_area_province = source_area_province;
    self.detailInfo.source_area_status = source_area_status;
    self.detailInfo.religion_id = religion_id;
    self.detailInfo.religion_name = religion_name;
    self.detailInfo.religion_status = religion_status;
    self.detailInfo.political_status = political_status;
    self.detailInfo.political_status_id = political_status_id;
    self.detailInfo.political_status_status = political_status_status;
    self.detailInfo.native_place_id = native_place_id;
    self.detailInfo.native_place_province = native_place_province;
    self.detailInfo.native_place_status = native_place_status;
    
    self.detailInfo.cellphone = cellphone;
    self.detailInfo.dormetry = dormetry;
    self.detailInfo.ethnic_group = ethnic_group;
    self.detailInfo.graduate_school = graduate_school;
    self.detailInfo.is_art_student = is_art_student;
    self.detailInfo.is_poor_student = is_poor_student;
    self.detailInfo.is_recommended = is_recommended;
    self.detailInfo.is_recommended_by_contest = is_recommended_by_contest;
    self.detailInfo.mail = mail;
    
    self.detailInfo.user_id = self.userId;
    
    [self.detailInfo commit];

    NSLog(@"detail info saved %@", self.userId);
}


- (IBAction)updateUserInfo:(id)sender {
    
    HttpRequestHelper *httpRequestHelper = [[HttpRequestHelper alloc] init];
    
    [httpRequestHelper PostJSONDataToUrl:nil json:nil didFinish:^(id json, NSError *error){
        NSLog(@"json=%@", json);
        NSDictionary *responseBody = [json objectForKey:@"meta"];
        NSNumber *code = [responseBody objectForKey:@"code"];
        if(code != nil){
            if([code intValue] == 113){
                NSLog(@"%@", [responseBody objectForKey:@"error"]);
                NSLog(@"%@", [responseBody objectForKey:@"info"]);
            } else if ([code intValue] == 0) {
                [self initBasicInfo:[json objectForKey:@"data"]];
                [self initDetailsInfo:[[json objectForKey:@"data"] objectForKey:@"detail"]];
                [self initFamilyInfo:[[json objectForKey:@"data"] objectForKey:@"family"]];
            }
        }
    }];

}


@end