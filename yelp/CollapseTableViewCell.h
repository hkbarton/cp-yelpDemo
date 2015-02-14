//
//  CollapseTableViewCell.h
//  yelp
//
//  Created by Ke Huang on 2/13/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollapseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelCollapseStatus;

@property (assign, nonatomic) BOOL isCollapse;

@end
