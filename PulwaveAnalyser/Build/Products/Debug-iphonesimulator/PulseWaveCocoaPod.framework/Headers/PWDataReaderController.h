//
//  PWDataReaderController.h
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 03/11/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <RedparkSerialFramework/RedparkSerialFramework.h>
#import "PWEtactReader.h"
#import "PWDataReaderDelegate.h"


@interface PWDataReaderController : NSObject <RscMgrDelegate, PWEtactReaderDelegate>

@property (nonatomic, strong) id<PWDataReaderDelegate> delegate;

-(void)resetAction;
-(void)testAction;
@end
