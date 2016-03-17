//
//  DemoVC2.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DemoVC2.h"
#import "UIView+SDAutoLayout.h"

@interface DemoVC2 ()

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *greenView;

@end

@implementation DemoVC2

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
    
    [self.view addSubview:_redView];
    [self.view addSubview:_orangeView];
    [self.view addSubview:_yellowView];
    [self.view addSubview:_greenView];
}

- (void)setupLayout {
    
    self.view.sd_equalWidthSubviews = @[self.redView,self.orangeView,self.yellowView];
    
    self.redView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,50).heightEqualToWidth();
    self.orangeView.sd_layout.leftSpaceToView(self.redView,0).topEqualToView(self.redView).heightEqualToWidth();
    self.yellowView.sd_layout.leftSpaceToView(self.orangeView,0).topEqualToView(self.orangeView).rightSpaceToView(self.view,0).heightEqualToWidth();
   
    
    self.greenView.sd_layout.widthIs(50).heightEqualToWidth().centerXEqualToView(self.view).centerYEqualToView(self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
