//
//  MoreViewController.m
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "MoreViewController.h"
#import "FPHttpClient.h"
#import "LoginViewViewController.h"
#import "MyFPViewController.h"
#import "AroundFPViewController.h"
#import "AppDelegate.h"
#import "MyInfoTableViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) initUserInterface{
    //self.title = @"更多";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
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
-(void) logOutButtonTab{
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:[defau objectForKey:@"userID"],@"userID", nil];
    [[FPHttpClient sharedHttpClient] POST:@"logout" parameters:info success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *num = [NSNumber numberWithInt:350];
        if ([responseObject[@"code"] isEqualToNumber:num]) {
            LoginViewViewController *loginViewController = [[LoginViewViewController alloc] init];
            loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [defau setValue:nil forKey:@"userID"];
            [defau setValue:nil forKey:@"password"];
            [self presentViewController:loginViewController animated:YES completion:^{
            }];
            [self removeFromParentViewController];
            [MyFPViewController setNibRegistered:NO];
            [AroundFPViewController setAroundnibRegistered:NO];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *directory = [paths objectAtIndex:0];
            directory = [directory stringByAppendingString:@"/image/"];
            
            if([fileManager fileExistsAtPath:directory] != NO){
                [fileManager removeItemAtPath:directory error:nil];
            }
            NSLog(@"log out seccess");
        }else if ([responseObject[@"code"] isEqualToNumber:@101]){
            LoginViewViewController *loginViewController = [[LoginViewViewController alloc] init];
            loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:loginViewController];
            //[self removeFromParentViewController];
            [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:loginViewController animated:YES completion:nil];
            NSLog(@"gt login");
        }else{
            NSLog(@"%@",responseObject[@"code"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //section 1 for personal info
    //section 2 for logout
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;// one row for my self,row 2 for my favorite
    }else{
        return 1;
    }
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        return 50.0f;
    }
    if(indexPath.section  == 0 && indexPath.row == 0){
        return 50.0f;
    }else{
        return 30.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"MoreViewTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [[cell textLabel] setText:@"我的资料"];
        }else if(indexPath.row == 1){
            [[cell textLabel]setText:@"我的收藏"];
        }
    }else if(indexPath.section == 1){
        NSString *themeStr = [NSString stringWithFormat:@"个性签名   %@",@"kakiku ergo sum"];
        [[cell textLabel] setText:themeStr];
        
    }else if(indexPath.section == 2){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setBackgroundColor:[UIColor redColor]];
        [[cell textLabel] setText:@"退出登录"];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            MyInfoTableViewController *viewContrl = [[MyInfoTableViewController alloc] init];
            [self.navigationController pushViewController:viewContrl animated:NO];
        }else if(indexPath.row == 1){
        }
    }else if(indexPath.section == 1){
        
    }
    else if(indexPath.section == 2){
        [self logOutButtonTab];
    }
    /*
    // Navigation logic may go here, for example:
    // Create the next view controller.
    //<#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
}


@end
