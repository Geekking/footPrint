//
//  MyInfoTableViewController.m
//  footprint
//
//  Created by apple on 5/12/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "MyInfoTableViewController.h"
#import "FPHttpClient.h"

#import "UIImageView+AFNetworking.h"

@interface MyInfoTableViewController (){
    NSMutableDictionary *_personInfo;
}

@end

@implementation MyInfoTableViewController

- (void)initUserInterface{
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUserInterface];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[FPHttpClient sharedHttpClient] getPersonInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] completion:^(NSDictionary *results, NSError *error) {
        if (error) {
            NSLog(@"get person information error: %@",error);
        }else{
            if ([results[@"code"] isEqualToNumber:@640]) {
                _personInfo = results[@"userInfo"][0];
                [self.tableView reloadData];
            }else{
                
                NSLog(@"query user not found");
            }
        }
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myPersonInfoId = @"MyPersonInfo";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myPersonInfoId];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        NSString *imageName = _personInfo[@"personalImg"];
        if (imageName != nil) {
            NSString *urlStr = [[FPHttpClient getBaseURL] stringByAppendingFormat: @"file/%@",imageName];
            NSURL *url = [NSURL URLWithString:urlStr];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            __weak UITableViewCell *weakCell = cell;
            NSLog(@"%@",url);
            
            [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake(0, 100, 80, 60);
                weakCell.accessoryView = imageView;
                [weakCell setNeedsLayout];
            
            } failure:nil];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"昵称";
        UILabel *nickLabel = [[UILabel alloc] init];
        nickLabel.text = _personInfo[@"nickName"];
        nickLabel.frame = CGRectMake(0, 0, 200, 30);
        nickLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = nickLabel;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60.0f;
    }else if (indexPath.row == 1){
        return 30.0f;
    }
    return 30.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
