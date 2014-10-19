#import "XYAuthorListViewController.h"
#import "XYAuthorViewController.h"
#import "XYCategory.h"
#import "XYConstants.h"
#import "XYAuthor.h"
#import "XYAuthorsViewController.h"

@implementation XYAuthorListViewController

@synthesize searchBar;
@synthesize sc;

- (void)readySource
{
    
    sectionTitles = [[NSMutableArray alloc]init];
    contentsArray = [[NSMutableArray alloc]init];
    
    data = [service searchAuthorsSort:nil limit:SIZE_PER_PAGE offset:0];
    [self refreshData];
}
- (void)refreshData{
    [sectionTitles removeAllObjects];
    [contentsArray removeAllObjects];
    if(data.count == 0 )
    {
        return;
    }
    NSMutableArray *oneSection;
    for(int i = 0; i < [data count]; i++)
    {
        XYAuthor *author = [data objectAtIndex:i];
        if(i == 0 || author.dynasty_id != self.lastDynastyId){
            oneSection = [[NSMutableArray alloc]init];
            [contentsArray addObject:oneSection];
            [oneSection addObject:author];
            [sectionTitles addObject:[author dynasty_name]];
        }else{
            [oneSection addObject:author];
        }
        self.lastDynastyId = author.dynasty_id;
    }
    [self.tableView reloadData];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    if (self) {
//        self.title = @"作者";
    }
    if(nil == service){
        service = [[XYPoemService alloc]init];
    }
    self.isEnd =false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readySource];
    
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
    
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width -24, 44)];
    searchBar.delegate = self;
    searchBar.placeholder=@"查询作者";

    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setTranslucent:YES];
    searchBar.backgroundColor =[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    

    if(!self.tableView.tableHeaderView){
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 44)];
    }
    
    [self.tableView.tableHeaderView addSubview:searchBar];
    
    NSArray *scOptions = [NSArray arrayWithObjects: @"列表",@"朝代",nil];
    sc = [[UISegmentedControl alloc] initWithItems:scOptions];
    sc.frame = CGRectMake(80,5,150, 30);
    sc.segmentedControlStyle = UISegmentedControlStyleBar;
    sc.selectedSegmentIndex = 0;
    [sc addTarget:self action:@selector(didChangeSegmentControl:)  forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = sc;
}

- (void)didChangeSegmentControl:(UISegmentedControl *)control
{
    // To get string: [control titleForSegmentAtIndex:control.selectedSegmentIndex]
    self.selectedTab = (int)control.selectedSegmentIndex;
    self.isEnd = false;
    if (self.selectedTab == 0)
    {
        if(!self.tableView.tableHeaderView){
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 44)];
        }
        
        [self.tableView.tableHeaderView addSubview:searchBar];
        _footer = [[MJRefreshFooterView alloc] init];
        _footer.delegate = self;
        _footer.scrollView = self.tableView;
        [self readySource];
    }
    else if (self.selectedTab == 1)
    {
        self.tableView.tableHeaderView = nil;
        _footer.delegate= nil;
        _footer.scrollView = nil;
        [_footer removeFromSuperview];
        [_footer free];
        data= [service getCategories:@"d"];
    }
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.selectedTab==0){
        return sectionTitles.count;
    }else{
        return 1;
    }
}

// 每个分区的页眉
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.selectedTab==0){
        NSString *title =   [NSString stringWithFormat:@"【%@】 - %d",[sectionTitles objectAtIndex:section],(int)[[contentsArray objectAtIndex:section] count]];
        return title;
    }else{
        return nil;
    }
}
// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(self.selectedTab==0){
        return sectionTitles;
    }else{
        return nil;
    }
}

// 点击目录
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}


#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    if(self.selectedTab==0){
        XYAuthor *author =[[contentsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSString *tit =@"";
        if([author.is_fav isEqualToString:@"1"])
        {
            tit = [tit stringByAppendingFormat:@"🌟%@",[author name]];
        }else{
            tit = [tit stringByAppendingFormat:@"%@",[author name]];
        }
        [[cell textLabel] setText:tit];
        NSString *lb = @"";
        if(author.poem_num){
            lb = [lb stringByAppendingFormat:@"%d首",author.poem_num];
        }
        [[cell detailTextLabel] setText:lb];
    }else{
        XYCategory *category =[data objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@",  category.name]];
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d位",category.author_num]];
    }
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier1 = @"Cell1";
    if(self.selectedTab ==0){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    }
    if (!cell) {
        if(self.selectedTab ==0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.selectedTab==0){
        return [[contentsArray objectAtIndex:section] count];
    }else{
        return data.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectedTab==0){
        [self performSegueWithIdentifier:@"showAuthorSegue" sender:indexPath];
    }else{
        [self performSegueWithIdentifier:@"showAuthorsSegue" sender:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAuthorSegue"])
    {
        NSIndexPath *indexPath =(NSIndexPath *)sender;
        XYAuthor *author =[[contentsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        XYAuthorViewController *vc = [segue destinationViewController];
        vc.uid = author.uid;
    }else if([[segue identifier] isEqualToString:@"showAuthorsSegue"]){
        NSIndexPath *indexPath =(NSIndexPath *)sender;
        XYCategory *category =[data objectAtIndex:indexPath.row];
        XYAuthorsViewController *vc = [segue destinationViewController];
        vc.dynasty_name = category.name;
    }
}

#pragma mark
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{   if(self.selectedTab==0){
    
    NSString *txt = [[self.searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( data.count % SIZE_PER_PAGE == 0 && !self.isEnd) {
        NSMutableArray *authors ;
        authors = [service searchAuthorsSort:txt limit:SIZE_PER_PAGE offset:(int)data.count];
        if(authors.count == 0){
            self.isEnd = true;
        }else{
            [data addObjectsFromArray:authors];
            NSMutableArray *oneSection = [contentsArray objectAtIndex:(contentsArray.count-1)];
            for(int i = 0; i < [authors count]; i++)
            {
                XYAuthor *author = [authors objectAtIndex:i];
                if(author.dynasty_id == self.lastDynastyId){
                    [oneSection addObject:author];
                }else{
                    oneSection= [[NSMutableArray alloc]init];
                    [oneSection addObject:author];
                    [contentsArray addObject:oneSection];
                    [sectionTitles addObject:[author dynasty_name]];
                }
                self.lastDynastyId = author.dynasty_id;
            }
        }
        [self refreshData];
        [self performSelector:@selector(doneWithView:) withObject:refreshView ];
    }else{
        [refreshView endRefreshing];
    }
}else{
    [refreshView endRefreshing];
}
    
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    [self.tableView reloadData];
    [refreshView endRefreshing];
}


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    // We don't want to do anything until the user clicks
    // the 'Search' button.
    // If you wanted to display results as the user types
    // you would do that here.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBa{
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
    data = [service searchAuthorsSort: nil limit:SIZE_PER_PAGE offset:0];
    [self refreshData];
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
    data = [service searchAuthorsSort:txt limit:SIZE_PER_PAGE offset:0];
    [self refreshData];
    if(data.count == 0){
        self.isEnd = true;
    }
    
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton=NO;
}

- (void)dealloc
{
    [_footer free];
}

@end
