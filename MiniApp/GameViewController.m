//
//  GameViewController.m
//  MiniApp
//
//  Created by Wayne Dahlberg on 9/20/15.
//  Copyright (c) 2015 Wayne Dahlberg. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
@import AVFoundation;

@interface GameViewController ()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startBackgroundMusic];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)startBackgroundMusic {
    NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"Lullaby" withExtension:@"caf"];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
    
    if (self.audioPlayer) {
        self.audioPlayer.numberOfLoops = -1;
        self.audioPlayer.volume = 0.05;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    } else {
        NSLog(@"Couldn't initialize audio player: %@   Audio URL: %@", error, musicURL);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"/// MEMORY WARNING ///");
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
