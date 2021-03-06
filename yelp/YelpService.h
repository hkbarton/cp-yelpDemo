//
//  YelpService.h
//  yelp
//
//  Created by Ke Huang on 2/9/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "SearchParameter.h"

@interface YelpService : BDBOAuth1RequestOperationManager

- (void) searchBusiness:(SearchParameter *) param withCallback:(void(^)(NSArray *data, NSError *err)) callback;

+ (id)defaultService;

@end
