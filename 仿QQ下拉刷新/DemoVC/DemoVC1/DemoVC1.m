//
//  DemoVC1.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DemoVC1.h"
#import "UIView+SDAutoLayout.h"

@interface DemoVC1 ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *cyanView;
@property (nonatomic, strong) UIView *purpleView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DemoVC1

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupViews];
    [self setupLayout];
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
    
    _cyanView = [UIView new];
    _cyanView.backgroundColor = [UIColor cyanColor];
    
    [self.view addSubview:_redView];
    [self.view addSubview:_orangeView];
    [self.view addSubview:_yellowView];
    [self.view addSubview:_greenView];
    [self.view addSubview:_blueView];
    [self.view addSubview:_cyanView];
    
    _purpleView = [UIView new];
    _purpleView.backgroundColor = [UIColor purpleColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.backgroundColor = [UIColor cyanColor];
    _titleLabel.text = @"jljflsjflsjflsjfjls,fjlsjflsjlfjslfjlsjfs,fjlsjfljs";
    
    [self.orangeView addSubview:_purpleView];
    [self.orangeView addSubview:_titleLabel];
}

- (void)setupLayout {
    
    self.redView.sd_layout.leftSpaceToView(self.view,10).topSpaceToView(self.view,20).widthIs(50).heightEqualToWidth();
    
    // 此处没有约束高度，因为需要根据文字内容自适应。
    self.orangeView.sd_layout.leftSpaceToView(self.redView,10).topEqualToView(self.redView).rightSpaceToView(self.view,30);
    
    self.yellowView.sd_layout.rightSpaceToView(self.view,10).topSpaceToView(self.orangeView,20).widthRatioToView(self.redView,1).heightRatioToView(self.redView,1);
    
    self.greenView.sd_layout.leftSpaceToView(self.view,30).topEqualToView(self.yellowView).rightSpaceToView(self.yellowView,10).heightRatioToView(self.view,0.17);
    
    self.blueView.sd_layout.leftEqualToView(self.redView).topSpaceToView(self.greenView,20).heightRatioToView(self.redView,1).widthRatioToView(self.redView,1);
    
    self.cyanView.sd_layout.leftEqualToView(self.orangeView).topEqualToView(self.blueView).rightEqualToView(self.orangeView).bottomSpaceToView(self.view,20);
    
    
    self.titleLabel.sd_layout.leftSpaceToView(self.orangeView,10).topSpaceToView(self.orangeView,10).rightSpaceToView(self.orangeView,10).autoHeightRatio(0);
    self.purpleView.sd_layout.leftEqualToView(self.titleLabel).topSpaceToView(self.titleLabel,10).heightIs(30).widthRatioToView(self.titleLabel,1);
    
    [self.orangeView setupAutoHeightWithBottomView:self.purpleView bottomMargin:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
