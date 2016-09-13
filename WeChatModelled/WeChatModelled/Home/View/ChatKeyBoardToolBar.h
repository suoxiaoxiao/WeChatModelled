//
//  ChatKeyBoardToolBar.h
//  SHChatUI
//
//  Created by 索晓晓 on 16/8/22.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatKeyBoardToolBar;

@protocol ChatKeyBoardToolBarDelegate <NSObject>

@required
/**点击更多*/
- (void)keyBoardToolClickMore;
/**点击表情*/
- (void)keyBoardToolClickFace;
/**点击声音*/
- (void)keyBoardToolClickSound;
/**点击键盘*/
- (void)keyBoardToolClickKeyboard;
/**长按录制声音*/
- (void)keyBoardToolLongProgress:(UIGestureRecognizer *)ges;
@end




@interface ChatKeyBoardToolBar : UIView

- (void)resignResponder;
- (void)becomeResponder;

@property (nonatomic , weak)id <ChatKeyBoardToolBarDelegate , UITextViewDelegate> delegate;

@end
