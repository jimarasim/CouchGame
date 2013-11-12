//
//  GameOverViewController.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 11/12/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

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
    
    //self.score is set in prepareforsegue of previous view
    self.ScoreLabel.text = [NSString stringWithFormat:@"%d", self.score];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
