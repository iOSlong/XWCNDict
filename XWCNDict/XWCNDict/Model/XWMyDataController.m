//
//  XWMyDataController.m
//  XWCNDict
//
//  Created by xw.long on 16/6/24.
//  Copyright © 2016年 linxi. All rights reserved.
//

#import "XWMyDataController.h"

@implementation XWMyDataController

+ (instancetype)shareDataController
{
    static XWMyDataController *shareOBJ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareOBJ = [[XWMyDataController alloc] init];
    });
    return shareOBJ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _synchronousArrCanvas       = [NSMutableArray array];
        _needReloadCollectionCanvas = YES;
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];

        NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        NSAssert(mom != nil, @"Error initializing Managed Object Model");

        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc setPersistentStoreCoordinator:psc];
        [self setManagedObjectContext:moc];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
        NSLog(@"storeURL %@",storeURL);

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSError *error = nil;
            NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
            NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
            NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        });
    }
    return _managedObjectContext;
}


- (NSArray *)arrObjectModel
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XWCharacter"];
    NSError *error = nil;
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:&error];

    /// 进行一下排序
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(XWCharacter *obj1, XWCharacter *obj2) {
        return  obj1.dateModify.timeIntervalSinceNow > obj2.dateModify.timeIntervalSinceNow;
    }];
    
    if (error) {
        NSAssert(arr != nil, @"Error fetch OCArray: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    return arr;
}



@end
