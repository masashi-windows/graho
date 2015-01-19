//
//  TimeViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/14.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

#pragma mark - 現在時刻ラベル宣言
// 現在時刻
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

#pragma mark - 時間のテキストフィールド・ラベル宣言
// 出勤・休憩・退勤・勤務時間
@property (retain, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (retain, nonatomic) IBOutlet UITextField *resetTimeTextField;
@property (retain, nonatomic) IBOutlet UITextField *finishTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;


#pragma mark - ピッカー宣言
// 出勤時間ピッカー
@property (nonatomic, retain)   UIPickerView *startPickerView;
@property (nonatomic, retain)   UIView *startBackView;
@property (nonatomic, strong)   NSArray *startItems;

// 休憩時間ピッカー
@property (nonatomic, retain)   UIPickerView *resetPickerView;
@property (nonatomic, retain)   UIView *resetBackView;
@property (nonatomic, strong)   NSArray *resetItems;

// 休憩時間の分表示（５分区切り）
@property (nonatomic, strong)   NSMutableArray *resetMinuteArray;

// 退勤時間ピッカー
@property (nonatomic, retain)   UIPickerView *finishPickerView;
@property (nonatomic, retain)   UIView *finishBackView;
@property (nonatomic, strong)   NSArray *finishItems;

#pragma mark - 出勤・退勤ボタン宣言
// ボタン
@property (weak, nonatomic) IBOutlet UIButton *wStartButton;
@property (weak, nonatomic) IBOutlet UIButton *wFinishButton;

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
    

    // 出勤ボタンのデザイン
    // self.wStartButton.backgroundColor = [UIColor lightGrayColor];
    self.wStartButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.wStartButton.layer.borderWidth = 1.0f;
    self.wStartButton.layer.cornerRadius = 7.5f;

    // 退勤ボタンのデザイン
    self.wFinishButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.wFinishButton.layer.borderWidth = 1.0f;
    self.wFinishButton.layer.cornerRadius = 7.5f;

    
    // 出勤時間テキストフィールドのデザイン
    self.startTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.startTimeTextField.textColor = [UIColor blackColor];
    self.startTimeTextField.placeholder = @"00:00";
    self.startTimeTextField.delegate = self;
    self.startTimeTextField.tag = 1;
    
    // 休憩時間テキストフィールドのデザイン
    self.resetTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.resetTimeTextField.textColor = [UIColor blueColor];
    self.resetTimeTextField.placeholder = @"未設定";
    self.resetTimeTextField.delegate = self;
    self.resetTimeTextField.tag = 2;
    
    // 退勤時間テキストフィールドのデザイン
    self.finishTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.finishTimeTextField.textColor = [UIColor blackColor];
    self.finishTimeTextField.placeholder = @"00:00";
    self.finishTimeTextField.delegate = self;
    self.finishTimeTextField.tag = 3;
    
    
    // 出勤時間ピッカーの生成
    _startPickerView = [[UIPickerView alloc] init];
    self.startPickerView.delegate = self;
    self.startPickerView.dataSource = self;
    self.startPickerView.showsSelectionIndicator = YES;
    self.startPickerView.tag = 1;
    
    // 休憩時間ピッカーの生成
    _resetPickerView = [[UIPickerView alloc] init];
    self.resetPickerView.delegate = self;
    self.resetPickerView.dataSource = self;
    self.resetPickerView.showsSelectionIndicator = YES;
    self.resetPickerView.tag = 2;
    
    // 退勤時間ピッカーの生成
    _finishPickerView = [[UIPickerView alloc] init];
    self.finishPickerView.delegate = self;
    self.finishPickerView.dataSource = self;
    self.finishPickerView.showsSelectionIndicator = YES;
    self.finishPickerView.tag = 3;
    
    // テキストフィールドの選択時にピッカー表示
    self.startTimeTextField.inputView = self.startPickerView;
    self.resetTimeTextField.inputView = self.resetPickerView;
    self.finishTimeTextField.inputView = self.finishPickerView;
    
    // ピッカーのツールバー（閉じるボタン）生成
    UIToolbar *startToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    startToolBar.barStyle = UIBarStyleBlackOpaque;
    [startToolBar sizeToFit];
    
    UIToolbar *resetToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    resetToolBar.barStyle = UIBarStyleBlackOpaque;
    [resetToolBar sizeToFit];
    
    UIToolbar *finishToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    finishToolBar.barStyle = UIBarStyleBlackOpaque;
    [finishToolBar sizeToFit];
    
    
    UIBarButtonItem *startSpacer = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
    
    UIBarButtonItem *resetSpacer = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
    
    UIBarButtonItem *finishSpacer = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];

    UIBarButtonItem *startDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(startDonePushed)];
    
    UIBarButtonItem *resetDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(resetDonePushed)];
    
    UIBarButtonItem *finishDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(finishDonePushed)];

    
    NSArray *startItems = [NSArray arrayWithObjects:startSpacer, startDone, nil];
    [startToolBar setItems:startItems animated:YES];
    
    NSArray *resetItems = [NSArray arrayWithObjects:resetSpacer, resetDone, nil];
    [resetToolBar setItems:resetItems animated:YES];
    
    NSArray *finishItems = [NSArray arrayWithObjects:finishSpacer, finishDone, nil];
    [finishToolBar setItems:finishItems animated:YES];
    
    // テキストフィールドの選択時にツールバー表示
    self.startTimeTextField.inputAccessoryView = startToolBar;
    self.resetTimeTextField.inputAccessoryView = resetToolBar;
    self.finishTimeTextField.inputAccessoryView = finishToolBar;
   

    // 一枚の黒いUIViewを加えて、ピッカーをモーダル表示のようにする
    _startBackView = [[UIView alloc] initWithFrame:self.view.frame];
    self.startBackView.backgroundColor = [UIColor blackColor];
    self.startBackView.alpha = 0.2;
    self.startBackView.hidden = YES;
    self.startBackView.userInteractionEnabled = NO;
    [self.view addSubview:self.startBackView];
    
    _resetBackView = [[UIView alloc] initWithFrame:self.view.frame];
    self.resetBackView.backgroundColor = [UIColor blackColor];
    self.resetBackView.alpha = 0.2;
    self.resetBackView.hidden = YES;
    self.resetBackView.userInteractionEnabled = NO;
    [self.view addSubview:self.resetBackView];
    
    _finishBackView = [[UIView alloc] initWithFrame:self.view.frame];
    self.finishBackView.backgroundColor = [UIColor blackColor];
    self.finishBackView.alpha = 0.2;
    self.finishBackView.hidden = YES;
    self.finishBackView.userInteractionEnabled = NO;
    [self.view addSubview:self.finishBackView];
    
    // 休憩時間ピッカーの２列目（NSNumberに変換して配列に格納）
    self.resetMinuteArray = [NSMutableArray array];
    int i;
    for (i=0; i<60; i +=5) {
        [self.resetMinuteArray addObject:[NSNumber numberWithInteger:i]];
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


#pragma mark - ピッカーの処理

/**
 *  出勤時間ピッカーを閉じる
 */
- (void)startDonePushed
{
    NSLog(@"%@", @"出勤Done押した。");
    self.startBackView.hidden = YES;
    [self.startTimeTextField resignFirstResponder];
}

/**
 *  休憩時間ピッカーを閉じる
 */
- (void)resetDonePushed
{
    NSLog(@"%@", @"休憩Done押した。");
    self.resetBackView.hidden = YES;
    [self.resetTimeTextField resignFirstResponder];
}

/**
 *  退勤時間ピッカーを閉じる
 */
- (void)finishDonePushed
{
    NSLog(@"%@", @"退勤Done押した。");
    self.finishBackView.hidden = YES;
    [self.finishTimeTextField resignFirstResponder];
}

/**
 *  テキストフィールドの編集表示
 *
 *  @param textField 出勤時間テキストフィールド
 *
 *  @return キーボードの表示（YES）
 */
- (BOOL)TextFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            self.startBackView.hidden = NO;
            break;
        case 2:
            self.resetBackView.hidden = NO;
            break;
        case 3:
            self.finishBackView.hidden = NO;
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - UIPikerViewDelegate

/**
 *  ピッカーに表示する列数を返す。(必須)
 *
 *  @param pickerView ピッカー
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
 *  @param pickerView ピッカー
 *  @param component  列数
 *
 *  @return 表示する行数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 休憩時間ピッカーは0~4時間で5分刻み
    if (pickerView.tag == 2) {
        switch (component) {
            case 0: return 5;
            case 1: return [self.resetMinuteArray count];
        }
        return 0;
    }
    
    switch (component) {
        case 0: return 24;
        case 1: return 60;
        default: return 0;
        break;
    }
}


/**
 *  行のサイズを指定する。
 *
 *  @param pickerView ピッカー
 *  @param component  列数
 *
 *  @return 行のサイズ
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
 *  @param pickerView ピッカー
 *  @param row        行数
 *  @param component  列数
 *
 *  @return 表示する値
 */
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 休憩時間ピッカーの表示形式
    if (pickerView.tag == 2) {
        switch (component) {
            case 0: // 1列目
                return [NSString stringWithFormat:@"%ld",(long)row];
                break;
            case 1: // 2列目
                return [NSString stringWithFormat:@"%d", [[self.resetMinuteArray objectAtIndex:row] intValue]];
                break;
            default:
                return 0;
                break;
        }
    }
    
    switch (component) {
        case 0: // 1列目
            return [NSString stringWithFormat:@"%ld",(long)row];
            break;
        case 1: // 2列目
            return [NSString stringWithFormat:@"%ld",(long)row];
            break;
        default:
            return 0;
            break;
    }
    
}


/**
 *  ピッカーで選択時した値を表示する処理
 *
 *  @param pickerView ピッカー
 *  @param row        行数
 *  @param component  列数
 */
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 選択されている時間の行を取得
    int rowOfHour  = (int)[pickerView selectedRowInComponent:0];
    int rowOfMinute = (int)[pickerView selectedRowInComponent:1];
    
    switch (pickerView.tag) {
        case 1:
            NSLog(@"%@", @"出勤text変更。");
            self.startTimeTextField.text = [NSString stringWithFormat:@"%d時%02d分",rowOfHour, rowOfMinute];
            break;
        case 2:
            NSLog(@"%@", @"休憩text変更。");
            self.resetTimeTextField.text = [NSString stringWithFormat:@"%d時間%d分",rowOfHour, [[self.resetMinuteArray objectAtIndex:rowOfMinute] intValue]];
            break;
        case 3:
            NSLog(@"%@", @"退勤text変更。");
            self.finishTimeTextField.text = [NSString stringWithFormat:@"%d時%02d分",rowOfHour, rowOfMinute];
            break;
        default:
            break;
    }
    
}
@end
