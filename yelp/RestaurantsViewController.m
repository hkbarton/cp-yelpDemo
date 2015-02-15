//
//  RestaurantsViewController.m
//  yelp
//
//  Created by Ke Huang on 2/9/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RestaurantsViewController.h"
#import "YelpService.h"
#import "SearchParameter.h"
#import "Business.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "RestaurantTableViewCell.h"
#import "FilterViewController.h"
#import "MapAnnotationDetailView.h"

typedef enum{
    TYPE_TableView, TYPE_MapView
} ViewType;

@interface RestaurantsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) FilterViewController *filterViewControler;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIActivityIndicatorView *infiniteLoadingView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) SearchParameter *searchParameter;
@property (nonatomic, strong) NSMutableArray *businesses;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, assign) ViewType viewType;

@end

@implementation RestaurantsViewController

NSString *const TABLE_VIEW_CELL_ID = @"RestaurantTableViewCell";
NSString * const AID = @"BusinessAnnotation";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewType = TYPE_TableView;
    self.tableView.hidden = NO;
    self.mapView.hidden = YES;
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
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    self.infiniteLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.infiniteLoadingView startAnimating];
    [self.tableFooterView addSubview:self.infiniteLoadingView];
    self.tableView.tableFooterView = self.tableFooterView;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 99;
    
    // init map view
    self.mapView.delegate = self;
    
    // filter view controller
    self.filterViewControler = [[FilterViewController alloc] init];
    self.filterViewControler.delegate = self;
    
    // init and load data
    self.businesses = [NSMutableArray array];
    self.searchParameter = [SearchParameter defaultParameter];
    self.hasNextPage = NO;
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onFilterButtonClicked:(id)sender {
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self.filterViewControler];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed:184.0f/255.0f green:11.0f/255.0f blue:4.0f/255.0f alpha:1.0f];
    [self.filterViewControler setSearchParameter:self.searchParameter];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)filterViewController:(FilterViewController *) filterViewContorller didChangeFileters:(SearchParameter *)param {
    self.searchParameter = param;
    [self refreshView];
}

- (void)onMapButtonClicked:(id)sender {
    if (self.viewType == TYPE_TableView) {
        self.viewType = TYPE_MapView;
        self.navigationItem.rightBarButtonItem.title = @"List";
        [UIView transitionFromView:self.tableView toView:self.mapView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight + UIViewAnimationOptionShowHideTransitionViews completion:nil];
    } else if (self.viewType == TYPE_MapView) {
        self.viewType = TYPE_TableView;
        self.navigationItem.rightBarButtonItem.title = @"Map";
        [UIView transitionFromView:self.mapView toView:self.tableView duration:1.0f options:UIViewAnimationOptionTransitionFlipFromLeft + UIViewAnimationOptionShowHideTransitionViews completion:nil];
    }
}

#pragma mark - Util

- (void)resetMapView {
    // setup map by search parameter
    MKCoordinateRegion mapRegion;
    CLLocationCoordinate2D mapCenter;
    mapCenter.latitude = self.searchParameter.latitude;
    mapCenter.longitude = self.searchParameter.longitude;
    mapRegion.center = mapCenter;
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.02; // 1 degree = 111 km ~= 69 mile
    mapSpan.longitudeDelta = 0.02;
    mapRegion.span = mapSpan;
    self.mapView.region = mapRegion;
    // clear annotation
    [self.mapView removeAnnotations:self.mapView.annotations];
}

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
        } else {
            self.tableView.tableFooterView.hidden = NO;
        }
        [self.businesses addObjectsFromArray:data];
        [self.tableView reloadData];
        [self.mapView addAnnotations:data];
    }];
}

- (void)reloadData {
    [self.businesses removeAllObjects];
    [self.searchParameter resetPagingParameter];
    [self resetMapView];
    [self loadData];
}

- (void)refreshView {
    [SVProgressHUD show];
    self.tableView.tableFooterView.hidden = YES;
    self.searchBar.text = self.searchParameter.term;
    [self reloadData];
}

#pragma mark - Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchParameter.term = searchBar.text;
    [self refreshView];
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
    
    [cell setBusiness:self.businesses[indexPath.row]];
    
    if (indexPath.row >= self.businesses.count -1 && self.hasNextPage) {
        CGRect frame = self.tableFooterView.frame;
        frame.size.width = tableView.bounds.size.width;
        self.tableFooterView.frame = frame;
        CGPoint center = self.infiniteLoadingView.center;
        center.x = self.tableFooterView.center.x;
        self.infiniteLoadingView.center = center;
        [self.searchParameter nextPage];
        [self loadData];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Map View

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AID];
    if (annotationView) {
        annotationView.annotation = annotation;
    } else {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AID];
    }
    annotationView.canShowCallout = NO;
    annotationView.image = [UIImage imageNamed:@"MapPin"];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MapAnnotationDetailView *detailView = [[[NSBundle mainBundle] loadNibNamed:@"MapAnnotationDetailView" owner:self options:nil] objectAtIndex:0];
    [detailView setBusiness:view.annotation withPinFrame:view.frame];
    [view addSubview:detailView];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [detailView updateFrameAndBound];
    } completion:nil];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (view.subviews.count > 0 && [view.subviews[0] isKindOfClass:[MapAnnotationDetailView class]]){
        [view.subviews[0] removeFromSuperview];
    }
}

@end
