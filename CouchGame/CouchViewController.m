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

//array of valid speeds for the images to hit
float imageToHitSpeeds[]={0.04,0.035,0.03,0.025,0.02,0.015,0.01,0.0095,0.009,0.0085,0.008,0.0075,0.007,0.0065,0.006,0.0055,0.005};

//number of speeds in the imageToHitSpeeds array, set dynamically in viewDidLoad
int numberOfSpeeds;

//how many durations to wait until increasing difficulty
int levelUp = 20;

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
    self.timerIncrement = 0.5;
    
    //create the fire bullet image to use for all fire bullets
    self.fireBullet = [UIImage imageNamed:@"fireshot.png"];
    
    //create filename array for images to hit
    self.imagesToHitFileNameArray = [NSArray arrayWithObjects:
                                     @"coffeetable.png",
                                     @"cat.png",
                                     @"lamp.png",
                                     @"tv.png",
                                     @"can.png",
                                     @"candy.jpeg",
                                     @"dog.png",
                                     nil];

    //associate sounds with images to hit. must be ordered same as self.imagesToHitFileNameArray
    self.imageSoundsArray = [NSArray arrayWithObjects:
                                     @"tap.mp3",
                                     @"meow.mp3",
                                     @"tap.mp3",
                                     @"tap.mp3",
                                     @"tap.mp3",
                                     @"tap.mp3",
                                     @"tap.mp3",
                                     nil];
    
    //create images to hit.  must be ordered same as self.imagesToHitFileNameArray, so we
    //can tell what image filename is being used, when playing sounds for it
    self.imagesToHitArray = [NSArray arrayWithObjects:
                             [UIImage imageNamed:self.imagesToHitFileNameArray[0]],
                             [UIImage imageNamed:self.imagesToHitFileNameArray[1]],
                             [UIImage imageNamed:self.imagesToHitFileNameArray[2]],
                             [UIImage imageNamed:self.imagesToHitFileNameArray[3]],
                             [UIImage imageNamed:self.imagesToHitFileNameArray[4]],
                             [UIImage imageNamed:self.imagesToHitFileNameArray[5]],
                             [UIImage imageNamed:self.imagesToHitFileNameArray[6]],
                             nil];
    
    //get the number of possible speeds in the speeds array
    numberOfSpeeds =sizeof(imageToHitSpeeds)/sizeof(imageToHitSpeeds[0]);
    
    //set the background image
    [self SetBackgroundImage:@"space.jpg"];
    
    //put the couch on the board
    [self CreateCouch];
    
    //kick off the timer for objects to hit
    self.addTargetTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerIncrement
                                                               target:self
                                                             selector:@selector(AddAnImageToHit)
                                                             userInfo:nil
                                                              repeats:YES];
    

    // Construct URL to sound file
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *path = [NSString stringWithFormat:@"%@/meow.mp3", resourcePath];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    self.meowAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [self.meowAudioPlayer prepareToPlay];
    
    // Construct URL to sound file
    resourcePath = [[NSBundle mainBundle] resourcePath];
    path = [NSString stringWithFormat:@"%@/tap.mp3",resourcePath];
    soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    self.tapAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [self.tapAudioPlayer prepareToPlay];
    
}

-(void)SetBackgroundImage:(NSString*)imageName{
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    backgroundImage.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    printf("%f, %f",self.view.frame.size.width,self.view.frame.size.height);
    
    [self.view addSubview:backgroundImage];
    
}

-(void)CreateCouch
{
    //create the couch and place it in the view
    self.couch = [[ImageToDrag alloc] initWithImage:[UIImage imageNamed:@"couch.png"]];
    
    //set this up as the couch's delegate when it wants to shoot
    self.couch.delegate = self;
    
    
    //place the couch in the view (will get removed in EndGame, like all subviews)
    self.couch.center = CGPointMake(self.view.center.x,self.view.center.y);
    
    [self.view addSubview:self.couch];
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
    
    //set available speeds based on duration of the game
    int randomSpeedIndex;
    if((self.duration/levelUp)>numberOfSpeeds)
    {
        //phase out the lower speeds, so that eventually only the highest speed is chosen
        int minimumSpeed = ((self.duration/levelUp)>=(numberOfSpeeds*2))?numberOfSpeeds-1:(self.duration/levelUp)-numberOfSpeeds;
        
        randomSpeedIndex=arc4random_uniform((numberOfSpeeds-1) - minimumSpeed + 1) + minimumSpeed;
    }
    else
    {
        //every levelUp durations, make another speed available
        randomSpeedIndex = (int)arc4random_uniform(self.duration/levelUp);
    }
    
    
    //pick a random speed from the array of valid speeds for the timer increment
    float timerIncrement = imageToHitSpeeds[randomSpeedIndex];
    
    //pick a random image as the image to drop
    int randomImageIndex = (int)arc4random_uniform((u_int32_t)[self.imagesToHitArray count]);
    
    //pick the points value based on the speed and difficulty of the target
    int points = (randomImageIndex+1)*(randomSpeedIndex+1)+100;
        
    //create a target to shoot
    ImageToHit *target = [[ImageToHit alloc] initWithImage:[self.imagesToHitArray objectAtIndex:randomImageIndex]
                                        withTimerIncrement:timerIncrement
                                            withSound:self.imageSoundsArray[randomImageIndex]];

    //set the targets point value (use the target difficulty multiplier)
    target.points = points;
    
    //set this up as the targets delegate for when it's hit, and the score needs to be adjusted
    target.delegate=self;
    
    //add the target to the view
    [self.view addSubview:target];
        
    
    //put target at the top of the view (can't do this in initWithImage because superview.bounds returns 0 for width there
    [target PlaceImageAtTop];
    
    target=nil;
    
}

//required as an ImageToHit and ImageToShoot and ImageToDrag delegate
-(void)AdjustScore:(int)points
{
    self.lScore += points;
    self.score.text =[NSString stringWithFormat:@"%li", self.lScore];
}

//required as an ImageToHit delegate
-(void)PlaySound:(NSString*)soundFile //for playing a sound when something is hit, required by ImageToHitDelegate
{
    if([soundFile isEqualToString:@"meow.mp3"] && !self.meowAudioPlayer.playing){
        [self.meowAudioPlayer play];
    }
    
    if([soundFile isEqualToString:@"tap.mp3"] && !self.tapAudioPlayer.playing){
        [self.tapAudioPlayer play];
    }
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

        if([subview isKindOfClass:[ImageToDrag class]])
        {
            ((ImageToDrag*)subview).animationArray=nil;
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
    self.score = nil;
    subviews = nil;
    
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
