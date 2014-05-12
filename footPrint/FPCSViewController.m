//
//  FPCSViewController.m
//  footprint
//
//  Created by apple on 4/22/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FPCSViewController.h"
#import "NewFPViewController.h"
#include "FPMyFriendsManager.h"
#include "User.h"
#include "FPHttpClient.h"
#include "UIImageView+AFNetworking.h"
@interface FPCSViewController (){
    BOOL publicToAllIndex;
    BOOL privateToAllIndex;
    BOOL upladingFlag;
}

@property (nonatomic,retain)NSObject<FPChooseFriendsDelegate> *delegate;
@property (nonatomic,strong)NSArray *myFriends;

@end

@implementation FPCSViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithFriends:(NSMutableArray *)chosenFriends{
    self = [super init];
    if (self) {
        // Custom initialization
        self.chosenFriends = chosenFriends;
        [[FPMyFriendsManager sharedFriendsManager] fetchAllMyFriends:^(NSMutableArray *res) {
            self.myFriends = res;
            [self.tableView reloadData];
        }];
        [self.tableView setEditing:YES];
        publicToAllIndex = NO;
        privateToAllIndex = NO;
        upladingFlag = NO;
    }
    return self;
}
- (void)initUserInterface{
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTabbed)];
    //  [navItem setLeftBarButtonItem:leftButton];
    //    [navItem setRightBarButtonItem:rightButton];
    [self.navigationItem setRightBarButtonItem:rightButton animated:NO];
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

-(void)doneButtonTabbed{
    [self.delegate getChooseFriends:self.chosenFriends];
    NSLog(@"select friends %d,%@",[[self chosenFriends] count],[self.chosenFriends objectAtIndex:0]);
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }else{
        return [self.myFriends count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        static NSString *CellIdentifier = @"FriendCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        User *aFr = [self.myFriends objectAtIndex:indexPath.row];
        cell.textLabel.text = [aFr getNickname];
        cell.detailTextLabel.text = [aFr getUID];
        // TODO:set the user to be
        
        if ([aFr getPersonImg] != nil) {
            
            __weak UITableViewCell *weakCell = cell;
            NSString *urlString = [[FPHttpClient getBaseURL] stringByAppendingString:@"file/"];
            urlString = [urlString stringByAppendingString:[aFr getPersonImg]];
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            UIImage *placeholderImage = [UIImage imageNamed:@"personlImageplaceHoder"];
            [cell.imageView setImageWithURLRequest:request
                                  placeholderImage:placeholderImage
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               weakCell.imageView.image = image;
                                               CALayer *lay  = weakCell.imageView.layer;//获取ImageView的层
                                               [lay setMasksToBounds:YES];
                                               
                                               [lay setCornerRadius:22.0f];//值越大，角度越圆
                                               [weakCell setNeedsLayout];
                                           }failure:nil];
            
        }
        
        
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        if(indexPath.row == 0) {
            [cell.textLabel setText:@"仅自己可见"];
            
        }else if(indexPath.row == 1){
            [cell.textLabel setText:@"对全部好友可见"];
            
        }
        return cell;
        
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)update{
    NSIndexPath *indexPath;
    UITableViewCell *cell;
    if (!upladingFlag) {
        upladingFlag = YES;
        if (publicToAllIndex) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.userInteractionEnabled = NO;
            for (int row = 0; row < [[self myFriends] count]; row++) {
                indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                
    //            User *chosenUsr = [self.myFriends objectAtIndex:indexPath.row];
    ////            if ([self.chosenFriends indexOfObject:[chosenUsr uID]]  == NSNotFound) {
    ////                [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    ////            }
                
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.userInteractionEnabled = NO;
                
            }
            
        }else if(privateToAllIndex){
            indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.userInteractionEnabled = NO;
            for (int row = 0; row < [[self myFriends] count]; row++) {
                
                indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                
    //            User *chosenUsr = [self.myFriends objectAtIndex:indexPath.row];
    //            if ([self.chosenFriends indexOfObject:[chosenUsr uID]]  != NSNotFound) {
    //                
    //                [self tableView:self.tableView didDeselectRowAtIndexPath:indexPath];
    //            }
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.userInteractionEnabled = NO;
            }
        }else{
            indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.userInteractionEnabled = NO;
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.userInteractionEnabled = NO;
            
            for (int row = 0; row < [[self myFriends] count]; row++) {
                indexPath = [NSIndexPath indexPathForRow:row inSection:1];
                cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.userInteractionEnabled = YES;
            }
        }
    }
    upladingFlag = NO;
}
- (void)resetRow {
    if (!upladingFlag) {
        upladingFlag = YES;
    
        NSIndexPath *indexPath;
        UITableViewCell *cell;
        upladingFlag = YES;
        
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.userInteractionEnabled = YES;
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.userInteractionEnabled = YES;
        
        for (int row = 0; row < [[self myFriends] count]; row++) {
            indexPath = [NSIndexPath indexPathForRow:row inSection:1];
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.userInteractionEnabled = YES;
        }
    }
    upladingFlag = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!privateToAllIndex) {
                privateToAllIndex = YES;
                [self.chosenFriends removeAllObjects];
                [self.chosenFriends addObject:@"0"];
                
                
            }
            //TODO: handle only to myself
            
        }else if(indexPath.row == 1){
            //TODO: handley public to all my friends
            if (!publicToAllIndex) {
                publicToAllIndex = YES;
                [self.chosenFriends removeAllObjects];
                [self.chosenFriends addObject:@"-1"];
                
            }
        }
    }else{
        User *chosenUsr = [self.myFriends objectAtIndex:indexPath.row];
        if ([self.chosenFriends indexOfObject:[chosenUsr uID]]  == NSNotFound) {
            if ([[self.chosenFriends objectAtIndex:0] isEqualToString:@"-1"]) {
                [self.chosenFriends removeAllObjects];
            }
            [self.chosenFriends addObject:[chosenUsr uID]];
            
        }
    }
    if (!upladingFlag) {
        [self update];
    }
    
}

//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (privateToAllIndex) {
                privateToAllIndex = NO;
                [self.chosenFriends removeAllObjects];
                [self.chosenFriends addObject:@"-1"];
                [self resetRow];
                
            }
            //TODO: handle only to myself
        }else if(indexPath.row == 1){
            if (publicToAllIndex) {
                publicToAllIndex = NO;
                [self.chosenFriends removeAllObjects];
                [self.chosenFriends addObject:@"-1"];
                [self resetRow];
                
            }
        }
    }else{
        User *chosenUsr = [self.myFriends objectAtIndex:indexPath.row];
        if ([self.chosenFriends indexOfObject:[chosenUsr uID]]  != NSNotFound) {
            
            [self.chosenFriends removeObject:[chosenUsr uID]];
            if ([self.chosenFriends count] == 0) {
                [self.chosenFriends addObject:@"-1"];
                [self resetRow];
                
                //default public to all
            }else{
                return ;
            }
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40.0f;
    }else{
        return 24.0f;
    }
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
