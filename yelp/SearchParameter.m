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
const int FilterCount = 4;

static NSArray *filterTypeTitles, *filterDefaultValue, *dealFilters, *sortByFilters, *categoryFilters, *radiusFilters;

+ (NSArray*) FilterTypeTitles {
    if (filterTypeTitles==nil) {
        filterTypeTitles = [NSArray arrayWithObjects:@"Deal", @"Distance", @"Sort by", @"General Features", nil];
    }
    return filterTypeTitles;
}

+ (NSArray*) filterDefaultValue {
    if (filterDefaultValue==nil) {
        filterDefaultValue = [NSArray arrayWithObjects:@(NO), @(0.0f), @(0), nil, nil];
    }
    return filterDefaultValue;
}

+ (NSArray *)getAllDealFilters {
    if (dealFilters == nil) {
        dealFilters = [[NSArray alloc] initWithObjects:
                       [[FilterItem alloc] initWith:@"With Deal Only" value:@(YES) filterType:0],
                       nil];
    }
    return dealFilters;
}

+ (NSArray *)getAllRadiusFilters {
    if (radiusFilters == nil) {
        radiusFilters = [[NSArray alloc] initWithObjects:
                           [[FilterItem alloc] initWith:@"Best Match" value:@(0.0f) filterType:1],
                           [[FilterItem alloc] initWith:@"0.3 miles" value:@(0.3f) filterType:1],
                           [[FilterItem alloc] initWith:@"1 mile" value:@(1.0f) filterType:1],
                           [[FilterItem alloc] initWith:@"5 miles" value:@(5.0f) filterType:1],
                           [[FilterItem alloc] initWith:@"20 miles" value:@(20.0f) filterType:1],
                           nil];
    }
    return radiusFilters;
}

+ (NSArray *)getAllSortByFilters {
    if (sortByFilters == nil) {
        sortByFilters = [[NSArray alloc] initWithObjects:
                         [[FilterItem alloc] initWith:@"Best Match" value:@(0) filterType:2],
                         [[FilterItem alloc] initWith:@"Distance" value:@(1) filterType:2],
                         [[FilterItem alloc] initWith:@"Rating" value:@(2) filterType:2],
                       nil];
    }
    return sortByFilters;
}

+ (NSArray *)getAllCategoryFilters {
    if (categoryFilters == nil) {
        categoryFilters = [[NSArray alloc] initWithObjects:
                           [[FilterItem alloc] initWith:@"Afghan" value:@"afghani" filterType:3],
                           [[FilterItem alloc] initWith:@"American, New" value:@"newamerican" filterType:3],
                           [[FilterItem alloc] initWith:@"Armenian" value:@"armenian" filterType:3],
                           [[FilterItem alloc] initWith:@"Asturian" value:@"asturian" filterType:3],
                           [[FilterItem alloc] initWith:@"Baguettes" value:@"baguettes" filterType:3],
                           [[FilterItem alloc] initWith:@"Barbeque" value:@"bbq" filterType:3],
                           [[FilterItem alloc] initWith:@"Bavarian" value:@"bavarian" filterType:3],
                           [[FilterItem alloc] initWith:@"Beer Garden" value:@"beergarden" filterType:3],
                           [[FilterItem alloc] initWith:@"Belgian" value:@"belgian" filterType:3],
                           [[FilterItem alloc] initWith:@"Brazilian" value:@"brazilian" filterType:3],
                           [[FilterItem alloc] initWith:@"Buffets" value:@"buffets" filterType:3],
                           [[FilterItem alloc] initWith:@"Burgers" value:@"burgers" filterType:3],
                           [[FilterItem alloc] initWith:@"Cafes" value:@"cafes" filterType:3],
                           [[FilterItem alloc] initWith:@"Cambodian" value:@"cambodian" filterType:3],
                           [[FilterItem alloc] initWith:@"Caribbean" value:@"caribbean" filterType:3],
                           [[FilterItem alloc] initWith:@"Cheesesteaks" value:@"cheesesteaks" filterType:3],
                           [[FilterItem alloc] initWith:@"Chicken Wings" value:@"chicken_wings" filterType:3],
                           [[FilterItem alloc] initWith:@"Comfort Food" value:@"comfortfood" filterType:3],
                           [[FilterItem alloc] initWith:@"Curry Sausage" value:@"currysausage" filterType:3],
                           [[FilterItem alloc] initWith:@"Diners" value:@"diners" filterType:3],
                           [[FilterItem alloc] initWith:@"Filipino" value:@"filipino" filterType:3],
                           [[FilterItem alloc] initWith:@"French" value:@"french" filterType:3],
                           [[FilterItem alloc] initWith:@"French Southwest" value:@"sud_ouest" filterType:3],
                           [[FilterItem alloc] initWith:@"Gluten-Free" value:@"gluten_free" filterType:3],
                           [[FilterItem alloc] initWith:@"Hawaiian" value:@"hawaiian" filterType:3],
                           [[FilterItem alloc] initWith:@"Hong Kong Style Cafe" value:@"hkcafe" filterType:3],
                           [[FilterItem alloc] initWith:@"Hot Pot" value:@"hotpot" filterType:3],
                           [[FilterItem alloc] initWith:@"Hot Dogs" value:@"hotdog" filterType:3],
                           [[FilterItem alloc] initWith:@"Indian" value:@"indpak" filterType:3],
                           [[FilterItem alloc] initWith:@"Japanese" value:@"japanese" filterType:3],
                           [[FilterItem alloc] initWith:@"Korean" value:@"korean" filterType:3],
                           [[FilterItem alloc] initWith:@"Latin American" value:@"latin" filterType:3],
                           [[FilterItem alloc] initWith:@"Pizza" value:@"pizza" filterType:3],
                           [[FilterItem alloc] initWith:@"Sandwiches" value:@"sandwiches" filterType:3],
                           [[FilterItem alloc] initWith:@"Soup" value:@"soup" filterType:3],
                           [[FilterItem alloc] initWith:@"Taiwanese" value:@"taiwanese" filterType:3],
                           [[FilterItem alloc] initWith:@"Vegetarian" value:@"vegetarian" filterType:3],
                           [[FilterItem alloc] initWith:@"Wok" value:@"wok" filterType:3],
                         nil];
    }
    return categoryFilters;
}

