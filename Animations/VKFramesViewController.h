//
//  VKFramesViewController.h
//  Animations
//
//  Created by KleMiX on 8/20/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKFramesViewController : UITableViewController

// will be set during prepare for segue
@property (strong, nonatomic) NSString *collectionName;
@property (strong, nonatomic) NSString *animationName;
@property (strong, nonatomic) NSMutableDictionary *animation;

@end
