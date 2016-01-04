//
//  ChartsTestViewController.m
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 19/11/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import "PulseWaveViewController.h"
#import "FileBufferManager.h"
#import <PulseWaveFramework/PWDataReaderController.h>
#import "LineChartViewController.h"
#import "RealTimeLineChartViewController.h"
@import Charts;

@interface PulseWaveViewController ()

@property (nonatomic) BOOL isAcquiring;
@property (weak, nonatomic) IBOutlet UILabel *cableStatus;
@property (weak, nonatomic) IBOutlet LineChartView *realTimeLineChartView;
@property (weak, nonatomic) IBOutlet LineChartView *bufferedLineChartView;
@property (nonatomic, weak) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) LineChartData *realTimeData;
@property (strong, nonatomic) LineChartDataSet *realTimeDataSet;
@property (strong, nonatomic) LineChartData *bufferedData;
@property (strong, nonatomic) LineChartDataSet *bufferedDataSet;
@property (nonatomic) NSInteger lastXIndexCreated;
@property (nonatomic) NSInteger lastIndex;

@property (nonatomic) double yMin;
@property (nonatomic) double yMax;

@property (nonatomic, weak) RealTimeLineChartViewController * realTimeLineChartViewController;
@property (nonatomic, weak) LineChartViewController * bufferedLineChartViewController;

//@property (nonatomic, strong) PulseWaveReader *reader;
//@property (nonatomic, strong) RscMgr *rscMgr;

//@property (nonatomic, strong) NSThread *commThread;
@property (nonatomic, strong) PWDataReaderController *dataReader;
@property (weak, nonatomic) IBOutlet UILabel *rawData;

@property (nonatomic) BOOL cableConnected;

@end

@implementation PulseWaveViewController

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

//static CGFloat refreshRate = 0.0001f;
static const NSInteger maxValues = 400;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    self.dataReader = [[PWDataReaderController alloc] init];
    self.dataReader.delegate = self;
    self.yMin = 0.0;
    self.yMax = 1.0;
    [self updateCableStatus];
}

- (void) updateCableStatus {
    self.controlButton.enabled = [self.dataReader isDeviceConnected];
    self.cableStatus.text= [NSString stringWithFormat:@"%@",[self.dataReader isDeviceConnected]?@"CONNECTED":@"DISCONNECTED"];
}

- (void) produceNewData:(CGFloat) value{

    [self shiftValues];
    
    self.lastXIndexCreated++;
    [self.realTimeLineChartViewController.rawData addXValue:[NSString stringWithFormat:@"%ld",(long)self.lastXIndexCreated]];
    
    [[self.realTimeLineChartViewController.rawData getDataSetByIndex:0] entryForXIndex:maxValues].value = value;
    
    [self.realTimeLineChartViewController.rawData removeEntryByXIndex:0 dataSetIndex:0];
    [self.realTimeLineChartViewController.rawData removeXValue:0];
    
    //Write value to the file buffer
    int intValue = roundf(value*100);
    BOOL didWriteBuffer = [[FileBufferManager sharedInstance] pushValueToBuffer:intValue];
    if (!didWriteBuffer) {
        DDLogError(@"Did not write buffer");
    }
    
    [self updateChartView];
}

- (void) updateChartView {
    self.cableStatus.text = [NSString stringWithFormat:@"total data size: %ld", (long)self.realTimeLineChartViewController.rawData.xValCount];
    //[self.lineChartView resetViewPortOffsets];
    //[self.realTimeLineChartViewController.lineChartView setVisibleYRangeMaximum:5.5f axis:AxisDependencyRight];
    [self.realTimeLineChartViewController.lineChartView notifyDataSetChanged];
}

-(void) shiftValues {
    self.yMin = 0.0;
    self.yMax = 1.0;
    for (int i=0; i < self.realTimeLineChartViewController.rawData.xValCount; i++) {
        double value = [[[self.realTimeLineChartViewController.rawData getDataSetByIndex:0] entryForXIndex:i+1] value];
        [[self.realTimeLineChartViewController.rawData getDataSetByIndex:0] entryForXIndex:i].value = value;
        
        if (value < self.yMin) {
            self.yMin = value;
        }
        if (value > self.yMax) {
            self.yMax = value;
        }
    }
}

