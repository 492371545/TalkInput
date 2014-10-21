//
//  TalkInputView.h
//  TalkInput
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TalkInputViewDelegate <NSObject>

- (void)inputChange:(UITextView*)textView;
- (void)sendInfoBtnAction:(UIButton *)btn;

@end

@interface TalkInputView : UIView
@property (nonatomic,strong)UITextView *infoInput;
@property (nonatomic,strong)UIButton *sendBtn;

@property (nonatomic,assign)id<TalkInputViewDelegate>delelgate;

@end
