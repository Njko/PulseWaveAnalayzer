//
//  LineChartViewController.h
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 01/12/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface LineChartViewController : UIViewController<ChartViewDelegate>

@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet LineChartView *overview;
@property (strong, nonatomic) LineChartData *rawData;
@property (strong, nonatomic) LineChartDataSet *dataSet;
@property (nonatomic) NSUInteger maxValues;

-(void) initializeGraphWithXValues:(NSMutableArray *)xVals andYValues:(NSMutableArray *)yVals;
@end
