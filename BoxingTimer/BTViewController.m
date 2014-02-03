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
    buzzerPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    buzzerPlayer.numberOfLoops = 0;
    
    url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/bell.mp3", [[NSBundle mainBundle] resourcePath]]];
    bellPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    bellPlayer.numberOfLoops  = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initTimer {
    timerDefaultPeriod.goPeriod = [goTimer period];
    timerDefaultPeriod.restPeriod = [restTimer period];
    timerThisPeriod = timerDefaultPeriod;
    
    appState.startOfThisRunningTimeBlock = 0;
    appState.clockIsRunning = NO;
    appState.existingRunningTimeThisPeriod = 0;
    appState.clockUsedLast = kRestTimer;
    appState.clockWasReset = YES;
    
    clockDisplay.goDisplay = timerDefaultPeriod.goPeriod;
    clockDisplay.goSeparatorOn = YES;
    clockDisplay.restDisplay = timerDefaultPeriod.restPeriod;
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
    
    if (appState.clockIsRunning == NO) {
        
        if (appState.clockWasReset == YES) {
            timerDefaultPeriod.goPeriod = [goTimer getSecondsInDisplay];
            timerDefaultPeriod.restPeriod = [restTimer getSecondsInDisplay];
            timerThisPeriod = timerDefaultPeriod;
            appState.clockWasReset = NO;
        } else {
            timerThisPeriod.goPeriod += ([goTimer getSecondsInDisplay] - clockDisplay.goDisplay);
            clockDisplay.goDisplay = [goTimer getSecondsInDisplay];
            timerThisPeriod.restPeriod += ([restTimer getSecondsInDisplay] - clockDisplay.restDisplay);
            clockDisplay.restDisplay = [restTimer getSecondsInDisplay];
        }
        //The current state is not running, and title of start button is "Hold"
        [startButton setTitle:@"Hold" forState:UIControlStateNormal];
        appState.clockIsRunning = YES;
        appState.startOfThisRunningTimeBlock = CACurrentMediaTime();
        if(stopTimer == nil) {
            stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        }
        [resetButton setEnabled:NO];
        [goTimer setRespondsToTouchForAdjustment:false];
        [restTimer setRespondsToTouchForAdjustment:false];
        
    } else {
        //The current state is running, and the title of the start button is "Hold"
        [startButton setTitle:@"Start" forState:UIControlStateNormal];
        appState.existingRunningTimeThisPeriod += CACurrentMediaTime() - appState.startOfThisRunningTimeBlock;
        appState.clockIsRunning = NO;
        if(stopTimer) {
            [stopTimer invalidate];
            stopTimer = nil;
        }
        
        [resetButton setEnabled:YES];
        [goTimer setRespondsToTouchForAdjustment:true];
        [restTimer setRespondsToTouchForAdjustment:true];
        if (appState.existingRunningTimeThisPeriod < timerThisPeriod.goPeriod) {
            [goTimer setRespondsToTouchForAdjustment:YES];
            [restTimer setRespondsToTouchForAdjustment:YES];
        } else {
            [goTimer setRespondsToTouchForAdjustment:NO];
            [restTimer setRespondsToTouchForAdjustment:YES];
        }
    }
    //[self refreshClockDisplay];
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
    [self initTimer];
    [self refreshClockDisplay];
    [goTimer setRespondsToTouchForAdjustment:YES];
    [restTimer setRespondsToTouchForAdjustment:YES];
}

- (void)updateTimer {
    double currentTime = CACurrentMediaTime();
    double runTimeThisPeriod = currentTime - appState.startOfThisRunningTimeBlock + appState.existingRunningTimeThisPeriod;
    NSLog(@"runTimeThisPeriod: %.3f", runTimeThisPeriod);
    [self convertTimerToDisplay:runTimeThisPeriod];
    [self refreshClockDisplay];
}

- (void)convertTimerToDisplay:(double) runTimeThisPeriod
{
    int tenthSec = (int)(runTimeThisPeriod * 10.0) %10;
    if(runTimeThisPeriod < timerThisPeriod.goPeriod)
    {
        //This is the goTime.
        clockDisplay.goDisplay = timerThisPeriod.goPeriod - runTimeThisPeriod;
        if(tenthSec < 5) {
            clockDisplay.goSeparatorOn = YES;
        } else {
            clockDisplay.goSeparatorOn = NO;
        }
        if(appState.clockUsedLast == kRestTimer) {
            [self playBellAtRoundStart];
            appState.clockUsedLast = kGoTimer;
            clockDisplay.restSeparatorOn = NO;
        }
    } else if (runTimeThisPeriod < timerThisPeriod.goPeriod + timerThisPeriod.restPeriod){
        clockDisplay.restDisplay = timerThisPeriod.restPeriod + timerThisPeriod.goPeriod - runTimeThisPeriod;
        if (tenthSec < 5) {
            clockDisplay.restSeparatorOn = YES;
        } else {
            clockDisplay.restSeparatorOn = NO;
        }
        if(appState.clockUsedLast == kGoTimer) {
            [self playAlarmAtRoundEnd];
            appState.clockUsedLast = kRestTimer;
            clockDisplay.goSeparatorOn = NO;
        }
    } else {
        //Finished this period (go + rest) entirely
        clockDisplay.roundDisplay = clockDisplay.roundDisplay + 1;
        timerThisPeriod = timerDefaultPeriod;
        clockDisplay.restSeparatorOn = NO;
        appState.startOfThisRunningTimeBlock = CACurrentMediaTime();
        appState.existingRunningTimeThisPeriod = 0;
    }
    
}

- (void) playAlarmAtRoundEnd {
    [buzzerPlayer play];
}

- (void) playBellAtRoundStart {
    [bellPlayer play];
}

- (void) setClockToDefaultPeriod {
    [goTimer setSecondsInDisplay:15];
    [goTimer setPeriod:15];

    [restTimer setSecondsInDisplay:15];
    [restTimer setPeriod:15];
}
@end
