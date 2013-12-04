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
