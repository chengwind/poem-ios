//
//  XYFifthViewController.m
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import "XYFavViewController.h"
#import "XYPoemViewController.h"
#import "XYAuthorViewController.h"
#import "XYPoemListViewController.h"
#import "XYConstants.h"
#import "XYPoem.h"
#import "XYAuthor.h"

@implementation XYFavViewController

@synthesize data,sc;


-(void)awakeFromNib{
    [super awakeFromNib];
    if (self) {
        self.title = @"收藏";
    }
    if(nil == service){
        service = [[XYPoemService alloc] init];
    }
//    self.offset = 0;
    self.selectedTab = 0;
    self.isEnd = false;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
    
    NSArray *scOptions = [NSArray arrayWithObjects: @"诗词",@"作者",nil];
    sc = [[UISegmentedControl alloc] initWithItems:scOptions];
    sc.frame = CGRectMake(80,5,150, 30);
    sc.segmentedControlStyle = UISegmentedControlStyleBar;
    sc.selectedSegmentIndex = 0;
    [sc addTarget:self action:@selector(didChangeSegmentControl:)  forControlEvents:UIControlEventValueChanged];

    
    self.navigationItem.titleView = sc;
    
    
    UIBarButtonItem *editButton =[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(EditData:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.selectedTab ==1){
        data =[service getAuthors:@"1" limit:SIZE_PER_PAGE offset:0];
    }else{
        data =[service getFavPoemsAuthors:@"1" limit:SIZE_PER_PAGE offset:0];
    }
    if(data.count == 0){
        self.isEnd = true;
    }
    [self.tableView reloadData];
}

- (void)didChangeSegmentControl:(UISegmentedControl *)control
{
    // To get string: [control titleForSegmentAtIndex:control.selectedSegmentIndex]
    self.selectedTab = (int)control.selectedSegmentIndex;
    self.isEnd = false;
    if (control.selectedSegmentIndex == 0)
    {
        data =[service getFavPoemsAuthors:@"1" limit:SIZE_PER_PAGE offset:0];
    }
    else if (control.selectedSegmentIndex == 1)
    {
        data =[service getAuthors:@"1" limit:SIZE_PER_PAGE offset:0];
    }
    [self.tableView reloadData];
}

-(IBAction)EditData:(id)sender{
    if(data.count ==0){
        return;
    }

    if(self.editing){
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }else{
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        
    }
}

-(void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(self.selectedTab ==0){
            XYAuthor *author =[data objectAtIndex:indexPath.row];
            [service updatePoemByAuthor:author.name isFav:@"0"];
        }else{
            XYAuthor *author =[data objectAtIndex:indexPath.row];
            [service updateAuthor:author.uid isFav:@"0"];
        }
        [data removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    }else if (editingStyle==UITableViewCellEditingStyleInsert){
        //add item here
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark Row reordering
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(self.selectedTab==0){
//        return UITableViewCellEditingStyleNone;
//    }
    if(self.editing ==NO || !indexPath){
        return UITableViewCellEditingStyleDelete;
    }
    if(self.editing && indexPath.row==([data count])){
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    return  UITableViewCellEditingStyleDelete;
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
    //    [[cell textLabel] setText:[NSString stringWithFormat:@"%@- %@", self.title,[data objectAtIndex:indexPath.row]]];
    if(self.selectedTab ==0){
        XYAuthor *author =[data objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", author.dynasty_name,[author name]]];
        NSString *lb = @"";
        
        if(author.poem_num){
            lb = [lb stringByAppendingFormat:@"收藏了%d首",author.poem_num];
        }
        [[cell detailTextLabel] setText:lb];
    }else{
        XYAuthor *author =[data objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@", author.dynasty_name,[author name]]];
        NSString *lb = @"";
        
        if(author.poem_num){
            lb = [lb stringByAppendingFormat:@"共%d首",author.poem_num];
        }
        [[cell detailTextLabel] setText:lb];
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
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.selectedTab==0){
        [self performSegueWithIdentifier:@"showPoemListSegue" sender:indexPath];
    }else{
        [self performSegueWithIdentifier:@"showAuthorSegue" sender:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPoemListSegue"])
    {
        XYPoemListViewController *vc = [segue destinationViewController];
        XYAuthor *author =[data objectAtIndex:((NSIndexPath *)sender).row];
        vc.searchType=@"f";
        vc.searchCatName = author.name;
        
    }else if([[segue identifier] isEqualToString:@"showAuthorSegue"]){
        XYAuthorViewController *vc = [segue destinationViewController];
        XYAuthor *author =[data objectAtIndex:((NSIndexPath *)sender).row];
        vc.uid = author.uid;
    }
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ( data.count % SIZE_PER_PAGE == 0 && !self.isEnd) {
        NSMutableArray *newData;
        if(self.selectedTab == 0){
            newData =[service getFavPoemsAuthors:@"1" limit:SIZE_PER_PAGE offset:(int)data.count];
        }else{
            newData =[service getAuthors:@"1" limit:SIZE_PER_PAGE offset:(int)data.count];
        }
        
        //        NSMutableArray *newData = [service getPoems:self.searchId limit:SIZE_PER_PAGE offset:data.count];
        if(newData.count == 0){
            self.isEnd = true;
        }
        [data addObjectsFromArray:newData];
        [self performSelector:@selector(doneWithView:) withObject:refreshView];
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

@end
