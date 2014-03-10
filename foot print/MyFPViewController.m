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

@interface MyFPViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)CLLocation *currentPosition;

@end

@implementation MyFPViewController

- (void)initUserInsterface{
    UINavigationBar *title = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"my FootPrint"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"refresh"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(refreshTabbed)];
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newFPButtonTabbed)];
    [title pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftButton];
    [navItem setRightBarButtonItem:rightButton];
    [self.view addSubview:title];
   // self.title = @"足迹";
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUserInsterface];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newFPButtonTabbed {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.mediaTypes = temp_MediaTypes;
        
        picker.videoMaximumDuration = 30.0f;
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.mediaTypes = temp_MediaTypes;
    }
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)refreshTabbed{
    
}

- (CGImageRef )getImage:(NSData *)videoData{
    CGImageRef img = nil;
    return img;
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    UIImage *image = [UIImage alloc];
    NSURL *fileURL = [NSURL alloc];
    if ([mediaType isEqualToString:@"public.image"]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        //TODO: REname the file
        NSString *imageFile = [documentDirectory stringByAppendingString:@"/temp.jpg"];
        success = [fileManager fileExistsAtPath:imageFile];
        if( success ){
            success = [fileManager removeItemAtPath:imageFile error:nil];
        }
        //TODO: edit more on file
        [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFile atomically:YES];
        fileURL = [NSURL fileURLWithPath:imageFile];
        
    }else if([ mediaType isEqualToString:@"public.movie"]){
        fileURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"%@",fileURL);
        NSData *videoData = [NSData dataWithContentsOfURL:fileURL];
        NSString *videoFile = [documentDirectory stringByAppendingString:@"/temp.mov"];
        success = [fileManager fileExistsAtPath:videoFile];
        if( success){
            success = [fileManager removeItemAtPath:videoFile error:nil];
        }
        [videoData writeToFile:videoFile atomically:YES];
        CGImageRef img = [self getImage:videoData];
        image = [UIImage imageWithCGImage:img];
    }
    NSLog(@"selected URL %@",fileURL);
    [picker dismissViewControllerAnimated:YES completion:^{
        NewFPViewController *newFPView = [[NewFPViewController alloc] initWithImage:image filURL:fileURL];
        [self presentViewController:newFPView animated:YES completion:nil];
        NSLog(@"change over %@",[self presentedViewController]);
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
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

@end
