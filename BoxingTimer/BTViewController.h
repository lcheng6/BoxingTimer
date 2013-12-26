//
//  BTViewController.h
//  BoxingTimer
//
//  Created by Liang Cheng on 12/7/13.
//  Copyright (c) 2013 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class BTCounterViewController;
@class BTRoundViewController;

typedef enum _ClockUsedInPrevousTimeUpdate {
    kGoTimer,
    kRestTimer
} ClockUsedInPreviousTimeUpdate;

typedef struct _Period {
    int goPeriod;
    int restPeriod;
    
} Period;

typedef struct _ClockDisplay {
    int goDisplay;
    BOOL goSeparatorOn;
    int restDisplay;
    BOOL restSeparatorOn;
    int roundDisplay;
} ClockDisplay;

typedef struct _AppState {
    double lastStartButtonPressedTime;
    double totalRunningTime;
    BOOL clockIsRunning;
    ClockUsedInPreviousTimeUpdate clockedUsedLast;
} AppState;

@interface BTViewController : UIViewController
{
    __weak IBOutlet UIButton *startButton;
    __weak IBOutlet UIButton *resetButton;
    
    Period timerPeriod;
    ClockDisplay clockDisplay;
    AppState appState;
    NSTimer * stopTimer;
    AVAudioPlayer * audioPlayer;
}

@property (readonly, strong) BTCounterViewController * goTimer;
@property (readonly, strong) BTCounterViewController * restTimer;
@property (readonly, strong) BTRoundViewController * roundCounter;

- (IBAction)startPressed:(id)sender;
- (IBAction)resetPressed:(id)sender;

@end
