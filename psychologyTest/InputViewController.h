//
//  InputViewController.h
//  psychologyTest
//
//  Created by stanley_Hwang on 3/20/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FamilyInfo.h"
#import "DetailsInfo.h"

@interface InputViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray       *dataSource;

@property (nonatomic, strong) NSString      *title;

@property (nonatomic, strong) FamilyInfo    *familyInfo;

@property (nonatomic, strong) DetailsInfo    *detailsInfo;

@property (nonatomic, strong) NSNumber      *isNumberInput;

@property (nonatomic, strong) NSNumber      *rowID;

@end
