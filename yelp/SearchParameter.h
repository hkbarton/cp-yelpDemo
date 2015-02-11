//
//  SearchParameter.h
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SearchParameter : NSObject

@property (nonatomic, strong) NSString *term;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger sortBy;
@property (nonatomic, strong) NSString *categoryFilter;
@property (nonatomic, assign) CGFloat radiusFilter;
@property (nonatomic, assign) BOOL onlySearchDeal;

+ (SearchParameter *) defaultParameter;

+ (NSDictionary *)getAllSortByTypes;
+ (NSArray *)getAllCategoryFilters;
+ (NSDictionary *)getAllRadiusFilter;

@end