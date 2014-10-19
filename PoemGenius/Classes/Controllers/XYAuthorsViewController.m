//
//  XYFifthViewController.m
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import "XYFavViewController.h"
#import "XYPoemViewController.h"
#import "XYAuthorsViewController.h"
#import "XYAuthorViewController.h"
#import "XYConstants.h"
#import "XYPoem.h"
#import "XYAuthor.h"

@implementation XYAuthorsViewController

@synthesize data,dynasty_name;
@synthesize searchBar;


-(void)awakeFromNib{
    [super awakeFromNib];
    if (self) {
        self.title = self.dynasty_name;
    }
    if(nil == service){
        service = [[XYPoemService alloc] init];
    }
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 232, 44)];
    searchBar.delegate = self;
    
    self.navigationItem.titleView = searchBar;
    
    self.isEnd = false;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //        data =[service getAuthors:@"string" limit:SIZE_PER_PAGE offset:0];
    data=[service searchAuthors:dynasty_name searchText:nil limit:SIZE_PER_PAGE offset:0];
    searchBar.placeholder= dynasty_name;;
    if(data.count == 0){
        self.isEnd = true;
    }
    [self.tableView reloadData];
}


- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBa {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
    searchBar.showsCancelButton=YES;
    NSArray *subViews;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        subViews = [(searchBa.subviews[0]) subviews];
    }else{
        subViews = searchBa.subviews;
    }
    for(id cc in subViews)
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBa {
    // Clear the search text
    // Deactivate the UISearchBar
    searchBar.showsCancelButton=NO;
    [self.searchBar setText:@""];
    data=[service searchAuthors:dynasty_name searchText:nil limit:SIZE_PER_PAGE offset:0];
    
    if(data.count == 0){
        self.isEnd = true;
    }
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *txt = [[self.searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(txt == nil || [txt isEqual:@""]){
        return;
    }
    data=[service searchAuthors:dynasty_name searchText:txt limit:SIZE_PER_PAGE offset:0];
    
    if(data.count == 0){
        self.isEnd = true;
    }
    
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    XYAuthor *author =[data objectAtIndex:indexPath.row];
    NSString *atitle = @"";
    if([author.is_fav isEqualToString:@"1"])
    {
        atitle = [atitle stringByAppendingFormat:@"🌟%@ - %@", author.dynasty_name,[author name]];
    }else{
        atitle = [atitle stringByAppendingFormat:@"%@ - %@", author.dynasty_name,[author name]];
    }
    [[cell textLabel] setText:atitle];
    NSString *lb = @"";
    
    if(author.poem_num){
        lb = [lb stringByAppendingFormat:@"共%d首",author.poem_num];
    }
    [[cell detailTextLabel] setText:lb];
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showAuthorSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showAuthorSegue"]){
        XYAuthorViewController *vc = [segue destinationViewController];
        XYAuthor *author =[data objectAtIndex:((NSIndexPath *)sender).row];
        vc.uid = author.uid;
    }
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    NSString *txt = [[self.searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( data.count % SIZE_PER_PAGE == 0 && !self.isEnd) {
        NSMutableArray *newData;
        newData=[service searchAuthors:dynasty_name searchText:txt limit:SIZE_PER_PAGE offset:data.count];
        if(newData.count == 0){
            self.isEnd = true;
        }
        [data addObjectsFromArray:newData];
        [self performSelector:@selector(doneWithView:) withObject:refreshView];
    }else{
        [refreshView endRefreshing];
    }
    
    
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    [self.tableView reloadData];
    [refreshView endRefreshing];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    _footer.delegate =nil;
    [_footer free];
    searchBar.delegate =nil;
    data =nil;
    service =nil;
}


@end
