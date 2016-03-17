//
//  TestTableViewCell.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "TestTableViewCell.h"
#import "UIView+SDAutoLayout.h"

@interface TestTableViewCell ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation TestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupViews];
        [self setupLayout];
        
    }
    return self;
}

- (void)setupViews {
    
    _redView = [UIView new];
    _redView.backgroundColor = [UIColor redColor];
    
    _orangeView = [UIView new];
    _orangeView.backgroundColor = [UIColor orangeColor];
    
    _yellowView = [UIView new];
    _yellowView.backgroundColor = [UIColor yellowColor];
    
    _greenView = [UIView new];
    _greenView.backgroundColor = [UIColor greenColor];
    
    _blueView = [UIView new];
    _blueView.backgroundColor = [UIColor blueColor];
    
    _contentLabel = [UILabel new];
    _contentLabel.backgroundColor = [UIColor cyanColor];
    
    [self.contentView addSubview:_redView];
    [self.contentView addSubview:_orangeView];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_yellowView];
    [self.contentView addSubview:_greenView];
    [self.contentView addSubview:_blueView];
}

- (void)setupLayout {
    
    self.redView.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10).widthIs(50).heightEqualToWidth();
    
    self.orangeView.sd_layout.leftSpaceToView(self.redView,10).topEqualToView(self.redView).rightSpaceToView(self.contentView,10).heightRatioToView(self.redView,0.4);
    
    self.contentLabel.sd_layout.leftEqualToView(self.orangeView).rightSpaceToView(self.contentView,60).topSpaceToView(self.orangeView,10).autoHeightRatio(0);
    
    self.yellowView.sd_layout.leftSpaceToView(self.contentLabel,10).rightEqualToView(self.orangeView).topEqualToView(self.contentLabel).heightRatioToView(self.contentLabel,1);
    
    self.greenView.sd_layout.leftEqualToView(self.contentLabel).topSpaceToView(self.contentLabel,10).heightIs(30).widthRatioToView(self.orangeView,0.7);
    
    self.blueView.sd_layout.leftSpaceToView(self.greenView,10).topEqualToView(self.greenView).rightEqualToView(self.yellowView).heightRatioToView(self.greenView,1);
    
    [self setupAutoHeightWithBottomView:self.greenView bottomMargin:10];
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    
    self.contentLabel.text = _titleText;
}

@end
