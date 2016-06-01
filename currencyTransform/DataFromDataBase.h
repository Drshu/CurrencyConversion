//
//  DataFromDataBase.h
//  currencyTransform
//
//  Created by shucheng on 16/5/31.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFromDataBase : NSObject


@property(retain,nonatomic) NSString *nameFromClass;

@property(retain,nonatomic)NSString *currencyNameFromClass;

@property(retain,nonatomic)NSString *countryShortFromClass;

@property(retain,nonatomic)NSMutableArray *nameArrayFromClass;

+(DataFromDataBase *)shareFromDataBase;
@end
