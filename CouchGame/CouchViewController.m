//
//  CouchViewController.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/22/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "CouchViewController.h"
#import "StartGameViewController.h"

@interface CouchViewController ()

@end

@implementation CouchViewController

//called everytime the view comes into play
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initialize the score
    self.lScore = 0;
    
    //initialize the duration of the game
    self.duration = 0;
    
    //initialize the couch lives allowed (decremented when couch is touched)
    self.lives = 3;
    
    //set the maximum number of objects in the view at once (to limit images to hit)
    self.maxObjects = 20;
    
    //set the timer interval for adding objects to hit (seconds)
    self.timerIncrement = 1;
    
    //create the fire bullet image to use for all fire bullets
    self.fireBullet = [UIImage imageNamed:@"fireshot.png"];
    
    //create images to hit
    self.imagesToHitArray = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"coffeetable.png"],
                             [UIImage imageNamed:@"lamp.png"],
                             [UIImage imageNamed:@"tv.png"],
                             [UIImage imageNamed:@"can.png"],
                             nil];
    
    //create the couch and place it in the view
    self.couch = [[ImageToDrag alloc] initWithImage:[UIImage imageNamed:@"couch.png"]];
    
    //set this up as the couch's delegate when it wants to shoot
    self.couch.delegate = self;

    
    //place the couch in the view (will get removed in EndGame, like all subviews)
    self.couch.center = CGPointMake(self.view.center.x,self.view.center.y);

    [self.view addSubview:self.couch];
    
    //kick off the timer for objects to hit
    self.addTargetTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerIncrement
                                                               target:self
                                                             selector:@selector(AddAnImageToHit)
                                                             userInfo:nil
                                                              repeats:YES];
}

-(void)AddAnImageToHit
{
    //increment the duration of the game
    self.duration += 1;
    
    //don't add a target if there are already a lot
    if ([[self.view subviews] count] >= self.maxObjects)
    {
        return;
    }
    
    int points=15; //default points for the image
    float timerIncrement=0.05; //default speed of the image
    
    //set speed and points depending on duration of the game
    if(self.duration > 200 &&
       self.duration % 10==0)
    {
        points = 175;
        timerIncrement=0.006;
    }
    else if(self.duration > 150 &&
       self.duration % 8==0)
    {
        points = 150;
        timerIncrement=0.008;
    }
    else if(self.duration > 100 &&
       self.duration % 7==0)
    {
        points = 125;
        timerIncrement=0.01;
    }
    else if(self.duration > 75 &&
            self.duration % 5==0)
    {
        points = 105;
        timerIncrement=0.015;
    }
    else if(self.duration > 50 &&
            self.duration % 3==0)
    {
        points = 75;
        timerIncrement=0.02;
    }
    else if(self.duration > 25 &&
            self.duration % 2==0)
    {
        points = 60;
        timerIncrement=0.03;
    }
    else
    {
        points=50;
        timerIncrement=0.05;
    }
    
    //number of images to shoot (double for every 200 images that get dropped)
    int imagesToShoot=1;
    if(self.duration > 200)
    {
        imagesToShoot = self.duration/100;
    }
    
    //var for random image index
    int randomImage = 0;
    for(int i=0;i<imagesToShoot;i++)
    {
        
        //pick a random image as the image to drop
        //randomImage = arc4random() % [self.imagesToHitArray count];
        randomImage = (int)arc4random_uniform((u_int32_t)[self.imagesToHitArray count]);
        
        //create a target to shoot
        ImageToHit *target = [[ImageToHit alloc] initWithImage:[self.imagesToHitArray objectAtIndex:randomImage] withTimerIncrement:timerIncrement];
    
        //set the targets point value (use the target difficulty multiplier)
        target.points = points*(randomImage+1);
    
        //set this up as the targets delegate for when it's hit, and the score needs to be adjusted
        target.delegate=self;
    
        //add the target to the view
        [self.view addSubview:target];
        
    
        //put target at the top of the view (can't do this in initWithImage because superview.bounds returns 0 for width there
        [target PlaceImageAtTop];
    
        
        target=nil;
    }
}

//required as an ImageToHit and ImageToShoot and ImageToDrag delegate
-(void)AdjustScore:(int)points
{
    self.lScore += points;
    self.score.text =[NSString stringWithFormat:@"%li", self.lScore];
}

//required by ImageToDrag delegate for firing bullets
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
    
    fireBulletLeft=nil;
    fireBulletRight=nil;
   
}

//required by ImageToDrag delegate for losing lives (can be called to add lives too)
-(void)AdjustLives:(int)lives
{
    //adjust the lives count
    self.lives += lives;
    
    //end the game if there are no more
    if(self.lives<=0)
    {
        [self EndGame];
    }
    
}

-(void)EndGame
{
    //remove all the views
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews)
    {
        
        //stop timers
        if([subview isKindOfClass:[ImageToHit class]])
        {
            [((ImageToHit*)subview).checkPositionTimer invalidate];
            ((ImageToHit*)subview).checkPositionTimer=nil;
        }
        
        if([subview isKindOfClass:[ImageToShoot class]])
        {
            [((ImageToShoot*)subview).checkPositionTimer invalidate];
            ((ImageToShoot*)subview).checkPositionTimer=nil;
        }
        
        //remove view
        [subview removeFromSuperview];
    }
    
    //stop the game timer
    [self.addTargetTimer invalidate];
    self.addTargetTimer=nil;
    
    //free allocated resources
    self.fireBullet = nil;
    self.imagesToHitArray = nil;
    self.couch = nil;
    
    //access the previous view controller (start game), and set the score
    NSUInteger nViewControllers = self.navigationController.viewControllers.count;
    [(StartGameViewController*)[self.navigationController.viewControllers objectAtIndex:nViewControllers-2] setScore:self.lScore];
    
    //go back to start game controller
    [self.navigationController popViewControllerAnimated:YES];
    
}

 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self EndGame];
}


@end
