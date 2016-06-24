//
//  XWCollectionViewController.m
//  XWProDict
//
//  Created by 龙学武 on 16/6/4.
//  Copyright © 2016年 林夕. All rights reserved.
//

#import "XWCollectionViewController.h"
#import "XWMyDataController.h"


@interface XWCollectionViewController ()

@end

@implementation XWCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    XWMyDataController *_DC = [XWMyDataController shareDataController];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XWCharacter"];
    NSArray *arr = [_DC.managedObjectContext executeFetchRequest:request error:nil];
    XWCharacter *charModel = [arr lastObject];
    for (XWCharacter *cModel in arr) {
        NSLog(@"%@ | %@ | %@",cModel.fontChar,cModel.dateModify,cModel.dataImg);
    }
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(200, 300, 200, 200)];
    imagev.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:imagev];
    imagev.image = [UIImage imageWithData:charModel.dataImg];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
