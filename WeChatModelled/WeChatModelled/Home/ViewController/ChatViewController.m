//
//  ChatViewController.m
//  SHChatUI
//
//  Created by 索晓晓 on 16/8/22.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatKeyBoardToolBar.h"
#import "MoreKeyBoard.h"

#define CustomHeight (200)
#define ToolBarHeight (49)

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

static NSString *const ChatTableViewCellID = @"ChatTableViewCellID";

@interface ChatViewController ()
<UITableViewDelegate,UITableViewDataSource,ChatKeyBoardToolBarDelegate,UITextViewDelegate>
{
    CGRect   _OldToolF;        //toolBar 最开始的位置
    BOOL     _isToolBarHidden; //toolBar 是否需要隐藏
    MoreKeyBoard * _customKeyBoard;  //更多键盘
    UIView * _faceKeyBoard;    //表情键盘
}
@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)ChatKeyBoardToolBar *toolBar;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTableView];
    [self createToolBar];
    
    
    
    _isToolBarHidden = YES;
    _OldToolF = self.toolBar.frame;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handerKeyBoardChangeValue:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewTap)]];
    
}

- (void)handleViewTap
{
    //隐藏键盘
    [self.toolBar resignResponder];
    //隐藏自定义栏
    [self hideCustomKeyBoard];
    //tooBar 需要隐藏
    _isToolBarHidden = YES;
    //复原toolBar 位置
    [self toolFrameAnimationWith:0];
}

- (void)handerKeyBoardChangeValue:(NSNotification *)not
{
    NSLog(@"%@",not.userInfo);
    
    CGRect rect = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (_isToolBarHidden) [self toolFrameAnimationWith:rect.origin.y - HEIGHT];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH,HEIGHT - 64 - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)createToolBar
{
    self.toolBar = [[ChatKeyBoardToolBar alloc] initWithFrame:CGRectMake(0, HEIGHT - ToolBarHeight, WIDTH, ToolBarHeight)];
    
    self.toolBar.backgroundColor = [UIColor lightGrayColor];
    
    self.toolBar.delegate = self;
    
    [self.view addSubview:self.toolBar];
    
    
    _customKeyBoard = [[MoreKeyBoard alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, CustomHeight)];
    _customKeyBoard.backgroundColor = [UIColor redColor];
    _customKeyBoard.hidden = YES;
    [self.view addSubview:_customKeyBoard];
    
}

- (void)showCustomKeyBoard
{
    _customKeyBoard.hidden = NO;
    _customKeyBoard.frame = CGRectMake(0, HEIGHT, WIDTH, CustomHeight);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBar.frame = CGRectMake(0, HEIGHT - ToolBarHeight - CustomHeight, WIDTH, ToolBarHeight);
        _customKeyBoard.frame = CGRectMake(0, HEIGHT - CustomHeight, WIDTH, CustomHeight);
        
    }];
}
//toolBar 跟随消失
- (void)hideCustomKeyBoard
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.toolBar.frame = CGRectMake(0, HEIGHT - ToolBarHeight, WIDTH, ToolBarHeight);
        _customKeyBoard.frame = CGRectMake(0, HEIGHT, WIDTH, CustomHeight);
        
    } completion:^(BOOL finished) {
        
        _customKeyBoard.hidden = YES;
    }];
}

//toolBar 单独消失
- (void)hideSilgeCustomKeyBoard
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _customKeyBoard.frame = CGRectMake(0, HEIGHT, WIDTH, CustomHeight);
        
    } completion:^(BOOL finished) {
        
        _customKeyBoard.hidden = YES;
    }];
}




#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatTableViewCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatTableViewCellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor redColor];
    }
    
    return cell;
    
}


#pragma mark - KeyBoardToolDelegate
/**点击更多*/
- (void)keyBoardToolClickMore
{
    
    _isToolBarHidden = NO;
    [self.toolBar resignResponder];
    //弹出
    [self showCustomKeyBoard];
}
/**点击表情*/
- (void)keyBoardToolClickFace
{
    _isToolBarHidden = NO;
    [self.toolBar resignResponder];
    //弹出
    [self showCustomKeyBoard];
}
/**点击声音*/
- (void)keyBoardToolClickSound
{
    _isToolBarHidden = YES;
    [self.toolBar resignResponder];
    [self hideCustomKeyBoard];
}
/**点击键盘*/
- (void)keyBoardToolClickKeyboard
{
    _isToolBarHidden = YES;
    [self.toolBar becomeResponder];
    [self hideSilgeCustomKeyBoard];
}
/**长按录制声音*/
- (void)keyBoardToolLongProgress:(UIGestureRecognizer *)ges
{
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _isToolBarHidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideSilgeCustomKeyBoard];
    });
    
    return YES;
}

- (void)toolFrameAnimationWith:(CGFloat)value
{
    CGRect newF = _OldToolF;
    newF.origin.y += value;
    [UIView animateWithDuration:0.26 animations:^{
        self.toolBar.frame = newF;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
