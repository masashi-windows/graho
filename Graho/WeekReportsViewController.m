//
//  ViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/14.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "WeekReportsViewController.h"

@interface WeekReportsViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingButton;

@property (weak, nonatomic) IBOutlet UITextField *firstWeekReport;
@property (weak, nonatomic) IBOutlet UITextField *secondWeekReport;
@property (weak, nonatomic) IBOutlet UITextField *thirdWeekReport;
@property (weak, nonatomic) IBOutlet UITextField *forthWeekReport;


@property (weak, nonatomic) IBOutlet UIToolbar *menuToolBar;



- (IBAction)moveSetting:(UIBarButtonItem *)sender;
- (IBAction)moveCreate:(UIButton *)sender;
- (IBAction)selectWeekReport:(UIBarButtonItem *)sender;
- (IBAction)sendWeekReport:(UIBarButtonItem *)sender;


@end

@implementation WeekReportsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendWeekReport:(UIBarButtonItem *)sender {
}

- (IBAction)moveSetting:(UIBarButtonItem *)sender {
}

- (IBAction)moveCreate:(UIButton *)sender {
}

- (IBAction)selectWeekReport:(UIBarButtonItem *)sender {
}
@end
