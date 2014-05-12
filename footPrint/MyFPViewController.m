//
//  MyFPViewController.m
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "MyFPViewController.h"
#import <MapKit/MapKit.h>
#import "NewFPViewController.h"
#import "LocationManager.h"
#import "FootPrint.h"
#import "MyFootPrintCell.h"
#import "FPMyFootPrintManager.h"
#import <AVFoundation/AVFoundation.h>
#import "FPDetailTableViewController.h"

static int RCellHeight = 90;

@interface MyFPViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIButton *_bottomRefresh;
    BOOL _loadingMorefp;
}

@property (strong, nonatomic)NSMutableArray *uploadedtableSource;
@property (strong, nonatomic)NSMutableArray *uploadingtableSource;
@property (nonatomic)NSInteger currentPage;
@property (strong,nonatomic)UIImagePickerController *picker;

@end

@implementation MyFPViewController

- (void)initUserInsterface{
        //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newFPButtonTabbed)];
    [self.navigationItem setRightBarButtonItem:rightButton animated:NO];
    
    self.tableView.pagingEnabled = YES;
    
    NSArray *segArray = [[NSArray alloc] initWithObjects:@"附近脚印",@"所有脚印", nil];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segArray];
    segmentControl.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0.0f, 50.0f, 30.0f);
    [segmentControl addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
//    [self.navigationItem setTitleView:segmentControl];
    self.navigationItem.title = @"我的脚印";
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    refresh.tintColor = [UIColor blueColor];
    [refresh addTarget:self action:@selector(refreshTabbed) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    /******自定义查看更多属性设置******/
    
    _bottomRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomRefresh setTitle:@"查看更多" forState:UIControlStateNormal];
    [_bottomRefresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bottomRefresh setContentEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    //[_bottomRefresh addTarget:self action:@selector(upToRefresh) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:_bottomRefresh];
    
}
- (void)sortMyFPBytime:(NSArray *)uploadedFP{
    
}
- (void)sortMyFPByDistance:(NSArray *)uploadedFP{
    
}

- (void)selected:(id)sender{
    NSInteger selectedIndex = ((UISegmentedControl *)sender).selectedSegmentIndex;
    if(selectedIndex == 0){
        [self sortMyFPByDistance:self.uploadedtableSource];
    }else{
        [self sortMyFPBytime:self.uploadedtableSource];
        NSLog(@"%d",selectedIndex);
    }
    
}
- (id) init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    //[self setHidesBottomBarWhenPushed:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setHidesBottomBarWhenPushed:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.uploadedtableSource = [NSMutableArray arrayWithCapacity:0];
    self.uploadingtableSource = [NSMutableArray arrayWithCapacity:0];
    self.currentPage = 0;
    _loadingMorefp = NO;
    
    FPMyFootPrintManager *client = [FPMyFootPrintManager sharedInstance];
    self.uploadedtableSource = [client fetchCurrentFootPrintsInPages:self.currentPage];
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    
    [self initUserInsterface];
    
   // [self.tableView reloadData];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newFPButtonTabbed {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIActionSheet *chooseSourcesheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"take picture" otherButtonTitles:@"choose from phone album", nil];
        chooseSourcesheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [chooseSourcesheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }else{
        self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
        self.picker.mediaTypes = temp_MediaTypes;
       
        self.picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.picker animated:YES completion:nil];
    }
    
}
- (void)loadData{
    FPMyFootPrintManager *client = [FPMyFootPrintManager sharedInstance];
    self.currentPage = 0;
    self.uploadedtableSource = [client fetchCurrentFootPrintsInPages:self.currentPage];
    
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"pull to refresh"];
    
    if([self.uploadedtableSource count]> 0 && [[UIScreen mainScreen] bounds].size.height <  [self.uploadedtableSource count] * RCellHeight ){
        NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height);
        _bottomRefresh.frame = CGRectMake(0, 20+[self.uploadedtableSource count]*RCellHeight, 320, RCellHeight);
    }
    [self.tableView reloadData];
    
}
- (void)refreshTabbed{
    if ([self.refreshControl isRefreshing]) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"refreshing"];
        [self performSelector:@selector(loadData) withObject:nil afterDelay:0.2f];
    }
}

+ (UIImage *)getImage:(NSURL *)videoURL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(600, 450);
    
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    
    return image;
}



