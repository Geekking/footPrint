//
//  SearchFriendsViewController.h
//  footprint
//
//  Created by apple on 3/14/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFriendsViewController : UITableViewController<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
