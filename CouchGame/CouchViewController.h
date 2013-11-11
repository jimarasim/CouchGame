//
//  CouchViewController.h
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/22/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageToDrag.h"
#import "ImageToHit.h"
#import "ImageToShoot.h"

//note, this is a delegate for ImageToHit (see ImageToHit.h for delegate definition)
@interface CouchViewController : UIViewController <ImageToHitDelegate,ImageToShootDelegate,ImageToDragDelegate>

@property (weak, nonatomic) IBOutlet UILabel *score; //label for showing score

@property int nScore; //model object for keeping track of score

@property ImageToDrag * couch;

@property NSTimer * addTargetTimer; //timer for dropping objects to hit

@property UIImage * fireBullet; //image to use for fire bullets

@property float timerIncrement; //how long to wait between dropping objects to hit

@property int maxObjects; //for keeping track of total objects in the view at one time

@property int duration; //for keeping track of how long the game has gone

@property int lives; //for keeping track of couch lives

-(void)AddAnImageToHit; //for adding objects to hit to the main view

-(void)AdjustScore:(int)points; //for adding/removing points to the overall score, required by delegates

-(void)Fire;

-(void)EndGame; //for ending the game for whatever reason

@end
