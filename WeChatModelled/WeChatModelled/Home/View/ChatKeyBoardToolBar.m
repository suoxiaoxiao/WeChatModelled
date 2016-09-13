//
//  ChatKeyBoardToolBar.m
//  SHChatUI
//
//  Created by 索晓晓 on 16/8/22.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "ChatKeyBoardToolBar.h"
#import <Masonry.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface ChatKeyBoardToolBar ()

@property (nonatomic ,strong)UIButton *soundBtn;//声音按钮
@property (nonatomic ,strong)UITextView *contentView;//内容
@property (nonatomic ,strong)UIView *soundContent;//录制声音
@property (nonatomic ,strong)UILabel *transcribeLabel;//录制文案
@property (nonatomic ,strong)UIButton *faceBtn;//表情
@property (nonatomic ,strong)UIButton *addBtn;//其他

@end

@implementation ChatKeyBoardToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        
        [self setUpUI];
        
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    //sound
    self.soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.soundBtn setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
    [self.soundBtn setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
//    [self.soundBtn setImage:[UIImage new] forState:UIControlStateSelected];
    [self.soundBtn addTarget:self action:@selector(handerSoundClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.soundBtn];
    
    //input
    self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self addSubview:self.contentView];
    
    
    self.soundContent = [[UIView alloc] init];
    self.soundContent.hidden = !self.contentView.hidden;
    self.soundContent.layer.cornerRadius = 5;
    self.soundContent.layer.borderWidth = 0.5;
    self.soundContent.layer.borderColor = [UIColor grayColor].CGColor;
    self.soundContent.backgroundColor = [UIColor lightGrayColor];
    
    //拖动手势
//    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handerPanGes:)];
//    [self.soundContent addGestureRecognizer:panGes];
    
//    //点击手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    longPress.minimumPressDuration = 0.1;
    
    [self.soundContent addGestureRecognizer:longPress];
    
    
    [self addSubview:self.soundContent];
    
    self.transcribeLabel = [[UILabel alloc] init];
    [self.transcribeLabel setTextAlignment:NSTextAlignmentCenter];
    self.transcribeLabel.textColor = [UIColor blackColor];
    self.transcribeLabel.font = [UIFont systemFontOfSize:14];
    self.transcribeLabel.text = @"按住说话";
    [self.soundContent addSubview:self.transcribeLabel];
    
    //face
    self.faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.faceBtn setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
    [self.faceBtn addTarget:self action:@selector(handleFaceClick) forControlEvents:UIControlEventTouchUpInside];
    [self.faceBtn setContentMode:UIViewContentModeCenter];
    [self addSubview:self.faceBtn];
    
    //add
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(handleAddClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    
    
}

- (void)setDelegate:(id<ChatKeyBoardToolBarDelegate,UITextViewDelegate>)delegate
{
    self.contentView.delegate  = delegate;
    _delegate = delegate;
}

- (void)handerSoundClick:(UIButton *)sender
{
    
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) { //声音
        self.contentView.hidden = YES;
        
        [self.delegate keyBoardToolClickSound];
        
    }else{// 键盘
        self.contentView.hidden = NO;
        
        [self.delegate keyBoardToolClickKeyboard];
        
    }
    self.soundContent.hidden = !self.contentView.hidden;
    
}

- (void)handleTapAction:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: //开始
//            NSLog(@"点击手势开始");
            self.transcribeLabel.text = @"松开结束";
            self.soundContent.backgroundColor = [UIColor grayColor];
            break;
        case UIGestureRecognizerStateChanged: //改变
//             NSLog(@"点击手势改变");
            self.transcribeLabel.text = @"松开结束";
            self.soundContent.backgroundColor = [UIColor grayColor];
            
            break;
        case UIGestureRecognizerStateEnded: //结束
//             NSLog(@"点击手势结束");
            self.transcribeLabel.text = @"按住说话";
            self.soundContent.backgroundColor = [UIColor lightGrayColor];
            
            break;
        default: //失败
            
            break;
    }
    
    //调用代理
    [self.delegate keyBoardToolLongProgress:longPress];
}

- (void)handleFaceClick //点击表情
{
    
    self.soundBtn.selected = NO;//让变成键盘
    self.contentView.hidden = NO;
    self.soundContent.hidden = YES;
    
    [self.delegate keyBoardToolClickFace];
}

- (void)handleAddClick //点击添加
{
    [self.delegate keyBoardToolClickMore];
}

- (void)resignResponder
{
    [self.contentView resignFirstResponder];
}
- (void)becomeResponder
{
    [self.contentView becomeFirstResponder];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat height = self.frame.size.height;
    
    self.soundBtn.frame = CGRectMake(5, (height - 40)/2, 40, 40);
    
    self.soundContent.frame = CGRectMake(CGRectGetMaxX(self.soundBtn.frame) + 5, 5, WIDTH - 120 - 25, height - 10);
    
    self.contentView.frame = CGRectMake(CGRectGetMaxX(self.soundBtn.frame) + 5, 5, WIDTH - 120 - 25, height - 10);
    
    self.transcribeLabel.frame = self.soundContent.bounds;
    
    self.faceBtn.frame = CGRectMake(CGRectGetMaxX(self.soundContent.frame) + 5, (height - 40)/2, 40, 40);
    
    self.addBtn.frame = CGRectMake(CGRectGetMaxX(self.faceBtn.frame) + 5, (height - 40)/2, 40, 40);
}

@end
