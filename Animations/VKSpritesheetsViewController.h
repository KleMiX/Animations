//
//  VKSpritesheetsViewController.h
//  Animations
//
//  Created by KleMiX on 8/20/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKSpritesheetsViewController : UITableViewController

@property (strong, nonatomic) NSString *collectionName;
@property (strong, nonatomic) NSMutableDictionary *collection;

@property (weak, nonatomic) IBOutlet UINavigationItem *titleHeader;

@end
