//
//  FilterItem.m
//  yelp
//
//  Created by Ke Huang on 2/12/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "FilterItem.h"

@implementation FilterItem

-(FilterItem *)initWith:(NSString *)key value:(id)value {
    if (self = [super init]) {
        self.key = key;
        self.value = value;
        self.isSelected = NO;
    }
    return self;
}

@end
