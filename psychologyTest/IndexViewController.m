//
//  IndexViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 2/29/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface IndexViewController : UITableViewController

@end


@implementation IndexViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = false;
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    [[NSUserDefaults standardUserDefaults] setObject:localeDate forKey:@"startTime"];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.section == 0 && indexPath.row == 0){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewController *myView = [story instantiateViewControllerWithIdentifier:@"testView"];
        [self.navigationController pushViewController:myView animated:YES];
    }
}

@end