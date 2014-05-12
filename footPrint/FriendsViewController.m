//
//  FriendsViewController.m
//  foot print
//
//  Created by apple on 3/3/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "FriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FPAddressBook.h"
#import "SearchFriendsViewController.h"
#import "FPMyFriendsManager.h"
#import "User.h"
#import "FPHttpClient.h"
#import "UIImageView+AFNetworking.h"
@interface FriendsViewController ()<UIScrollViewDelegate,UISearchDisplayDelegate>{
    NSMutableArray *_searchList;
    NSFileManager *_fimeManager;
    NSString *_homedir;
}
@property (strong, nonatomic)NSMutableArray *addressBook;
@property (strong, nonatomic)NSMutableArray *friendsArray;
@property (strong, nonatomic)FPMyFriendsManager *manager;

@end

@implementation FriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)initUserInterface{
    self.title = @"朋友";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(searchFrendsButtonTabbed)];
        [self.navigationItem setRightBarButtonItem:rightButton];
    
    self.searchDisplayController.searchBar.placeholder = @"search you friends";
    
    self.addressBook = [NSMutableArray array];
    self.manager = [FPMyFriendsManager sharedFriendsManager];
    [self.manager fetchAllMyFriends:^(NSMutableArray * res) {
        self.friendsArray =res;
        [self.tableView reloadData];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [self initUserInterface];
    
}
/*
- (void) test{
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    
    else
        
    {
        addressBooks = ABAddressBookCreateWithOptions(nil, nil);
        
    }
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        FPAddressBook *addressBook = [[FPAddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [self.addressBook addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    _fimeManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _homedir = [paths objectAtIndex:0];
    
    //[self initUserInterface];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return _searchList.count;
    }
    else{
        
        return [self.friendsArray count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    User *aFr;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        aFr = [_searchList objectAtIndex:indexPath.row];
    }else{
        aFr = [self.friendsArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = [aFr getNickname];
    cell.detailTextLabel.text = [aFr getUID];
    
    // TODO:set the user to be
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    NSString *path = [_homedir stringByAppendingString:@"/image/"];
    path = [_homedir stringByAppendingString:(NSString *)[defau objectForKey:@"userID"]];
    
    
    __weak UITableViewCell *weakCell = cell;
    
    NSString *urlString;
    NSString *filePath = [path stringByAppendingFormat:@"/%@",[aFr getPersonImg]];
    if([ _fimeManager fileExistsAtPath:filePath]){
        urlString = filePath;
    }
    else{
        urlString = [[FPHttpClient getBaseURL] stringByAppendingString:@"file/"];
        urlString = [urlString stringByAppendingString:[aFr getPersonImg]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"personlImageplaceHolder.jpg"];
    cell.imageView.image = placeholderImage;
    
    [cell.imageView setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           weakCell.imageView.image = image;
                                           CALayer *lay  = weakCell.imageView.layer;//获取ImageView的层
                                           [lay setMasksToBounds:YES];
                                           [lay setCornerRadius:22.0f];//值越大，角度越圆
                                           
                                           [weakCell setNeedsLayout];
                                           
                                           if( [_fimeManager fileExistsAtPath:filePath] == NO){
                                               [UIImageJPEGRepresentation(image, 1.0f) writeToFile:filePath atomically:YES];
                                           }
                                           
                                       }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           NSLog(@"%@",response);
                                           NSLog(@"%@",error);
                                       }];

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

- (void)searchFrendsButtonTabbed{
    SearchFriendsViewController *searchFriendsController = [[SearchFriendsViewController alloc] init];
    [self.navigationController pushViewController:searchFriendsController animated:NO];
    
}

#pragma mark - UISearch delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self MATCHES %@", searchString];
    
    if (_searchList)
    {
        [_searchList removeAllObjects];
        _searchList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSMutableArray *friendIDs = [[NSMutableArray alloc] initWithCapacity:0];
    for (User *u in self.friendsArray) {
        [friendIDs addObject:[u uID]];
    }
    NSMutableArray *searchResultIDs = [NSMutableArray arrayWithArray:[friendIDs filteredArrayUsingPredicate:predicate]];
    for (NSString *uID in searchResultIDs) {
        [_searchList addObject: [self.friendsArray  objectAtIndex:[friendIDs indexOfObject:uID] ]];
    }
    return YES;
}


@end
