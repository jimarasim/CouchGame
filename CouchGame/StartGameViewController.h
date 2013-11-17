//
//  StartGameViewController.h
//  CouchGame
//
//  Created by JAMES K ARASIM on 11/16/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *StartGameButton;
@property (weak, nonatomic) IBOutlet UILabel *ScoreLabel;

-(void)setScore:(long)score;

@end
