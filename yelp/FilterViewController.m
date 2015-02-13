//
//  FilterViewController.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, FilterTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) SearchParameter *filterParameter;
@property (strong, nonatomic) NSArray *filters;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filters";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonClicked:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButtonClicked:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FilterTableViewCell" bundle:nil] forCellReuseIdentifier:@"FilterTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onCancelButtonClicked:(id)sender {
    self.filters = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSearchButtonClicked:(id)sender {
    [self.delegate filterViewController:self didChangeFileters:self.filterParameter];
    self.filters = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setSearchParameter: (SearchParameter *) param {
    self.filterParameter = param;
    self.filters = [self.filterParameter getAllFiltersByCurrentValue];
}

-(void)filterTableViewCell:(FilterTableViewCell *)filterTableViewCell didSwitchFilterValueChanged:(FilterItem *)item {
    [self.filterParameter updateFilterByFilterItem:item];
    self.filters = [self.filterParameter getAllFiltersByCurrentValue];
}

-(void)filterTableViewCell:(FilterTableViewCell *)filterTableViewCell didCheckFilterClicked:(FilterItem *)item withValueChanged:(BOOL)isValueChagned {
    if (isValueChagned) {
        [self.filterParameter updateFilterByFilterItem:item];
        self.filters = [self.filterParameter getAllFiltersByCurrentValue];
        [self.tableView reloadData];
    }
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *filterItems = (NSArray *)self.filters[section];
    return filterItems.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [SearchParameter FilterTypeTitles][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCell"];
    cell.delegate = self;
    
    NSArray *filterItems = (NSArray *)self.filters[indexPath.section];
    FilterItem *filterItem = filterItems[indexPath.row];
    [cell setFilterItem:filterItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
