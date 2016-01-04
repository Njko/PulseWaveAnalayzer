//
//  ChartsTestViewController.h
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 19/11/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PulseWaveFramework/PulseWaveFramework.h>
#import "PulseWaveReader.h"
@import CocoaLumberjack;

@interface PulseWaveViewController : UIViewController <PWDataReaderDelegate>

@end
