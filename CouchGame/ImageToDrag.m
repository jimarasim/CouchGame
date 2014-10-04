//
//  ImageToDrag.m
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/29/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import "ImageToDrag.h"

@implementation ImageToDrag

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
    if (self = [super initWithImage:image])
        self.userInteractionEnabled = YES;
    
    //setup a tap gesture recognizer, for when this image is tapped
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognizer];
    
    //setup sequence of images to play when the couch is touched
    self.animationArray = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"v2couch1.png"],
                            [UIImage imageNamed:@"v2couch2.png"],
                            [UIImage imageNamed:@"v2couch3.png"],
                            nil];
    self.animationImages = self.animationArray;
    self.animationDuration = 1.0;
    self.animationRepeatCount = 1;
    
    tapRecognizer=nil;
    
    return self;
}

//when an initial touch happens
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // When a touch starts, get the current location in the view
    //"touches anyObject" returns any uitouch object from the touches NSSet... any... could be random
    //then calls the locationInView method of the uitouch object
    currentPoint = [[touches anyObject] locationInView:self];
}

//when the touch moves, move this image with it
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Get active location upon move
    CGPoint activePoint = [[touches anyObject] locationInView:self];
    
    // Determine new point based on where the touch is now located
    //HINT: command+click to see something's code   
    CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x),
                                   self.center.y + (activePoint.y - currentPoint.y));
    
    //--------------------------------------------------------
    // Make sure we stay within the bounds of the parent view
    //--------------------------------------------------------
    float midPointX = CGRectGetMidX(self.bounds);
    // If too far right...
    if (newPoint.x > self.superview.bounds.size.width  - midPointX)
        newPoint.x = self.superview.bounds.size.width - midPointX;
    else if (newPoint.x < midPointX)  // If too far left...
        newPoint.x = midPointX;
    
    float midPointY = CGRectGetMidY(self.bounds);
    // If too far down...
    if (newPoint.y > self.superview.bounds.size.height  - midPointY)
        newPoint.y = self.superview.bounds.size.height - midPointY;
    else if (newPoint.y < midPointY)  // If too far up...
        newPoint.y = midPointY;
    
    // Set new center location
    self.center = newPoint;
}

//when a tap happens
- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    // Do something when the tap is over
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        
        [self.delegate Fire];
        
    }
}

//animation to play when the couch is touched
-(void)TouchCouchAnimation
{
    if(![self isAnimating])
    {
        [self startAnimating];
        
        //decrement score when couch is touched
        [self.delegate AdjustScore:-15];
        
        //decrement lives when couch is touched
        [self.delegate AdjustLives:-1];
    }
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
