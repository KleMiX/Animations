//
//  VKFilesViewController.h
//  Animations
//
//  Created by KleMiX on 8/18/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKFilesViewController : UICollectionViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
