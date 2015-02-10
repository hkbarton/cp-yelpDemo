//
//  RestaurantsViewController.m
//  yelp
//
//  Created by Ke Huang on 2/9/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "YelpService.h"

@interface RestaurantsViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *buttonFilter;
@property (nonatomic, strong) UIButton *buttonMap;

@end

@implementation RestaurantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup navigation bar
    self.searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    
    self.buttonFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    self.buttonFilter.frame = CGRectMake(0, 0, 60, 0);
    [self.buttonFilter setTitle:@"Filter" forState:UIControlStateNormal];
    [self.buttonFilter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonFilter addTarget:self action:@selector(onFilterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonFilter];
    
    self.buttonMap = [UIButton buttonWithType:UIButtonTypeSystem];
    self.buttonMap.frame = CGRectMake(0, 0, 60, 0);
    [self.buttonMap setTitle:@"Map" forState:UIControlStateNormal];
    [self.buttonMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonMap addTarget:self action:@selector(onMapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.buttonMap];
    
    // Do any additional setup after loading the view from its nib.
    [[YelpService defaultService] searchWithTerm:@"Thai" withCallback:^(NSArray *data, NSError *err) {
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFilterButtonClicked:(id)sender {
    
}

- (void)onMapButtonClicked:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
