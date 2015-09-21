//
//  GameScene.m
//  MiniApp
//
//  Created by Wayne Dahlberg on 9/20/15.
//  Copyright (c) 2015 Wayne Dahlberg. All rights reserved.
//

#import "GameScene.h"
#import "SAMRateLimit.h"

@interface GameScene ()

@property (nonatomic, strong) NSArray *giggleSounds;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    [self preloadSounds];
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Avenir"];
    
    myLabel.text = @"Hi Lane!";
    myLabel.fontSize = 35;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    SKAction *wait = [SKAction waitForDuration:3];
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:1];
    SKAction *remove = [SKAction removeFromParent];
    
    [myLabel runAction:[SKAction sequence:@[wait, fadeOut, remove]]];
    
    [self addChild:myLabel];
}

- (void)preloadSounds {
    
    // TODO: - Separate the sounds array into types of laughs
    
    self.giggleSounds = @[
                          [SKAction playSoundFileNamed:@"baby-big-laugh-1.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-big-laugh-2.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-giggle-1.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-giggle-2.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-giggle-3.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-giggle-4a.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-giggle-4b.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-giggle-4c.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-1.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-2.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-3.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-4.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-5.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-6.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-7.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-8.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-4a.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-5a.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-5b.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-5c.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-5d.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-6.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-7a.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-8.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-9.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-laugh-snort-10.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-screech-1.caf" waitForCompletion:YES],
                          [SKAction playSoundFileNamed:@"baby-goo-8.caf" waitForCompletion:YES]
                          ];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        [self spawnNodeAtLocation:[touch locationInNode:self]];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self spawnNodeAtLocation:[touch locationInNode:self]];
    }
}

- (void)spawnNodeAtLocation:(CGPoint)location {
    
    SKNode *node;
    
    if ([self shouldSpawnGiggler]) {
        node = [self gigglerNode];
    } else {
        node = [self randomShapeNode];
    }
    
    node.position = location;
    [self addChild:node];
}

- (BOOL)shouldSpawnGiggler {
    return arc4random_uniform(5) == 0;
}

- (SKNode *)gigglerNode {
    // Randomize Sprites
    NSInteger num = arc4random_uniform(13) + 1;
    NSString *stringNumber = [NSString stringWithFormat:@"%ld", num];
    NSString *imageName = @"lane";
    NSString *fullName = [imageName stringByAppendingString:stringNumber];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:fullName];
    
    sprite.yScale = sprite.xScale = 0.25;
    
    const NSInteger scaleKeyFrameCount = 8;
    const CGFloat scaleKeyFrames[scaleKeyFrameCount] = { 1.0, 0.68, 0.9, 0.7, 0.85, 0.79, 0.81, 0.8 };
    NSMutableArray *actions = [NSMutableArray array];
    
    for (int i=0; i<scaleKeyFrameCount; i++) {
        SKAction *scaleAction = [SKAction scaleTo:scaleKeyFrames[i] duration:0.2];
        [actions addObject:scaleAction];
    }
    
    SKAction *drop = [SKAction moveByX:0 y:-500 duration:0.3];
    SKAction *remove = [SKAction removeFromParent];
    
    [actions addObject:drop];
    [actions addObject:remove];
    
    SKAction *animations = [SKAction sequence:actions];
    __block SKAction *playSound = [[SKAction alloc] init];
    [SAMRateLimit executeBlock:^{
        playSound = self.giggleSounds[arc4random_uniform((u_int32_t)self.giggleSounds.count)];
        
    } name:@"ThrottleGiggleSound" limit:0.8];
    
    SKAction *group = [SKAction group:@[playSound, animations]];
    
    [sprite runAction:group];
    
    return sprite;
}


- (SKNode *)randomShapeNode {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[self randomShape]];
    sprite.yScale = sprite.xScale = 1.0;
    
    CGFloat duration = [self randomDuration];
    SKAction *rotate = [SKAction rotateByAngle:[self randomAngle] duration:[self randomDuration]];
    
    SKAction *scale = [SKAction scaleTo:[self randomScale] duration:duration];
    
    SKAction *group = [SKAction group:@[rotate, scale]];
    SKAction *fadeAction = [SKAction fadeAlphaTo:0 duration:0.25];
    SKAction *remove = [SKAction removeFromParent];
    [sprite runAction:[SKAction sequence:@[group, fadeAction, remove]]];
    
    return sprite;
}

- (CGFloat)randomScale {
    //    return (100- (arc4random() % 20)) / 100;
    CGFloat x = arc4random_uniform(49);
    NSLog(@"X: %g", x);
    CGFloat scale = (90.0 -x) / 100.0;
    NSLog(@"Scale: %g", scale);
    return scale;
}

- (CGFloat)randomDuration {
    return (CGFloat)(arc4random_uniform(3) + 1);
}

- (CGFloat)randomAngle {
    CGFloat revs = (arc4random_uniform(4) + 1) / 2.0f;
    return revs * 2 * M_PI;
}

- (NSString *)randomShape {
    static NSArray *__shapes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shapes = @[@"purpleTriangle", @"greenPolygon", @"yellowStar", @"redSquare", @"blueCircle"];
    });
    
    int index = arc4random_uniform((uint32_t)__shapes.count);
    return __shapes[index];
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
