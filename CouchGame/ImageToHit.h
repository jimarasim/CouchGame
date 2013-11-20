//
//  ImageToHit.h
//  CouchGame
//
//  Created by JAMES K ARASIM on 11/6/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import <UIKit/UIKit.h>

//delegate method implemented by viewcontroller when image is hit; to update the score
@protocol ImageToHitDelegate <NSObject>
@required
-(void)AdjustScore:(int)points;
@end


@interface ImageToHit : UIImageView

- (id)initWithImage:(UIImage *)image withTimerIncrement:(float)tinc;

//access to the registered delegate
@property (weak, nonatomic) id <ImageToHitDelegate> delegate;

@property (strong) NSTimer * checkPositionTimer;

@property float timerIncrement;

@property int animationStep;

@property int points;

-(void)PlaceImageAtTop;

-(void)HitImage;

-(CGPoint) position;
-(void)setPosition:(CGPoint)position;

-(int)MinimumPosition:(int)chosenPosition;

@end
