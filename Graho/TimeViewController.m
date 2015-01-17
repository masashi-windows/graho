//
//  TimeViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/14.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()

// 現在時刻ラベル
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// 出勤・休憩・退勤・勤務時間ラベル
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;

// ボタンエリア
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
    
    // ボタンのデザイン
//    self.wStartButton.backgroundColor = [UIColor lightGrayColor];
    self.wStartButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.wStartButton.layer.borderWidth = 1.0f;
    self.wStartButton.layer.cornerRadius = 7.5f;

    self.wFinishButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.wFinishButton.layer.borderWidth = 1.0f;
    self.wFinishButton.layer.cornerRadius = 7.5f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
