//
//  ViewController.m
//  Empty
//
//  Created by Charlesyx on 2017/4/19.
//  Copyright © 2017年 cy. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+CYEmptySet.h"
#import "CYEmptyPageView.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray <NSString *> *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.titles = [NSMutableArray new];
    
    CYEmptyPageView *empty = [[NSBundle mainBundle] loadNibNamed:@"CYEmptyPageView" owner:nil options:nil].firstObject;
    empty.title = @"暂时没有信息~";
    empty.btnTitle = @"重新加载";
    empty.imagename = @"cy_empty_no_msg";
    empty.handle = ^(CYEmptyPageView *emptyPageView) {
        [self add];
    };
    self.tableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    self.tableView.emptyEnabled = YES;
    self.tableView.customEmptyView = empty;
    
    [self add];
}

- (void)remove {
    [self.titles removeAllObjects];
    [self.tableView reloadData];
}

- (void)add {
    [self.titles removeAllObjects];
    [self.titles addObjectsFromArray:@[@"点击移除所有数据",@"这是一列数据", @"这是一列数据", @"这是一列数据",
                                       @"这是一列数据", @"这是一列数据", @"这是一列数据", @"这是一列数据",
                                       @"这是一列数据", @"这是一列数据", @"这是一列数据", @"这是一列数据",
                                       @"这是一列数据", @"这是一列数据", @"这是一列数据", @"这是一列数据"]];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self remove];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

@end
