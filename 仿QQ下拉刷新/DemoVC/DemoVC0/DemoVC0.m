//
//  Demo0ViewController.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DemoVC0.h"
#import "UIView+SDAutoLayout.h"

const CGFloat kTimever = 0.8;

@interface DemoVC0 ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;

@property (nonatomic, assign) CGFloat widthRatio;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DemoVC0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _widthRatio = 0.4;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:kTimever target:self
                                            selector:@selector(animationBegin) userInfo:nil repeats:YES];
    
    [self setupViews];
    
    [self setupAutoLayout];
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
    
    [self.view addSubview:_redView];
    [self.view addSubview:_orangeView];
    [self.view addSubview:_yellowView];
    [self.redView addSubview:_greenView];
}

- (void)setupAutoLayout {
    self.redView.sd_layout.leftSpaceToView(self.view,20).topSpaceToView(self.view,80).heightIs(150).widthRatioToView(self.view,_widthRatio);
    
    self.orangeView.sd_layout.leftSpaceToView(self.redView,10).topEqualToView(self.redView).heightIs(60).widthRatioToView(self.redView,0.5);
    
    self.yellowView.sd_layout.leftSpaceToView(self.orangeView,10).topEqualToView(self.redView).heightRatioToView(self.orangeView,1).widthRatioToView(self.orangeView,1);
    
    self.greenView.sd_layout.centerYEqualToView(self.redView).rightSpaceToView(self.redView,10).widthRatioToView(self.redView,0.5).heightRatioToView(self.redView,0.5);
}

- (void)animationBegin {
    if (_widthRatio == 0.4) {
        _widthRatio = 0.1;
    }else{
        _widthRatio = 0.4;
    }
    
    [UIView animateWithDuration:kTimever animations:^{
        self.redView.sd_layout.widthRatioToView(self.view,_widthRatio);
        [self.redView updateLayout];
        [self.greenView updateLayout];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
