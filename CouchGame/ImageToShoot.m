//
//  ImageToShoot.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 11/2/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "ImageToShoot.h"
#import "ImageToHit.h"

@implementation ImageToShoot

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
 */

- (id)initWithImage:(UIImage *)image
{
    //load the uiimageview with the image specified
    self = [super initWithImage:image];
    
    //set the timer interval
    self.timerIncrement = 0.01;
    
    //set the animation step (how many points or pixels the image moves at each timer interval)
    self.animationStep=10;
    
    //kick off the timer
    self.checkPositionTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerIncrement
                                                               target:self
                                                             selector:@selector(changePosition)
                                                             userInfo:nil
                                                              repeats:YES];
    
    return self;
}

- (void)changePosition
{
    //if position is less than 0, bullet has been wasted!
    if(self.position.y<0)
    {
        //stop the timer
        [self.checkPositionTimer invalidate];
        
        //decrement the score because this bullet didn't hit anything
        [self.delegate AdjustScore:-5];
        
        //remove from view
        [self removeFromSuperview];
    }
    
    //move the bullet up
    [self setPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y-self.animationStep)];
    
    //check if an image to hit is hit
    // Get the subviews of the view
    NSArray *subviews = [self.superview subviews];
    
    // skip if there are no subviews
    if ([subviews count] > 0)
    {
        //loop through all the subviews
        for (UIView *subview in subviews)
        {
            //only look for images to hit
            if([subview isKindOfClass:[ImageToHit class]])
            {
                //check if image is hit
                if(CGRectContainsPoint(subview.frame, self.center))
                {
                    //hit the image
                    [(ImageToHit*)subview  HitImage];
                    
                    //kill the fire
                    [self.checkPositionTimer invalidate];
                    [self removeFromSuperview];
                }
            }
        }
    }

}

//getter for position
-(CGPoint) position
{
    return self.frame.origin;
}

//setter for position
-(void)setPosition:(CGPoint)position
{
    [self setFrame:CGRectMake(position.x, position.y, self.bounds.size.width, self.bounds.size.height)];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
