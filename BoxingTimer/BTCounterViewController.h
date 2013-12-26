//
//  BTCounterViewController.h
//  BoxingTimer
//
//  Created by Liang Cheng on 12/7/13.
//  Copyright (c) 2013 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef struct _TimeForDisplay {
    int min1;
    int min2;
    int sec1;
    int sec2;
} TimeForDisplay;

@interface BTCounterViewController : UIViewController 
{
    __weak IBOutlet UIImageView *min1;
    __weak IBOutlet UIImageView *min2;
    __weak IBOutlet UIImageView *sec1;
    __weak IBOutlet UIImageView *sec2;
    __weak IBOutlet UIImageView *separator;
    
}

@property(nonatomic, assign) int secondsInDisplay;
@property(nonatomic, assign) int period;
@property(nonatomic, assign) BOOL displayInGreen;
- (void) convertSecsToDisplay;
- (void) setSeparatorOn:(BOOL) on;

@end
