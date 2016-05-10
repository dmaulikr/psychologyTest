//
//  ViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 11/20/15.
//  Copyright © 2015 stanley_Hwang. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "Question.h"
#import "Option.h"
#import "Answer.h"
#import "HttpRequestHelper.h"
#import <CommonCrypto/CommonDigest.h>

#define UN_SELECT_TIP          @"还未作答"
#define MULTI_SELECT_TIP       @"该题目为多选题"

#define DOWNLOAD_QUESTION_API  @""

#define GET_USER_INFO          @"http://101.200.132.161:90/psycloud_backend/index.php/Home/Student/getStudentInfo"


@interface ViewController ()

@property (nonatomic, weak)   NSTimer           *timer;

@property (nonatomic, strong) NSString          *costTimeStr;

@property (nonatomic, strong) NSMutableArray    *optionArray;

@property (nonatomic, strong) NSMutableArray    *currentSelections;

@property (nonatomic, strong) Question          *question;

@property (nonatomic, strong) NSString          *answerText;

@property int                                   questionCount;


@end

@implementation ViewController

int questionIndex = 1;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.optionArray = [[NSMutableArray alloc] init];
    
    [self initFooterViewButton];
    
    self.answerText = @"";
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.costTimeStr = [[NSString alloc] init];

    [self initData];
    
    self.question = [[Question alloc] init];
    
    self.questionCount = [self getQuestionCount];
    
    self.currentSelections = [[NSMutableArray alloc] init];
    
    questionIndex = 1;
    
    [self initQuestionByID];

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"night_icon_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(dismissView)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.costTimeStr = [NSString stringWithFormat:@"0小时:0分:0秒"];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(costTime)
                                            userInfo:nil
                                             repeats:YES];
}


- (void)dismissView {
    [self.navigationController popViewControllerAnimated:YES];
}

// 初始化数据
- (void)initData
{
//    NSMutableArray *options = [[NSMutableArray alloc] init];

//    Option *s1 = [Option new];
//    s1.questionID = 1;
//    s1.optionID = 1;
//    s1.content = @"TCP";
//    
//    [s1 commit];
//    
//    Option *s2 = [Option new];
//    s2.questionID = 1;
//    s2.optionID = 2;
//    s2.content = @"UDP";
//    
//    [s2 commit];
//    
//    Option *s3 = [Option new];
//    s3.questionID = 1;
//    s3.optionID = 3;
//    s3.content = @"UDP";
//    
//    [s3 commit];
//    
//    Option *s4 = [Option new];
//    s4.questionID = 1;
//    s4.optionID = 4;
//    s4.content = @"UDP";
//    
//    [s4 commit];
//
//    Option *s5 = [Option new];
//    s5.questionID = 2;
//    s5.optionID = 1;
//    s5.content = @"chmod a+x g+w exer1";
//    
//    [s5 commit];
//    
//    Option *s6 = [Option new];
//    s6.questionID = 2;
//    s6.optionID = 2;
//    s6.content = @"chmod g+w exer1";
//    
//    [s6 commit];
//    
//    Option *s7 = [Option new];
//    s7.questionID = 2;
//    s7.optionID = 3;
//    s7.content = @"chmod 765 exer1";
//    
//    [s7 commit];
//    
//    Option *s8 = [Option new];
//    s8.questionID = 2;
//    s8.optionID = 4;
//    s8.content = @"chmod o+x exer1";
//    
//    [s8 commit];
//    
//    Option *s9 = [Option new];
//    s9.questionID = 3;
//    s9.optionID = 1;
//    s9.content = @"chmod a+x g+w exer1";
//    
//    [s9 commit];
//    
//    Option *s10 = [Option new];
//    s10.questionID = 3;
//    s10.optionID = 2;
//    s10.content = @"chmod g+w exer1";
//    
//    [s10 commit];
//    
//    Option *s11 = [Option new];
//    s11.questionID = 3;
//    s11.optionID = 3;
//    s11.content = @"chmod 765 exer1";
//    
//    [s11 commit];
//    
//    Option *s12 = [Option new];
//    s12.questionID = 3;
//    s12.optionID = 4;
//    s12.content = @"chmod o+x exer1";
//    
//    [s12 commit];
//    
//    int count = [[Option query] count];
//    NSLog(@"Option length = %d", count);
//
//    Question *q1 = [Question new];
//    
//    q1.questionID = 1;
//    q1.content = @"我七岁之前曾经超过一周时间住在别人家里";
//    q1.type = 1;
//    
//    [q1 commit];
//    
//    Question *q2 = [Question new];
//    q2.questionID = 2;
//    q2.content = @"我们常说的mvc框架是指的什么的?";
//    q2.type = 1;
//    
//    [q2 commit];
////
//    Question *q3 = [Question new];
//    q3.questionID = 3;
//    q3.content = @"我们常说的mvc框架是指的什么的?";
//    q3.type = 3;
//    
//    [q3 commit];

//    int count2 = [[Question query] count];
//    NSLog(@"Question length = %d", count2);
//    [Options addObject:@"1 TCP"];
//    [Options addObject:@"2 UDP"];
//    [Options addObject:@"3 共享内存"];
//    [Options addObject:@"4 Socket"];
//    //    NSLog(@"count=%d", [Options count]);
//    
//    NSMutableArray *Options2 = [[NSMutableArray alloc] init];
//    [Options2 addObject:@"1 chmod a+x g+w exer1"];
//    [Options2 addObject:@"2 chmod g+w exer1"];
//    [Options2 addObject:@"3 chmod 765 exer1"];
//    [Options2 addObject:@"4 chmod o+x exer1"];
//    
//    NSMutableArray *Options3 = [[NSMutableArray alloc] init];
//    [Options3 addObject:@"1 模块(module)-视图(view)-组件(component)"];
//    [Options3 addObject:@"2 模型(model)-视图(view)-组件(component)"];
//    [Options3 addObject:@"3 模块(module)-视图(view)-控制器(controller)"];
//    [Options3 addObject:@"4 模型(model)-视图(view)-控制器(controller)"];
//    
//    [self.OptionList setObject:Options forKey:@"1"];
//    [self.OptionList setObject:Options2 forKey:@"2"];
//    [self.OptionList setObject:Options3 forKey:@"3"];
}


