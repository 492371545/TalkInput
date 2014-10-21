//
//  ViewController.m
//  TalkInput
//
//  Created by Mengying Xu on 14-10-21.
//  Copyright (c) 2014年 Crystal Xu. All rights reserved.
//

#import "ViewController.h"
#import "TalkInputView.h"

#define TalkHeight 60

@interface ViewController ()<TalkInputViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    CGFloat _talkViewOriginY;
    CGFloat _talkViewHeight;
    CGFloat _keyoardHeight;

    int _textNumberOfLines;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic,strong)TalkInputView *talkView;
@property (nonatomic,strong)NSMutableArray *arr;


@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _keyoardHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.bgScrollView.delegate = self;
    _talkViewHeight = TalkHeight;
    _talkViewOriginY = self.view.frame.size.height-_talkViewHeight;

    _textNumberOfLines = 1;
    
    _arr = [[NSMutableArray alloc] initWithObjects:@"sagvr",@"ghsrn",@"42523",@"hgkc",@"574365", @"rjdyrt",@"346zat",@"64w73sy",@"56eu8e567",@"yghyw46",nil];
    
	if(!_talkView)
    {
        _talkView = [[TalkInputView alloc] initWithFrame:CGRectMake(0, _talkViewOriginY, self.view.frame.size.width, _talkViewHeight)];
        _talkView.delelgate = self;
        [self.bgScrollView addSubview:_talkView];
    }
    
    self.bgScrollView.backgroundColor = [UIColor blueColor];
    self.bgScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, self.bgScrollView.frame.size.width, self.bgScrollView.frame.size.height-_talkViewHeight);

}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyboardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHei = keyboardFrame.size.height;
    CGFloat keyboardOriginY = keyboardFrame.origin.y;
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    NSDictionary *userInfo = [aNotification userInfo];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

    if(keyboardOriginY < self.talkView.frame.size.height+self.talkView.frame.origin.y)
    {
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
//                             _talkViewOriginY = self.view.frame.size.height-keyboardOriginY-_talkViewHeight;
                             _keyoardHeight = keyboardHei;
                             [self scrollTalkView:keyboardHei];

                         }
                         completion:nil];
    }

}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    CGRect keyboardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHei = keyboardFrame.size.height;
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    NSDictionary *userInfo = [aNotification userInfo];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
//                         _talkViewOriginY = self.view.frame.size.height-keyboardOriginY-_talkViewHeight;
                         _keyoardHeight = keyboardHei;
                         [self scrollTalkView:keyboardHei];

                     }
                     completion:nil];
    
}

- (void)scrollTalkView:(CGFloat)height
{
    [self.bgScrollView setContentOffset:CGPointMake(0, height)];
}

- (void)adjustInputView
{
    CGRect inputFrame = self.talkView.infoInput.frame;
    inputFrame.size.height = _talkViewHeight;
    self.talkView.infoInput.frame = inputFrame;
    
    CGRect bottomViewFrame = self.talkView.frame;
    bottomViewFrame.size.height = _talkViewHeight+10;
    bottomViewFrame.origin.y = _talkViewOriginY;
    self.talkView.frame = bottomViewFrame;
    
    CGRect btnFrame = self.talkView.sendBtn.frame;
    btnFrame.origin.y = _talkViewHeight+10-55;
    self.talkView.sendBtn.frame = btnFrame;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollToBottom
{
    CGFloat keyboardHeight = self.tableView.contentInset.bottom;
    //可显示区域高度
    CGFloat visibHeight = self.tableView.frame.size.height - keyboardHeight;
    //内容高度
    CGFloat contentHeight = self.tableView.contentSize.height;
    
    NSLog(@"%f,%f,%f",keyboardHeight,visibHeight,contentHeight);
    
    if (contentHeight > visibHeight)
    {
        [self.tableView setContentOffset:CGPointMake(0, contentHeight-visibHeight) animated:YES];
    }
}
#pragma mark - TalkInputViewDelegate
- (void)sendInfoBtnAction:(UIButton *)btn
{
    [self.arr addObject:self.talkView.infoInput.text];
    [self scrollTalkView:0];
    self.talkView.infoInput.text = @"";
    _talkViewHeight = 50;
    _talkViewOriginY = self.view.frame.size.height-_talkViewHeight-10;
    [self adjustInputView];
    [self.tableView reloadData];
    [self scrollToBottom];
}
- (void)inputChange:(UITextView *)textView
{
    CGFloat lineHeight = textView.font.lineHeight;
    int numLines = textView.contentSize.height/lineHeight;
    
    _textNumberOfLines = numLines;
    
    if(textView.contentSize.height > 50 && (textView.contentSize.height+10+_keyoardHeight)<= self.view.frame.size.height)
    {
        _talkViewHeight = textView.contentSize.height;
        _talkViewOriginY = self.view.frame.size.height-_talkViewHeight-10;
        
        NSLog(@"");
        [self adjustInputView];

    }
    else
    {
        
    }
    
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_arr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"revfv"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"revfv"];
    }
    cell.textLabel.text = [_arr objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