#pragma mark - Actions

-(IBAction)acquisitionControl:(id)sender {
    if(self.isAcquiring){
        [self.dataReader stopToAcquire];
        [[FileBufferManager sharedInstance] closeBuffer];
        [self.controlButton setTitle:@"Start to acquire" forState:UIControlStateNormal];
    }else{
        [self.dataReader startToAcquire];
        [[FileBufferManager sharedInstance] openBuffer];
        [self.controlButton setTitle:@"Stop the acquisition" forState:UIControlStateNormal];
    }
    self.isAcquiring = !self.isAcquiring;
}

#pragma mark - delegates
- (void) didChangeConnectionStatus:(BOOL)isConnected {
    [self updateCableStatus];
}

- (void) didReceiveValue:(NSString *)value {
    [self performSelectorOnMainThread:@selector(drawNewValue:) withObject:value waitUntilDone:NO];
}

-(void) drawNewValue:(id)value {
    CGFloat strFloat = (CGFloat)[value floatValue];
    [self produceNewData:strFloat];
    self.rawData.text = [NSString stringWithFormat:@"%f",strFloat];
}

-(IBAction) testWriteBinaryBuffer:(id)sender {
    [[FileBufferManager sharedInstance] openBuffer];
    [[FileBufferManager sharedInstance] pushValueToBuffer:250];
    [[FileBufferManager sharedInstance] testBinaryBuffer];
}

-(IBAction) testReadBinaryBuffer:(id)sender {
    NSInteger senderTag = ((UIView*)sender).tag;
    //Generate values button
    if (senderTag == 1000) {
        //randomize and write to the buffer file
        [[FileBufferManager sharedInstance] openBuffer];
        for (int i=0; i<25000;i++) {
            [[FileBufferManager sharedInstance] pushValueToBuffer:(arc4random() % 250)+200];
        }
        [[FileBufferManager sharedInstance] pushValueToBuffer:0];//always finish by a different value to commit the last pairs of value to the file
    }
    
    NSDictionary * dict = [[FileBufferManager sharedInstance] readBinaryBuffer];
    NSString * deviceId = [dict objectForKey:@"deviceID"];
    NSString * frequency = [dict objectForKey:@"frequency"];
    NSString * timestamp = [dict objectForKey:@"timestamp"];
    NSArray * rawValues = [dict objectForKey:@"rawValues"];
    NSArray * coeffs = [dict objectForKey:@"coeffs"];
    DDLogWarn(@"Data read from buffer: %@ : %@ : %@ ",deviceId,frequency, timestamp);
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    int i=0;
    for (int coeffIndex = 0; coeffIndex < [coeffs count]; coeffIndex++) {
        
        for (int coeffValue = [((NSNumber *)coeffs[coeffIndex]) intValue]; coeffValue>0; coeffValue--) {
            int rawValue = [((NSNumber *)rawValues[coeffIndex]) intValue];
            [yVals addObject:[[ChartDataEntry alloc] initWithValue:(float)(rawValue/100.0f) xIndex:i]];
            i++;
        }
    }
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < [yVals count]; i++)
    {
        double x = i*0.00625f; // 1/160 of a second, refresh rate is 160 Hz
        NSString * xAsString = [NSString stringWithFormat:@"%.3f",x];
        [xVals addObject:xAsString];
    }
    
    [self.bufferedLineChartViewController initializeGraphWithXValues:xVals andYValues:yVals];
    [self.bufferedLineChartViewController.lineChartView notifyDataSetChanged];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"realTimeGraph"]) {
        self.realTimeLineChartViewController = segue.destinationViewController;
        self.realTimeLineChartViewController.maxValues = 400;
        
    }
    
    if ([segue.identifier isEqualToString:@"bufferedGraph"]) {
        self.bufferedLineChartViewController = segue.destinationViewController;
        self.bufferedLineChartViewController.maxValues = 3000;
    }
}

-(IBAction)resetZoomOnChartView:(id)sender {
    [self.bufferedLineChartViewController.lineChartView fitScreen];
}

@end