- (int)getQuestionCount
{
    return [[Question query] count];
}


// 初始化底部 上一题/下一题button
- (void)initFooterViewButton
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 400)];
    
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];         //边框设置
    preButton.frame = CGRectMake(10, 0, self.tableView.frame.size.width/4, 30);   //位置及大小
    preButton.backgroundColor = [UIColor whiteColor];
    [preButton setTitle:@"<  上一题" forState:UIControlStateNormal];                      //按钮的提示字
    preButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    [preButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [preButton.layer setMasksToBounds:YES];
    preButton.layer.cornerRadius = 5.0;
    [preButton addTarget:self action:@selector(preButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];         //边框设置
    nextButton.frame = CGRectMake(self.tableView.frame.size.width-self.tableView.frame.size.width/4-10, 0, self.tableView.frame.size.width/4, 30);                                   //位置及大小
    [nextButton setTitle:@"下一题  >" forState:UIControlStateNormal];                      //按钮的提示字
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    [nextButton setTitleColor:[UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1] forState:UIControlStateNormal];
    [nextButton.layer setMasksToBounds:YES];
    nextButton.layer.cornerRadius = 5.0;
    [nextButton addTarget:self action:@selector(nextButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    
    [footerView addSubview:preButton];
    
    [footerView addSubview:nextButton];
    
    self.tableView.tableFooterView = footerView;
}


- (void)preButtonTap
{
    questionIndex--;
    if( questionIndex >= 1 ){
        [self initQuestionByID];
    } else {
        questionIndex = 1;
        [self initQuestionByID];
    }
    [self.tableView reloadData];
}

- (void)nextButtonTap
{
    questionIndex++;
    if(questionIndex <= self.questionCount){
        // 如果为多选题目时
        if(self.question.type == 2 || self.question.type == 3){
            if([self.currentSelections count] <= 1){
                [self showTextOnly:MULTI_SELECT_TIP];
                questionIndex--;
            }else{
                // 保存当前答案
                [self saveCurrentQuestionAnswer];
                // 初始化题目
                [self initQuestionByID];
            }
        } else if(self.question.type == 1){
            if([self.currentSelections count] == 0){
                [self showTextOnly:UN_SELECT_TIP];
                questionIndex--;
            } else {
                [self initQuestionByID];
            }
        }
    } else {
        
        if([self.currentSelections count] <= 1){
            if([self.currentSelections count] == 0 && self.question.type == 1){
                [self showTextOnly:UN_SELECT_TIP];
            } else if ((self.question.type == 2 || self.question.type == 3) && [self.currentSelections count] <= 1){
                [self showTextOnly:MULTI_SELECT_TIP];
            }
            questionIndex--;
            return;
        }
        questionIndex = self.questionCount;
        // 保存当前答案
        [self saveCurrentQuestionAnswer];
        [self enterNextView];
    }
    
    [self.tableView reloadData];
}


// 初始化题目
-(void)initQuestionByID
{
    // 重置相关变量
    [self.optionArray removeAllObjects];
    
    [self.currentSelections removeAllObjects];
    
    self.answerText = @"";
    
    NSString *filterStr = [NSString stringWithFormat:@"questionID = %d", questionIndex];
    
    DBResultSet* results = [[[[Option query]
                              where:filterStr]
                             orderBy:@"OptionID"]
                            fetch];
    for(Option *item in results){
        [self.optionArray addObject:item];
    }
    
    NSString *questionQuery = [NSString stringWithFormat:@"questionID = %d", questionIndex];
    
    DBResultSet* questions = [[[Question query]
                               where:questionQuery] fetch];
    
    DBResultSet* answers = [[[Answer query] where:questionQuery] fetch];
    
    self.question = [questions objectAtIndex:0];
    
    // 将已经勾选答案进行初始化
    if(answers != nil && [answers count] > 0){
        Answer *answer = [answers objectAtIndex:0];
    
        NSArray *answerArray = [answer.selectionList componentsSeparatedByString:@"_"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        for(NSString *ss in answerArray){
            [self.currentSelections addObject:[self.optionArray objectAtIndex:[[f numberFromString:ss] intValue]]];
        }
        
        if(self.question.type == 3){
            NSLog(@"answer=%@", answer.other);
            UITextField *answerTextField = [self.tableView viewWithTag:100];
            answerTextField.text = answer.other;
            self.answerText = answer.other;
        }
    }
}


// 计时
-(void)costTime
{
    NSDate *fromDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"startTime"];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    
    long lTime = (long)intervalTime;
    NSInteger iSeconds = lTime % 60;
    NSInteger iMinutes = (lTime / 60) % 60;
    NSInteger iHours = (lTime / 3600);
    self.costTimeStr = [NSString stringWithFormat:@"%d小时:%d分:%d秒", iHours, iMinutes, iSeconds];
    
    UILabel* label = (UILabel *)[self.tableView viewWithTag:101];
    label.text = self.costTimeStr;
//    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:false];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    } else {
        return self.optionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString * CellIdentifier = @"MessageViewControllerCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:15];
        // 該行要顯示的內容
        NSLog(@"Question Index = %d", questionIndex);
        
        NSString *content = self.question.content;
        // 实例化单元格对象
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // 设置显示文字
        cell.textLabel.text = content;
        // 設置自動換行(重要)
        cell.textLabel.numberOfLines = 0;
        // 設置顯示字體(一定要和之前計算時使用字體一至)
        cell.textLabel.font = font;
        return cell;
    } else {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        if(3 == self.question.type && indexPath.row == ([self.optionArray count]-1)){
            UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 1.0f, self.tableView.frame.size.width/3*2, 35.0f)];
            textFiled.placeholder = @"其他答案";
            textFiled.font = [UIFont systemFontOfSize:12];
            textFiled.tag = 100;
            textFiled.returnKeyType = UIReturnKeyDone;
            textFiled.delegate = self;
            [textFiled setBorderStyle:UITextBorderStyleRoundedRect];
            [cell addSubview:textFiled];
            return cell;
        }
        
        Option *Option = [self.optionArray objectAtIndex:indexPath.row];;
        cell.textLabel.text = [NSString stringWithFormat:@"%d  %@", Option.optionID, Option.content];
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:15];
        // 設置自動換行(重要)
        cell.textLabel.numberOfLines = 0;
        // 設置顯示字體(一定要和之前計算時使用字體一至)
        cell.textLabel.font = font;
        
        // 多选题
        if([self.currentSelections count] > 0
        && [self.currentSelections containsObject:[self.optionArray objectAtIndex:indexPath.row]]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.tableView setTintColor:[UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1]];
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        // 耗费时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.tableView.frame.size.width/3, 20)];
        timeLabel.textColor = [UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1];
        timeLabel.text = self.costTimeStr;
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.tag = 101;
//        [timeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:5]];
        timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [headerView addSubview:timeLabel];
        

        // 题目类型 单选/多选
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/3, 5, self.tableView.frame.size.width/3, 20)];
        typeLabel.textColor = [UIColor grayColor];
        if(2 == self.question.type || 3 == self.question.type){
            typeLabel.text = @"多选";
        } else {
            typeLabel.text = @"单选";
        }
        typeLabel.textAlignment = UITextAlignmentCenter;
        typeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [headerView addSubview:typeLabel];

        // 题目进度 做到第几题/总题数
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/3*2, 5, self.tableView.frame.size.width/3, 20)];
        progressLabel.textColor = [UIColor colorWithRed:23.0/255 green:215.0/255 blue:177.0/255 alpha:1];
        progressLabel.text = [NSString stringWithFormat:@"%d/%d", questionIndex, self.questionCount];
        progressLabel.textAlignment = UITextAlignmentCenter;
        progressLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        [headerView addSubview:progressLabel];
        return headerView;
    }else{
        UIView *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        // 列寬
        CGFloat contentWidth = self.tableView.frame.size.width;
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:15];
        // 該行要顯示的內容
        NSString *content = self.question.content;
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        // 這裏返回需要的高度
        return size.height+30;
    } else {
        CGFloat contentWidth = self.tableView.frame.size.width;
        UIFont *font = [UIFont systemFontOfSize:5];
        Option *Option = [self.optionArray objectAtIndex:indexPath.row];
        NSString *content = Option.content;
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        // 如果是有输入的多选题
        if(3 == self.question.type && indexPath.row == ([self.optionArray count]-1)){
            return 40;
        }
        return size.height+30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 30;
    else
        return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1){
        return 15;
    }
    return 0.1;
}

