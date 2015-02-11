//
//  Business.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.imageUrl = dictionary[@"image_url"];
        self.name = dictionary[@"name"];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        self.numOfReviews = [dictionary[@"review_count"] integerValue];
        self.street = [dictionary valueForKeyPath:@"location.address"][0];
        self.neighborhoods = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
        self.city = [dictionary valueForKeyPath:@"location.city"];
        self.address = [NSString stringWithFormat:@"%@, %@", self.street, self.neighborhoods];
        self.latitude = [[dictionary valueForKeyPath:@"location.coordinate.latitude"] floatValue];
        self.longitude = [[dictionary valueForKeyPath:@"location.coordinate.longitude"] floatValue];
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [[categoryNames copy] componentsJoinedByString:@", "];
        //self.distance = dictionary[@"distance"]
        self.phone = dictionary[@"display_phone"];
    }
    return self;
}

+ (NSArray *)businessesWithDictionaries: (NSArray *)dictinoaries {
    NSMutableArray *businesses = [NSMutableArray array];
    for (NSDictionary *dictionary in dictinoaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    return businesses;
}

@end