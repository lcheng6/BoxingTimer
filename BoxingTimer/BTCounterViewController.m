//
//  BTCounterViewController.m
//  BoxingTimer
//
//  Created by Liang Cheng on 12/7/13.
//  Copyright (c) 2013 Liang Cheng. All rights reserved.
//

#import "BTCounterViewController.h"

@interface BTCounterViewController ()

@end

@implementation BTCounterViewController
@synthesize secondsInDisplay, period, displayInGreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setSeparatorOn:YES];
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [[self view] addGestureRecognizer:singleTapRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)convertSecsToDisplay
{
    TimeForDisplay displayStruct;
    int secs = secondsInDisplay;
    
    secs = secs % 3600;
    displayStruct.min1 = secs / 600;
    secs = secs % 600;
    displayStruct.min2 = secs / 60;
    secs = secs % 60;
    displayStruct.sec1 = secs / 10;
    secs = secs % 10;
    displayStruct.sec2 = secs;
    
    [self setImageForTimer:min1 number:displayStruct.min1];
    [self setImageForTimer:min2 number:displayStruct.min2];
    [self setImageForTimer:sec1 number:displayStruct.sec1];
    [self setImageForTimer:sec2 number:displayStruct.sec2];
    
}

- (void) setImageForTimer:(UIImageView *)imageDisplay number:(int)imageIndex
{
    NSString * imageName;
    if (displayInGreen == true) {
        imageName = [[NSString alloc] initWithFormat:@"Numbers_green_%d", imageIndex];
    }
    else {
        imageName = [[NSString alloc] initWithFormat:@"Numbers_red_%d", imageIndex];
    }
    UIImage * img = [UIImage imageNamed:imageName];
    [imageDisplay setImage:img];
}

- (void) setSecondsInDisplay:(int)secs
{
    secondsInDisplay = secs;
    [self convertSecsToDisplay];
}

- (void) setSeparatorOn:(BOOL) on
{
    NSString * imageOn;
    NSString * imageOff;
    
    if (displayInGreen == true) {
        imageOn = @"Numbers_green_separator_on";
        imageOff = @"Numbers_green_separator_off";
    } else {
        imageOn = @"Numbers_red_separator_on";
        imageOff = @"Numbers_red_separator_off";
    }
    UIImage * image = nil;
    if(on) {
        image = [UIImage imageNamed:imageOn];
    } else{
        image = [UIImage imageNamed:imageOff];
    }
    
    [separator setImage:image];
}

- (void) setDisplayInGreen:(BOOL)displayInGreen1
{
    displayInGreen = displayInGreen1;
    [[self view] setNeedsDisplay];
}

- (void) handleSingleTap: (id) input
{
    NSLog(@"touch recognized");
}


@end
