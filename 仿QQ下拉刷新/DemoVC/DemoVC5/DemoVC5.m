//
//  DemoVC5.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DemoVC5.h"
#import "UIView+SDAutoLayout.h"

@interface DemoVC5 ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DemoVC5

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:_redView];
    [_scrollView addSubview:_orangeView];
    [_scrollView addSubview:_yellowView];
    [_scrollView addSubview:_greenView];
}

- (void)setupLayout {
    _scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _redView.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).heightIs(100);
    
    _orangeView.sd_layout.centerXEqualToView(_scrollView).topSpaceToView(_redView,20).widthIs(200).heightEqualToWidth();
    
    _yellowView.sd_layout.leftSpaceToView(_scrollView,50).rightSpaceToView(_scrollView,50).topSpaceToView(_orangeView,20).heightRatioToView(_redView,1);
    
    _greenView.sd_layout.centerXEqualToView(_orangeView).topSpaceToView(_yellowView,20).widthIs(200).heightEqualToWidth();
    
    // scrollview自动contentsize
    [_scrollView setupAutoContentSizeWithBottomView:self.greenView bottomMargin:20];
    
    // 设置圆角
    self.redView.sd_cornerRadiusFromHeightRatio = @(0.5);
    self.orangeView.sd_cornerRadiusFromWidthRatio = @(0.5);
    self.yellowView.sd_cornerRadiusFromWidthRatio = @(0.5);
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
