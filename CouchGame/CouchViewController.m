//
//  CouchViewController.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/22/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "CouchViewController.h"
#import "GameOverViewController.h"

@interface CouchViewController ()

@end

@implementation CouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //initialize the score
    self.nScore = 0;
    
    //initialize the duration of the game
    self.duration = 0;
    
    //initialize the couch lives allowed (decremented when couch is touched)
    self.lives = 3;
    
    //set the maximum number of objects in the view at once (to limit images to hit)
    self.maxObjects = 20;
    
    //set the timer interval for adding objects to hit (seconds)
    self.timerIncrement = 0.75;
    
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
    
    UIImage *targetImage; //image to drop
    int points=15; //default points for the image
    float timerIncrement=0.05; //default speed of the image
    
    if(self.duration % 10==0)
    {
        UIImage *originalCoffeeTable = [UIImage imageNamed:@"coffeetable.png"];
        targetImage=[UIImage imageWithCGImage:[originalCoffeeTable CGImage]
                                        scale:(originalCoffeeTable.scale * 3.0)
                                  orientation:(originalCoffeeTable.imageOrientation)];
        points = 125;
        timerIncrement=0.007;
    }
    else if(self.duration % 5==0)
    {
        UIImage *originalCoffeeTable = [UIImage imageNamed:@"coffeetable.png"];
        targetImage=[UIImage imageWithCGImage:[originalCoffeeTable CGImage]
                                        scale:(originalCoffeeTable.scale * 3.0)
                                  orientation:(originalCoffeeTable.imageOrientation)];
        points = 100;
        timerIncrement=0.01;
    }
    else if(self.duration % 2==0)
    {
        UIImage *originalCoffeeTable = [UIImage imageNamed:@"coffeetable.png"];
        targetImage=[UIImage imageWithCGImage:[originalCoffeeTable CGImage]
                                        scale:(originalCoffeeTable.scale * 3.0)
                                  orientation:(originalCoffeeTable.imageOrientation)];
        points = 50;
        timerIncrement=0.03;
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
    ImageToHit *target = [[ImageToHit alloc] initWithImage:targetImage withTimerIncrement:timerIncrement];
    
    //set the targets point value
    target.points = points;
    
    //set the targets speed
    target.timerIncrement = timerIncrement;
    
    //set this up as the targets delegate for when it's hit, and the score needs to be adjusted
    target.delegate=self;
    
    //add the target to the view
    [self.view addSubview:target];
    
    //put target at the top of the view (can't do this in initWithImage because superview.bounds returns 0 for width there
    [target PlaceImageAtTop];
}

//required as an ImageToHit and ImageToShoot and ImageToDrag delegate
-(void)AdjustScore:(int)points
{
    self.nScore += points;
    self.score.text =[NSString stringWithFormat:@"%d", self.nScore];
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
        [subview removeFromSuperview];
    }
    
    //stop the game timer
    [self.addTargetTimer invalidate];
    
    
    //call the game over segue
    [self performSegueWithIdentifier: @"GameOverSegue" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GameOverSegue"])
    {
        NSLog(@"prepareForSegue");
        GameOverViewController *vc = [segue destinationViewController];
        vc.score = self.nScore;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
