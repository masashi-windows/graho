//
//  ViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/14.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "ReportViewController.h"
#import "EditReportViewController.h"

@interface ReportViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *reportTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingButton;
@property (weak, nonatomic) IBOutlet UIToolbar *menuToolBar;

// 選択セルのインデックスを格納する変数
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (IBAction)moveSetting:(UIBarButtonItem *)sender;

@end

@implementation ReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 日付の書式を作成
    NSDateFormatter *titleDate = [[NSDateFormatter alloc]init];
    [titleDate setDateFormat:@"yyyy'年'M'月'"];
    
    // ReportViewControllerのタイトルに日付を表示
    self.navigationItem.title = [titleDate stringFromDate:[NSDate date]];
    
    // デリゲートメソッドをこのクラスで実装する
    self.reportTableView.delegate = self;
    self.reportTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * テーブルに表示するデータ件数を返します。（必須）
 *
 * @return NSInteger : データ件数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // テーブルに表示するデータ件数を返す
    
    // 今の時刻を取得する
    NSDate *now = [NSDate date];
    
    // NSCalendarを取得する
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];;
    NSInteger daysOfThisMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:now].length;
    return daysOfThisMonth;
}


/**
 * テーブルに表示するセルを返します。（必須）
 *
 * @return UITableViewCell : テーブルセル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // 再利用できるセルがあれば再利用する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld日", (long)indexPath.row + 1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


/**
 * 選択されたセルのインデックスを取得
 * 日付を選択したらEditReport画面へ
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 選択されたセルのインデックスを格納
    self.selectedIndexPath = indexPath;
    
    // セグエのIDで遷移先を指定
    [self performSegueWithIdentifier:@"reportToEdit" sender:self];
}


#pragma mark - Segue method

/**
 *  セグエでの画面遷移前に呼び出されます。
 *
 *  @param segue  セグエ（pushを選択したやつ）
 *  @param sender 呼び出し元のViewController（今回の場合はViewController）
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 日付セルを選択した場合(セグエIDで判別)
    if ([segue.identifier isEqualToString:@"reportToEdit"] ){
        // 遷移先を取得します
        EditReportViewController *editReportView = segue.destinationViewController;
        editReportView.toTitle = [NSString stringWithFormat:@"%ld日", (long)self.selectedIndexPath.row + 1];
    }
}


- (IBAction)moveSetting:(UIBarButtonItem *)sender {
}

@end
