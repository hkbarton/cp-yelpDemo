//
//  MapAnnotationDetailView.m
//  yelp
//
//  Created by Ke Huang on 2/14/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "MapAnnotationDetailView.h"
#import "UIImageView+AFNetworking.h"

@implementation MapAnnotationDetailView

const CGFloat WIDTH = 170;
const CGFloat HEIGHT = 68;
const CGFloat MARGIN = 3;

CGRect finalFrame;

-(void)setBusiness:(Business *)business withPinFrame:(CGRect)frame {
    finalFrame = CGRectMake(-WIDTH/2+frame.size.width/2-MARGIN, -HEIGHT-MARGIN, WIDTH, HEIGHT);
    self.frame = CGRectMake(finalFrame.origin.x, -MARGIN, WIDTH, 0);
    self.alpha = 0;
    self.labelName.text = business.name;
    self.labelCategories.text = business.categories;
    self.labelReviewCount.text = [NSString stringWithFormat:@"%ld reviews", business.numOfReviews];
    [self.imageRating setImageWithURL:[NSURL URLWithString:business.ratingImageUrl]];
}

-(void)updateFrameAndBound {
    self.frame = finalFrame;
    self.alpha = 0.7;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = 4.0f;
}

@end
