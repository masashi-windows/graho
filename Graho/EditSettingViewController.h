//
//  EditSettingViewController.h
//  Graho
//
//  Created by 須藤 将史 on 2014/12/23.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSettingViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>

// 設定入力画面のタイトル、テキスト、選択されたセルのキー、を受け渡し
@property (nonatomic, copy) NSString *toTitle;
@property (nonatomic, copy) NSString *toText;
@property (nonatomic, copy) NSString *selectedKey;

@end
