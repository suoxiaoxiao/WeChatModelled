//
//  ViewController.m
//  SHChatUI
//
//  Created by 索晓晓 on 16/8/22.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"开始" forState:0];
    [btn addTarget:self action:@selector(handleJumpChatVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(84);//Y
        make.size.mas_equalTo(CGSizeMake(120, 40)); //W H
        make.left.equalTo(self.view).with.offset((self.view.frame.size.width - 240)/3); //X
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)handleJumpChatVC
{
    [self.navigationController pushViewController:[[ChatViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
