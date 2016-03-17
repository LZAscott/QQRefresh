//
//  DemoVC4.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DemoVC4.h"
#import "SDCycleScrollView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "DemoVC4TableViewCell.h"
#import "DemoVC4Model.h"

static NSString *reuseCellIdentifier = @"demo4_cellIden";

@interface DemoVC4 ()

@property (nonatomic, strong) NSMutableArray *modelsArr;

@end

@implementation DemoVC4

- (NSMutableArray *)modelsArr {
    return _modelsArr ? : (_modelsArr = [NSMutableArray new]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableViewHeader];
    [self createModelsWithCount:10];
}

- (void)setupTableViewHeader {
    UIView *headerView = [UIView new];
    
    NSArray *localPicArr = @[@"pic1.jpg",@"pic2.jpg",@"pic3.jpg",@"pic4.jpg"];
    
    SDCycleScrollView *scrollView = [SDCycleScrollView new];
    scrollView.localizationImageNamesGroup = localPicArr;
    [headerView addSubview:scrollView];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [headerView addSubview:bottomLine];
    
    
    scrollView.sd_layout.leftSpaceToView(headerView,0).topSpaceToView(headerView,0).rightSpaceToView(headerView,0).heightIs(150);
    bottomLine.sd_layout.leftSpaceToView(headerView,0).topSpaceToView(scrollView,0).rightSpaceToView(headerView,0).heightIs(1);
    
    [headerView setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
    [headerView layoutSubviews];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)createModelsWithCount:(int)count {
    NSArray *iconImagesNameArr = @[@"icon0.jpg",
                                   @"icon1.jpg",
                                   @"icon2.jpg",
                                   @"icon3.jpg",
                                   @"icon4.jpg",];
    
    NSArray *namesArray = @[@"Scott_iOS",
                            @"测试网名",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     ];
    
    for (int i=0; i<count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int textRandomIndex = arc4random_uniform(5);
        int picRandomIndex = arc4random_uniform(5);
        
        DemoVC4Model *model = [DemoVC4Model new];
        model.iconName = iconImagesNameArr[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.content = textArray[textRandomIndex];
        
        // 模拟“有或者无图片”
        int random = arc4random_uniform(100);
        if (random <= 80) {
            model.picName = picImageNamesArray[picRandomIndex];
        }
        
        [self.modelsArr addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoVC4TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    
    if (!cell) {
        cell = [[DemoVC4TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellIdentifier];
    }
    cell.model = self.modelsArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView cellHeightForIndexPath:indexPath model:self.modelsArr[indexPath.row] keyPath:@"model" cellClass:[DemoVC4TableViewCell class] contentViewWidth:self.view.width];
}

@end
