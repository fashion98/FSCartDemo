//
//  FSHomeVC.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "FSHomeVC.h"
#import "FSGoodsCollectionCell.h"
#import "FSFMDB.h"

@interface FSHomeVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
static NSString *cellID = @"FSGoodsCollectionView";
@implementation FSHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor colorWithRed:242/250.0 green:243/250.0 blue:240/250.0 alpha:1];
    
    self.dataArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"goodsList" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in array) {
        
        FSGoods *good = [FSGoods new];
        good.goodsId = dict[@"goodsId"];
        good.goodsImg = dict[@"goodsImg"];
        good.goodsName = dict[@"goodsName"];
        good.goodsSeries = dict[@"goodsSeries"];
        good.goodsPrice = dict[@"goodsPrice"];
        
        [self.dataArray addObject:good];
        
    }
    NSLog(@"%@", self.dataArray);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenWidth-30)/2, (kScreenWidth-30)/2+70);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 5, 10);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49)collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:242/250.0 green:243/250.0 blue:240/250.0 alpha:1];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FSGoodsCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    
    [self.view addSubview:self.collectionView];


}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.buyBlock = ^(FSGoods *model){
    
        [FSFMDB findSQLWithPathComponent:@"goods.sqlite"];
        
        [FSFMDB createTableWithSQL:@"create table if not exists goods ('goodsId' text not null, 'goodsImg' text ,'goodsName' text not null, 'goodsSeries' text not null, 'goodsPrice' text, 'goodsNum' integer not null)" andResultBlock:^(NSString *result) {
            
            NSLog(@"创建表：%@", result);
            
            NSString *searchSQL = [NSString stringWithFormat:@"select * from goods where goodsId = '%@'", model.goodsId];
            
            
            [FSFMDB searchOneDataWithSQL:searchSQL andResultBlock:^(BOOL result, NSDictionary *dict)
             {
                 
                 if (result)
                 {
                     
                     // 查询到该商品在数据库中
                     int num = 0;
                     NSString *number = [dict objectForKey:@"goodsNum"];
                     num = [number intValue] + 1;
                     number = [NSString stringWithFormat:@"%zd", num];
                     
                     NSString *updateSQL = [NSString stringWithFormat:@"update goods set goodsNum = '%d' where goodsId = '%@'", num, model.goodsId];
                     
                     [FSFMDB updateWithSQL:updateSQL andResultBlocck:^(BOOL result) {
                         
                         if (result)
                         {
                             NSLog(@"提醒用户，增加购物车成功");
                         }
                         
                     }];
                 }
                 else
                 {
                     model.goodsNum = 1;
                     
                     NSString *insertSQL = [NSString stringWithFormat:@"insert into goods values ('%@', '%@', '%@', '%@', '%@', '%d')", model.goodsId, model.goodsImg, model.goodsName, model.goodsSeries, model.goodsPrice, model.goodsNum];
                     
                     [FSFMDB insertWithSQL:insertSQL andResultBlocck:^(BOOL result) {
                         
                         
                     }];
                 }
                 
                 
             }];
            
            
        }];

    };
    
    cell.model = self.dataArray[indexPath.item];
    
    return cell;
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
