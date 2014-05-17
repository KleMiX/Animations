//
//  VKAnimationViewController.m
//  Animations
//
//  Created by KleMiX on 8/20/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import "VKAnimationViewController.h"
#import "VKSpriteFrameCache.h"
#import "VKFramesViewController.h"

@interface VKAnimationViewController () {
    NSMutableDictionary *_batchFrames;
    
    float _currentDelay;
    float _currentDelayUnits;
    float _animationDelay;

    uint _currentFrame;

    BOOL _paused;
    BOOL _looped;
    BOOL _emptyAnimation;
    
    NSTimer *_ticker;
}

-(void) updateCurrentDelayUnits;
-(void) updateFrame;
-(void) update:(NSTimer*)timer;

@end

@implementation VKAnimationViewController

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

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editAnimationFramesSegue"])
    {
        VKFramesViewController *frames = segue.destinationViewController;
        frames.animation = self.animation;
        frames.animationName = self.animationName;
        frames.collectionName = self.collectionName;
    }
}

- (IBAction)frameBackTapped:(id)sender
{
    if (_currentFrame > 0)
    {
        _currentFrame--;
        [self updateFrame];
        [self updateCurrentDelayUnits];
    }
}

- (IBAction)playTapped:(id)sender
{
    _paused = NO;
}

- (IBAction)pauseTapped:(id)sender
{
    _paused = YES;
}

- (IBAction)frameForwardTapped:(id)sender
{
    NSArray *frames = [self.animation objectForKey:@"frames"];
    if (_currentFrame < [frames count] - 1)
    {
        _currentFrame++;
        [self updateFrame];
        [self updateCurrentDelayUnits];
    }
}

-(void) update:(NSTimer*)timer
{
    if (!_paused && !_emptyAnimation) {
        _currentDelay += timer.timeInterval;
        
        if (_currentDelay >= _animationDelay * _currentDelayUnits) {
            _currentDelay -= _animationDelay * _currentDelayUnits;
            
            NSArray *frames = [_animation objectForKey:@"frames"];
            
            if (_currentFrame == [frames count]) {
                _currentFrame = 0;
            }
            
            [self updateFrame];
            [self updateCurrentDelayUnits];
            
            if ( _looped || (!_looped && _currentFrame != [frames count] - 1)) {
                _currentFrame++;
            }
            else {
                _paused = YES;
            }
        }
    }
}

// checks and updates custom frame delay
-(void) updateCurrentDelayUnits
{
    NSArray *frames = [_animation objectForKey:@"frames"];
    NSDictionary *currentFrame = [frames objectAtIndex:_currentFrame];

    _currentDelayUnits = 1.0f;

    if (currentFrame) {
        NSNumber *delay = [currentFrame objectForKey:@"delayUnits"];
        if (delay) _currentDelayUnits = [delay floatValue];
    }
}

-(void) updateFrame
{
    NSArray *frames = [_animation objectForKey:@"frames"];
    if (_currentFrame >= [frames count]) {
        _currentFrame = 0;
    }

    NSDictionary *currentFrame = [frames objectAtIndex:_currentFrame];
    UIImage *frame = nil;

    if (currentFrame) {

        frame = [[VKSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[currentFrame objectForKey:@"spriteframe"]];
    }

    self.imageView.image = frame;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // we have nothing to show, just go to edit
    if (_emptyAnimation)
    {
//        [self performSegueWithIdentifier:@"editAnimationFramesSegue" sender:self];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_ticker invalidate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _looped = YES;
    _paused = NO;
    _emptyAnimation = YES;

    NSArray *frames = [self.animation objectForKey:@"frames"];

    if (_emptyAnimation && [frames count] == 0) {
        return;
    }
    else {
        _emptyAnimation = NO;
    }

    // Loading delay
    NSNumber *delay = [_animation objectForKey:@"delayPerUnit"];
    if ( ! delay) {
        delay = [NSNumber numberWithFloat:1.0f];
    }
    _animationDelay = [delay floatValue];

    // setting up sprite
    _currentFrame = 0;
    [self updateCurrentDelayUnits];
    [self updateFrame];
    
    // 60 fps timer
    _ticker = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}
@end
