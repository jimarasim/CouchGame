//
//  ImageToDrag.h
//  CouchGame
//
//  Created by JAMES K ARASIM on 10/29/13.
//  Copyright (c) 2013 JAMES K ARASIM. All rights reserved.
//

#import <UIKit/UIKit.h>

//delegate method implemented by viewcontroller when image is hit; to update the score
@protocol ImageToDragDelegate <NSObject>
@required
-(void)Fire;
-(void)AdjustScore:(int)points;
-(void)AdjustLives:(int)lives;
@end

@interface ImageToDrag : UIImageView
//member variable to track the current point of this image view
{
    CGPoint currentPoint;
}

//access to the registered delegate
@property (weak, nonatomic) id <ImageToDragDelegate> delegate;

//array of animation images
@property NSArray * animationArray;

//method to animate couch when it gets touched
-(void)TouchCouchAnimation;

@end
