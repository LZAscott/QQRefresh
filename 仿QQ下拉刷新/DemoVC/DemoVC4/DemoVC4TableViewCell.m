//
//  DemoVC4TableViewCell.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DemoVC4TableViewCell.h"
#import "DemoVC4Model.h"
#import "UIView+SDAutoLayout.h"

@interface DemoVC4TableViewCell()

@property (nonatomic, weak) UIImageView *advanImv;
@property (nonatomic, weak) UILabel *nickLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIImageView *picImv;
@property (nonatomic, weak) UILabel *noticeLabel;

@end


@implementation DemoVC4TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *advanImv = [UIImageView new];
    advanImv.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:advanImv];
    self.advanImv = advanImv;
    
    UILabel *nickLabel = [UILabel new];
    nickLabel.textColor = [UIColor orangeColor];
    [self.contentView addSubview:nickLabel];
    self.nickLabel = nickLabel;
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIImageView *picImv = [UIImageView new];
    picImv.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:picImv];
    self.picImv = picImv;
    
    UILabel *noticeLabel = [UILabel new];
    noticeLabel.backgroundColor = [UIColor lightGrayColor];
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.text = @"纯文本";
    noticeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
    
    
    // 头像
    advanImv.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10).widthIs(40).heightEqualToWidth();
    
    // 昵称
    nickLabel.sd_layout.leftSpaceToView(advanImv,10).topEqualToView(advanImv).heightRatioToView(advanImv,0.4);
    
    // 内容
    contentLabel.sd_layout.leftEqualToView(nickLabel).topSpaceToView(nickLabel,10).rightSpaceToView(self.contentView,10).autoHeightRatio(0);
    
    // 图片
    picImv.sd_layout.leftEqualToView(contentLabel).topSpaceToView(contentLabel,10).widthRatioToView(contentLabel,0.7);
    
    // 提示
    noticeLabel.sd_layout.leftSpaceToView(nickLabel,5).centerYEqualToView(nickLabel).heightIs(14);
    
    advanImv.sd_cornerRadiusFromHeightRatio = @0.5;
    [nickLabel setSingleLineAutoResizeWithMaxWidth:200];
    [noticeLabel setSingleLineAutoResizeWithMaxWidth:50];
}

- (void)setModel:(DemoVC4Model *)model {
    _model = model;
    
    _advanImv.image = [UIImage imageNamed:_model.iconName];
    
    _nickLabel.text = _model.name;
    // 防止单行文本label在重用时宽度计算不准的问题
    [_nickLabel sizeToFit];
    
    _contentLabel.text = _model.content;
    
    CGFloat bottomMargin = 0;
    UIImage *pic = [UIImage imageNamed:_model.picName];
    if (pic.size.width > 0) {   // 有图片
        CGFloat scale = pic.size.height / pic.size.width;
        _picImv.sd_layout.autoHeightRatio(scale);
        _picImv.image = pic;
        bottomMargin = 10;
        _noticeLabel.hidden = YES;
    }else{  // 没有图片
        _picImv.sd_layout.autoHeightRatio(0);
        _noticeLabel.hidden = NO;
    }
    
    //***********************高度自适应cell设置步骤************************
    [self setupAutoHeightWithBottomView:_picImv bottomMargin:bottomMargin];
}

@end
