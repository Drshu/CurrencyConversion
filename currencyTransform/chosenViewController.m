//
//  chosenViewController.m
//  currencyTransform
//
//  Created by shucheng on 16/5/28.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "chosenViewController.h"
#import <FMDB.h>

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface chosenViewController ()
@property (nonatomic, strong) NSMutableArray *nameArray;
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)FMDatabase *db;
@property (weak, nonatomic) IBOutlet UITableView *chosentableView;
@property(nonatomic,strong) NSData *jsonData;
@end

@implementation chosenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
//        //1.获得数据库文件的路径
//    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName=[doc stringByAppendingPathComponent:@"supportList.sqlite"];
//    
//    //2.获得数据库
//    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
//    
//    //3.打开数据库
//    if ([db open]) {
//        //4.创表
//        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_supportList (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, introduction text NOT NULL, lastDate text NOT NULL, allDate text NOT NULL);"];
//        
//        if (result) {
//            NSLog(@"创表成功");
//            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM t_show"];
//            
//            if([resultSet next] == NO){
//                NSString *defaultName = @"Please add a TV Show name";
//                NSString *defaultIntroduction = @"Your show's introduction";
//                NSString *defaultLastDate = @"S01E01";
//                NSString *defaultAllDate = @"S20E20";
//                [db executeUpdate:@"INSERT INTO t_show (name,introduction,lastDate,allDate) VALUES (?,?,?,?);",defaultName,defaultIntroduction,defaultLastDate,defaultAllDate];
//                
//            }
//        }
//        
//    }else
//    {
//        NSLog(@"创表失败");
//    }
    

    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"supportList" ofType:@"plist"];
    NSMutableArray *data =[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    NSLog(@"data count:%lu",(unsigned long)data.count);
    NSLog(@"data:%@",data);
    self.data = data;
    NSString *jsonString = [[NSString alloc] initWithData:_jsonData
                            
                                                 encoding:NSUTF8StringEncoding];
    
    NSLog(@"json:%@",jsonString);
   }


// 将字典或者数组转化为JSON串

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.data
                        
                                                       options:NSJSONWritingPrettyPrinted
                        
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        
        return jsonData;
        
    }else{
        
        return nil;
        
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
       NSLog(@"data:%@",self.data);
    return _data.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)chosentableView{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SectionsTableIdentifier];
    }
    NSLog(@"self.data == %@",self.data);
    
    cell.textLabel.text =self.data[indexPath.row];
    return cell;
}
-(NSIndexPath *)chosentableView:(UITableView *)chosentableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return nil;//第一行的时候返回nil
    }else{
        return indexPath;//传递即将选中的行对应的索引
    }
}

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
