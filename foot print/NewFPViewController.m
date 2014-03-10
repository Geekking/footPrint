#import "NewFPViewController.h"
#import "FootPrint.h"
#import "AFNetworking.h"
#import "FPHttpClient.h"

@interface NewFPViewController ()<UIActionSheetDelegate>

@property (strong, nonatomic)FootPrint *aFP;
@property (strong, nonatomic)FPHttpClient *client;

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //TODO: ADD SOME PLACEholder PHOTO
    self.shortImage.image = [self.aFP objectForKey:@"coverImage"];
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
        self.aFP = [[FootPrint alloc]init];
        [self setValue:image forKey:@"coverImage"];
        [self setValue:fileURL forKey:@"localURL"];
        
    }
    return self;
}

- (IBAction)uploadButtonTapped:(id)sender {
    
    [self.client uploadNewFPForFP:self.aFP fileURL:[self.aFP getFileURL] completion:^(NSArray *results, NSError *error) {
        NSLog(@"hello");
    }];
}

- (IBAction)chooseSecurityTypeButtonTabbed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择文权限"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"OnlyToMyself", @"OnlyToSomeFriends", @"OnlyToAllFriends",@"OnlyToPswFriends",@"PublicToAll",nil];
    [actionSheet showInView:self.view];
}
#pragma  actionSheetdeleage

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet cancelButtonIndex])
        return;
    NSInteger type;
   /* if (buttonIndex == 0) {
        type = kOnlyToMyself;
        [self.aFP setValue:*type forKey:@"secureType"];
    }else if (buttonIndex == 1){
        [self.aFP setValue:kOnlyToSomeFriends forKey:@"secureType"];
        //TODO: at some friends;
    }else if (buttonIndex == 2){
        [self.aFP setValue:kOnlyToAllFriends forKey:@"secureType"];
        
    }else if (buttonIndex == 3){
        [self.aFP setValue:kOnlyToPswFriends forKey:@"secureType"];
        //TODO: SET A PASSWORD
    }else {
        [self.aFP setValue:kPublicToAll forKey:@"secureType"];
    }
    */
}

#pragma  picker deleagete

@end
