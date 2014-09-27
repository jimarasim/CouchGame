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
-(void)PlaySound:(NSString*)imageAliasForSound;

@end


@interface ImageToHit : UIImageView

//custom initialization method, that additionally takes a timer increment, for speed, and image alias, to know what sound to play
- (id)initWithImage:(UIImage *)image withTimerIncrement:(float)tinc withSound:(NSString*)soundFileParm;


//access to the registered delegate, that will adjust the score when the image is hit
@property (weak, nonatomic) id <ImageToHitDelegate> delegate;

@property (strong) NSTimer * checkPositionTimer;

@property float timerIncrement;

@property int animationStep;

@property int points;

//sound associated with hitting this image
@property NSString * soundFile;

-(void)PlaceImageAtTop;

-(void)HitImage;

-(CGPoint) position;
-(void)setPosition:(CGPoint)position;

-(int)MinimumPosition:(int)chosenPosition;

@end
