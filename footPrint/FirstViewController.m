//
//  FirstViewController.m
//  footPrint
//
//  Created by apple on 2/23/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FirstViewController.h"
#import <MapKit/MapKit.h>
#import "NewFPViewController.h"
#import "LocationManager.h"

@interface FirstViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)CLLocation *currentPosition;

@end

@implementation FirstViewController

- (void)initUserInsterface{

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
       
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addVideoButtonTabbed:(id)sender {
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

- (IBAction)uploadVideoButtonTabbed:(id)sender {
    
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

#pragma tableView delegate 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

@end
