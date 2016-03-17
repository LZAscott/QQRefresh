//
//  UIView+Extension.h
//  Travelling
//
//  Created by Scott_Mr on 15/11/23.
//  Copyright © 2015年 Troll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

/**
 *  截屏
 *  @return 截了之后的图片
 */
- (UIImage *)convertViewToImage;

/**  点击事件 */
- (void)addTarget:(id)target action:(SEL)selector;

/**  长按手势 */
- (void)addLongPressTarget:(id)target withAction:(SEL)selector;


@end
