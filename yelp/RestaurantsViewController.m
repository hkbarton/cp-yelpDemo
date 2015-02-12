//
//  RestaurantsViewController.m
//  yelp
//
//  Created by Ke Huang on 2/9/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "YelpService.h"
#import "SearchParameter.h"
#import "Business.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "RestaurantTableViewCell.h"

@interface RestaurantsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SearchParameter *searchParameter;
@property (nonatomic, strong) NSMutableArray *businesses;
@property (nonatomic, assign) BOOL hasNextPage;

@end

@implementation RestaurantsViewController

NSString *const TABLE_VIEW_CELL_ID = @"RestaurantTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup navigation bar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButtonClicked:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(onMapButtonClicked:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    // init table view
    [self.tableView registerNib:[UINib nibWithNibName:@"RestaurantTableViewCell" bundle:nil] forCellReuseIdentifier:TABLE_VIEW_CELL_ID];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:loadingView];
    self.tableView.tableFooterView = tableFooterView;
    self.tableView.tableFooterView.hidden = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 99;
    
    // init data
    self.businesses = [NSMutableArray array];
    self.searchParameter = [SearchParameter defaultParameter];
    self.hasNextPage = NO;
    
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onFilterButtonClicked:(id)sender {
    
}

- (void)onMapButtonClicked:(id)sender {
    
}

#pragma mark - Util

- (void)loadData {
    [[YelpService defaultService] searchBusiness:self.searchParameter withCallback:^(NSArray *data, NSError *err) {
        [SVProgressHUD dismiss];
        [self.tableRefreshControl endRefreshing];
        if (err != nil) {
            // TODO error handle
            return;
        }
        self.hasNextPage = data.count == self.searchParameter.pageCount ? YES : NO;
        if (!self.hasNextPage) {
            self.tableView.tableFooterView.hidden = YES;
        }
        [self.businesses addObjectsFromArray:data];
        [self.tableView reloadData];
    }];
}

- (void)reloadData {
    [self.businesses removeAllObjects];
    [self.searchParameter resetPagingParameter];
    [self loadData];
}

- (void)refreshView {
    [SVProgressHUD show];
    [self reloadData];
}

- (void)loadImage:(__weak UIImageView *)imageView withURL:(NSString *)url {
    NSURL *posterUrl = [NSURL URLWithString:url];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3.0f];
    [imageView setImageWithURLRequest:posterRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        imageView.image = image;
        // Only animate image fade in when result come from network
        if (response != nil) {
            imageView.alpha = 0;
            [UIView animateWithDuration:0.7f animations:^{
                imageView.alpha = 1.0f;
            }];
        }
    } failure:nil];
}

#pragma mark - Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // do search
    [searchBar resignFirstResponder];
}

#pragma mark - Table View

// fix separator inset bug
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_CELL_ID];
    
    Business *business = self.businesses[indexPath.row];
    [self loadImage:cell.imageBusiness withURL:business.imageUrl];
    cell.labelName.text = business.name;
    cell.labelDistance.text = [NSString stringWithFormat:@"%.02f mi", business.distance];
    [cell.imageRating setImageWithURL:[NSURL URLWithString:business.ratingImageUrl]];
    cell.labelReviewCount.text = [NSString stringWithFormat:@"%ld Reviews", business.numOfReviews];
    cell.labelAddress.text = business.address;
    cell.labelCategory.text = business.categories;
    
    if (indexPath.row >= self.businesses.count -1 && self.hasNextPage) {
        tableView.tableFooterView.hidden = NO;
        [self.searchParameter nextPage];
        [self loadData];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
