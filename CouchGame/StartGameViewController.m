//
//  StartGameViewController.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 11/16/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "StartGameViewController.h"

@interface StartGameViewController ()

@end

@implementation StartGameViewController

long highScore=0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//TITLE LABEL
    [self.TitleLabel setTextColor:[UIColor orangeColor]];
    [self.TitleLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    [self.TitleLabel sizeToFit];
    
//INSTRUCTION LABEL
    [self.InstructionsLabel setTextColor:[UIColor greenColor]];
    [self.InstructionsLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.InstructionsLabel setText:@"+Drag Couch\n+Tap It To Shoot\n+Lose Points for Missing"];

//SCORE LABELs
    [self.ScoreLabel setTextColor:[UIColor yellowColor]];
    [self.ScoreMessage setTextColor:[UIColor yellowColor]];
    [self.ScoreLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.ScoreMessage setFont:[UIFont boldSystemFontOfSize:20.0]];
    
//START BUTTON
    [self.StartGameButton setBackgroundImage:[UIImage imageNamed:@"v2couch3.png"] forState:UIControlStateNormal];
    [self.StartGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.StartGameButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];

    
//BACKGROUND - "SPACE"
    //set the background image
    //initialize the image
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space.jpg"]];
    
    //add image as a subview
    [self.view addSubview:backgroundImage];
    
    //move behind other subviews (like score, which is being blocked)
    [self.view  sendSubviewToBack:backgroundImage];
    
    //stretch it out
    backgroundImage.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    
}

-(void)setScore:(long)score
{
    if(score>highScore)
    {
        highScore=score;
        self.ScoreMessage.text = @"New High Score!";
    }
    else
    {
        self.ScoreMessage.text = @"Score to beat:";
    }
    
    self.ScoreLabel.text = [NSString stringWithFormat:@"%li", highScore];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
