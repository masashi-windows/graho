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
    self.textField.delegate = self;
    self.navigationItem.title = self.toTitle;
    self.textField.text = self.toText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// UITextFieldクラスのデリゲートメソッド
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードを引っ込める
    [self.view endEditing:YES];
    
    // 文字の出力
    NSLog(@"入力された文字> %@", self.textField.text);
    
    // 改行コードを入力しない
    return NO;
}


// 保存ボタンの処理
- (IBAction)saveButton:(id)sender {
    
    // アラートを作る
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確認" message:@"設定を保存しました" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    //アラートを表示する
    [alert show];
}

// アラート処理（デリゲートメソッド）
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        //　OKが押されたら保存処理
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:self.textField.text forKey:@"KEY_WPNAME"];  // をKEY_WPNAMEというキーの初期値は99
//        [ud synchronize];  // NSUserDefaultsに即時反映させる（即時で無くてもよい場合は不要）
    }
}

//// データ保存
//- (void)save
//{
//
//}

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
