#import "XYSearchViewController.h"
#import "MJRefresh.h"
#import "XYPoemListViewController.h"
#import "XYPoem.h"
#import "XYConstants.h"
#import "XYPoemViewController.h"

@implementation XYSearchViewController

@synthesize searchBar;
@synthesize data;
@synthesize uilabel,uilabel1;
@synthesize myPicker,actionSheet;

- (void)awakeFromNib{
    [super awakeFromNib];
    if (self) {
        self.title = @"查询";
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if(nil == service){
        service = [[XYPoemService alloc] init];
    }
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 88)];
    //    self.searchBar.showsCancelButton= YES;
    self.searchBar.delegate = self;
    
    searchBar.placeholder=@"输入要查询的内容";
    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"标题",@"作者",@"内容",@"注释", nil];
    
    searchBar.showsScopeBar = YES;
    
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setTranslucent:YES];
    [searchBar setScopeBarBackgroundImage:[UIImage new]];
    searchBar.backgroundColor =[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    //    for (UIView *subView in searchBar.subviews) {
    //        if ([subView isKindOfClass:[UIButton class]]) {
    //            UIButton *cancelButton = (UIButton*)subView;
    //            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    //        }
    //    }
    
    if(!self.tableView.tableHeaderView){
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 88)];
    }
    
    [self.tableView.tableHeaderView addSubview:searchBar];
    
}


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBa {
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBa{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBa {
    // searchBarTextDidEndEditing is fired whenever the
    // UISearchBar loses focus
    // We don't need to do anything here.
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBa {
    searchBar.showsCancelButton=NO;
    [self resetSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBa {
    [self doSearch];
    self.searchBar.showsCancelButton=NO;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self doSearch];
    self.searchBar.showsCancelButton=NO;
}

- (void)doSearch{
    
//    UIActivityIndicatorView *activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [activityIndicator setBackgroundColor:[UIColor blackColor]];
//    [activityIndicator setColor:[UIColor greenColor]];
//    activityIndicator.hidesWhenStopped = TRUE;

  
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView: activityIndicator];
//    [[self navigationItem] setTitleView:barButtonItem.customView];
//    [activityIndicator startAnimating];
    
//    [NSThread sleepForTimeInterval:2.0f];
    
    NSString *txt = [[self.searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(txt == nil || [txt isEqual:@""]){
        [self resetSearch];
    }else{
        int i =(int)self.searchBar.selectedScopeButtonIndex;
            data = [service searchPoems:i searchText:txt limit:SIZE_PER_PAGE offset:0];
        if(data.count == 0 || data.count <SIZE_PER_PAGE){
            self.isEnd = true;
        }else{
            self.isEnd = false;
        }
        [self.tableView reloadData];
        [self.searchBar resignFirstResponder];
    }
    [[self navigationItem] setRightBarButtonItem:nil];
//    [activityIndicator stopAnimating];
//    [activityIndicator removeFromSuperview];
}

- (void)resetSearch{
    [self.searchBar setText:@""];
    [data removeAllObjects];
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing a CMPopTipView instance variable, if necessary
    [popTipView dismissAnimated:YES];
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
    //    [[cell textLabel] setText:[NSString stringWithFormat:@"Cell : %@", [data objectAtIndex:indexPath.row]]];
    XYPoem *poem =[data objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%d . %@", (int)(indexPath.row + 1 ),[poem title]]];
    NSString *lb = @"";
    if(poem.genre_name){
        lb = [lb stringByAppendingFormat:@"[%@] ",poem.genre_name];
    }
    if(poem.rhythm_name){
        lb = [lb stringByAppendingFormat:@"[%@] ",poem.rhythm_name];
    }
    if(poem.dynasty_name){
        lb = [lb stringByAppendingFormat:@"- [%@ , %@]",poem.dynasty_name,poem.author_name];
    }
    [[cell detailTextLabel] setText:lb];
    
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    [self performSegueWithIdentifier:@"showPoemSegue" sender:indexPath];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPoemSegue"])
    {
        XYPoemViewController *vc = [segue destinationViewController];
        int idx  =(int)((NSIndexPath *)sender).row;
        XYPoem *poem =[data objectAtIndex:idx];
        vc.uid = poem.uid;
     
        NSMutableArray *ids = [NSMutableArray array];
        for (XYPoem *poem in data) {
            [ids addObject: [NSNumber numberWithInt:poem.uid]];
        }
        vc.ids = ids;
        vc.idx = idx;
    }
}

#pragma mark
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ( data.count % SIZE_PER_PAGE == 0 && !self.isEnd) {
        NSMutableArray *newData;
        int i =(int)self.searchBar.selectedScopeButtonIndex;
        NSString *txt = [[self.searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(txt == nil || [txt isEqual:@""]){
            [data removeAllObjects];
        }else{
                newData = [service searchPoems:i searchText:txt limit:SIZE_PER_PAGE offset:(int)data.count];
            if(newData.count == 0 || newData.count <SIZE_PER_PAGE){
                self.isEnd = true;
            }
            [data addObjectsFromArray:newData];
        }
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.5];
    }else{
        [refreshView endRefreshing];
    }
    
    //    [NSTimer scheduledTimerWithTimeInterval:1 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
    
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    [self.tableView reloadData];
    [refreshView endRefreshing];
}



-(void) viewWillAppear:(BOOL)animated{
    //[self.tableView setContentOffset:CGPointMake(0.0, 88.0) animated:NO];
    //    [self.tableView setFrame:CGRectMake(0, 0, 320, 88)];
    //    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 88);
    
}

@end