#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    BOOL isDir = NO;
    NSString *imageDir = [NSString stringWithFormat:@"%@/Cache", documentDirectory];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    UIImage *image = [UIImage alloc];
    NSURL *fileURL = [NSURL alloc];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSDate *localDate = [NSDate date];
        NSString *fileName = [NSString stringWithFormat:@"/%ld.jpg", (long)[localDate timeIntervalSince1970]];
        
        NSString *imageFile = [imageDir stringByAppendingString:fileName];
        success = [fileManager fileExistsAtPath:imageFile];
        if( success ){
            success = [fileManager removeItemAtPath:imageFile error:nil];
        }
        
        [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFile atomically:YES];
        fileURL = [NSURL fileURLWithPath:imageFile];
        
    }else if([ mediaType isEqualToString:@"public.movie"]){
        fileURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSData *videoData = [NSData dataWithContentsOfURL:fileURL];
        
        NSDate *localDate = [NSDate date];
        NSString *fileName = [NSString stringWithFormat:@"/%ld.mov", (long)[localDate timeIntervalSince1970]];
        NSString *videoFile = [imageDir stringByAppendingString:fileName];
        success = [fileManager fileExistsAtPath:videoFile];
        if( success){
            success = [fileManager removeItemAtPath:videoFile error:nil];
        }
        [videoData writeToFile:videoFile atomically:YES];
        image = [MyFPViewController getImage:fileURL];
    }
    
    NewFPViewController *newFPView = [[NewFPViewController alloc] initWithImage:image filURL:fileURL];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:newFPView animated:NO];
    [self setHidesBottomBarWhenPushed:NO];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //TODO: add asyncni c updloading
    //return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0;
//    }
    NSLog(@"numberof rows: %lu",(unsigned long)[self.uploadedtableSource count]);
    return [self.uploadedtableSource count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        
//        static NSString *CellIdentifier = @"UploadingCell";
//        UITableViewCell *uploadingcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        // Configure the cell
//        if (uploadingcell == nil) {
//            uploadingcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//        uploadingcell.textLabel.text = @"Uploading";
//        return  uploadingcell;
//    }
    
    static NSString *UploadedCellIdentifier = @"UploadedCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MyFootPrintCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:UploadedCellIdentifier];
        nibsRegistered = YES;
    }
    
    MyFootPrintCell *cell = [tableView dequeueReusableCellWithIdentifier:UploadedCellIdentifier];
    if (cell == nil) {
        cell = [[MyFootPrintCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UploadedCellIdentifier];
    }
    [cell configureCell: [self.uploadedtableSource objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        FPDetailTableViewController *detailViewController = [[FPDetailTableViewController alloc] initWithFootPrint:[self.uploadedtableSource objectAtIndex:indexPath.row]];

        // Pass the selected object to the new view controller.
        
        // Push the view controller.
        [detailViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 90.0f;
}

#pragma mark - Scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    
    // 假设偏移表格高度的20%进行刷新
    
    
    
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
        FPMyFootPrintManager *client = [FPMyFootPrintManager sharedInstance];
        self.currentPage += 1;
        if ([[client fetchCurrentFootPrintsInPages:self.currentPage] count] == 0) {
            [_bottomRefresh.titleLabel setText:@"no more"];
        }
        else {
            [self.uploadedtableSource addObjectsFromArray:[client fetchCurrentFootPrintsInPages:self.currentPage]];
            [self.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if([self.uploadedtableSource count]> 0 && [[UIScreen mainScreen] bounds].size.height <  [self.uploadedtableSource count] * RCellHeight ){
            NSLog(@"%f",[[UIScreen mainScreen] bounds].size.height);
            _bottomRefresh.frame = CGRectMake(0, 20+[self.uploadedtableSource count]*RCellHeight, 320, RCellHeight);
        }
        _bottomRefresh.enabled = YES;
        
        _loadingMorefp = NO;
    });
}


#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
        self.picker.mediaTypes = temp_MediaTypes;
        self.picker.videoMaximumDuration = 7.0f;
        self.picker.videoQuality = UIImagePickerControllerQualityTypeMedium;

        self.picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.picker animated:YES completion:nil];

    }else if (buttonIndex == 1) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
        self.picker.mediaTypes = temp_MediaTypes;
        
        self.picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:self.picker animated:YES completion:nil];

    }else if(buttonIndex == 2) {
        
    }
    
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}


+ (void)setNibRegistered:(BOOL)value{
    nibsRegistered = value;
}

@end
