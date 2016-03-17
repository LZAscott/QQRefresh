//
//  DIYTableViewCell.h
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/1/28.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define cellHeight 250.0

@interface DIYTableViewCell : UITableViewCell



//cell的位移
- (CGFloat)cellOffset;

//设置图片
- (void)setImg:(UIImage *)img;


@end
