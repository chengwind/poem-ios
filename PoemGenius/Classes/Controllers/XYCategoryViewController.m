#import "XYCategoryViewController.h"
#import "XYPoemListViewController.h"
#import "XYCategory.h"

@implementation XYCategoryViewController

@synthesize data;
@synthesize sc;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.title = @"分类";
//    }
//    if(nil == service){
//        service = [[XYPoemService alloc] init];
//    }
//    self.catType =@"g";
//    return self;
//}

- (void) awakeFromNib
{
    [super awakeFromNib];
    if (self) {
        self.title = @"分类";
    }
    if(nil == service){
        service = [[XYPoemService alloc] init];
    }
    self.catType =@"c";
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data= [service getCategories:@"c"];
    
    NSArray *scOptions = [NSArray arrayWithObjects: @" 常 用 ", @" 体 裁 ", @" 韵 部 ", @" 朝 代 ",nil];
    sc = [[UISegmentedControl alloc] initWithItems:scOptions];
//    sc = CGRectMake(0,0,150, 32);
    sc.segmentedControlStyle = UISegmentedControlStyleBar;
    sc.selectedSegmentIndex = 0;
    [sc addTarget:self action:@selector(didChangeSegmentControl:)  forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView: sc];
    self.navigationItem.titleView = segmentBarItem.customView;
//    self.navigationItem.title = @"";
    
}


- (void)didChangeSegmentControl:(UISegmentedControl *)control
{
    // To get string: [control titleForSegmentAtIndex:control.selectedSegmentIndex]
    if (control.selectedSegmentIndex == 1)
    {
        data= [service getCategories:@"g"];
        self.catType =@"g";
    }
    else if (control.selectedSegmentIndex == 2)
    {
        data= [service getCategories:@"r"];
        self.catType =@"r";
    }
    else if (control.selectedSegmentIndex == 3)
    {
        data= [service getCategories:@"d"];
        self.catType =@"d";
    }
    else if (control.selectedSegmentIndex == 0)
    {
        data= [service getCategories:@"c"];
        self.catType =@"c";
    }
    [self.tableView reloadData];
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.tableView reloadData];
    [refreshControl endRefreshing];
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
//    [[cell textLabel] setText:[NSString stringWithFormat:@"%ld - %@",  (long)indexPath.row,[data objectAtIndex:indexPath.row]]];
//
//    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    XYCategory *category =[data objectAtIndex:indexPath.row];
    //    id<XYCategory> category =[data objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",  category.name]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%d首",category.poem_num]];
}

#pragma mark - Table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [self configureCell:cell forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showPoemListSegue" sender:indexPath];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPoemListSegue"])
    {
        XYPoemListViewController *vc = [segue destinationViewController];
        
        XYCategory *category =[data objectAtIndex:((NSIndexPath *)sender).row];
        vc.searchType=self.catType;
        vc.searchCatId = category.uid;
        vc.searchCatName = category.name;
    }
}

-(void) viewWillAppear:(BOOL)animated{
//    [[self rdv_tabBarController] setTabBarHidden:NO animated:NO];
}


@end