+ (SearchParameter *) defaultParameter {
    SearchParameter *result = [[SearchParameter alloc] init];
    result.term = @"Restaurants";
    result.pageCount = DefaultPageCount;
    result.startIndex = 0;
    result.latitude = 37.77493f;
    result.longitude = -122.419415;
    for (int i=0; i<FilterCount; i++) {
        [result setDefaultFilterItemValueByFilterType:i];
    }
    return result;
}

- (void)setDefaultFilterItemValueByFilterType: (NSInteger) type {
    switch (type) {
        case 0:
            self.onlySearchDeal = [[SearchParameter filterDefaultValue][type] boolValue];
            break;
        case 1:
            self.radiusFilter = [[SearchParameter filterDefaultValue][type] floatValue];
            break;
        case 2:
            self.sortBy = [[SearchParameter filterDefaultValue][type] integerValue];
            break;
        case 3:
            if (self.categoryFilters == nil) {
                self.categoryFilters = [NSMutableArray array];
            }
            [self.categoryFilters removeAllObjects];
            break;
    }
}

- (NSDictionary *)getAPISearchParameter {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:self.term forKey:@"term"];
    [result setObject:@(self.pageCount) forKey:@"limit"];
    [result setObject:@(self.startIndex) forKey:@"offset"];
    [result setObject:@(self.sortBy) forKey:@"sort"];
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

- (NSArray *)selectFilterItems: (NSArray *)filterItems byValues:(NSArray *)values {
    for(int i=0; i<filterItems.count; i++) {
        FilterItem *item = filterItems[i];
        item.isSelected = NO;
        for (int j=0; j<values.count; j++) {
            if (item.filterType == 1) { // float value compare
                if ([[NSString stringWithFormat:@"%02f", [item.value floatValue]] isEqualToString:[NSString stringWithFormat:@"%02f", [values[j] floatValue]]]) {
                    item.isSelected = YES;
                }
            }else {
                if ([[NSString stringWithFormat:@"%@", item.value] isEqualToString:[NSString stringWithFormat:@"%@", values[j]]]) {
                    item.isSelected = YES;
                }
            }
        }
    }
    return filterItems;
}

- (NSArray *)getAllFiltersByCurrentValue {
    return [NSArray arrayWithObjects:
            [self selectFilterItems:[SearchParameter getAllDealFilters] byValues:[NSArray arrayWithObjects:@(self.onlySearchDeal), nil]],
            [self selectFilterItems:[SearchParameter getAllRadiusFilters] byValues:[NSArray arrayWithObjects:@(self.radiusFilter), nil]],
            [self selectFilterItems:[SearchParameter getAllSortByFilters] byValues:[NSArray arrayWithObjects:@(self.sortBy), nil]],
            [self selectFilterItems:[SearchParameter getAllCategoryFilters] byValues:self.categoryFilters],
            nil];
}

- (void)updateFilterByFilterItem: (FilterItem *)filterItem {
    switch (filterItem.filterType) {
        case 0:
            self.onlySearchDeal = filterItem.isSelected ? [filterItem.value boolValue] : [[SearchParameter filterDefaultValue][filterItem.filterType] boolValue];
            break;
        case 1:
            self.radiusFilter = filterItem.isSelected ? [filterItem.value floatValue] : [[SearchParameter filterDefaultValue][filterItem.filterType] floatValue];
            break;
        case 2:
            self.sortBy = filterItem.isSelected ? [filterItem.value integerValue] : [[SearchParameter filterDefaultValue][filterItem.filterType] integerValue];
            break;
        case 3:
            if (filterItem.isSelected) {
                [self.categoryFilters addObject:filterItem.value];
            } else {
                [self.categoryFilters removeObject:filterItem.value];
            }
            break;
    }
}

@end
