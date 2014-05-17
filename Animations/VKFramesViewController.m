//
//  VKFramesViewController.m
//  Animations
//
//  Created by KleMiX on 8/20/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import "VKFramesViewController.h"
#import "VKImageNameCell.h"
#import "VKSpriteFrameCache.h"
#import "VKFrameEditViewController.h"

@interface VKFramesViewController ()

@end

@implementation VKFramesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    UITableView *view = (UITableView*)self.view; // we know that we are the table view, right?
    [view reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editFrameSegue"])
    {
        NSIndexPath *indexPath = sender;
        VKFrameEditViewController *frame = segue.destinationViewController;
        NSArray *frames = [self.animation objectForKey:@"frames"];
        frame.frame = [frames objectAtIndex:indexPath.row];
        frame.animationName = self.animationName;
        frame.collectionName = self.collectionName;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *frames = [self.animation objectForKey:@"frames"];
    return [frames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"editableFrameCell";
    VKImageNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // get the data about the frame
    NSArray *frames = [self.animation objectForKey:@"frames"];
    NSDictionary *frame = [frames objectAtIndex:indexPath.row];
    
    NSNumber *delay = [frame valueForKey:@"delayUnits"];
    NSString *spriteframe = [frame valueForKey:@"spriteframe"];
    
    // put the data into the cell
    cell.nameLabel.text = spriteframe;
    cell.imageView.image = [[VKSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteframe];
    if (delay)
        cell.descriptionLabel.text = [NSString stringWithFormat:@"Delay units: %f", [delay floatValue]];
    else
        cell.descriptionLabel.text = @"";
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"editFrameSegue" sender:indexPath];
}

@end
