//
//  XWNotebookViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWNotebookViewController.h"

@interface XWNotebookViewController ()

@end

@implementation XWNotebookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [self addLocalNote:nil];
}


- (IBAction)addLocalNote:(id)sender {
    // 1.创建一个本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];

    // 2.设置本地通知的一些属性(通知发出的时间/通知的内容)
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    // 2.2.设置通知的内容
    localNote.alertBody = @"吃饭了吗?";
    // 2.3.设置锁屏界面的文字
    localNote.alertAction = @"查看具体的消息";
    // 2.4.设置锁屏界面alertAction是否有效
//    localNote.hasAction = YES;
    // 2.5.设置通过点击通知打开APP的时候的启动图片(无论字符串设置成什么内容,都是显示应用程序的启动图片)
    localNote.alertLaunchImage = @"111";
    // 2.6.设置通知中心通知的标题
    localNote.alertTitle = @"222222222222";
    // 2.7.设置音效
    localNote.soundName = @"buyao.wav";
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 1;
    // 2.9.设置通知之后的属性
    localNote.userInfo = @{@"name" : @"张三", @"toName" : @"李四"};

    // 3.调度通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}


@end
