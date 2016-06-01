//
//  ViewController.h
//  currencyTransform
//
//  Created by shucheng on 16/5/27.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chosenViewController.h"


@interface ViewController : UIViewController
<UIAlertViewDelegate> 

@property(strong,nonatomic)chosenViewController *chosenViewController;
@end

