//
//  ScottRefreshControll.h
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/1/21.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ScottRefreshControll;
@protocol ScottRefreshControllDelegate <NSObject>

@optional
- (void)refreshControllStartRefresh:(ScottRefreshControll *)refreshControll;

@end

@interface ScottRefreshControll : UIView

@property (nonatomic, weak) id<ScottRefreshControllDelegate> delegate;

+ (instancetype)refreshControllWithScrollView:(UIScrollView *)scrollView;
- (void)endRefreshing;



@end
