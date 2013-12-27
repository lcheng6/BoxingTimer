//
//  BTViewController.m
//  BoxingTimer
//
//  Created by Liang Cheng on 12/7/13.
//  Copyright (c) 2013 Liang Cheng. All rights reserved.
//

#import "BTViewController.h"
#import "BTCounterViewController.h"
#import "BTRoundViewController.h"
#import "math.h"

@interface BTViewController ()

@end

@implementation BTViewController

@synthesize goTimer, restTimer, roundCounter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    goTimer = [[BTCounterViewController alloc] init];
    [goTimer setDisplayInGreen:true];
    [goTimer setSecondsInDisplay:15];
    [goTimer setPeriod:15];
    [goTimer setRespondsToTouchForAdjustment:true];
    CGRect timerRect = [[goTimer view] bounds];
    timerRect.origin.y = 30;
    timerRect.origin.x = 14;
    [[goTimer view] setFrame:timerRect];
    [[self view] addSubview:[goTimer view]];
    
    
    
    timerRect.origin.y = 193;
    timerRect.origin.x = 14;
    restTimer = [[BTCounterViewController alloc] init];
    [restTimer setDisplayInGreen:false];
    [restTimer setSecondsInDisplay:15];
    [restTimer setPeriod:15];
    [restTimer setRespondsToTouchForAdjustment:true];
    [[restTimer view] setFrame:timerRect];
    [restTimer setSeparatorOn:NO];
    [[self view] addSubview:[restTimer view]];
        

    roundCounter = [[BTRoundViewController alloc] init];
    CGRect roundRect = [[roundCounter view] bounds];
    roundRect.origin.y = 356;
    roundRect.origin.x = 77;
    [[roundCounter view] setFrame:roundRect];
    [[self view] addSubview:[roundCounter view]];
    [roundCounter setRoundNum:0];
    
    stopTimer = nil;
    
    [self initTimer];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/buzzer.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initTimer {
    timerPeriod.goPeriod = [goTimer period];
    timerPeriod.restPeriod = [restTimer period];
    
    appState.lastStartButtonPressedTime = 0;
    appState.clockIsRunning = NO;
    appState.totalRunningTime = 0;
    
    clockDisplay.goDisplay = timerPeriod.goPeriod;
    clockDisplay.goSeparatorOn = YES;
    clockDisplay.restDisplay = timerPeriod.restPeriod;
    clockDisplay.restSeparatorOn = NO;
    clockDisplay.roundDisplay = 0;
}

- (void) refreshClockDisplay
{
    [goTimer setSecondsInDisplay:clockDisplay.goDisplay];
    [goTimer setSeparatorOn:clockDisplay.goSeparatorOn];
    [restTimer setSecondsInDisplay:clockDisplay.restDisplay];
    [restTimer setSeparatorOn:clockDisplay.restSeparatorOn];
    [roundCounter setRoundNum:clockDisplay.roundDisplay];
}

- (IBAction)startPressed:(id)sender {
   /*
    
    [self refreshClockDisplay];
    
    if (appState.clockIsRunning == NO) {
        //The current state is not running, and title of start button is "Hold"
        [startButton setTitle:@"Hold" forState:UIControlStateNormal];
        appState.clockIsRunning = YES;
        appState.lastStartButtonPressedTime = CACurrentMediaTime();
        if(stopTimer == nil) {
            stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        }
        [resetButton setEnabled:NO];
    } else {
        //The current state is running, and the title of the start button is "Hold"
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        appState.totalRunningTime += CACurrentMediaTime() - appState.lastStartButtonPressedTime;
        appState.clockIsRunning = NO;
        if(stopTimer) {
            [stopTimer invalidate];
            stopTimer = nil;
        }
        [resetButton setEnabled:YES];
    }
    */
}

- (IBAction)resetPressed:(id)sender {
    /*
    if (appState.clockIsRunning == NO)
    {
        [self initTimer];
        [self refreshClockDisplay];
        //[self playAlarmAtRoundEnd];
    }
     */
}

- (void)updateTimer {
    double currenTime = CACurrentMediaTime();
    double runnTime = currenTime - appState.lastStartButtonPressedTime + appState.totalRunningTime;
    NSLog(@"difftime: %.3f", runnTime);
    [self convertTimerToDisplay:runnTime];
    [self refreshClockDisplay];
}

- (void)convertTimerToDisplay:(double) diffTime
{
    /*
    int entirePeriod = timerPeriod.goPeriod + timerPeriod.restPeriod;
    clockDisplay.roundDisplay = ((int) diffTime)/entirePeriod;
    int secIntoThisEntirePriod = ((int) diffTime % entirePeriod);
    int tenthSec = ((int)(diffTime * 10.0)) % 10;
    
    
    if (secIntoThisEntirePriod < goTimer.period) {
        clockDisplay.goDisplay = timerPeriod.goPeriod - secIntoThisEntirePriod;
        if(tenthSec < 5) {
            clockDisplay.goSeparatorOn = YES;
        } else {
            clockDisplay.goSeparatorOn = NO;
        }
        clockDisplay.restSeparatorOn = NO;
        clockDisplay.restDisplay = 0;
        
        appState.clockedUsedLast = kGoTimer;
    } else {
        clockDisplay.restDisplay = entirePeriod - secIntoThisEntirePriod;
        if (tenthSec < 5) {
            clockDisplay.restSeparatorOn = YES;
        } else {
            clockDisplay.restSeparatorOn = NO;
        }
        clockDisplay.goSeparatorOn = NO;
        clockDisplay.goDisplay = 0;
        if (appState.clockedUsedLast == kGoTimer) {
            [self playAlarmAtRoundEnd];
        }
        appState.clockedUsedLast = kRestTimer;
    }
     */
}

- (void) playAlarmAtRoundEnd {
    
    [audioPlayer play];
}

@end
