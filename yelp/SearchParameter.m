//
//  SearchParameter.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "SearchParameter.h"

@implementation SearchParameter

+ (NSDictionary *)getAllSortByTypes {
    return [NSDictionary dictionaryWithObjectsAndKeys:0, @"Best Match", 1, @"Distance", 2, @"Rating", nil];
}

+ (NSArray *)getAllCategoryFilters {
    return [NSArray arrayWithObjects:@"", nil];
}

+ (NSDictionary *)getAllRadiusFilter {
    return [NSDictionary dictionaryWithObjectsAndKeys:@(0.0f), @"Best Match", @(0.3f), @"0.3 miles", @(1.0f), @"1 miles", @(5.0f), @"5 miles", @(20.0f), @"20 miles", nil];
}

+ (SearchParameter *) defaultParameter {
    SearchParameter *result = [[SearchParameter alloc] init];
    result.term = @"Restaurants";
    result.pageCount = 15;
    result.startIndex = 0;
    result.sortBy = 0;
    result.categoryFilter = nil;
    result.radiusFilter = 0.0f;
    result.onlySearchDeal = NO;
    return result;
}

@end
