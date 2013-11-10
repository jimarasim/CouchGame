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

//when initializing with the image, make this imageview available to user interaction
- (id)initWithImage:(UIImage *)image
{
    //make user interations enabled for tapping and dragging
    self = [super initWithImage:image];
    
    //set the timer interval
    self.timerIncrement = 0.05;
    
    //set the animation step (how many points or pixels the image moves at each timer interval)
    self.animationStep=3;
    
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
    //if position has gone off the screen
    if(self.position.y>self.superview.frame.origin.y+self.superview.frame.size.height)
    {
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
    
    //make it disappear
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0)];}
                     completion:^(BOOL finished){
                         //remove from view
                         [self removeFromSuperview];
                     }];
    
    //increment the score
    [self.delegate AdjustScore:15];
    
}

//put the image somewhere at the top of the superview
-(void)PlaceImageAtTop
{
    //generate a random x position
    int xmax = abs((int)self.superview.frame.size.width-self.frame.size.width);
    
    int randomx = arc4random() % xmax;
    
    //place image at random x position at the top of the superview
    [self setPosition:CGPointMake((float)randomx, self.superview.frame.origin.y-self.frame.size.height)];
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
