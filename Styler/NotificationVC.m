//
//  NotificationVC.m
//  Styler
//
//  Created by Apple on 5/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import "NotificationVC.h"
#import "Firebase.h"

@interface NotificationVC ()

@end

@implementation NotificationVC{
    NSMutableArray *notiCustomer;
    Firebase *customerNotiRef;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFirebase];
    _tableView.backgroundColor = [UIColor clearColor];
    NSDictionary *allNoti =[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"customerNoti"]];
    notiCustomer = [NSMutableArray arrayWithArray:allNoti.allValues];

}
- (void) createFirebase{
    NSString *customerID = [[NSUserDefaults standardUserDefaults]objectForKey:@"idcustomer"];
    customerNotiRef = [[[Firebase alloc]initWithUrl:@"https://stylerapplication.firebaseio.com/noti"]childByAppendingPath:customerID];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return notiCustomer.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *notiRoom = notiCustomer[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",notiRoom[@"content"],notiRoom[@"date"]];
    if ([notiRoom[@"status"] isEqualToString:@"opened"]) {
     cell.contentView.alpha = 0.5;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    CGSize boundingSize = CGSizeMake(cell.frame.size.width - 50, 200);
    UIFont *font = [UIFont fontWithName:@"Baskerville" size:17];
    NSString *text = [NSString stringWithFormat:@"%@\n%@",notiCustomer[indexPath.row][@"content"],notiCustomer[indexPath.row][@"date"]];
    
    CGRect textRect = [text boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return  MAX(textRect.size.height, 60);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *notiRoom = [NSMutableDictionary dictionaryWithDictionary:notiCustomer[indexPath.row]];
    if ([notiRoom[@"status"] isEqualToString:@"off"]){
        // update
        notiRoom[@"status"] = @"opened";
//        [UIApplication sharedApplication].applicationIconBadgeNumber -=1;
        
        [self updateNotiRoom:notiRoom];
        
        notiCustomer[indexPath.row] = notiRoom;
        [tableView reloadData];
    }
    
    
}
- (void) updateNotiRoom:(NSDictionary*)notiRoom{
    NSString *notiId = [NSString stringWithFormat:@"%@",notiRoom[@"notiid"]];
    Firebase *roomRef = [customerNotiRef childByAppendingPath:notiId];
    [roomRef setValue:notiRoom withCompletionBlock:^(NSError*error, Firebase*ref){
        // only update badge after data transmit to serve
        [UIApplication sharedApplication].applicationIconBadgeNumber -=1;
        [self updateNotiInClient];
    }];
    
}
- (void) updateNotiInClient{
    [customerNotiRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot*snapShot){
        if (snapShot.value!=[NSNull null]){
            [[NSUserDefaults standardUserDefaults]setObject:snapShot.value forKey:@"customerNoti"];
        }
        
    }];
}

- (IBAction)onDoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
