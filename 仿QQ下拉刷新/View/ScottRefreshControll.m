//
//  ScottRefreshControll.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/1/21.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "ScottRefreshControll.h"
#import "UIView+Extension.h"

#define Scott_obsever_key  @"contentOffset"

// 初始化高度
#define SCOTT_INIT_HEIGHT 60.
// 开始刷新最高偏移
#define SCOTT_REFRESH_HEIGHT 120.

// 隐藏刷新视图默认时长
#define SCOTT_HIDE_DURATION 0.25

// 形变的最小比例
#define SCOTT_MIN_SCALE 0.25

// 形变的最大比例
#define SCOTT_MAX_SCALE 0.7


// 角度转弧度
static inline CGFloat kAngleToArc(CGFloat angle){
    return angle * (M_PI / 180.);
}

typedef NS_ENUM(NSInteger, ScottRefreshState){
    ScottRefreshStateNomal,
    ScottRefreshStateReday,
    ScottRefreshStateRefreshing
};

@interface ScottRefreshControll ()

@property (nonatomic, assign) CGFloat    initWidth;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) CGFloat    insetsTop;

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UIImageView *refreshImageView;

@property (nonatomic, assign) ScottRefreshState    state;

@property (nonatomic, strong) UIButton *successBtn;

@end


@implementation ScottRefreshControll

+ (instancetype)refreshControllWithScrollView:(UIScrollView *)scrollView {
    ScottRefreshControll *refreshControl = [[ScottRefreshControll alloc] init];
    refreshControl.scrollView = scrollView;
    return refreshControl;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    
    if (newSuperview) {
        _scrollView = (UIScrollView *)newSuperview;
        [_scrollView addObserver:self forKeyPath:Scott_obsever_key options:NSKeyValueObservingOptionNew + NSKeyValueObservingOptionOld context:nil];
    }
}

#pragma mark - 移除观察者
- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:Scott_obsever_key];
}

#pragma mark - 控件重新布局时刷新
- (void)layoutSubviews {
    [super layoutSubviews];
    self.refreshImageView.center = CGPointMake(self.centerX, SCOTT_INIT_HEIGHT / 2);
    _activityIndicatorView.center = _refreshImageView.center;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commitInit];
    }
    return self;
}

// 通用的控件初始化
- (void)commitInit {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.userInteractionEnabled = NO;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:self.activityIndicatorView];
}

#pragma mark - setter
- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView) {
        [self removeFromSuperview];
        [_scrollView removeObserver:self forKeyPath:Scott_obsever_key];
    }
    
    CGRect frame = CGRectMake(0, -SCOTT_INIT_HEIGHT-_insetsTop, CGRectGetWidth(scrollView.frame), SCOTT_INIT_HEIGHT);
    self.frame = frame;
    [scrollView addSubview:self];
    _scrollView = scrollView;
    _insetsTop = scrollView.contentInset.top;
    
    [self.layer addSublayer:self.circleLayer];
    [self addSubview:self.refreshImageView];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    CGFloat offSetY = _scrollView.contentOffset.y + _insetsTop;
    if (offSetY > 0) return;

    offSetY = ABS(offSetY);
    
    // 如果下拉的高度小于初始化高度，则圆圈不用变形
    if (offSetY < SCOTT_INIT_HEIGHT) {
        if (_state == ScottRefreshStateReday) {
            _state = ScottRefreshStateRefreshing;
            UIEdgeInsets insets = _scrollView.contentInset;
            insets.top = SCOTT_INIT_HEIGHT + _insetsTop;
            _scrollView.contentInset = insets;
            
            // 刷新代理
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshControllStartRefresh:)]) {
                [self.delegate refreshControllStartRefresh:self];
            }
        }
    }else{  // 下拉的高度大于初始化高度，该变圆圈
        self.height = offSetY;
        self.y = - offSetY;
        CGFloat scale = (offSetY - SCOTT_INIT_HEIGHT)/(SCOTT_REFRESH_HEIGHT - SCOTT_INIT_HEIGHT);
        [self makeWaterScaleWithScale:scale];
        [self scaleToShowRefresh:scale offset:offSetY];
    }
}

#pragma mark - end Refreshing
- (void)endRefreshing {
    if (_state == ScottRefreshStateRefreshing) {
        _state = ScottRefreshStateNomal;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopActivity];
            [self recoverySubViews];
        });
    }
}

#pragma mark - 复原所有的子控件
- (void)recoverySubViews {
    UIEdgeInsets insets = _scrollView.contentInset;
    insets.top = _insetsTop;
    
    [UIView animateWithDuration:SCOTT_HIDE_DURATION animations:^{
        self.successBtn.alpha = 1;
    } completion:^(BOOL finished) {
        /// 隐藏刷新成功信息并且显示刷新水滴
        [UIView animateWithDuration: SCOTT_HIDE_DURATION delay: SCOTT_HIDE_DURATION options: UIViewAnimationOptionCurveEaseIn animations: ^{
            _scrollView.contentInset = insets;
        } completion: ^(BOOL finished) {
            _refreshImageView.alpha = 1;
            _circleLayer.opacity = 1;
            _successBtn.alpha = 0;
        }];
    }];
}

