//
//  SettingViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/14.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "SettingViewController.h"
#import "EditSettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@property (nonatomic, strong) NSArray *dataSourceWork;
@property (nonatomic, strong) NSArray *dataSourceMail;
@property (nonatomic, strong) NSString *settingValue;
@property (nonatomic, strong) NSString *unSetting;

// 選択セルのインデックスを格納する変数
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation SettingViewController

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

    // デリゲートメソッドをこのクラスで実装する
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    
    // テーブルに表示したいデータソースをセット
    self.dataSourceWork = @[@"現場名", @"言語"];
    self.dataSourceMail = @[@"件名", @"書き出し文", @"署名"];
    self.unSetting = @"未設定";
    NSLog(@"viewDidLoadスタート");
}

/**
 *  設定画面が表示される都度呼び出される（設定値の読み込み）
 *
 *  @param animated 表示はプッシュ
 */
-(void)viewWillAppear:(BOOL)animated
{
    // TableViewを更新
    [self.settingTableView reloadData];
    [super viewWillAppear:animated];
    NSLog(@"UItableViewの更新");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource

/**
 * テーブルに表示するセクション名を返します。（オプション）
 *
 * @return NSString : セクション名
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    // テーブルに表示するデータ件数を返す
    switch (section) {
        case 0:
            title = [NSString stringWithFormat:@"現場設定"];
            break;
        case 1:
            title = [NSString stringWithFormat:@"書式設定"];
            break;
        default:
            break;
    }
    return title;
}


/**
 * テーブルに表示するデータ件数を返します。（必須）
 *
 * @return NSInteger : データ件数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount;
    
    // テーブルに表示するデータ件数を返す
    switch (section) {
        case 0:
            dataCount = self.dataSourceWork.count;
            break;
        case 1:
            dataCount = self.dataSourceMail.count;
            break;
        default:
            break;
    }
    return dataCount;
}


/**
 * テーブルに表示するセクション（区切り）の件数を返します。（オプション）
 *
 * @return NSInteger : セクションの数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    // 右側にキャプションを追加する
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    
    // NSUserDefaultsを取得して利用
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    // キーと値の取得
    NSString *defaultsKey = [[NSString alloc] initWithFormat:@"%d%d",indexPath.section, indexPath.row];
    self.settingValue = [ud stringForKey:defaultsKey];
    
    
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.dataSourceWork[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
            // 空の場合は未設定
            if (self.settingValue.length == 0){
                self.settingValue = self.unSetting;
            }
            
            // セルの左側のキャプション
            cell.detailTextLabel.text = self.settingValue;
            NSLog(@"%@%@", cell.detailTextLabel.text, defaultsKey);
            
            break;
        case 1:
            cell.textLabel.text = self.dataSourceMail[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            // 空の場合は未設定
            if (self.settingValue.length == 0){
                self.settingValue = self.unSetting;
            }
            
            // セルの左側のキャプション
            cell.detailTextLabel.text = self.settingValue;
            NSLog(@"%@%@", cell.detailTextLabel.text, defaultsKey);
            
            break;
        default:
            break;
    }
    
    return cell;
}


/**
 * 選択されたセルのインデックスを取得
 * 設定項目を選択したら設定入力画面へ
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 選択されたセルのインデックスを格納
    self.selectedIndexPath = indexPath;
    
    // セグエのIDで遷移先を指定
    [self performSegueWithIdentifier:@"settingToEdit" sender:self];
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
    // 遷移先を取得します
    EditSettingViewController *editSettingView = segue.destinationViewController;
    
    // NSUserDefaultsを取得して利用
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    // キーと値の取得
    NSString *defaultsKey = [[NSString alloc] initWithFormat:@"%d%d",self.selectedIndexPath.section, self.selectedIndexPath.row];
    self.settingValue = [ud stringForKey:defaultsKey];
    
    // 遷移先にキーを渡す
    editSettingView.selectedKey = defaultsKey;
    
    // 選択されたセルの行数を遷移先の「件名」「テキストフィールドのテキスト」に表示する。
    switch (_selectedIndexPath.section) {
        case 0: // 現場設定
            editSettingView.toTitle = self.dataSourceWork[self.selectedIndexPath.row];
            
            // 空の場合は未設定
            if (self.settingValue.length == 0){
                self.settingValue = self.unSetting;
            }
            
            // 遷移先にタイトル名を渡す
            editSettingView.toText = self.settingValue;
            break;
        case 1: // 書式設定
            editSettingView.toTitle = self.dataSourceMail[self.selectedIndexPath.row];
            
            // 空の場合は未設定
            if (self.settingValue.length == 0){
                self.settingValue = self.unSetting;
            }
            
            // 遷移先にタイトル名を渡す
            editSettingView.toText = self.settingValue;
            break;
        default:
            break;
    }
}

@end
