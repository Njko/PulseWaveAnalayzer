//
//  AppDelegate.h
//  PulwaveAnalyser
//
//  Created by Nicolas Linard on 02/11/2015.
//  Copyright © 2015 MEDES. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(BOOL) storeDocumentWithMeta:(NSDictionary*)dict andBinaryFilePath:(NSString *)path;
@end

