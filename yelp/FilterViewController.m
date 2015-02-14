//
//  FilterViewController.m
//  yelp
//
//  Created by Ke Huang on 2/10/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "CollapseTableViewCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, FilterTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) SearchParameter *filterParameter;
@property (strong, nonatomic) NSArray *filters;
@property (strong, nonatomic) NSMutableArray *sectionCollapsedRowCount;

@end

@implementation FilterViewController

const NSInteger DEFAULT_CATEGORIES_COLLAPSE_COUNT = 7;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Filters";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonClicked:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButtonClicked:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FilterTableViewCell" bundle:nil] forCellReuseIdentifier:@"FilterTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollapseTableViewCell" bundle:nil] forCellReuseIdentifier:@"CollapseTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.rowHeight = 44;
    
    self.sectionCollapsedRowCount = [NSMutableArray arrayWithObjects:@(0),@(1),@(1),@(DEFAULT_CATEGORIES_COLLAPSE_COUNT), nil];
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
    }
    self.sectionCollapsedRowCount[item.filterType] = @(1);
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:item.filterType] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark Util

- (NSInteger)getRowCountBySection:(NSInteger)section {
    NSArray *filterItems = (NSArray *)self.filters[section];
    NSInteger result = filterItems.count;
    NSInteger sectionCollapseRowCount = [self.sectionCollapsedRowCount[section] integerValue];
    if (sectionCollapseRowCount > 0 && sectionCollapseRowCount < result) {
        result = sectionCollapseRowCount;
    }
    if (section == 3) { // categories filter have one more button at bottom (show more/show less)
        result += 1;
    }
    return result;
}

-(FilterItem *)getCellFilterItem:(NSIndexPath *)indexPath {
    NSArray *filterItems = (NSArray *)self.filters[indexPath.section];
    NSInteger sectionCollapseRowCount = [self.sectionCollapsedRowCount[indexPath.section] integerValue];
    FilterItem *filterItem = nil;
    if (indexPath.section < 3 && sectionCollapseRowCount > 0 && sectionCollapseRowCount < filterItems.count) {
        for (int i=0;i<filterItems.count;i++) {
            FilterItem *selectedFilterItem = filterItems[i];
            if(selectedFilterItem.isSelected) {
                filterItem = selectedFilterItem;
                filterItem.isCollapsed = YES;
                break;
            }
        }
    } else {
        filterItem = filterItems[indexPath.row];
        filterItem.isCollapsed = NO;
    }
    return filterItem;
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filters.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getRowCountBySection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [SearchParameter FilterTypeTitles][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger filterItemCount = ((NSArray*)self.filters[indexPath.section]).count;
    NSInteger sectionCollapseRowCount = [self.sectionCollapsedRowCount[indexPath.section] integerValue];
    if (indexPath.row < filterItemCount && (indexPath.section < 3 || sectionCollapseRowCount == 0 || indexPath.row < sectionCollapseRowCount)) {
        FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterTableViewCell"];
        cell.delegate = self;
        [cell setFilterItem:[self getCellFilterItem:indexPath]];
        return cell;
    } else { // show less / show more button for categories filter
        CollapseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollapseTableViewCell"];
        if (sectionCollapseRowCount > 0 && sectionCollapseRowCount < filterItemCount) {
            cell.isCollapse = YES;
        } else {
            cell.isCollapse = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionCollapseRowCount = [self.sectionCollapsedRowCount[indexPath.section] integerValue];
    if (indexPath.section < 3) {
        if (sectionCollapseRowCount > 0) {
            self.sectionCollapsedRowCount[indexPath.section] = @(0);
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else { // categories collapse item
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[CollapseTableViewCell class]]) {
            CollapseTableViewCell *collapseCell = (CollapseTableViewCell *)cell;
            if (collapseCell.isCollapse) {
                self.sectionCollapsedRowCount[indexPath.section] = @(0);
            } else {
                self.sectionCollapsedRowCount[indexPath.section] = @(DEFAULT_CATEGORIES_COLLAPSE_COUNT);
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

@end
