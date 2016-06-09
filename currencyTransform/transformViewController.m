//
//  transformViewController.m
//  currencyTransform
//
//  Created by shucheng on 16/6/5.
//  Copyright © 2016年 shucheng. All rights reserved.
//

#import "transformViewController.h"

@interface transformViewController ()
@property(weak,nonatomic)IBOutlet UIPickerView *countryPicker;
@property (strong,nonatomic)NSArray *country;
@property(strong,nonatomic)NSArray *name;

@end

@implementation transformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"supportList" withExtension:@"plist"];
    self.country = [NSArray arrayWithContentsOfURL:plistURL];
//    NSString *selectedCountry = self.country[0];
//    self.country = self.countryPicker[self.country[0]];
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    
//}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.country count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.country[row];
}

@end
