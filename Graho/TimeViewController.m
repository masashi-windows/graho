//
//  TimeViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/14.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

// 現在時刻
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// 出勤・休憩・退勤・勤務時間
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (retain, nonatomic) IBOutlet UITextField *resetTextField;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;

// ボタン
@property (weak, nonatomic) IBOutlet UIButton *wStartButton;
@property (weak, nonatomic) IBOutlet UIButton *wFinishButton;

// 休憩時間ピッカー
@property (nonatomic, retain)   UIPickerView *pickerView;
@property (nonatomic, retain)   UIView *backView;
@property (nonatomic, strong)   NSArray *items;

// 休憩時間ピッカーの分表示
@property (strong, nonatomic) NSMutableArray *minutesArray;

@end

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // 現在時刻を１秒ごとに表示
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(workTimer)
                                   userInfo:nil
                                    repeats:YES];
    // 現在時刻の更新へ
    [self workTimer];
    
    
    
    // ボタンのデザイン
    // self.wStartButton.backgroundColor = [UIColor lightGrayColor];
    self.wStartButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.wStartButton.layer.borderWidth = 1.0f;
    self.wStartButton.layer.cornerRadius = 7.5f;

    self.wFinishButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.wFinishButton.layer.borderWidth = 1.0f;
    self.wFinishButton.layer.cornerRadius = 7.5f;
    
    // 休憩時間テキストフィールドのデザイン
    self.resetTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.resetTextField.textColor = [UIColor blueColor];
    self.resetTextField.placeholder = @"未選択";
    self.resetTextField.delegate = self;
    
    
    
    // 休憩時間ピッカーの生成
    _pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    // テキストフィールドの選択時にピッカー表示
    self.resetTextField.inputView = self.pickerView;
    
    // 休憩時間ピッカーのツールバー（閉じるボタン）生成
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    [toolBar sizeToFit];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                    target:nil
                                                    action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(donePushed)];
    
    NSArray *items = [NSArray arrayWithObjects:spacer, done, nil];
    [toolBar setItems:items animated:YES];
    
    // テキストフィールドの選択時にツールバー表示
    self.resetTextField.inputAccessoryView = toolBar;
    
    
    // 一枚の黒いUIViewを加えて、ピッカーをモーダル表示のようにする
    _backView = [[UIView alloc] initWithFrame:self.view.frame];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.2;
    self.backView.hidden = YES;
    self.backView.userInteractionEnabled = NO;
    [self.view addSubview:self.backView];
    
    // 休憩時間ピッカーの２列目（NSNumberに変換して配列に格納）
    self.minutesArray = [NSMutableArray array];
    NSInteger i;
    for (i=0; i<60; i +=5) {
        [self.minutesArray addObject:[NSNumber numberWithInteger:i]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 現在時刻の表示処理

/**
 *  現在時刻の更新
 */
- (void)workTimer
{
    NSDate *now = [NSDate date];
    NSDateFormatter *nowformat = [[NSDateFormatter alloc] init];
    [nowformat setDateFormat:@"HH:mm:ss"];
    [nowformat setTimeZone:[NSTimeZone defaultTimeZone]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [nowformat stringFromDate:now]];
}

#pragma mark - 出勤・退勤ボタンの処理

/**
 *  出勤ボタン処理
 *
 *  @param sender <#sender description#>
 */
- (IBAction)wStartButton:(id)sender {
    // アラートを作る
    UIAlertView *wStartAlert = [[UIAlertView alloc]initWithTitle:@"確認"
                                                   message:@"出勤しますか？"
                                                  delegate:self
                                         cancelButtonTitle:@"キャンセル"
                                         otherButtonTitles:@"OK", nil];
    
    //アラートを表示する
    [wStartAlert show];
}


/**
 *  退勤ボタン処理
 *
 *  @param sender <#sender description#>
 */
- (IBAction)wFinishButton:(id)sender {
    // アラートを作る
    UIAlertView *wFinishAlert = [[UIAlertView alloc]initWithTitle:@"確認"
                                                   message:@"退勤しますか？"
                                                  delegate:self
                                         cancelButtonTitle:@"キャンセル"
                                         otherButtonTitles:@"OK", nil];
    
    //アラートを表示する
    [wFinishAlert show];
}


#pragma mark - 休憩時間ピッカーの処理

/**
 *  ピッカーを閉じる
 */
- (void)donePushed
{
    self.backView.hidden = YES;
    [self.resetTextField resignFirstResponder];
}

/**
 *  テキストフィールドの編集表示
 *
 *  @param textField 休憩時間テキストフィールド
 *
 *  @return キーボードの表示（YES）
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.backView.hidden = NO;
    
    return YES;
}


#pragma mark - UIPikerViewDelegate

/**
 *  ピッカーに表示する列数を返す。(必須)
 *
 *  @param pickerView 休憩時間ピッカー
 *
 *  @return 表示する列数
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


/**
 *  ピッカーに表示する行数を返す。(必須)
 *
 *  @param pickerView 休憩時間ピッカー
 *  @param component  列数
 *
 *  @return 表示する行数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0: return 5;
        case 1: return [self.minutesArray count];
    }
    return 0;
}


/**
 *  行のサイズを指定する。
 *
 *  @param pickerView 休憩時間ピッカー
 *  @param component  列数
 *
 *  @return <#return value description#>
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 100.0;
            break;
        case 1: // 2列目
            return 100.0;
            break;
        default:
            return 0;
            break;
    }
}


/**
 *  ピッカーに表示する値を返す。
 *
 *  @param pickerView 休憩時間ピッカー
 *  @param row        行数
 *  @param component  列数
 *
 *  @return 表示する値
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    switch (component) {
        case 0: // 1列目
            return [NSString stringWithFormat:@"%ld時間",(long)row];
            break;
        case 1: // 2列目
            return [NSString stringWithFormat:@"%d分", [[self.minutesArray objectAtIndex:row] intValue]];
            break;
        default:
            return 0;
            break;
    }
}


/**
 *  ピッカーで選択時した値を表示する処理
 *
 *  @param pickerView 休憩時間ピッカー
 *  @param row        行数
 *  @param component  列数
 */
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 選択されている時間の行を取得
    int rowOfHour  = (int)[pickerView selectedRowInComponent:0];
    int rowOfMinutes = (int)[pickerView selectedRowInComponent:1];
    
    self.resetTextField.text = [NSString stringWithFormat:@"%d時間%d分",rowOfHour, [[self.minutesArray objectAtIndex:rowOfMinutes] intValue]];
}
@end
