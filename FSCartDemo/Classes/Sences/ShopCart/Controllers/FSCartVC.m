//
//  FSCartVC.m
//  FSCartDemo
//
//  Created by 如果思念是自己的 on 17/1/4.
//  Copyright © 2017年 如果思念是自己的. All rights reserved.
//

#import "FSCartVC.h"
#import "FSFMDB.h"
#import "FSGoods.h"
#import "FSShopCartCell.h"
#import "FSSumView.h"
#import "FSOrderDetailVC.h"

@interface FSCartVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *noGoodsImgView;
@property (strong, nonatomic) UIButton *goHomeViewButton;

@property (strong, nonatomic) UITableView *shopcartTableView;
@property (strong, nonatomic) NSMutableArray *shopcartGoodsArray;
@property (strong, nonatomic) NSMutableArray *resultArray;

@property (strong, nonatomic) FSSumView *sumView;

@property (assign, nonatomic) BOOL isSelectAll;

@end

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

static NSString *cellID = @"FSShopCartCell";
@implementation FSCartVC

- (void)viewWillAppear:(BOOL)animated
{
    
    self.resultArray = [NSMutableArray array];
    [self.resultArray removeAllObjects];
    self.shopcartGoodsArray = [NSMutableArray array];
    
    NSString *searchAllSQL = [NSString stringWithFormat:@"select * from goods"];
    
    [FSFMDB findSQLWithPathComponent:@"goods.sqlite"];
    
    [FSFMDB searchAllDataWithSQL:searchAllSQL andResultBlock:^(BOOL success, NSMutableArray *goodList) {
        
        if (success)
        {
            self.shopcartGoodsArray = goodList;
        }
        NSLog(@"%@", self.shopcartGoodsArray);
    }];
    
    if (self.shopcartGoodsArray.count>0)
    {
        [self initView];
    }
    else
    {
        [self initNoGoodsView];
    }
    
    
    self.isSelectAll = NO;
    
    [self.shopcartTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";

    self.view.backgroundColor = [UIColor colorWithRed:242/250.0 green:243/250.0 blue:240/250.0 alpha:1];
}


#pragma mark ____ 您的购物车空... ____
- (void)initNoGoodsView
{
    self.noGoodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-90)/2, 64, 90, 90*1.28)];
    self.noGoodsImgView.image = [UIImage imageNamed:@"noGoodsBG"];
    [self.view addSubview:self.noGoodsImgView];
    
    self.goHomeViewButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-90)/2, CGRectGetMaxY(self.noGoodsImgView.frame)+10, 90, 20)];
    self.goHomeViewButton.backgroundColor = [UIColor orangeColor];
    [self.goHomeViewButton setTitle:@"去首页逛逛" forState:(UIControlStateNormal)];
    self.goHomeViewButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.goHomeViewButton addTarget:self action:@selector(goHomeViewAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.goHomeViewButton];
}

- (void)goHomeViewAction:(UIButton *)button
{
    self.tabBarController.selectedIndex = 0;
}


