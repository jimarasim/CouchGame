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
    
    //initialize the duration
    self.duration = 0;
    
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

    //create the fire bullet image to use for all fire bullets
    self.fireBullet = [UIImage imageNamed:@"fireshot.png"];
    
    //set the maximum number of objects to hit
    self.maxObjects = 10;
    
    //set the timer interval for adding objects to hit
    self.timerIncrement = 1;
    
    //kick off the timer for objects to hit
    self.addTargetTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerIncrement
                                                               target:self
                                                             selector:@selector(AddAnImageToHit)
                                                             userInfo:nil
                                                              repeats:YES];
    
    
}

-(void)AddAnImageToHit
{
    //increment the duration (for tracking when the game should end)
    self.duration += 1;
    
    //end the game after so long
    if(self.duration>60)
    {
        [self EndGame];
        return;
    }
    
    //don't add a target if there are already a lot
    if ([[self.view subviews] count] >= self.maxObjects)
    {
        return;
    }
    
    //select the target image based on points
    UIImage *targetImage;
    int points=15;
    int animationStep=3;
    
    if(self.nScore > 200)
    {
        UIImage *originalCoffeeTable = [UIImage imageNamed:@"coffeetable.png"];
        targetImage=[UIImage imageWithCGImage:[originalCoffeeTable CGImage]
                                        scale:(originalCoffeeTable.scale * 3.0)
                                  orientation:(originalCoffeeTable.imageOrientation)];
        points = 50;
        animationStep=5;
    }
    else
    {
        // grab the original image
        UIImage *originalLamp = [UIImage imageNamed:@"lamp.png"];
        // scaling set to 2.0 makes the image 1/2 the size.
        targetImage=[UIImage imageWithCGImage:[originalLamp CGImage]
                                         scale:(originalLamp.scale * 2.0)
                                   orientation:(originalLamp.imageOrientation)];
    }
    
    
    //create a target to shoot
    ImageToHit *target = [[ImageToHit alloc] initWithImage:targetImage];
    
    //set the targets point value
    target.points = points;
    
    //set the targets speed
    target.animationStep = animationStep;
    
    //set this up as the targets delegate for when it's hit, and the score needs to be adjusted
    target.delegate=self;
    
    [self.view addSubview:target];
    
    //put target at the top of the view (can't do this in initWithImage because superview.bounds returns 0 for width there
    [target PlaceImageAtTop];
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

-(void)EndGame
{
    //remove all the views
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews)
    {
        [subview removeFromSuperview];
    }
    
    //stop the game timer
    [self.addTargetTimer invalidate];
    
    
    //call the game over segue
    [self performSegueWithIdentifier: @"GameOverSegue" sender: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
