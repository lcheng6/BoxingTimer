//
//  BTRoundViewController.h
//  BoxingTimer
//
//  Created by Liang Cheng on 12/8/13.
//  Copyright (c) 2013 Liang Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRoundViewController : UIViewController

{
    __weak IBOutlet UIImageView *digit1Image;
    __weak IBOutlet UIImageView *digit2Image;
}
@property (nonatomic, assign) int roundNum;

@end
