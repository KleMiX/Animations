//
//  VKLinkDropboxViewController.m
//  Animations
//
//  Created by KleMiX on 8/19/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import "VKLinkDropboxViewController.h"
#import <Dropbox/Dropbox.h>

@interface VKLinkDropboxViewController ()

@end

@implementation VKLinkDropboxViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([DBAccountManager sharedManager] && [DBAccountManager sharedManager].linkedAccount && [DBAccountManager sharedManager].linkedAccount.linked)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"unlink_enabled_preference"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:NO completion:NULL];
    }
}

- (IBAction)linkPressed:(id)sender
{
    //[[DBAccountManager sharedManager] linkFromController:self.presentingViewController];
    [[DBAccountManager sharedManager] linkFromController:self];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:NO completion:NULL];
}
@end
