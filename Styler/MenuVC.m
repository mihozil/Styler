//
//  MenuVC.m
//  Styler
//
//  Created by Apple on 4/28/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "MenuVC.h"
#import "SignInVC.h"
#import "TableViewCell.h"
#import "MKNumberBadgeView.h"

@implementation MenuVC{
    NSArray*menuArray;
    NSDictionary *userData;
    NSIndexPath *userIndexPath;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    menuArray = @[@"user",@"profile",@"notification",@"payment"];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"0menuBg.png"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)viewWillAppear:(BOOL)animated{
    if (userIndexPath) [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:userIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        userIndexPath = indexPath;
        TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:menuArray[indexPath.row] forIndexPath:indexPath];
        [self updateBadgeView:cell];
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:menuArray[indexPath.row] forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}
- (void) updateBadgeView:(TableViewCell*)cell{
    MKNumberBadgeView *badgeView = [[MKNumberBadgeView alloc]initWithFrame:CGRectMake(cell.imgLayerView.frame.size.width-40, 0, 40, 40)];
    badgeView.value = [[UIApplication sharedApplication]applicationIconBadgeNumber];
    
    for (MKNumberBadgeView *view in cell.imgLayerView.subviews){
        [view removeFromSuperview];
    }
    
    if (badgeView.value>0) [cell.imgLayerView addSubview:badgeView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) return 120;
    else return 60;
}
- (IBAction)onSignoutBt:(id)sender {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"idcustomer"];    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
