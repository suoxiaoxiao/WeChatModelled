//
//  MoreKeyBoard.m
//  SHChatUI
//
//  Created by 索晓晓 on 16/8/23.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "MoreKeyBoard.h"
#import "CustomMoreModule.h"

@interface MoreKeyBoard ()

@end

@implementation MoreKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MorePlist" ofType:@"plist"]];
    
    for (NSDictionary *obj in dataArray) {
        
        CustomMoreModule *sub = [[CustomMoreModule alloc] init];
        
        [self addSubview:sub];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
