
//
//  TestDoneViewController.h
//  psychologyTest
//
//  Created by stanley_Hwang on 12/20/15.
//  Copyright © 2015 stanley_Hwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestResultViewController.h"

@interface TestResultViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *resultList;

@end

@implementation TestResultViewController


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}


- (void)dismissMyView {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.resultList = [[NSMutableArray alloc] init];
    NSString *rst1 = @"  亲爱的同学，看起来你可能最近过得不太好，或许遇到了一些困难， 如有需要，建议你联系心理咨询中心预约咨询，心理中心的心理学博士们会给你进一步的帮助。";
    
    NSString *rst2 = @"  亲爱的同学，看起来你可能最近过得不太好，或许遇到了一些困难， 如有需要，建议你联系心理咨询中心预约咨询，心理中心的心理学博士们会给你进一步的帮助。";
    
    NSString *rst3 = @"  你比较安静，离群，内省，喜爱读书而不喜欢接触人。保守，与人保持一定距离 ( 除非挚友 ) ， 倾向于事前有计划，做事关前顾后，不凭一时冲动。不喜欢兴奋的事，日常生活有规律，严谨。 很少攻击行为，多少有些悲观。踏实可靠。价值观念是以伦理道德做标准。";
    
    [self.resultList addObject:rst1];
    [self.resultList addObject:rst2];
    [self.resultList addObject:rst3];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"night_icon_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissView)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
}


- (void)dismissView {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat contentWidth = self.tableView.frame.size.width;
    UIFont *font = [UIFont systemFontOfSize:14];
    NSString *result = @"";
    if(indexPath.section == 0 && indexPath.row == 0){
       result = [self.resultList objectAtIndex:0];
    } else if(indexPath.section == 1 && indexPath.row == 0){
       result = [self.resultList objectAtIndex:1];
    } else {
       result = [self.resultList objectAtIndex:2];
    }
    NSString *content = result;
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    // 這裏返回需要的高度
    return size.height+30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    UILabel *headerLabel = nil;
    if(section == 1){
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width, 30)];
        headerLabel.textColor = [UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1];
        headerLabel.text = @"总的结果";
        headerLabel.font = [UIFont systemFontOfSize:15];
    }
    if (section == 2){
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width, 30)];
        headerLabel.textColor = [UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1];
        headerLabel.text = @"你的性格特征";
        headerLabel.font = [UIFont systemFontOfSize:15];
    }
    if (section == 0){
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width, 30)];
        headerLabel.textColor = [UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1];
        headerLabel.text = @"你最近的情绪状态";
        headerLabel.font = [UIFont systemFontOfSize:15];
    }
    [headerView addSubview:headerLabel];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *content = @"";
    if(indexPath.section == 0 && indexPath.row == 0){
        content = [self.resultList objectAtIndex:0];
    } else if(indexPath.section == 1 && indexPath.row == 0){
        content = [self.resultList objectAtIndex:1];
    } else {
        content = [self.resultList objectAtIndex:2];
    }
    cell.textLabel.text = content;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor grayColor];
    // 設置自動換行(重要)
    cell.textLabel.numberOfLines = 0;
    // 設置顯示字體(一定要和之前計算時使用字體一至)
    cell.textLabel.font = font;
    return cell;
}

// Called after the user changes the Option.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


@end