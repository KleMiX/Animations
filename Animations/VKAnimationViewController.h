//
//  VKAnimationViewController.h
//  Animations
//
//  Created by KleMiX on 8/20/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKAnimationViewController : UIViewController

// will be set during prepare for segue
@property (strong, nonatomic) NSString *collectionName;
@property (strong, nonatomic) NSString *animationName;
@property (strong, nonatomic) NSMutableDictionary *animation;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;

- (IBAction)frameBackTapped:(id)sender;
- (IBAction)playTapped:(id)sender;
- (IBAction)frameForwardTapped:(id)sender;

@end
