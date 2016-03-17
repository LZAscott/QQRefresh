//
//  DIYTableViewController.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/1/21.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DIYTableViewController.h"
#import "ScottRefreshControll.h"
#import "DIYTableViewCell.h"

static NSString * const iden = @"ReuseCell";

@interface DIYTableViewController ()<ScottRefreshControllDelegate>

@property (nonatomic, strong) ScottRefreshControll *refreshCtrl;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation DIYTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 20; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
            [_dataArr addObject:image];
        }
    }
    return _dataArr;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.refreshCtrl.delegate = self;
}

- (ScottRefreshControll *)refreshCtrl {
    return _refreshCtrl ? : (_refreshCtrl = [ScottRefreshControll refreshControllWithScrollView:self.tableView]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DIYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DIYTableViewCell *diyCell = (DIYTableViewCell *)cell;
    
    [diyCell setImg:self.dataArr[indexPath.row]];
    
    [diyCell cellOffset];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // visibleCells 获取界面上能显示出来了cell
    NSArray<DIYTableViewCell *> *array = [self.tableView visibleCells];
    
    //enumerateObjectsUsingBlock 类似于for，但是比for更快
    [array enumerateObjectsUsingBlock:^(DIYTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cellOffset];
    }];
}


#pragma mark - ScottRefreshControllDelegate
- (void)refreshControllStartRefresh:(ScottRefreshControll *)refreshControll {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControll endRefreshing];
    });
}


@end
