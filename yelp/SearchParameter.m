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

static NSArray *dealFilters, *sortByFilters, *categoryFilters, *radiusFilters;

+ (NSArray *)getAllDealFilters {
    if (dealFilters == nil) {
        dealFilters = [[NSArray alloc] initWithObjects:
                       [[FilterItem alloc] initWith:@"With Deal Only" value:@(YES)],
                       nil];
    }
    return dealFilters;
}

+ (NSArray *)getAllRadiusFilters {
    if (radiusFilters == nil) {
        radiusFilters = [[NSArray alloc] initWithObjects:
                           [[FilterItem alloc] initWith:@"Best Match" value:@(0.0f)],
                           [[FilterItem alloc] initWith:@"0.3 miles" value:@(0.3f)],
                           [[FilterItem alloc] initWith:@"1 mile" value:@(1.0f)],
                           [[FilterItem alloc] initWith:@"5 miles" value:@(5.0f)],
                           [[FilterItem alloc] initWith:@"20 miles" value:@(20.0f)],
                           nil];
    }
    return radiusFilters;
}

+ (NSArray *)getAllSortByFilters {
    if (sortByFilters == nil) {
        sortByFilters = [[NSArray alloc] initWithObjects:
                         [[FilterItem alloc] initWith:@"Best Match" value:@(0)],
                         [[FilterItem alloc] initWith:@"Distance" value:@(1)],
                         [[FilterItem alloc] initWith:@"Rating" value:@(2)],
                       nil];
    }
    return sortByFilters;
}

+ (NSArray *)getAllCategoryFilters {
    if (categoryFilters == nil) {
        categoryFilters = [[NSArray alloc] initWithObjects:
                         [[FilterItem alloc] initWith:@"" value:@""],
                         nil];
    }
    return categoryFilters;
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

- (NSArray *)selectFilterItemsBy: (NSArray *)filterItems byValues:(NSArray *)values {
    for(int i=0; i<filterItems.count; i++) {
        FilterItem *item = filterItems[i];
        item.isSelected = NO;
        for (int j=0; j<values.count; j++) {
            if ([[item.value stringValue] isEqualToString:[values[j] stringValue]]) {
                item.isSelected = YES;
            }
        }
    }
    return filterItems;
}

- (NSArray *)getAllFiltersByCurrentValue {
    return [NSArray arrayWithObjects:
            [self selectFilterItemsBy:[SearchParameter getAllDealFilters] byValues:[NSArray arrayWithObjects:@(self.onlySearchDeal), nil]],
            [self selectFilterItemsBy:[SearchParameter getAllRadiusFilters] byValues:[NSArray arrayWithObjects:@(self.radiusFilter), nil]],
            [self selectFilterItemsBy:[SearchParameter getAllSortByFilters] byValues:[NSArray arrayWithObjects:@(self.sortBy), nil]],
            [self selectFilterItemsBy:[SearchParameter getAllCategoryFilters] byValues:self.categoryFilters],
            nil];
}

- (void)updateFilterValue: (NSArray *)filters {
    
}

@end
