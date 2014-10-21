//
//  TalkInputView.m
//  TalkInput
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import "TalkInputView.h"
@interface TalkInputView()<UITextViewDelegate>


@end
@implementation TalkInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.infoInput];
        [self addSubview:self.sendBtn];
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (UITextView*)infoInput
{
    if(!_infoInput)
    {
        _infoInput = [[UITextView alloc] init];
        
        _infoInput.frame = CGRectMake(5, 5, 225, self.frame.size.height-10);
        
        _infoInput.backgroundColor = [UIColor whiteColor];
        _infoInput.font = [UIFont systemFontOfSize:15];
        _infoInput.delegate = self;
    }
    
    return _infoInput;
}

- (UIButton*)sendBtn
{
    if(!_sendBtn)
    {
        _sendBtn = [[UIButton alloc] init];
        
        _sendBtn.frame = CGRectMake(self.infoInput.frame.size.width+self.infoInput.frame.origin.x+5, self.frame.size.height-5-50, 80, 50);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        
        _sendBtn.backgroundColor = [UIColor orangeColor];
        
        [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendBtn;
}

- (void)sendBtnAction:(UIButton *)btn
{
    [self.infoInput resignFirstResponder];
    if(_delelgate && [_delelgate respondsToSelector:@selector(sendInfoBtnAction:)])
    {
        [_delelgate sendInfoBtnAction:btn];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        NSString *trimStr = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        if (trimStr.length)
        {
            
        }
        self.infoInput.text = @"";
        [self textViewDidChange:self.infoInput];
        
        return NO;
    }
    else
    {

        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{

    if(_delelgate && [_delelgate respondsToSelector:@selector(inputChange:)])
    {
        [_delelgate inputChange:textView];
    }
    
    
}


@end
