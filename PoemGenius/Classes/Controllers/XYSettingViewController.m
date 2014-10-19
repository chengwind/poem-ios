#import "XYSettingViewController.h"
#import "MJRefresh.h"
#import "XYOftenViewController.h"
#import "XYCategoryViewController.h"
#import "XYSearchViewController.h"
#import "XYAuthorListViewController.h"
#import "XYFavViewController.h"

@implementation XYSettingViewController

@synthesize searchBar;
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectZero];
        self.title = @"设置";
    }
    
//    [self.navigationItem.titleView setHidden:YES];

    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data =[[NSMutableArray alloc] initWithObjects:
                  @"Singing Birds",
                  @"Wind Chines",
                  @"Falling Rain",
                  @"Ocean",
                  @"Whale Song",nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(performBackNavigation:)];

}



- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    // searchBarTextDidBeginEditing is called whenever
    // focus is given to the UISearchBar
    // call our activate method so that we can do some
    // additional things when the UISearchBar shows.
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // Clear the search text
    // Deactivate the UISearchBar
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // Do the search and show the results in tableview
    // Deactivate the UISearchBar
    
    // You'll probably want to do this on another thread
    // SomeService is just a dummy class representing some
    // api that you are using to do the search
//    NSArray *results = [SomeService doSearch:searchBar.text];
//    
//    [self searchBar:searchBar activate:NO];
    
//    [self.tableData removeAllObjects];
//    [self.tableData addObjectsFromArray:results];
    data =[[NSMutableArray alloc] initWithObjects:
           @"One",
           @"Two",
           @"Three",
           @"Five",
           @"Six",nil];
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
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

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
//    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ Controller Cell %ld", self.title, (long)indexPath.row]];
  [[cell textLabel] setText:[NSString stringWithFormat:@"Cell : %@", [data objectAtIndex:indexPath.row]]];
    
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    
//[self.tableView setContentOffset:CGPointMake(0.0, 88.0) animated:NO];
//    [self.tableView setFrame:CGRectMake(0, 0, 320, 88)];
//    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 88);

}



@end
