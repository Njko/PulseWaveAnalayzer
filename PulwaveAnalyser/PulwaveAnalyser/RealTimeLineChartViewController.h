//
//  RealTimeLineChartViewController.h
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 02/12/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface RealTimeLineChartViewController : UIViewController

@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property (strong, nonatomic) LineChartData *rawData;
@property (strong, nonatomic) LineChartDataSet *dataSet;
@property (nonatomic) NSUInteger maxValues;

-(void) addNewEntryWithXValue:(NSString *)xValue andYValue:(NSString *)yValue;

@end
