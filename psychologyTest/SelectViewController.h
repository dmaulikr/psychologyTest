//
//  SelectViewController.h
//  psychologyTest
//
//  Created by stanley_Hwang on 3/20/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SelectViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray   *dataSource;

@property (nonatomic, strong) NSString  *title;

@property (nonatomic, strong) NSString  *optionsFilter;

@end