// Called after the user changes the Option.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    // 单选题
    if(1 == self.question.type){
        /// 删除所有对象
        [self.currentSelections removeAllObjects];
        /// 添加当前选项
        [self.currentSelections addObject:[self.optionArray objectAtIndex:indexPath.row]];
        
        if(questionIndex <= self.questionCount){
            [self saveCurrentQuestionAnswer];
            
            questionIndex++;
            
            [self initQuestionByID];
            [self.tableView reloadData];
        } else {
            questionIndex = self.questionCount;
            [self saveCurrentQuestionAnswer];
            [self enterNextView];
        }
    } else {
        if(![self.currentSelections containsObject:[self.optionArray objectAtIndex:indexPath.row]]){
            [self.currentSelections addObject:[self.optionArray objectAtIndex:indexPath.row]];
        } else {
            [self.currentSelections removeObject:[self.optionArray objectAtIndex:indexPath.row]];
        }
        [self.tableView reloadData];
    }
}


// 保存现在的答案
- (void)saveCurrentQuestionAnswer
{
    NSString *answerStr = @"";
    
    NSString *questionQuery = [NSString stringWithFormat:@"questionID = %d", self.question.questionID];
    
    DBResultSet* answers = [[[Answer query] where:questionQuery] fetch];
    
    // 删除原有答案
    if(answers != nil && [answers count] > 0){
        Answer *oldAnswer = [answers objectAtIndex:0];
        NSLog(@"%d, %@", oldAnswer.questionID, oldAnswer.selectionList);
        [oldAnswer remove];
    }
    
    // 构建答案字符串
    for(Option *option in self.currentSelections){
        if(![answerStr isEqualToString:@""]){
            answerStr = [NSString stringWithFormat:@"%@_%d", answerStr, option.optionID-1];
        } else {
            answerStr = [NSString stringWithFormat:@"%d", option.optionID-1];
        }
    }
    
    Answer* answer = [Answer new];
    answer.questionID = self.question.questionID;
    answer.selectionList = answerStr;
    
    if(self.question.type == 3 && ![self.answerText isEqualToString:@""]){
        answer.other = self.answerText;
    }
    
    [answer commit];
    NSLog(@"%@", answerStr);
}


- (void)enterNextView
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITableViewController *mainView = [mainStoryBoard   instantiateViewControllerWithIdentifier:@"TestDoneViewController"];
    [self.navigationController pushViewController:mainView animated:YES];
}


// 上传所有答题结果
- (void)uploadAnswer
{
    
}


// 下载所有题目
- (void)downloadAllQuestions
{
    NSURL *url = [NSURL URLWithString:DOWNLOAD_QUESTION_API];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setTimeoutInterval:2.0f];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *bodyStr = @"";
    
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError * error) {
        NSLog(@"data: %@", data);
        if (data != nil) {
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);
            NSDictionary *jsonData = [self jsonParse:str];
            NSNumber *code = [jsonData objectForKey:@"errCode"];
            
            NSLog(@"%@", jsonData);
        } else if (data == nil && error != nil)
        {

        } else {

        }
        [self.tableView reloadData];
    }];
}


// 解析Json, 并将返回的字符串转化为字典类型
- (NSDictionary*)jsonParse:(NSString *)jsonString
{
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}



- (void)showTextOnly:(NSString *)msg {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 30.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}


- (void)showWithLabel:(NSString *)msg {
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.answerText = textField.text;
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
