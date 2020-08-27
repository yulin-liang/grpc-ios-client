//
//  YLRootViewController.m
//  grpc-ios-client
//
//  Created by 梁煜麟 on 5/15/20.
//  Copyright © 2020 Yulin Liang. All rights reserved.
//

#import "YLRootViewController.h"
#import "YLUnaryCallViewController.h"
#import "YLClientStreamingCallViewController.h"
#import "YLCallsWithURLSessionViewController.h"

const NSString * kCellIdentifier = @"kCellIdentifier";

@interface YLRootViewController() <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) NSArray *dataSource;
@property(nonatomic) UITableView *contentTableView;

@end

@implementation YLRootViewController

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSArray arrayWithObjects:@"Unary Call", @"Client Streaming Call", @"Calls with NSURLSession", nil];
    }
    return self;
}

- (void)viewDidLoad {
    _contentTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    [self.view addSubview:_contentTableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    NSString *label = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = label;
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            YLUnaryCallViewController *unaryVC = [[YLUnaryCallViewController alloc] init];
            [self.navigationController pushViewController:unaryVC animated:YES];
            break;
        }
        case 1: {
            YLClientStreamingCallViewController *clientStreamingVC = [[YLClientStreamingCallViewController alloc] init];
            [self.navigationController pushViewController:clientStreamingVC animated:YES];
            break;
        }
        case 2: {
            YLCallsWithURLSessionViewController *callVC = [[YLCallsWithURLSessionViewController alloc] init];
            [self.navigationController pushViewController:callVC animated:YES];
        }
        default:
            break;
    }
}

@end
