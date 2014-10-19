//
//  XYListViewController.m
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import "XYPoemListViewController.h"
#import "XYPoemViewController.h"
#import "MJRefresh.h"
#import "XYPoemService.h"
#import "XYPoem.h"
#import "XYConstants.h"

@implementation XYPoemListViewController

@synthesize searchBar;

#pragma mark - View lifecycle

- (void) awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        self.title = @"诗词列表";
    }
    if(nil == service){
        service = [[XYPoemService alloc] init];
    }
    //    self.offset = 0;
    self.isEnd = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *txt = [[self.searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([self.searchType isEqual:@"c"]){
        data = [service getPoems:txt catId:self.searchCatId limit:SIZE_PER_PAGE offset:0];
    }else if([self.searchType isEqual:@"f"]){
        data =[service getPoems:txt catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:0];
    }else {
        data =[service getPoems:txt catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:0];
    }
    
    if(data.count == 0 || data.count < SIZE_PER_PAGE){
        self.isEnd = true;
    }
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 232, 44)];
    searchBar.delegate = self;
    searchBar.placeholder=[[NSString alloc] initWithFormat:@"%@",self.searchCatName];
    self.navigationItem.titleView = searchBar;

    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
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
    if([self.searchType isEqual:@"c"]){
        data = [service getPoems:nil catId:self.searchCatId limit:SIZE_PER_PAGE offset:0];
    }else if([self.searchType isEqual:@"f"]){
        data =[service getPoems:nil catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:0];
    }else {
        data =[service getPoems:nil catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:0];
    }
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
    if([self.searchType isEqual:@"c"]){
        data = [service getPoems:txt catId:self.searchCatId limit:SIZE_PER_PAGE offset:0];
    }else if([self.searchType isEqual:@"f"]){
        data =[service getPoems:txt catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:0];
    }else {
        data =[service getPoems:txt catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:0];
    }
    if(data.count == 0){
        self.isEnd = true;
    }
    
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
}


#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    XYPoem *poem =[data objectAtIndex:indexPath.row];
    NSString *tit =@"";
    if([poem.is_fav isEqualToString:@"1"])
    {
        tit = [tit stringByAppendingFormat:@"🌟%d . %@ ",(int)(indexPath.row + 1 ),poem.title];
    }else{
        tit = [tit stringByAppendingFormat:@"%d . %@ ",(int)(indexPath.row + 1 ),poem.title];
    }
    [[cell textLabel] setText:tit];
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
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    
//    float reload_distance = 50;
//    if(y > h + reload_distance) {
//        NSLog(@"pos: %f of %f", y, h);
//        NSLog(@"load more rows");
//    }
}

-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showPoemSegue" sender:indexPath];
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showPoemSegue" sender:indexPath];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPoemSegue"])
    {
        XYPoemViewController *vc = [segue destinationViewController];
        XYPoem *poem =[data objectAtIndex:((NSIndexPath *)sender).row];
        vc.uid = poem.uid;
        NSMutableArray *ids = [NSMutableArray array];
        for (XYPoem *poem in data) {
            [ids addObject: [NSNumber numberWithInt:poem.uid]];
        }
        vc.ids = ids;
        vc.idx = (int)((NSIndexPath *)sender).row;

    }
}

//
//#pragma mark
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ( data.count % SIZE_PER_PAGE == 0 && !self.isEnd) {
        NSMutableArray *newData;
        NSString *txt = [[self.searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([self.searchType isEqual:@"c"]){
            newData = [service getPoems:txt catId:self.searchCatId limit:SIZE_PER_PAGE offset:(int)data.count];
        }else if([self.searchType isEqual:@"f"]){
            data =[service getPoems:txt catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:(int)data.count];
        }else {
            newData =[service getPoems:txt catType:self.searchType catName:self.searchCatName limit:SIZE_PER_PAGE offset:(int)data.count];
        }

        if(newData.count == 0 || newData.count <SIZE_PER_PAGE){
            self.isEnd = true;
        }
        [data addObjectsFromArray:newData];
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
