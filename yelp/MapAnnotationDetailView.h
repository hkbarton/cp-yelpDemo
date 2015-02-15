//
//  MapAnnotationDetailView.h
//  yelp
//
//  Created by Ke Huang on 2/14/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface MapAnnotationDetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageRating;
@property (weak, nonatomic) IBOutlet UILabel *labelReviewCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCategories;

-(void)setBusiness:(Business *)business withPinFrame:(CGRect)frame;
-(void)updateFrameAndBound;

@end
