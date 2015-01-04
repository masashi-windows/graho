//
//  TimeViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/14.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *wStartButton;
@property (weak, nonatomic) IBOutlet UIButton *wRestButton;
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

- (IBAction)wStartButton:(id)sender {
}


- (IBAction)wRestButton:(id)sender {
}


- (IBAction)wFinishButton:(id)sender {
}

@end
