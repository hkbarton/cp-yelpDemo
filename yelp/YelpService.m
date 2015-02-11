//
//  YelpService.m
//  yelp
//
//  Created by Ke Huang on 2/9/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "YelpService.h"
#import "Business.h"

NSString *const CONSUMER_KEY = @"IV7gz2IYcmz5VHCMZ2rggQ";
NSString *const CONSUMER_SECRET = @"2zRW7oCrWRssYWQsswIbWXDV63g";
NSString *const ACCESS_TOKEN = @"uoV13mAr9QdB9lDXCXu9tSN0EPS5Tm3d";
NSString *const ACCESS_TOKEN_SECRET = @"fqYTNBX_mJzd36qEgp46amuZYlg";

NSString *const URL_BASE = @"http://api.yelp.com/v2/";

static YelpService *_defaultService = nil;

@implementation YelpService

- (YelpService *)init {
    if (self = [super initWithBaseURL:[NSURL URLWithString:URL_BASE] consumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET]) {
        BDBOAuth1Credential *token = [[BDBOAuth1Credential alloc] initWithToken:ACCESS_TOKEN secret:ACCESS_TOKEN_SECRET expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (void) searchWithTerm:(SearchParameter *) param withCallback:(void(^)(NSArray *data, NSError *err)) callback {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // TODO
    
    [self GET:@"search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *businessDictinary = responseObject[@"businesses"];
        NSArray *result = [Business businessesWithDictionaries:businessDictinary];
        callback(result, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, error);
    }];
}

+ (id)defaultService {
    if (_defaultService == nil) {
        _defaultService = [[YelpService alloc] init];
    }
    return _defaultService;
}

@end
