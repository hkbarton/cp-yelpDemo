//
//  FilterViewController.h
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchParameter.h"

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController:(FilterViewController *) filterViewContorller didChangeFileters:(SearchParameter *)filters;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) SearchParameter* filters;
@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end
