#import "NewFPViewController.h"
#import "FootPrint.h"
#import "AFNetworking.h"
#import "FPHttpClient.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
#import "RootViewController.h"
#include "AppDelegate.h"
#include "FPCSViewController.h"

@interface NewFPViewController ()<UINavigationControllerDelegate,FPChooseFriendsDelegate,UIActionSheetDelegate>

@property (strong, nonatomic)FootPrint *aFP;
@property (strong, nonatomic)FPHttpClient *client;
@property (strong, nonatomic)NSURL *fileURL;
@property (strong, nonatomic)UIImage *coverImage;
@property (strong, nonatomic)NSString *position;

@property (strong, nonatomic)NSMutableArray *informFriends;
@property (strong, nonatomic)FPCSViewController *csViewController;
@end

@implementation NewFPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)initUserInterface{
    
    self.shortImage.image = self.coverImage;
    //创建一个右边按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(uploadButtonTapped:)];
    [self.navigationItem setRightBarButtonItem:rightBtn animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //TODO: ADD SOME PLACEholder PHOTO
    [self initUserInterface];
    
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    
    self.currentPosition.text = [defaultUser objectForKey:@"FPCurrentAddress"];
    
    [[LocationManager sharedInstance] getCurrentPosition:^(NSString *addressString) {
        [self.currentPosition setText:addressString];
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (id)initWithImage:(UIImage *)image filURL:(NSURL *)fileURL{
    self = [super init];
    if (self){
        self.client = [FPHttpClient sharedHttpClient];
        self.coverImage = image;
        self.fileURL = fileURL;
        //TODO:set to empty
        self.informFriends = [[NSMutableArray alloc] initWithObjects:@"-1", nil];
        self.csViewController = [[FPCSViewController alloc] initWithFriends:self.informFriends];
    }
    [self setHidesBottomBarWhenPushed:YES];
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    if ([self.informFriends count] ==0 ){
        [self.selectSecurityType.titleLabel setText:@"private"];
    }
    else if ([self.informFriends count] == 1 ) {
        if ([[self.informFriends objectAtIndex:0] isEqualToString: @"0"]) {
            [self.selectSecurityType.titleLabel setText:@"private"];
        }else if([[self.informFriends objectAtIndex:0] isEqualToString: @"-1"]){
            [self.selectSecurityType.titleLabel setText:@"public"];
        }else{
            [self.selectSecurityType.titleLabel setText:@"部分好友可见"];
        }
    }else{
        [self.selectSecurityType.titleLabel setText:@"部分好友可见"];
        
    }
}

- (IBAction)uploadButtonTapped:(id)sender {
    NSLog(@"currentloca:%@",self.currentPosition.text);
    
    self.aFP = [[FootPrint alloc] initWithDescription:self.descriptionTextField.text coverImage:self.coverImage currentPosition:self.currentPosition.text informUserList:self.informFriends secureType:kOnlyToMyself videoURL:self.fileURL];
    //TODO: asynchroize uploading the files.
    
    [self.client uploadNewFPForFP:self.aFP fileURL:[self.aFP getFileURL] completion:^(NSDictionary *results, NSError *error) {
        
        NSNumber *num = [[NSNumber alloc] initWithInt:400];
        if ([results[@"code"] isEqualToNumber:num]) {
            
            //TODO: delete the fp from uplatind fps
            
            self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController popViewControllerAnimated:YES];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager removeItemAtURL:self.fileURL error:nil]) {
            };
        }
    }];
}
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}

- (IBAction)chooseSecurityTypeButtonTabbed:(id)sender {
    [self.navigationController pushViewController:self.csViewController animated:NO];
    
}

- (IBAction)TextField_DidEndOnexit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
#pragma mark- uinavigation delegate


#pragma mark - UIActionsheet delegate
- (void)backNavTabbed{
    UIActionSheet *confirmShet = [[UIActionSheet alloc] initWithTitle:@"Are you sure" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"yes" otherButtonTitles:nil, nil];
    [confirmShet showInView:[UIApplication sharedApplication].keyWindow];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager removeItemAtURL:self.fileURL error:nil]) {
            
        };
    }else{
        
    }
}
#pragma FPChooseFriendsDelegate
- (void)getChooseFriends:(NSMutableArray *)chosenFriends{
    self.informFriends = chosenFriends;
}

#pragma  picker deleagete

#pragma kvc delegete

@end
