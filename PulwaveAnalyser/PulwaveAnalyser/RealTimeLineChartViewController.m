//
//  RealTimeLineChartViewController.m
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 02/12/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import "RealTimeLineChartViewController.h"

@interface RealTimeLineChartViewController()

@property (nonatomic) NSUInteger lastXIndexCreated;
@property (nonatomic) NSUInteger lastXIndexDestroyed;
@property (nonatomic) NSUInteger lastIndex;

@end

@implementation RealTimeLineChartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self initializeData];
}

- (void) initializeData {
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.maxValues; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.maxValues-1; i++)
    {
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:0.0f xIndex:i]];
    }
    [yVals addObject:[[ChartDataEntry alloc] initWithValue:0.0f xIndex:self.maxValues]];
    [yVals addObject:[[ChartDataEntry alloc] initWithValue:5.0f xIndex:self.maxValues]];
    
    self.dataSet = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
    self.dataSet.axisDependency = AxisDependencyRight;
    [self.dataSet setColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    [self.dataSet setCircleColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:0.f]];
    self.dataSet.lineWidth = 4.0;
    self.dataSet.circleRadius = 0.0;
    self.dataSet.fillAlpha = 65/255.0;
    self.dataSet.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.0f];
    self.dataSet.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    self.dataSet.drawCircleHoleEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:self.dataSet];
    
    self.rawData = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [self.rawData setValueTextColor:UIColor.blackColor];
    [self.rawData setValueFont:[UIFont systemFontOfSize:9.f]];
    self.lastXIndexCreated = self.rawData.xValCount;
    self.lastIndex = self.lastXIndexCreated;
    self.lastXIndexDestroyed = 0;
    self.lineChartView.data = self.rawData;
    [self.lineChartView setVisibleXRangeWithMinXRange:1 maxXRange:self.maxValues-1];
    [self.lineChartView setVisibleYRangeMaximum:5.5f  axis:AxisDependencyRight];
    self.lineChartView.rightAxis.enabled = NO;
    self.lineChartView.leftAxis.enabled = NO;
    self.lineChartView.descriptionText = @"";
    self.lineChartView.legend.enabled = NO;
    
}

-(void) addNewEntryWithXValue:(NSString *)xValue andYValue:(NSString *)yValue {
    
}


@end
