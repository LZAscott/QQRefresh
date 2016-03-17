//
//  ViewController.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/1/21.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "ViewController.h"
#import "ScottRefreshControll.h"
#import "UIView+Extension.h"
#import "ViewControllerCell.h"


NSString * const demo0Content = @"自动布局动画，修改一个view的布局约束，其他view也会自动重新排布";
NSString * const demo1Content = @"布局示例，其中view1用到了普通view的内容自适应功能，view1内部的label用到了文字自适应功能";
NSString * const demo2Content = @"1.设置水平方向的3个等宽子view\n2.设置一个宽高都为50的位于父view中间的view";
NSString * const demo3Content = @"简单tableview展示";
NSString * const demo4Content = @"1.利用普通view的内容自适应功能添加tableheaderview\n2.利用自动布局功能实现cell内部图文排布，图片可根据原始尺寸按比例缩放后展示\n3.利用“普通版tableview的cell高度自适应”完成tableview的排布";
NSString * const demo5Content = @"展示scrollview的内容自适应和普通view的动态圆角处理";
NSString * const demo6Content = @"利用“普通版tableview的《多cell》高度自适应”2步设置完成tableview的排布";
NSString * const demo7Content = @"利用“升级版tableview的《多cell》高度自适应”1步完成tableview的排布。\n注意：升级版方法适用于cell的model有多个的情况下,性能比普通版稍微差一些,不建议在数据量大的tableview中使用（cell数量尽量少于100个）,如果有大量的cell或者cell界面复杂渲染耗费性能较大则推荐使用普通方法简化版“cellHeightForIndexPath:model:keyPath:cellClass:contentViewWidth:”方法同样是一步设置即可完成";
NSString * const demo8Content = @"利用SDAutoLayout仿制微信朋友圈。高仿微信计划：\n1.高仿朋友圈 \n2.完善细节 \n3.高仿完整微信app \nPS：代码会持续在我的github更新";
NSString * const demo9Content = @"仿微信的聊天界面：\n1.纯文本消息（带可点击链接，表情）\n2.图片消息";

NSString * const demo10Content = @"1.设置水平方向的3个等宽子view\n2.设置一个宽高都为50的位于父view中间的view";
NSString * const demo11Content = @"自动布局动画，修改一个view的布局约束，其他view也会自动重新排布";
NSString * const demo12Content = @"仿微信的聊天界面：\n1.纯文本消息（带可点击链接，表情）\n2.图片消息";
NSString * const demo13Content = @"自动布局动画，修改一个view的布局约束，其他view也会自动重新排布";

static NSString * const reuserIdentifier = @"DIYCellID";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,ScottRefreshControllDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ScottRefreshControll *refreshControll;
@property (nonatomic, strong) ViewControllerCell *cell;
@property (nonatomic, strong) NSArray *tbData;

@property (nonatomic, assign) BOOL    isAnimation;
@property (nonatomic, assign) CGFloat    lastContentOffY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tbData = @[demo0Content,demo1Content, demo2Content, demo3Content,demo4Content,demo5Content,demo6Content,demo7Content,demo8Content,demo9Content,demo10Content,demo11Content,demo12Content,demo13Content];

    self.tableView.tableFooterView = [UIView new];
    self.cell = [self.tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    self.cell.contentLabel.preferredMaxLayoutWidth  = self.cell.titleLabel.preferredMaxLayoutWidth = self.cell.width - 20;
    
    self.lastContentOffY = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.refreshControll.delegate = self;
}

#pragma mark - 懒加载
- (ScottRefreshControll *)refreshControll {
    return _refreshControll ? : (_refreshControll = [ScottRefreshControll refreshControllWithScrollView:self.tableView]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tbData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    cell.titleLabel.text = [NSString stringWithFormat:@"Demo--%ld",indexPath.row];
    cell.contentLabel.text = self.tbData[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewControllerCell *cell = (ViewControllerCell *)self.cell;
    cell.contentLabel.text = [self.tbData objectAtIndex:indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"Demo--%ld",indexPath.row];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return MAX(44, 1 + size.height + 4);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row > 6 && self.isAnimation) {
        [self startAnimationWithView:cell OffsetY:80 andDuration:1.0];
    }
}

- (void)startAnimationWithView:(UIView *)view OffsetY:(CGFloat)offY andDuration:(NSTimeInterval)time {

    view.transform = CGAffineTransformMakeTranslation(0, offY);
    [UIView animateWithDuration:time animations:^{
        view.transform = CGAffineTransformIdentity;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *demoClassString = [NSString stringWithFormat:@"DemoVC%ld", indexPath.row];
    UIViewController *vc = [NSClassFromString(demoClassString) new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = demoClassString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= scrollView.contentSize.height) {
        self.isAnimation = self.lastContentOffY < scrollView.contentOffset.y;
        self.lastContentOffY = scrollView.contentOffset.y;
    }
}

#pragma mark - ScottRefreshControllDelegate
- (void)refreshControllStartRefresh:(ScottRefreshControll *)refreshControll {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControll endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
