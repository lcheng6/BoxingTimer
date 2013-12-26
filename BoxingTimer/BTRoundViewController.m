//
//  BTRoundViewController.m
//  BoxingTimer
//
//  Created by Liang Cheng on 12/8/13.
//  Copyright (c) 2013 Liang Cheng. All rights reserved.
//

#import "BTRoundViewController.h"

@interface BTRoundViewController ()

@end

@implementation BTRoundViewController

@synthesize roundNum;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayRound
{
    int num1;
    int num2;
    num1 = (roundNum % 100)/10;
    num2 = roundNum% 10;
    
    [self setImageWithDigit:digit1Image digit:num1];
    [self setImageWithDigit:digit2Image digit:num2];
}

- (void) setImageWithDigit:(UIImageView*) imageView digit:(int) imageIndex
{
    NSString * imageName = [[NSString alloc] initWithFormat:@"Numbers_red_%d", imageIndex];
    UIImage * img = [UIImage imageNamed:imageName];
    [imageView setImage:img];
}

- (void) setRoundNum:(int)roundNumber
{
    roundNum = roundNumber;
    [self displayRound];
}

@end
