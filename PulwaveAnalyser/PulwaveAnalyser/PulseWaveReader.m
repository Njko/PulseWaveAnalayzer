//
//  PulseWaveReader.m
//  BodyCapSerial
//
//  Created by Yann Lapeyre on 24/07/2015.
//  Copyright (c) 2015 Medes-IMPS. All rights reserved.
//

#import "PulseWaveReader.h"
#import <PulseWaveFramework/PulseWaveFramework.h>

@interface PulseWaveReader()

@property (nonatomic,strong) NSMutableData *currentLine;


@end

@implementation PulseWaveReader

-(instancetype)init
{
    self = [super init];
    if(self){
        self.currentLine = [[NSMutableData alloc] init];
    }
    return self;
}

// handle new bytes read
-(void)newBytesRead:(NSData *)read {
    
    for(int i=0; i<read.length; i++){
        UInt8 buf[1];
        [read getBytes:&buf range:NSMakeRange(i, 1)];
        
        //look for new line char
        if(buf[0]==0x0A){
            [self finalizeCurrentLine];
        }else if(buf[0]!=0x0D){
            [self addToCurrentLine:buf[0]];
        }
    }
}


-(void)finalizeCurrentLine
{
    [self.delegate newPulseWaveValue:[NSString stringWithUTF8String:[self.currentLine bytes]]];
    [self startsNewLine];
}


-(float)readDataFromCurrentLine
{
   // NSString* newStr = [NSString stringWithUTF8String:[self.currentLine bytes]];
    return 0.0;
}


-(void)startsNewLine
{
    self.currentLine = [[NSMutableData alloc] init];
}


-(void)addToCurrentLine:(UInt8)byte {
    [self.currentLine appendBytes:&byte length:1];
}

@end
