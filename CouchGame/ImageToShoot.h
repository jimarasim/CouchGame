//
//  ImageToShoot.h
//  CouchGame
//
//  Created by JAMES K ARASIM on 11/2/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import <UIKit/UIKit.h>

//delegate method implemented by viewcontroller when image is hit; to update the score
@protocol ImageToShootDelegate <NSObject>
@required
-(void)AdjustScore:(int)points;
@end

@interface ImageToShoot : UIImageView

//access to the registered delegate
@property (weak, nonatomic) id <ImageToShootDelegate> delegate;

@property (strong) NSTimer * checkPositionTimer;

@property float timerIncrement;

@property int animationStep;

-(CGPoint) position;
-(void)setPosition:(CGPoint)position;

@end
