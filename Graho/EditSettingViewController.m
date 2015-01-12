//
//  EditSettingViewController.m
//  Graho
//
//  Created by 須藤 将史 on 2014/12/23.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import "EditSettingViewController.h"

@interface EditSettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)saveButton:(id)sender;

@end

@implementation EditSettingViewController

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
    
    // 設定画面から受け渡された変数を格納
    self.textField.delegate = self;
    self.navigationItem.title = self.toTitle;
    self.textField.text = self.toText;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  設定画面に戻るボタンを押下した時のイベント処理
 *
 *  @param parent 設定画面
 */
- (void)didMoveToParentViewController:(UIViewController *)parent
{

}


/**
 *  UITextFieldクラスのデリゲートメソッド
 *
 *  @param textField 設定入力のテキスト
 *
 *  @return 改行コード無し
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードを引っ込める
    [self.view endEditing:YES];
    // 改行コードを入力しない
    return NO;
}


/**
 *  保存ボタンの処理
 *
 *  @param sender 保存ボタン
 */
- (IBAction)saveButton:(id)sender {
    
    // アラートを作る
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確認"
                                                   message:@"設定を保存しました"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK", nil];
    
    //アラートを表示する
    [alert show];
}


/**
 *  アラート処理（デリゲートメソッド）
 *
 *  @param alertView   保存の確認アラート
 *  @param buttonIndex 保存ボタン
 */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        
        // OKが押されたら保存処理
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:self.textField.text forKey:self.selectedKey];
        
        // NSUserDefaultsに即時反映させる
        [ud synchronize];
        
        NSString *settingValue = [ud stringForKey:self.selectedKey];
        NSLog(@"%@", settingValue);
    }
}

@end
