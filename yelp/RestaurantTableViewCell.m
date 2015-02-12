//
//  RestaurantTableViewCell.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "RestaurantTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation RestaurantTableViewCell

- (void)awakeFromNib {
    self.labelName.preferredMaxLayoutWidth = self.labelName.frame.size.width;
    self.imageBusiness.layer.cornerRadius = 4.0f;
    self.imageBusiness.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.labelName.preferredMaxLayoutWidth = self.labelName.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadImage:(__weak UIImageView *)imageView withURL:(NSString *)url {
    NSURL *posterUrl = [NSURL URLWithString:url];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3.0f];
    [imageView setImageWithURLRequest:posterRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        imageView.image = image;
        // Only animate image fade in when result come from network
        if (response != nil) {
            imageView.alpha = 0;
            [UIView animateWithDuration:0.7f animations:^{
                imageView.alpha = 1.0f;
            }];
        }
    } failure:nil];
}

- (void)setBusiness: (Business *)business {
    [self loadImage:self.imageBusiness withURL:business.imageUrl];
    self.labelName.text = business.name;
    self.labelDistance.text = [NSString stringWithFormat:@"%.02f mi", business.distance];
    [self.imageRating setImageWithURL:[NSURL URLWithString:business.ratingImageUrl]];
    self.labelReviewCount.text = [NSString stringWithFormat:@"%ld Reviews", business.numOfReviews];
    self.labelAddress.text = business.address;
    self.labelCategory.text = business.categories;
}

@end
