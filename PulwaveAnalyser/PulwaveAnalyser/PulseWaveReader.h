//
//  PulseWaveReader.h
//  BodyCapSerial
//
//  Created by Yann Lapeyre on 24/07/2015.
//  Copyright (c) 2015 Medes-IMPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PulseWaveReaderDelegate

-(void)newPulseWaveValue:(NSString *)value;

@end

@interface PulseWaveReader : NSObject

@property (nonatomic, weak) id<PulseWaveReaderDelegate> delegate;

-(void)newBytesRead:(NSData *)read;

@end
