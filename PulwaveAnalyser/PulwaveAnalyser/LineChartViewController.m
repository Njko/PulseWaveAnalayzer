//
//  LineChartViewController.m
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 01/12/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import "LineChartViewController.h"

@interface LineChartViewController()

@property (strong, nonatomic) NSMutableArray * dataSets;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineConstraint;

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
}

-(void) initializeGraphWithXValues:(NSMutableArray *)xVals andYValues:(NSMutableArray *)yVals {
    
    self.dataSet = [[LineChartDataSet alloc] initWithYVals:yVals label:@""];
    self.dataSets = [[NSMutableArray alloc] init];
    [self.dataSets addObject:self.dataSet];
    
    [self createSubValuesFromDataSets];
    
    if (!self.rawData) {
        self.rawData = [[LineChartData alloc] init];
    }
    
    self.rawData = [[LineChartData alloc] initWithXVals:xVals dataSets:self.dataSets];
    [self.rawData setValueTextColor:UIColor.blackColor];
    [self.rawData setValueFont:[UIFont systemFontOfSize:9.f]];
    
    [self.rawData getDataSetByIndex:0].visible = NO;
    [self.rawData getDataSetByIndex:1].visible = NO;
    [self.rawData getDataSetByIndex:2].visible = NO;
    [self.rawData getDataSetByIndex:3].visible = NO;
    [self.rawData getDataSetByIndex:4].visible = NO;
    [self.rawData getDataSetByIndex:5].visible = YES;
    
    self.lineChartView.data = self.rawData;
    [self.lineChartView setVisibleXRangeWithMinXRange:1 maxXRange:self.rawData.xValCount-1];
    [self.lineChartView setVisibleYRangeMaximum:5.0f axis:AxisDependencyRight];
    [self.lineChartView setDescriptionText:@""];
    self.lineChartView.rightAxis.enabled = NO;
    self.lineChartView.delegate = self;
    self.lineChartView.legend.enabled = NO;
    
    [self.overview setVisibleXRangeWithMinXRange:1 maxXRange:xVals.count];
    [self.overview setVisibleYRangeMaximum:6.0f axis:AxisDependencyRight];
    [self.overview setUserInteractionEnabled:NO];
    [self.overview setScaleEnabled:NO];
    [self.overview setPinchZoomEnabled:NO];
    [self.overview setDescriptionText:@""];
    [self.overview setDrawBordersEnabled:NO];
    [self.overview setDrawGridBackgroundEnabled:NO];
    [self.overview setDrawMarkers:NO];
    [self.overview setScaleXEnabled:NO];
    [self.overview setScaleYEnabled:NO];
    self.overview.rightAxis.enabled = NO;
    self.overview.leftAxis.enabled = NO;
    self.overview.descriptionText = @"";
    self.overview.legend.enabled = NO;
    self.overview.data = self.rawData;
    self.overview.xAxis.enabled = NO;
    
}

-(void) createSubValuesFromDataSets {
    LineChartDataSet * halfValuesSet = [[LineChartDataSet alloc] init];
    LineChartDataSet * fifthValuesSet = [[LineChartDataSet alloc] init];
    LineChartDataSet * tenthValuesSet = [[LineChartDataSet alloc] init];
    LineChartDataSet * fifteenthValuesSet = [[LineChartDataSet alloc] init];
    LineChartDataSet * twentiethValuesSet = [[LineChartDataSet alloc] init];
    
    for (int i=0; i<self.dataSet.valueCount;i++) {
        ChartDataEntry* entry = [self.dataSet entryForXIndex:i];
        if (i%2 == 0) {
            [halfValuesSet addEntry:entry];
        }
        if (i%5 == 0) {
            [fifthValuesSet addEntry:entry];
            
        }
        if (i%10 == 0) {
            [tenthValuesSet addEntry:entry];
        }
        if (i%15 == 0) {
            [fifteenthValuesSet addEntry:entry];
        }
        if (i%20 == 0) {
            [twentiethValuesSet addEntry:entry];
        }
    }
    
    [self.dataSets addObject:halfValuesSet];
    [self.dataSets addObject:fifthValuesSet];
    [self.dataSets addObject:tenthValuesSet];
    [self.dataSets addObject:fifteenthValuesSet];
    [self.dataSets addObject:twentiethValuesSet];
    
    for (int i =0; i< [self.dataSets count]; i++) {
        LineChartDataSet * currentSet = [self.dataSets objectAtIndex:i];
        
        currentSet.axisDependency = AxisDependencyLeft;
        [currentSet setColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
        [currentSet setCircleColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:0.f]];
        currentSet.lineWidth = 2.0;
        currentSet.circleRadius = 0.0;
        currentSet.fillAlpha = 65/255.0;
        currentSet.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.0f];
        currentSet.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        currentSet.drawCircleHoleEnabled = NO;
        
        if (i>0&&i<5) {
            currentSet.drawCubicEnabled = YES;
            currentSet.cubicIntensity = 0.2;
        }
    }
}

