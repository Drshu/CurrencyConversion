//
//  ViewController.m
//  currencyTransform
//
//  Created by shucheng on 16/5/27.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>
#import "chosenViewController.h"
#import "DataFromDataBase.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import <MGSwipeTableCell.h>


static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
@interface ViewController ()

@property(nonatomic,strong)FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加右上角的『加号』
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;

    UITableView *tableView = (id)[self.view viewWithTag:1];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;//调整表视图顶部边缘值
    [tableView setContentInset:contentInset];
    
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView stopLoading];
            //第一步，创建URL
            NSURL *url = [NSURL URLWithString:@"http://www.blublu.top/api/v1/allcurrencies"];
            //第二步，创建请求
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

            [request setHTTPMethod:@"GET"];//设置请求方式为POST，默认为GET
            NSString *str =[NSString stringWithFormat:@""];//设置参数
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            //第三步，连接服务器
            NSError *error;
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];

            NSDictionary *currencyDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
                        NSLog(@"%@",str1);
            //NSDictionary *country
        });
    } LoadingView:loadingViewCircle];
    [self.tableView setJElasticPullToRefreshFillColor:[UIColor colorWithRed:0.0431 green:0.7569 blue:0.9412 alpha:1.0]];
    [self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];




}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
        //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"countryList.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_countryList (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL,currencyName text ,countryShort text );"];
        
        if (result) {
            NSLog(@"创表成功");
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM t_countryList"];
            
            if([resultSet next] == NO){
                NSString *defaultName = @"CNY";
                NSString *defaultCurrencyName = @"CN";
                NSString *defaultCountryShort = @"Y";
                [db executeUpdate:@"INSERT INTO t_countryList (name,currencyName,countryShort) VALUES (?,?,?);",defaultName,defaultCurrencyName,defaultCountryShort];
                
            }
        }
        
    }else
    {
        NSLog(@"创表失败");
    }
    self.db = db;
    [self query];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}


-(void)query{
    self.nameArray = [[NSMutableArray alloc]init];
    
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_countryList"];
    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *currencyName = [resultSet stringForColumn:@"currencyName"];
        NSString *countryShort = [resultSet stringForColumn:@"countryShort"];
        NSLog(@"%d %@ %@ %@", ID, name, currencyName,countryShort);
        [self.nameArray addObject:name];
    }
    [[DataFromDataBase shareFromDataBase].nameArrayFromClass arrayByAddingObjectsFromArray:self.nameArray];
    NSLog(@"self.nameArray == %@",self.nameArray);

}

-(void)insertNewObject{
    //chosenViewController *chosenCountry = [[chosenViewController alloc]initWithNibName:@"chosenCountry" bundle:nil];
    //self.chosenViewController = chosenCountry;
    //[self.navigationController pushViewController:chosenCountry animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"chosenCountry"];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma -
#pragma UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.nameArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    
    if (cell == nil) {
        cell = [[MGSwipeTableCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SectionsTableIdentifier];
    }
    NSLog(@"self.nameArray == %@",self.nameArray);
    
    cell.textLabel.text =self.nameArray[indexPath.row];
    cell.delegate = self;
    cell.allowsMultipleSwipe = NO;
     cell.rightExpansion.fillOnTrigger = YES;
    //configure left buttons
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"fav.png"] backgroundColor:[UIColor greenColor]]];
    cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    
    
    //configure right buttons
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor]]];
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    return cell;
}


//-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        return nil;//第一行的时候返回nil
//    }else{
//        return indexPath;//传递即将选中的行对应的索引
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSString *chooseName = self.nameArray[indexPath.row];
    NSLog(@"tag :: %ld",indexPath.row);
        [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
}



-(BOOL)tableView:(UITableView*)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}


-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        //delete button
        NSIndexPath * path = [_tableView indexPathForCell:cell];
        [self.db executeUpdate:@"delete from t_countryList where name = (?) ;",_nameArray[path.row]];

        [_nameArray removeObjectAtIndex:path.row];
        [_tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
               return NO; //Don't autohide to improve delete expansion animation
    }
    
    return YES;
}


#pragma -
#pragma head reload
- (NSArray *)btnLeftCount:(int)count
{
    NSMutableArray *result = [NSMutableArray array];
    UIColor *colors[3] = {[UIColor greenColor],
        [UIColor colorWithRed:0 green:0x99/255.0 blue:0xcc/255.0 alpha:1.0],
        [UIColor colorWithRed:0.59 green:0.29 blue:0.08 alpha:1.0]};;
    for (int i = 0; i < count; i ++) {
        // 按钮提供了几个方法, 可以点进去看一看
        MGSwipeButton *btn = [MGSwipeButton buttonWithTitle:@"" backgroundColor:colors[i] padding:15 callback:^BOOL(MGSwipeTableCell *sender) {
            return YES;
        }];
        // 把按钮加到数组中
        [result addObject:btn];
    }
    return result;
}
@end
