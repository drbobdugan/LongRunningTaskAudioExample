//
//  ViewController.h
//  LongRunningTaskAudioExample
//
//  Created by Bob Dugan on 11/4/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundTimeRemainingUtility.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblMusicName;
@property (strong, nonatomic) IBOutlet UILabel *lblMusicTime;
@property (strong, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (nonatomic, strong) AVQueuePlayer *player;
@property (nonatomic, strong) id timeObserver;

- (IBAction)didTapPlayPause:(id)sender;


@end

