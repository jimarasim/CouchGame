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
    
//INSTRUCTION LABEL
    [self.InstructionsLabel setTextColor:[UIColor whiteColor]];
    [self.InstructionsLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
    [self.InstructionsLabel setText:@"Drag and Tap couch to shoot\nLose points for missing"];
    
//START BUTTON
    [self.StartGameButton setBackgroundImage:[UIImage imageNamed:@"v2couch3.png"] forState:UIControlStateNormal];
    [self.StartGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//OTHER LABELS
    [self.ScoreLabel setTextColor:[UIColor whiteColor]];
    [self.ScoreMessage setTextColor:[UIColor whiteColor]];
    [self.TitleLabel setTextColor:[UIColor whiteColor]];
    
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
