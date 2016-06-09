//
//  ViewController.h
//  currencyTransform
//
//  Created by shucheng on 16/5/27.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chosenViewController.h"
#import <MGSwipeTableCell.h>


@interface ViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate,MGSwipeTableCellDelegate>

@property(strong,nonatomic)chosenViewController *chosenViewController;
@end

