//
//  XWPDFViewController.m
//  XWCNDict
//
//  Created by xw.long on 16/7/4.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWPDFViewController.h"

@interface XWPDFViewController ()


@end

@implementation XWPDFViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarVC setBarHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarVC setBarHidden:YES];
}

- (void)backCollectionVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tabBarVC setBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.platViewModel  = XWPlatViewModelPDFPrint;
    
    self.view.backgroundColor           = [UIColor whiteColor];
    self.collectionPlat.backgroundColor = [UIColor whiteColor];


    UIImage *imgPlat = [self.collectionPlat convertToImage];
    self.collectionPlat.backgroundColor = self.setInfo.themeColorCollection;

    CGSize sizeShow = CGSizeMake(CGImageGetWidth(imgPlat.CGImage)*1.5, CGImageGetHeight(imgPlat.CGImage)*1.5);


    self.imgvShow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sizeShow.width, sizeShow.height)];
    self.imgvShow.backgroundColor   = [UIColor whiteColor];
    self.imgvShow.image             = imgPlat;


    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20, kScreenSize.width - 40, kScreenSize.height)];
    [scrollView setContentSize:sizeShow];
    [scrollView addSubview:_imgvShow];
    [self.view addSubview:scrollView];


    /// 点击打印按钮
    UIButton *btnPrint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPrint setTitle:@"Print" forState:UIControlStateNormal];
    [btnPrint setTintColor:[UIColor purpleColor]];
    [btnPrint.titleLabel setFont:[UIFont systemFontOfSize:22 * kFixed_rate]];
    [btnPrint setFrame:CGRectMake(kScreenSize.width - 100, 30, 100 * kFixed_rate, 35)];
    [btnPrint addTarget:self action:@selector(btnPrintClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPrint];

    /// 点击返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backBtn setFrame:CGRectMake(10, 30, 110 * kFixed_rate, 35)];
    [backBtn setTitle:@"《 goback" forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:22 * kFixed_rate]];
    [backBtn addTarget:self action:@selector(backCollectionVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];


    [self writePDFSaveFrom:imgPlat];
}

- (void)btnPrintClick:(UIButton *)btnPrint
{
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = self;

    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(_imgvShow.image)];

    if (printC && [UIPrintInteractionController canPrintData:data]) {


        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
        printC.showsPageRange = YES;//显示的页面范围

        printInfo.jobName = @"willingseal";

        printC.printInfo = printInfo;
        NSLog(@"\n printinfo---->%@",printC.printInfo);
        printC.printingItem = data;//single NSData, NSURL, UIImage, ALAsset
        //        NSLog(@"printingitem-%@",printC);


        //    等待完成

        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"可能无法完成，因为印刷错误: %@", error);
            }
        };

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnPrint];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
            [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
            //注意这里的printBtn添加在哪一个View上，在printOptionView 出现后，只有点击该View才能使得printOptionsView hidden,也就是说，最好将printBtn放置要最顶层的位置。
        } else {
            [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
        }
    }
}

- (void)writePDFSaveFrom:(UIImage *)image
{
    XWPrintPageRender       *myRenderer = [[XWPrintPageRender alloc] init];

    UIViewPrintFormatter    *viewFormat = [self.view viewPrintFormatter];

    [myRenderer addPrintFormatter:viewFormat startingAtPageAtIndex:0];

    NSData *pdfData  = [myRenderer convertUIWevViewToPDFsaveWidth:image.size.width height:image.size.height andData:nil];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"datapdf" ofType:nil];

    [pdfData writeToFile:filePath atomically:YES];
}

//#pragma mark - set Status_Bar hidden
//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

@end
