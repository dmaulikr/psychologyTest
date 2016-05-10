//
//  AvatarViewController.h
//  psychologyTest
//
//  Created by stanley_Hwang on 5/9/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionCell.h"
#import "BasicInfo.h"

@interface AvatarViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>


@property (strong, nonatomic) NSMutableArray                 *dataMArr;

@property (weak, nonatomic) IBOutlet UICollectionView        *myConllection;

@property (strong, nonatomic) BasicInfo                      *basicInfo;

@end

