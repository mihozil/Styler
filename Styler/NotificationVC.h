//
//  NotificationVC.h
//  Styler
//
//  Created by Apple on 5/16/16.
//  Copyright © 2016 AMOSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
