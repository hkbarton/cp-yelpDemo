//
//  FilterItem.h
//  yelp
//
//  Created by Ke Huang on 2/12/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterItem : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) NSInteger filterType;
@property (nonatomic, strong) id value;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isCollapsed;

-(FilterItem *)initWith:(NSString *)key value:(id)value filterType:(NSInteger)filterType;

@end
