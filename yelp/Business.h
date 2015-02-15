//
//  Business.h
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Business : NSObject<MKAnnotation>

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, assign) NSInteger numOfReviews;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *neighborhoods;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) NSString *phone;

+ (NSArray *)businessesWithDictionaries: (NSArray *)dictinoaries;

@end
