//
//  SearchParameter.h
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FilterItem.h"

@interface SearchParameter : NSObject

@property (nonatomic, strong) NSString *term;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger sortBy;
@property (nonatomic, strong) NSMutableArray *categoryFilters;
@property (nonatomic, assign) CGFloat radiusFilter;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) BOOL onlySearchDeal;

- (NSDictionary *)getAPISearchParameter;
- (void)resetPagingParameter;
- (void)nextPage;

- (NSArray *)getAllFiltersByCurrentValue;
- (void)updateFilterByFilterItem: (FilterItem *)filterItem;

+ (SearchParameter *) defaultParameter;

+ (NSArray*) FilterTypeTitles;

@end