- (void)initView
{
    self.shopcartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49-50) style:(UITableViewStylePlain)];
    self.shopcartTableView.backgroundColor = [UIColor colorWithRed:242/250.0 green:243/250.0 blue:240/250.0 alpha:1];
    self.shopcartTableView.delegate = self;
    self.shopcartTableView.dataSource = self;
    [self.view addSubview:self.shopcartTableView];
    
    [self.shopcartTableView registerNib:[UINib nibWithNibName:@"FSShopCartCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.shopcartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.sumView = [FSSumView initView];
    self.sumView.frame = CGRectMake(0, kScreenHeight - 49 - 64 - 50, kScreenWidth, 50);
    [self.sumView.selectAllButton addTarget:self action:@selector(selectAllAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.sumView.payButton addTarget:self action:@selector(jiesuanAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.sumView];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.shopcartGoodsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.isSelected = self.isSelectAll;
    
    if ([self.resultArray containsObject:self.shopcartGoodsArray[indexPath.section]]) {
        
        cell.isSelected = YES;
    }
    
    // cell中选中按钮的点击回调
    cell.cellBlock = ^(BOOL isSelect){
        
        if (isSelect)
        {
            [self.resultArray addObject:self.shopcartGoodsArray[indexPath.section]];
        }
        else
        {
            [self.resultArray removeObject:self.shopcartGoodsArray[indexPath.section]];
        }
        
        if (self.resultArray.count == self.shopcartGoodsArray.count)
        {
            self.sumView.selectAllButton.selected = YES;
        }
        else
        {
            self.sumView.selectAllButton.selected = NO;
        }
        
        [self calculateTheTotalPrice];
        
    };
    
    // cell中－号点击的回调
    cell.cutNumBlock = ^(UILabel *numLabel){
        
        int num = numLabel.text.intValue;
        
        FSGoods *goods = self.shopcartGoodsArray[indexPath.section];
        
        if (num > 1) {
            
            num--;
            numLabel.text = [NSString stringWithFormat:@"%zd", num];
            
            [self cutOneGoods:goods];
        }
        
        goods.goodsNum = num;
        
        [self.shopcartGoodsArray replaceObjectAtIndex:indexPath.section withObject:goods];
        if ([self.resultArray containsObject:goods])
        {
            [self.resultArray removeObject:goods];
            [self.resultArray addObject:goods];
            [self calculateTheTotalPrice];
        }
        
        [self.shopcartTableView reloadData];
        
    };
    
    // cell中＋号点击的回调
    cell.addNumBlock = ^(UILabel *numLabel){
        
        int num = numLabel.text.intValue;
        
        num++;
        numLabel.text = [NSString stringWithFormat:@"%zd", num];
        
        
        FSGoods *goods = [self.shopcartGoodsArray objectAtIndex:indexPath.section];
        goods.goodsNum = num;
        
        [self addOneGoods:goods];
        
        [self.shopcartGoodsArray replaceObjectAtIndex:indexPath.section withObject:goods];
        if ([self.resultArray containsObject:goods])
        {
            [self.resultArray removeObject:goods];
            [self.resultArray addObject:goods];
            [self calculateTheTotalPrice];
        }
        
        [self.shopcartTableView reloadData];
    };
    
    // cell中删除按钮的回调
    cell.deleteBlock = ^(FSGoods *good){
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 通过FMDB删除本地数据库对应的商品
            [FSFMDB findSQLWithPathComponent:@"goods.sqlite"];
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM goods WHERE goodsId = '%@'", good.goodsId];
            [FSFMDB deleteWithSQL:sql andResultBlock:^(BOOL result) {
                
                if (result) {
                    
                    NSLog(@"删除成功！");
                }
            }];
            

            // 需要先判断要删除的model，结算数组里是否包含
            // 1、如果包含，结算数组也需要删除对应的model，否则会影响全选按钮的选中状态
            // 2、如果不包含，在删除数据源数组对应的model之后，需要判断结算数组和数据源数组的个数，否则同样会影响全选按钮的选中状态（eg：如果购物车中有三个model数据，选中两个model，如果删除一个未选中的model，此时全选按钮选中状态应该置为YES）
            if ([self.resultArray containsObject:self.shopcartGoodsArray[indexPath.section]]) {
                
                [self.resultArray removeObject:self.shopcartGoodsArray[indexPath.section]];
            }
            
            // 删除数据源
            [self.shopcartGoodsArray removeObjectAtIndex:indexPath.section];
            
            // 删除UI
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationFade)];
            
            
            if (!self.shopcartGoodsArray.count) {
                
                [self.sumView removeFromSuperview];
                [self initNoGoodsView];
            }
            
            // 判断数据源数组的个数和结算数组的个数是否相等
            if (self.resultArray.count == self.shopcartGoodsArray.count) {
                
                self.sumView.selectAllButton.selected = YES;
            }
            
            
            [self.shopcartTableView reloadData];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    
    
    cell.model = self.shopcartGoodsArray[indexPath.section];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}


// UITableView设置分区头跟随UITableView滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 10; //根据实际情况设置
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark ____ 数据库中相应商品数量减1 ____
- (void)cutOneGoods:(FSGoods *)model
{
    [FSFMDB findSQLWithPathComponent:@"goods.sqlite"];
    
    NSString *searchOneSQL = [NSString stringWithFormat:@"select * from goods where goodsId = '%@'", model.goodsId];
    
    [FSFMDB searchOneDataWithSQL:searchOneSQL andResultBlock:^(BOOL result, NSDictionary *dict) {
        
        if (result)
        {
            int num = [[dict objectForKey:@"goodsNum"] intValue];
            num = num - 1;
            
            [FSFMDB updateWithSQL:[NSString stringWithFormat:@"update goods set goodsNum = '%d' where goodsId = '%@'", num, model.goodsId] andResultBlocck:^(BOOL result) {
                
                if (result)
                {
                    NSLog(@"数据库里对应数据减1");
                }
                
            }];
        }
    }];
}

#pragma mark ____ 数据库中相应商品数量加1 ____
- (void)addOneGoods:(FSGoods *)model
{
    [FSFMDB findSQLWithPathComponent:@"goods.sqlite"];
    
    NSString *searchOneSQL = [NSString stringWithFormat:@"select * from goods where goodsId = '%@'", model.goodsId];
    
    [FSFMDB searchOneDataWithSQL:searchOneSQL andResultBlock:^(BOOL result, NSDictionary *dict) {
        
        if (result)
        {
            int num = [[dict objectForKey:@"goodsNum"] intValue];
            num = num + 1;
            
            [FSFMDB updateWithSQL:[NSString stringWithFormat:@"update goods set goodsNum = '%d' where goodsId = '%@'", num, model.goodsId] andResultBlocck:^(BOOL result) {
                
                if (result)
                {
                    NSLog(@"数据库里对应数据加1");
                }
                
            }];
        }
    }];
}

#pragma mark ____ 全选按钮 ____
- (void)selectAllAction:(UIButton *)button
{
    [self.resultArray removeAllObjects];
    
    button.selected = !button.selected;
    
    self.isSelectAll = button.selected;
    
    if (self.isSelectAll)
    {
        
        for (FSGoods *good in self.shopcartGoodsArray) {
            
            [self.resultArray addObject:good];
        }
        
    }else
    {
        
        [self.resultArray removeAllObjects];
    }
    
    [self calculateTheTotalPrice];
    
    [self.shopcartTableView reloadData];
}

#pragma mark ____ 计算总共价格 ____
- (void)calculateTheTotalPrice
{
    double totalPrice = 0.00;
    
    for (FSGoods *model in self.resultArray)
    {
        double a = 0.00;
        
        if (model.goodsNum < 5)
        {
            a = model.goodsNum * [model.goodsPrice doubleValue];
        }
        else
        {
            a = model.goodsNum * [model.goodsPrice doubleValue] * 0.8;
        }
        
        totalPrice = totalPrice + a;
    }
    
    self.sumView.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", totalPrice];
}

#pragma mark ____ 结算按钮 ____
- (void)jiesuanAction
{
    if (self.resultArray.count == 0)
    {
        NSLog(@"不能结算");
    }
    else
    {
        FSOrderDetailVC *detailVC = [FSOrderDetailVC new];
        detailVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
