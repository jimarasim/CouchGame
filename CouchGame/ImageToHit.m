//
//  ImageToHit.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 11/6/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "ImageToHit.h"
#import "ImageToDrag.h"

@implementation ImageToHit

//track where the last x was thrown, to guarantee safe distance
static int lastXposition = 0;

//track what last width was, to guarantee safe distance
static int lastWidth;


//when initializing with the image, make this imageview available to user interaction
- (id)initWithImage:(UIImage *)image withTimerIncrement:(float)tinc
{
    self = [super initWithImage:image];
    
    //set the timer interval
    self.timerIncrement = tinc;
    
    //set the animation step (how many points or pixels the image moves at each timer interval)
    self.animationStep=3;
    
    //set default point value
    self.points = 15;
    
    
    //kick off the timer for moving the image down
    self.checkPositionTimer = [NSTimer scheduledTimerWithTimeInterval:self.timerIncrement
                                                               target:self
                                                             selector:@selector(changePosition)
                                                             userInfo:nil
                                                              repeats:YES];
    
    
    return self;
}

- (void)changePosition
{
    //if position has gone off the screen (got past the couch)
    if(self.position.y>self.superview.frame.origin.y+self.superview.frame.size.height)
    {
        //decrement score by one third the points value
        [self.delegate AdjustScore:-(self.points/3)];
        
        //put back on top
        [self PlaceImageAtTop];
    }
    
    //move the hit image down
    [self setPosition:CGPointMake(self.frame.origin.x, self.frame.origin.y+self.animationStep)];
    
    //check if it's hit the couch
    // Get the subviews of the view
    NSArray *subviews = [self.superview subviews];
    
    // skip if there are no subviews
    if ([subviews count] > 0)
    {
        //loop through all the subviews
        for (UIView *subview in subviews)
        {
            //only look for images to hit
            if([subview isKindOfClass:[ImageToDrag class]])
            {
                //check if couch is hit
                if(CGRectContainsPoint(subview.frame, self.center))
                {
                    //play couch hit animation
                    [(ImageToDrag*)subview TouchCouchAnimation];
                    
                }
            }
        }
    }
    
    subviews=nil;

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

//do something special when image is hit
-(void)HitImage
{
    //stop the timer
    [self.checkPositionTimer invalidate];
    self.checkPositionTimer=nil;
    
    //increment the score
    [self.delegate AdjustScore:self.points];
    
    //make it disappear
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0)];}
                     completion:^(BOOL finished){
                         //remove from view
                         [self removeFromSuperview];
                     }];
    //play a sound
    if([self.imageAlias compare:@"cat.png"]){
        NSLog(@"image alias:%@",self.imageAlias);
    }
    
    
}

//put the image somewhere at the top of the superview
-(void)PlaceImageAtTop
{
    //set the max distance x position an image can be placed
    int xMaxPosition = (int)self.superview.frame.size.width-self.frame.size.width;
    
    //choose a random position
    int randomx = (int)arc4random_uniform(xMaxPosition);
    
    //make sure position is a minimum distance
    int finalPosition = [self MinimumPosition:randomx];
    
    //set where x was last positioned
    lastXposition = finalPosition;
    
    //set width of last positioned
    lastWidth = self.frame.size.width;
    
    //place image at random x position at the top of the superview
    [self setPosition:CGPointMake((float)finalPosition, self.superview.frame.origin.y-self.frame.size.height)];
}

//make sure images to hit are at least 75 pixels of each other
-(int)MinimumPosition:(int)chosenPosition
{
    if(abs(chosenPosition-lastXposition)<75)
    {
        chosenPosition=lastXposition+75;
        
        //check if position is outside the frame, if so, set the other way
        if(chosenPosition>(self.superview.frame.size.width-self.frame.size.width))
        {
            chosenPosition=lastXposition-75;
        }
    }
    
    return chosenPosition;
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
