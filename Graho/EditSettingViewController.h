//
//  EditSettingViewController.h
//  Graho
//
//  Created by 須藤 将史 on 2014/12/23.
//  Copyright (c) 2014年 masashi_sutou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSettingViewController : UIViewController<UITextFieldDelegate>

// 設定入力画面のタイトルとテキストの受け渡し
@property (nonatomic, copy) NSString *toTitle;
@property (nonatomic, copy) NSString *toText;

@end
