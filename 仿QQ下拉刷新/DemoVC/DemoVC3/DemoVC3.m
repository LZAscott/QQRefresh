//
//  DemoVC3.m
//  仿QQ下拉刷新
//
//  Created by Scott_Mr on 16/3/2.
//  Copyright © 2016年 Scott_Mr. All rights reserved.
//

#import "DemoVC3.h"
#import "TestTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

static NSString *cellIdentifier = @"reuseCellIdentifier";

@interface DemoVC3 ()

@property (nonatomic, assign) NSInteger  rowCount;
@property (nonatomic, strong) NSArray *textArr;

@end

@implementation DemoVC3

- (NSArray *)textArr {
    return _textArr ? : (_textArr = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                                      @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                                      @"当你的 app 没有提供 3x 的 LaunchImage 时",
                                      @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                                      @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下，"]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rowCount = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = indexPath.row % 5;
    
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleText = self.textArr[index];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = indexPath.row % 5;
    NSString *str = self.textArr[index];
    
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
    /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
    return [self.tableView cellHeightForIndexPath:indexPath model:str keyPath:@"titleText" cellClass:[TestTableViewCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
