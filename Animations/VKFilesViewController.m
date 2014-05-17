//
//  VKFilesViewController.m
//  Animations
//
//  Created by KleMiX on 8/18/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import "VKFilesViewController.h"
#import <Dropbox/Dropbox.h>
#import "VKImageLabelCell.h"
#import "VKAnimationCollection.h"
#import "VKStorage.h"
#import "VKAnimationsViewController.h"
#import "VKSpritesheetsViewController.h"

@interface VKFilesViewController ()
{
    NSMutableArray *fileNames;
}

-(void) loadAssets;

@end

@implementation VKFilesViewController

-(void) loadAssets
{
    // load all files only at startup
//    NSArray *files = [[VKStorage sharedStorage] listOfFiles];
//    [[VKAnimationCollection sharedCollection] addFromFiles:files];
    [fileNames removeAllObjects];
    
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    NSArray *contents = [filesystem listFolder:[DBPath root] error:nil];
    
    for (DBFileInfo *fileInfo in contents)
    {
        NSString *fileName = fileInfo.path.stringValue;
        if ([fileName hasSuffix:@".ccanim"])
        {
            [fileNames addObject:[fileName lastPathComponent]];
            
            DBFile *file = [[DBFilesystem sharedFilesystem] openFile:fileInfo.path error:nil];
            if (file.status.cached)
            {
                // read the data
                NSData *contents = [file readData:nil];
                NSString *error;
                NSPropertyListFormat format;
                // get the dictionary
                NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:contents mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
                
                if (plist)
                {
                    [[VKAnimationCollection sharedCollection] addWithDictionary:plist andFilename:[fileName lastPathComponent]];
                }
            }
        }
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        // Update UI
        [self.collectionView reloadData];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
    });
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"collectionOpened"])
    {
        VKImageLabelCell *imageLabel = sender;
        UITabBarController *tabs = segue.destinationViewController;
        
        VKAnimationsViewController *animations = nil;
        VKSpritesheetsViewController *spritesheets = nil;
        
        for (UIViewController *controller in [tabs viewControllers])
        {
            if ([controller isKindOfClass:[VKSpritesheetsViewController class]])
                spritesheets = (VKSpritesheetsViewController*)controller;
            else if ([controller isKindOfClass:[VKAnimationsViewController class]])
                animations = (VKAnimationsViewController*)controller;
        }
        
        // copy collection name
        animations.collectionName = [NSString stringWithString:imageLabel.nameLabel.text];
        animations.titleHeader.title = animations.collectionName;
        spritesheets.collectionName = [NSString stringWithString:imageLabel.nameLabel.text];
        spritesheets.titleHeader.title = spritesheets.collectionName;
        
        // start loading file, maybe downloading it as well
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [VKStorage sharedStorage].shouldDownloadTouchedFiles = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            DBPath *path = [[DBPath root] childPath:animations.collectionName];
            DBFile *file = [[DBFilesystem sharedFilesystem] openFile:path error:nil];
            if (file)
            {
                // read the data
                NSData *contents = [file readData:nil];
                NSString *error;
                NSPropertyListFormat format;
                // get the dictionary
                NSMutableDictionary* plist = [NSPropertyListSerialization propertyListFromData:contents mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
                animations.collection = plist;
                spritesheets.collection = plist;
                
                [[VKAnimationCollection sharedCollection] addWithDictionary:plist andFilename:animations.collectionName];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                // Update UI
                [VKStorage sharedStorage].shouldDownloadTouchedFiles = NO;
                [self.activityIndicator stopAnimating];
                [self.activityIndicator setHidden:YES];
            });
        });
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([DBAccountManager sharedManager] && [DBAccountManager sharedManager].linkedAccount && [DBAccountManager sharedManager].linkedAccount.linked)
    {
        if (![DBFilesystem sharedFilesystem])
        {
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:[DBAccountManager sharedManager].linkedAccount];
            [DBFilesystem setSharedFilesystem:filesystem];
        }
        
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [[VKAnimationCollection sharedCollection] wipeCollections];
        // load dropbox data
        // Load all the assets in another thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self loadAssets];
        });
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // check if the user wants to unlink account
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"unlink_enabled_preference"] == YES)
    {
        if ([DBAccountManager sharedManager] && [DBAccountManager sharedManager].linkedAccount && [DBAccountManager sharedManager].linkedAccount.linked)
        {
            [[DBAccountManager sharedManager].linkedAccount unlink];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"unlink_enabled_preference"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    // User not logged
    if (![DBAccountManager sharedManager] || ![DBAccountManager sharedManager].linkedAccount || ![DBAccountManager sharedManager].linkedAccount.linked)
    {
        [self performSegueWithIdentifier:@"LinkDropbox" sender:self];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VKImageLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FileCell" forIndexPath:indexPath];
    NSString *collection = [fileNames objectAtIndex:indexPath.row];
    cell.nameLabel.text = collection;
    cell.imageView.image = [[VKAnimationCollection sharedCollection] previewImageForCollection:collection];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView  numberOfItemsInSection:(NSInteger)section
{
    return fileNames.count;
}

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
	// Do any additional setup after loading the view.
    
    fileNames = [NSMutableArray arrayWithCapacity:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
