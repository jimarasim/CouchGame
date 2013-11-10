//
//  CouchViewController.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/22/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "CouchViewController.h"

@interface CouchViewController ()

@end

@implementation CouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //initialize the score
    self.nScore = 0;
    
    //create a couch image and scale it down
    // grab the original image
    UIImage *originalCouch = [UIImage imageNamed:@"couch.png"];
    // scaling set to 2.0 makes the image 1/2 the size.
    UIImage *scaledCouch =[UIImage imageWithCGImage:[originalCouch CGImage]
                        scale:(originalCouch.scale * 3.0)
                  orientation:(originalCouch.imageOrientation)];
    
    
    
    //create the couch and place it in the view
    self.couch = [[ImageToDrag alloc] initWithImage:scaledCouch];
    self.couch.center = CGPointMake(self.view.center.x,self.view.center.y);
    //set this up as the couch's delegate when it wants to shoot
    self.couch.delegate = self;
    [self.view addSubview:self.couch];
    
    //create the lamp image to use for all lamps
    // grab the original image
    UIImage *originalLamp = [UIImage imageNamed:@"lamp.png"];
    // scaling set to 2.0 makes the image 1/2 the size.
    self.scaledLamp =[UIImage imageWithCGImage:[originalLamp CGImage]
                                             scale:(originalLamp.scale * 2.0)
                                       orientation:(originalLamp.imageOrientation)];

    //create the fire bullet image to use for all fire bullets
    self.fireBullet = [UIImage imageNamed:@"fireshot.png"];
    
    //set the maximum number of objects to hit
    self.maxObjects = 10;
    
    //set the timer interval for adding objects to hit
    self.timerIncrement = 1.0;
    
    //kick off the timer for objects to hit
    self.addLampTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerIncrement
                                                               target:self
                                                             selector:@selector(AddAnImageToHit)
                                                             userInfo:nil
                                                              repeats:YES];
    
    
}

-(void)AddAnImageToHit
{
    
    //don't add a lamp if there are already a lot
    NSArray *subviews = [self.view subviews];
    
    // skip if there are no subviews
    if ([subviews count] >= self.maxObjects)
    {
        return;
    }
    
    //create a lamp to shoot
    ImageToHit *lamp = [[ImageToHit alloc] initWithImage:self.scaledLamp];
    
    //set this up as the lamps delegate for when it's hit, and the score needs to be adjusted
    lamp.delegate=self;
    
    [self.view addSubview:lamp];
    
    //put lamp at the top of the view (can't do this in initWithImage because superview.bounds returns 0 for width there
    [lamp PlaceImageAtTop];
}

//required as an ImageToHit and ImageToShoot delegate
-(void)AdjustScore:(int)points
{
    self.nScore += points;
    self.score.text =[NSString stringWithFormat:@"%d", self.nScore];
}

//required by ImageToDrag delegate
-(void)Fire
{
    //create a fire bullets. bullets will remove themselves from the view when its position is less than 0
    ImageToShoot *fireBulletLeft = [[ImageToShoot alloc] initWithImage:self.fireBullet];
    ImageToShoot *fireBulletRight = [[ImageToShoot alloc] initWithImage:self.fireBullet];
    
    fireBulletLeft.center = CGPointMake(self.couch.center.x-(self.couch.frame.size.width/2)+fireBulletLeft.frame.size.width, self.couch.center.y);
    fireBulletRight.center = CGPointMake(self.couch.center.x+(self.couch.frame.size.width/2)-fireBulletRight.frame.size.width, self.couch.center.y);
    
    //make this controller a delegate for the firebullets, for decreasing score when they don't hit anything
    fireBulletLeft.delegate = self;
    fireBulletRight.delegate = self;
    
    [self.view addSubview:fireBulletLeft];
    [self.view addSubview:fireBulletRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
