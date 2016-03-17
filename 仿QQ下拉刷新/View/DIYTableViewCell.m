//
//  DIYTableViewCell.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/1/28.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DIYTableViewCell.h"

@interface DIYTableViewCell ()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation DIYTableViewCell

- (void)awakeFromNib {
    
    //取消选中效果
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    self.clipsToBounds = YES;
    
    [self setupViews];
}

- (void)setupViews {
    _picImageView = [[UIImageView alloc] init];
    _picImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_picImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"标题";
    [self.contentView addSubview:_titleLabel];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    _subTitleLabel.textColor = [UIColor whiteColor];
    _subTitleLabel.text = @"xxxxx";
    [self.contentView addSubview:_subTitleLabel];
    
    self.picImageView.frame = CGRectMake(0, -cellHeight * 0.5, kWidth, cellHeight * 2);
    self.titleLabel.frame = CGRectMake(0, cellHeight * 0.5 - 30, kWidth, 30);
    self.subTitleLabel.frame = CGRectMake(0, cellHeight * 0.5 + 30, kWidth, 30);
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setImg:(UIImage *)img {
    self.picImageView.image = img;
}

- (CGFloat)cellOffset {
    /*
     - (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
     将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
     这里用来获取self在window上的位置
     */
    CGRect toWindow = [self convertRect:self.bounds toView:self.window];
    
    //获取父视图的中心
    CGPoint windowCenter = self.superview.center;
    
    //cell在y轴上的位移  CGRectGetMidY之前讲过,获取中心Y值
    CGFloat cellOffsetY = CGRectGetMidY(toWindow) - windowCenter.y;
    
    //位移比例
    CGFloat offsetDig = 2 * cellOffsetY / self.superview.frame.size.height ;
    
    //要补偿的位移
    CGFloat offset =  -offsetDig * cellHeight/2;
    
    //让pictureViewY轴方向位移offset
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    self.picImageView.transform = transY;
    
    return offset;

}

@end
