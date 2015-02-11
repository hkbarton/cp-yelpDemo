//
//  SearchParameter.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "SearchParameter.h"

@implementation SearchParameter

const float MeterPerMile = 1609.34f;
const int DefaultPageCount = 20;

+ (NSDictionary *)getAllSortByTypes {
    return [NSDictionary dictionaryWithObjectsAndKeys:0, @"Best Match", 1, @"Distance", 2, @"Rating", nil];
}

+ (NSArray *)getAllCategoryFilters {
    // TODO add categories
    return [NSArray arrayWithObjects:@"", nil];
}

+ (NSDictionary *)getAllRadiusFilter {
    return [NSDictionary dictionaryWithObjectsAndKeys:@(0.0f), @"Best Match", @(0.3f), @"0.3 miles", @(1.0f), @"1 miles", @(5.0f), @"5 miles", @(20.0f), @"20 miles", nil];
}

+ (SearchParameter *) defaultParameter {
    SearchParameter *result = [[SearchParameter alloc] init];
    result.term = @"Restaurants";
    result.pageCount = DefaultPageCount;
    result.startIndex = 0;
    result.sortBy = 0;
    result.categoryFilters = [NSMutableArray array];
    result.radiusFilter = 0.0f;
    result.latitude = 37.77493f;
    result.longitude = -122.419415;
    result.onlySearchDeal = NO;
    return result;
}

- (NSDictionary *)getAPISearchParameter {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:self.term forKey:@"term"];
    [result setObject:@(self.pageCount) forKey:@"limit"];
    [result setObject:@(self.startIndex) forKey:@"offset"];
    [result setObject:@(self.sortBy) forKey:@"@sort"];
    if (self.categoryFilters != nil && self.categoryFilters.count > 0) {
        [result setObject:[self.categoryFilters componentsJoinedByString:@","] forKey:@"category_filter"];
    }
    if (self.radiusFilter > 0) {
        [result setObject:@(self.radiusFilter * MeterPerMile) forKey:@"radius_filter"];
    }
    NSString *location = [NSString stringWithFormat:@"%f,%f", self.latitude, self.longitude];
    [result setObject:location forKey:@"ll"];
    if (self.onlySearchDeal) {
        [result setObject:@"true" forKey:@"deals_filter"];
    }
    return result;
}

- (void)resetPagingParameter {
    self.startIndex = 0;
}

- (void)nextPage {
    self.startIndex += self.pageCount;
}

@end
