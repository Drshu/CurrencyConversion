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
                NSString *defaultName = @"China";
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SectionsTableIdentifier];
    }
    NSLog(@"self.nameArray == %@",self.nameArray);
    
    cell.textLabel.text =self.nameArray[indexPath.row];
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
    if(indexPath.row != 0){
        [self performSegueWithIdentifier:@"showDetail" sender:indexPath];
    }
    
}

-(BOOL)tableView:(UITableView*)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
