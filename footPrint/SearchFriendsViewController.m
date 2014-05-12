//
//  SearchFriendsViewController.m
//  footprint
//
//  Created by apple on 3/14/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "SearchFriendsViewController.h"
#import "FPHttpClient.h"
#import "UserViewController.h"
@interface SearchFriendsViewController ()

@end

@implementation SearchFriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
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

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *aimedUserID = searchBar.text;
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    [client lookForNewFriendsWithFriendID:aimedUserID completion:^(NSDictionary *results, NSError *error) {
        if (error) {
            NSLog(@"look friend error");
        }else{
            if ([results[@"code"]  isEqual: @500]) {
                NSLog(@"%@",results);
                NSDictionary *res = results[@"results"][0];
                NSLog(@"user found");
                NSLog(@"%@",res[@"userID"]);
               
                UserViewController *userViewController = [[UserViewController alloc] initWithUserID:res[@"userID"] nickName:res[@"nickName"] personalImageUrl:res[@"personalImg"]];
                [self.navigationController pushViewController:userViewController animated:NO];
                
            }else if([results[@"code"]  isEqual: @501]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户不存在" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
}


@end
