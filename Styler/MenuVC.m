//
//  MenuVC.m
//  Styler
//
//  Created by Apple on 4/28/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "MenuVC.h"
#import "SignInVC.h"

@implementation MenuVC{
    NSArray*menuArray;
    NSDictionary *userData;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    menuArray = @[@"user",@"profile",@"notification",@"payment"];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"0menuBg.png"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:menuArray[indexPath.row] forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) return 120;
    else return 60;
}
- (IBAction)onSignoutBt:(id)sender {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"idcustomer"];
    
}

@end
