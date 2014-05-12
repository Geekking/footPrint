//
//  MyFootPrintCell.m
//  footprint
//
//  Created by apple on 3/15/14.
//  Copyright (c) 2014 SYSU. All rights reserved.
//

#import "MyFootPrintCell.h"
#import "UIImageView+AFNetworking.h"
#import "FPHttpClient.h"
@implementation MyFootPrintCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configureCell:(FootPrint *)fp{
    
    self.description.text = [fp getInfo][@"description"];
    self.positionLabel.text = [fp getInfo][@"position"];
    
    NSDate *videoTime = [fp getInfo][@"videoTime"] ;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    self.timeLabel.text = [formatter stringFromDate:videoTime];
    
   
    __weak MyFootPrintCell *weakCell = self;
    
    NSString *urlString = [[FPHttpClient getBaseURL] stringByAppendingString:@"file/"];
    urlString = [urlString stringByAppendingString:[fp getInfo][@"coverImageURL"] ];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.coverImage setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.coverImage.image = image;
                                       [fp setCoverImage:image];
                                       [weakCell setNeedsLayout];
                                       
                                   }failure:nil];
    
    
}
@end
