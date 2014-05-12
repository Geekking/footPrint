//
//  FPDetailTableViewController.m
//  footprint
//
//  Created by apple on 5/6/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FPDetailTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Comment.h"
#import "FPHttpClient.h"
#import "UIImageView+AFNetworking.h"
@interface FPDetailTableViewController (){
    NSMutableArray *_commentlist;
}

@property (strong, nonatomic) FootPrint *fp;
@property (strong,nonatomic) MPMoviePlayerController *player;
@end

@implementation FPDetailTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.descriptionLabel = [[UILabel alloc] init];
    self.coverImage = [[UIImageView alloc] init];
    self.timeLabel = [[UILabel alloc] init];
    self.locationLabel = [[UILabel alloc] init];
    self.informUserList = [[UILabel alloc] init];
    self.playBtn = [[UIButton alloc] init];
    self.commentBtn = [[UIButton alloc] init];
    self.commentContentText = [[UITextField alloc] init];
    //[self initUserInterface];
    [self fetchCommentOfFP];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (id)initWithFootPrint:(FootPrint *)fp{
    self = [super init];
    if (self) {
        self.fp = fp;
    }
    return  self;
}

- (void)initUserInterface{
    self.descriptionLabel.text = [self.fp getInfo][@"description"];
    
    self.locationLabel.text = [self.fp getInfo][@"position"];
    
    NSDate *videoTime = [self.fp getInfo][@"videoTime"] ;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    self.timeLabel.text = [formatter stringFromDate:videoTime];
    
    NSString *informIDs = [self.fp getInfo][@"infouIDs"];
    if ([informIDs isEqualToString: @"0"]) {
        [self.informUserList setText:@"private"];
    }else if([informIDs isEqualToString: @"-1"]){
        [self.informUserList setText:@"public"];
    }else{
        [self.informUserList setText:@"部分好友可见"];
    }
    
    if ([self.fp getImage] != nil) {
        [self.coverImage setImage:[self.fp getImage]];
    }else{
        __weak FPDetailTableViewController *weakDetail = self;
        NSString *urlString = [[FPHttpClient getBaseURL] stringByAppendingString:@"file/"];
        urlString = [urlString stringByAppendingString:[self.fp getInfo][@"coverImageURL"] ];
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        [self.coverImage setImageWithURLRequest:request
                               placeholderImage:placeholderImage
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            weakDetail.coverImage.image = image;
                                            //[self.fp setCoverImage:image];
                                            
                                        }failure:nil];
        
    }
    
    if ([[self.fp getInfo][@"movieUrl"] isEqualToString:@"undefine"]) {
        self.playBtn.enabled = NO;
    }else{
        self.playBtn.enabled = YES;
        [self.playBtn setTitle:@"PLAY" forState:UIControlStateNormal];
        [self.playBtn addTarget:self action:@selector(playMovieTabbed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.commentBtn setTitle:@"comment" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(commentBtnTabbed) forControlEvents:UIControlEventTouchUpInside];
    [self.commentContentText setHidden:YES];
    [self.commentContentText setPlaceholder:@"say something"];
     [self.commentContentText addTarget:self action:@selector(commentTypeEnd) forControlEvents:UIControlEventEditingDidEndOnExit];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    //    header.backgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.2 blue:0.3 alpha:0.5f];
    
    self.descriptionLabel.frame = CGRectMake(30, 70, 270, 25);
    [header addSubview:self.descriptionLabel];
    
    self.coverImage.frame = CGRectMake(30, 110, 270, 180);
    NSLog(@"%@",self.coverImage);
    [header addSubview:self.coverImage];
    
    self.timeLabel.frame = CGRectMake(30, 325,200 , 20);
    [header addSubview:self.timeLabel];
    
    self.locationLabel.frame = CGRectMake(70, 350, 215, 20);
    [header addSubview:self.locationLabel];
    
    self.informUserList.frame = CGRectMake(30, 380, 260, 25);
    [header addSubview:self.informUserList];
    
    
    self.commentBtn.frame = CGRectMake(200, 400, 100, 30);
    [header addSubview:self.commentBtn];
    
    self.commentContentText.frame =  CGRectMake(30, 400, 270, 30);
    [header addSubview:self.commentContentText];
    
    self.playBtn.frame = CGRectMake(120, 180, 70, 50);
    [header addSubview:self.playBtn];
    self.tableView.tableHeaderView = header;

}

- (void)commentBtnTabbed{
    [self.commentBtn setHidden:YES];
    [self.commentContentText setHidden:NO];
    [self.commentContentText becomeFirstResponder];
}
- (void)commentTypeEnd{
    [self.commentContentText setHidden:YES];
    [self.commentBtn setHidden:NO];
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    if ([self.commentContentText.text length] > 0) {
        [client commentOnFP:(NSUInteger)[self.fp getInfo][@"fpID"] comentContent:self.commentContentText.text completion:^(NSDictionary *results, NSError *error) {
            if (error) {
                NSLog(@"comment error");
            }else{
                [self fetchCommentOfFP];
                NSLog(@"comment success");
            }
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUserInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) playMovieTabbed:(id)sender {
    
    NSString *urlString = [[FPHttpClient getBaseURL] stringByAppendingString:@"file/"];
    urlString = [urlString stringByAppendingString:[self.fp getInfo][@"movieUrl"] ];
    NSURL *url = [NSURL URLWithString:urlString];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.player.controlStyle = MPMovieControlStyleFullscreen;
    [self.navigationItem setHidesBackButton:YES];
    [self.player.view setFrame:self.view.bounds];
    self.player.initialPlaybackTime = -1;
    [self.view addSubview:self.player.view];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player];
    [self.player play];
}

- (void)fetchCommentOfFP{
    FPHttpClient *client = [FPHttpClient sharedHttpClient];
    [client getCommentOfFP:(NSUInteger)[self.fp getInfo][@"fpID"]  completion:^(NSDictionary *results, NSError *error){
        if (error) {
            NSLog(@"fetch comment error:%@",error);
        }else{
            if ([results[@"code"] isEqualToNumber:@630]) {
                _commentlist = results[@"results"];
                [self.tableView reloadData];
            }else{
                NSLog(@"%@",results[@"phase"]);
            }
        }
        
    }];
}

#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
    [self.navigationItem setHidesBackButton:NO];
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 668.0f;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    [self initUserInterface];
//    return header;
//}

#pragma mark -
#pragma tableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    static NSString *commentCellID = @"commentCell";
    cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commentCellID];
    }
    NSString *commentContent = [_commentlist objectAtIndex:indexPath.row][@"commentContent"];
    NSString *commentUser = [_commentlist objectAtIndex:indexPath.row][@"commentUserID"];
    NSString *commentTimeStamp = [_commentlist objectAtIndex:indexPath.row][@"commentTime"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[commentTimeStamp intValue]];
    NSString *commentTime = [formatter stringFromDate:date];
    
    NSString *text = [[NSString alloc] initWithFormat:@"%@:%@  %@",commentUser,commentContent,commentTime];
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark -
#pragma tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        return [_commentlist count];
        
    }else{
        return 0;
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