#pragma mark ChartViewDelegate
-(void) chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    
    float chartScale = chartView.viewPortHandler.scaleX;
    NSLog(@"scale : %f", chartScale);
    
    if (chartScale < 1.2f) {
        [self.rawData getDataSetByIndex:0].visible = NO;
        [self.rawData getDataSetByIndex:1].visible = NO;
        [self.rawData getDataSetByIndex:2].visible = NO;
        [self.rawData getDataSetByIndex:3].visible = NO;
        [self.rawData getDataSetByIndex:4].visible = NO;
        [self.rawData getDataSetByIndex:5].visible = YES;
    } else if (chartScale >= 1.2f && chartScale <10.0f) {
        [self.rawData getDataSetByIndex:0].visible = NO;
        [self.rawData getDataSetByIndex:1].visible = NO;
        [self.rawData getDataSetByIndex:2].visible = NO;
        [self.rawData getDataSetByIndex:3].visible = NO;
        [self.rawData getDataSetByIndex:4].visible = YES;
        [self.rawData getDataSetByIndex:5].visible = NO;
    } else if (chartScale >= 10.0f && chartScale <40.0f) {
        [self.rawData getDataSetByIndex:0].visible = NO;
        [self.rawData getDataSetByIndex:1].visible = NO;
        [self.rawData getDataSetByIndex:2].visible = NO;
        [self.rawData getDataSetByIndex:3].visible = YES;
        [self.rawData getDataSetByIndex:4].visible = NO;
        [self.rawData getDataSetByIndex:5].visible = NO;
    } else if (chartScale >=40.0f && chartScale < 100.0f) {
        [self.rawData getDataSetByIndex:0].visible = NO;
        [self.rawData getDataSetByIndex:1].visible = NO;
        [self.rawData getDataSetByIndex:2].visible = YES;
        [self.rawData getDataSetByIndex:3].visible = NO;
        [self.rawData getDataSetByIndex:4].visible = NO;
        [self.rawData getDataSetByIndex:5].visible = NO;
    } else if (chartScale >= 100.0f && chartScale < 250.0f) {
        [self.rawData getDataSetByIndex:0].visible = NO;
        [self.rawData getDataSetByIndex:1].visible = YES;
        [self.rawData getDataSetByIndex:2].visible = NO;
        [self.rawData getDataSetByIndex:3].visible = NO;
        [self.rawData getDataSetByIndex:4].visible = NO;
        [self.rawData getDataSetByIndex:5].visible = NO;
    } else {
        [self.rawData getDataSetByIndex:0].visible = YES;
        [self.rawData getDataSetByIndex:1].visible = NO;
        [self.rawData getDataSetByIndex:2].visible = NO;
        [self.rawData getDataSetByIndex:3].visible = NO;
        [self.rawData getDataSetByIndex:4].visible = NO;
        [self.rawData getDataSetByIndex:5].visible = NO;
    }
    
}

-(void) chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    self.verticalLineConstraint.constant -= dX*0.05;
}
@end
