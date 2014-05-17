//
//  VKFrameEditViewController.h
//  Animations
//
//  Created by KleMiX on 8/22/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKFrameEditViewController : UITableViewController

// will be set during prepare for segue
@property (strong, nonatomic) NSString *collectionName;
@property (strong, nonatomic) NSString *animationName;
@property (strong, nonatomic) NSMutableDictionary *frame;

@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleHeader;
@property (weak, nonatomic) IBOutlet UITextField *delayUnitsTextfield;
- (IBAction)delayUnitsChanged:(id)sender;

@end
