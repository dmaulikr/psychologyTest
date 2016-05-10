
//
//  AvatarViewController.m
//  psychologyTest
//
//  Created by stanley_Hwang on 5/9/16.
//  Copyright © 2016 stanley_Hwang. All rights reserved.
//

#import "ViewController.h"
#import "AvatarViewController.h"

@interface AvatarViewController ()

@end

@implementation AvatarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCollection];
}

-(void)setUpCollection {
    self.tabBarController.tabBar.hidden = true;
    self.dataMArr = [NSMutableArray array];
    for(NSInteger index=0; index<9; index++){
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)index+1]];
        NSString *title = [NSString stringWithFormat:@"头像 %ld",(long)index+1];
        NSDictionary *dic = @{@"image": image, @"title":title};
        [self.dataMArr addObject:dic];
    }
    self.myConllection.delegate = self;
    self.myConllection.dataSource = self;
}


#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataMArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCellID = @"myCollectionCell";
    collectionCell *cell = (collectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    NSDictionary *dic    = self.dataMArr[indexPath.row];
    
    UIImage *image       = dic[@"image"];
    NSString *title      = dic[@"title"];
    
    if([self.basicInfo.head_pic_id intValue] == indexPath.row){
//    if((indexPath.row == 1)){
        title = @"已选中";
        cell.titleLabel.textColor = [UIColor greenColor];
    } else {
        cell.titleLabel.textColor = [UIColor grayColor];
    }
    cell.imageView.image = image;
    cell.titleLabel.text = title;
    cell.titleLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
};


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
//    NSDictionary *dic    = self.dataMArr[indexPath.row];
    self.basicInfo.head_pic_id = [NSNumber numberWithInteger:indexPath.row];
    [self.basicInfo commit];
    [self.myConllection reloadData];
}


@end
