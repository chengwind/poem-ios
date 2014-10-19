//
//  XYFourthViewController.m
//  RDVTabBarController
//
//  Created by jason on 3/20/14.
//  Copyright (c) 2014 Robert Dimitrov. All rights reserved.
//

#import "XYOftenViewController.h"
#import "XYPoemListViewController.h"
#import "XYCategory.h"

@implementation XYOftenViewController

@synthesize data;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.title = @"常用";
//    }
//    if(nil == service){
//        service = [[XYPoemService alloc] init];
//    }
//    return self;
//}

- (void) awakeFromNib
{
    [super awakeFromNib];
//    if (self) {
//        self.title = @"常用";
//    }
    if(nil == service){
        service = [[XYPoemService alloc] init];
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data= [service getCategories:@"c"];
//    self.navigationController.navigationBar.translucent =YES;
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
//    self.navigationController.navigationBar.alpha = 0.300;
}


- (void)didChangeSegmentControl:(UISegmentedControl *)control
{
    // To get string: [control titleForSegmentAtIndex:control.selectedSegmentIndex]
    if (control.selectedSegmentIndex == 0)
    {

    }
    else if (control.selectedSegmentIndex == 1)
    {

    }
    else if (control.selectedSegmentIndex == 2)
    {

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

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
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
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    XYCategory *category =[data objectAtIndex:indexPath.row];
//    
//    XYPoemListViewController *viewController  =[[XYPoemListViewController alloc] init];
//    
//    viewController.searchType=@"c";
//    viewController.searchId = category.uid;
//    
//	[self.navigationController pushViewController:viewController animated:TRUE];
    
    [self performSegueWithIdentifier:@"showPoemListSegue" sender:indexPath];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPoemListSegue"])
    {
        XYPoemListViewController *vc = [segue destinationViewController];
        
        XYCategory *category =[data objectAtIndex:((NSIndexPath *)sender).row];
        vc.searchType=@"c";
        vc.searchCatId = category.uid;
    }
}

@end