#pragma mark - 制作水滴形变动画
- (void)makeWaterScaleWithScale:(CGFloat)scale {
    // 取0到1之间的数
    scale = MAX(0, MIN(1, scale));
    CGFloat bigCircleScale = 1 - scale * SCOTT_MIN_SCALE;
    CGFloat smallCircleScale = 1 - scale * SCOTT_MAX_SCALE;
    
    CGFloat bigWidth = _initWidth * bigCircleScale;
    CGFloat smallWidth = _initWidth * smallCircleScale;
    
    CGFloat topOffSet = (SCOTT_INIT_HEIGHT - self.refreshImageView.height) / 2.0;
    CGFloat smallCenterY = self.height - topOffSet - smallWidth / 2;
    
    // 两个圆的左右点
    CGPoint A = {_refreshImageView.centerX - bigWidth/2.0, _refreshImageView.centerY};
    CGPoint B = {_refreshImageView.centerX + bigWidth/2.0, _refreshImageView.centerY};
    
    CGPoint C = CGPointMake(_refreshImageView.centerX - smallWidth/2.0, smallCenterY);
    CGPoint D = CGPointMake(_refreshImageView.centerX + smallWidth/2.0, smallCenterY);
    
    // 贝塞尔控制点
    CGPoint E = {(C.x - A.x) * 0.85 + A.x , (C.y - A.y) * 0.4 + A.y};
    CGPoint F = {(B.x - D.x) * 0.15 + D.x , (D.y - B.y) * 0.4 + B.y};
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_refreshImageView.center radius:bigWidth/2.0 startAngle:kAngleToArc(180) endAngle:kAngleToArc(540) clockwise:YES];
    if (smallWidth < _initWidth * 0.95) {
        [path appendPath: [UIBezierPath bezierPathWithArcCenter: CGPointMake(_refreshImageView.centerX, smallCenterY) radius: smallWidth / 2 startAngle: kAngleToArc(0) endAngle: kAngleToArc(-180) clockwise: YES]];
        [path moveToPoint:A];
        [path addLineToPoint:B];
        [path addQuadCurveToPoint:D controlPoint:F];
        
        [path addLineToPoint:C];
        [path addQuadCurveToPoint:A controlPoint:E];
    }
    _circleLayer.path = path.CGPath;
}

- (void)scaleToShowRefresh:(CGFloat)scale offset:(CGFloat)offSet {
    scale = 1 - MAX(0, MIN(1, scale)) * SCOTT_MIN_SCALE;
    _refreshImageView.layer.transform = CATransform3DMakeScale(scale, scale, 1);
    if (offSet >= SCOTT_REFRESH_HEIGHT) {
        _state = ScottRefreshStateReday;
        [UIView animateWithDuration: 0.05 animations: ^{
            _refreshImageView.alpha = 0;
            _circleLayer.opacity = 0;
        } completion: ^(BOOL finished) {
            [self startActivity];
        }];
    }
}

#pragma mark - layz
- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        _initWidth = CGRectGetWidth(self.refreshImageView.frame) + 12;
        
        _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:_refreshImageView.center radius:_initWidth/2 startAngle:kAngleToArc(0) endAngle:kAngleToArc(360) clockwise:YES].CGPath;
        _circleLayer.fillColor = [UIColor lightGrayColor].CGColor;
        _circleLayer.shadowColor = [UIColor grayColor].CGColor;
        _circleLayer.shadowOpacity = 0.7;
        _circleLayer.shadowOffset = CGSizeMake(0, 2);
    }
    return _circleLayer;
}

- (UIImageView *)refreshImageView {
    if (!_refreshImageView) {
        _refreshImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ready_refresh_icon"]];
        _refreshImageView.center = CGPointMake(self.center.x, SCOTT_INIT_HEIGHT/2.);
    }
    return _refreshImageView;
}

#pragma mark - 停止刷新之后显示刷新成功
- (UIButton *)successBtn {
    if (!_successBtn) {
        _successBtn = [[UIButton alloc] initWithFrame: (CGRect){ 0, 0, self.width, SCOTT_INIT_HEIGHT }];
        [_successBtn setImage: [UIImage imageNamed: @"refresh_success"] forState: UIControlStateNormal];
        [_successBtn setTitle: @"  刷新成功" forState: UIControlStateNormal];
        [_successBtn setTitleColor: [UIColor colorWithRed: 77/255. green: 77/255. blue: 77/255. alpha: 1] forState: UIControlStateNormal];
        _successBtn.alpha = 0;
        [self addSubview: _successBtn];
    }
    return _successBtn;
}

#pragma mark - begin refreshing
- (void)startActivity {
    if (!_activityIndicatorView.isAnimating) {
        [_activityIndicatorView startAnimating];
    }
}

#pragma mark - stop refreshing
- (void)stopActivity {
    if (_activityIndicatorView.isAnimating) {
        [_activityIndicatorView stopAnimating];
    }
}

@end
