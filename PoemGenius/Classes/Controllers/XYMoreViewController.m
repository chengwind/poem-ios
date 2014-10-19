//
//  XYMoreViewController.m
//  PoemGenius
//
//  Created by jason on 8/15/14.
//  Copyright (c) 2014 XiaoYao. All rights reserved.
//

#import "XYMoreViewController.h"

@interface XYMoreViewController ()

@end

@implementation XYMoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void) awakeFromNib
{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
//    NSLog(@"1 = %@",cell.detailTextLabel.text);
//    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"        当前版本 : %@",version];
//    NSLog(@"2 = %@",cell.detailTextLabel.text);
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.detailTextLabel.text = [[NSString alloc]initWithFormat:@"        当前版本 : %@ ( Build: %@ )",version,build];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1 && indexPath.row == 2)
    {
        NSLog(UMENG_APPKEY);
        [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
    }
}

@end
