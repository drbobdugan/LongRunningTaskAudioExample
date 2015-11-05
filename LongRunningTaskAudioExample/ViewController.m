//
//  ViewController.m
//  LongRunningTaskAudioExample
//
//  Created by Bob Dugan on 11/4/15.
//
//  From code that originated in The Backgrounder by Gustavo Ambrozio
//  https://github.com/gpambrozio/TheBackgrounder.git
//
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // register interrrupt notification for audio session
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(interruption:)
                                                 name:AVAudioSessionInterruptionNotification object:nil];
    
    // set category play/record for audio session
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // playback will mix with other music
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    // if something is playing override it with my audio
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];

    //
    // Configure song queue, we'll watch for changes
    //
    NSArray *queue = @[
                       [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"IronBacon" withExtension:@"mp3"]],
                       [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"FeelinGood" withExtension:@"mp3"]],
                       [AVPlayerItem playerItemWithURL:[[NSBundle mainBundle] URLForResource:@"WhatYouWant" withExtension:@"mp3"]]];
    
    self.player = [[AVQueuePlayer alloc] initWithItems:queue];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    [self.player addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:nil];
    
    
    //
    // Configure time observer to update stats every 100ms, the observer has to be declared in scope as a block
    //
    void (^observerBlock)(CMTime time) = ^(CMTime time) {
        NSString *musicTime = [NSString stringWithFormat:@"%02.2f", (float)time.value / (float)time.timescale];
        
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            self.lblMusicTime.text = musicTime;
        } else {
            NSLog(@"App is backgrounded, music time is: %@", musicTime);
            [BackgroundTimeRemainingUtility NSLog];
        }
    };
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 100)
                                                                  queue:dispatch_get_main_queue()
                                                             usingBlock:observerBlock];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentItem"])
    {
        AVPlayerItem *item = ((AVPlayer *)object).currentItem;
        self.lblMusicName.text = ((AVURLAsset*)item.asset).URL.pathComponents.lastObject;
        NSLog(@"New music name: %@", self.lblMusicName.text);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapPlayPause:(id)sender
{
    self.btnPlayPause.selected = !self.btnPlayPause.selected;
    if (self.btnPlayPause.selected)
    {
        [self.player play];
    }
    else
    {
        [self.player pause];
    }
}

- (void) interruption:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSUInteger interuptionType = (NSUInteger)[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    
    if (interuptionType == AVAudioSessionInterruptionTypeBegan)
    {
        NSLog(@"%s: AVAudioSessionInterruptionBegan", __PRETTY_FUNCTION__);
    }
    else if (interuptionType == AVAudioSessionInterruptionTypeEnded)
    {
        NSLog(@"%s: AVAudioSessionInterruptionBegan", __PRETTY_FUNCTION__);
    }
}

@end