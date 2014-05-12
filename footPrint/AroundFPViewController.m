//
//  AroundFPViewController.m
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "AroundFPViewController.h"
#import "FPNearFPManager.h"
#import "FootPrint.h"
#import "AroundFPTableViewCell.h"
#import "MyFPViewController.h"
#import "FPDetailTableViewController.h"
@interface AroundFPViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIButton *_bottomRefresh;
    float RCellHeight;
    BOOL _loadingMorefp;
}

@end

@implementation AroundFPViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)initUserInterface{
    RCellHeight = 90.0f;
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(searchAroundMe)];
//    [self.navigationItem setRightBarButtonItem:rightButton animated:NO];
//
    self.title = @"好友圈";
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    refresh.tintColor = [UIColor blueColor];
    [refresh addTarget:self action:@selector(refreshBtnTabbed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    /******自定义查看更多属性设置******/
    
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh setTitle:@"查看更多" forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    //[_bottomRefresh addTarget:self action:@selector(upToRefresh) forControlEvents:UIControlEventTouchUpInside];
    _bottomRefresh.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height+[self.nearFPs count]*RCellHeight, 320, RCellHeight);
    [self.tableView addSubview:_bottomRefresh];
    [self setHidesBottomBarWhenPushed:YES];
    
    
    UIView *header = [[UIView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/3)];
    UIImageView *headerImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.jpg"] ];
    headerImg.frame = CGRectMake(0, -[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [header addSubview:headerImg];
    
    self.tableView.tableHeaderView = header;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
    self.nearFPs = [[NSMutableArray alloc ] initWithCapacity:0];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidDisappear:(BOOL)animated{
    [self setHidesBottomBarWhenPushed:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshBtnTabbed{
    if ([self.refreshControl isRefreshing]) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"refreshing"];
        [self performSelector:@selector(searchAroundMe) withObject:nil afterDelay:0.2f];
    }

}
- (void)searchAroundMe{
    [[FPNearFPManager sharedFriendsManager] fetchAllMyFriendsWithDirection:@"1" Completion:^(NSArray *res, NSError *error) {
        if (error) {
            NSLog(@"error");
        }else{
            
            NSLog(@"%@",res);
            for(NSDictionary *aFP in res) {
                NSDictionary *fpDict = [self translateFriendFP:aFP];
                [self.nearFPs insertObject:[[FootPrint alloc] initWithDictionary:fpDict] atIndex:0];
            }
            
        }
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"pull to refresh"];
        if([self.nearFPs count]> 0 && [[UIScreen mainScreen] bounds].size.height <  [self.nearFPs count] * RCellHeight ){
            _bottomRefresh.frame = CGRectMake(0, 20+[self.nearFPs count]*RCellHeight, 320, RCellHeight);
        }
        [self.tableView reloadData];
    }];
   

}
- (NSDictionary *)translateFriendFP:(NSDictionary *)friFP{
    NSMutableDictionary *fpDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [fpDict setValue:friFP[@"fpID"] forKey:@"fpID"];
    [fpDict setValue:friFP[@"uID"] forKey:@"userID"];
    [fpDict setValue:friFP[@"descript"] forKey:@"description"];
    [fpDict setValue:friFP[@"secureType"] forKey:@"secureType"];
    [fpDict setValue:friFP[@"location"] forKey:@"location"];
    [fpDict setValue:friFP[@"position"] forKey:@"position"];
    [fpDict setValue:friFP[@"infouIDs"] forKey:@"infouIDs"];
    
    [fpDict setValue:friFP[@"videoTime"] forKey:@"videoTime"];
    
    [fpDict setValue:friFP[@"imageUrl"] forKey:@"coverImageURL"];
    [fpDict setValue:friFP[@"movieUrl"] forKey:@"movieUrl"];
    
    
    return fpDict;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nearFPs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NearFPIdentifier = @"AroundFPCell";
    
    if (!AroundnibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"AroundFPTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:NearFPIdentifier];
        AroundnibsRegistered = YES;
    }
    
    AroundFPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NearFPIdentifier];
    if (cell == nil) {
        cell = [[AroundFPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NearFPIdentifier];
    }
    [cell configureCell: [self.nearFPs objectAtIndex:indexPath.row]];
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    FPDetailTableViewController *detailViewController = [[FPDetailTableViewController alloc] initWithFootPrint:[self.nearFPs objectAtIndex:indexPath.row]];
    // Pass the selected object to the new view controllers
    // Push the view controller.
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

- (void)comment{
    
}

+ (void)setAroundnibRegistered:(BOOL)value{
    AroundnibsRegistered = value;
}


#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    
    // 假设偏移表格高度的15%进行刷新
    
    
    
    if (!_loadingMorefp) { // 判断是否处于刷新状态，刷新中就不执行
        
        
        
        // 取内容的高度：
        
        //    如果内容高度大于UITableView高度，就取TableView高度
        
        //    如果内容高度小于UITableView高度，就取内容的实际高度
        
        float height = scrollView.contentSize.height > self.tableView.frame.size.height ?self.tableView.frame.size.height : scrollView.contentSize.height;
        
        
        
        if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.15) {
            _loadingMorefp = YES;
            // 调用上拉加载方法
            [self upToRefresh];
            
        }
        
        
        
        //        if (- scrollView.contentOffset.y / _tableView.frame.size.height > 0.2) {
        //
        //            // 调用下拉刷新方法
        //
        //        }
    }
}

- (void)upToRefresh
{
    _bottomRefresh.enabled = NO;
    double delayInSeconds = 1.5;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [[FPNearFPManager sharedFriendsManager] fetchAllMyFriendsWithDirection:@"-1" Completion:^(NSArray *res, NSError *error) {
            if (error) {
                NSLog(@"error");
            }else{
                if ([res count] > 0) {
                    for(NSDictionary *aFP in res) {
                        NSDictionary *fpDict = [self translateFriendFP:aFP];
                        //[self.nearFPs insertObject:[[FootPrint alloc] initWithDictionary:fpDict] atIndex:[self.]];
                        [self.nearFPs addObject:[[FootPrint alloc] initWithDictionary:fpDict]];
                    }
                    
                }else{
                    [_bottomRefresh.titleLabel setText:@"no more"];
                }
                
                
            }
            
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if([self.nearFPs count]> 0 && [[UIScreen mainScreen] bounds].size.height <  [self.nearFPs count] * RCellHeight ){
            _bottomRefresh.frame = CGRectMake(0, 20+[self.nearFPs count]*RCellHeight, 320, RCellHeight);
        }
        _bottomRefresh.enabled = YES;
        [self.tableView reloadData];
        _loadingMorefp = NO;
    });
}

@end
