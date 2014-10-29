//
//  ViewController.h
//  gimbalDemo
//
//  Created by Mark Watson on 8/7/14.
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContextLocation/QLContextPlaceConnector.h>
#import <FYX/FYX.h>
#import <FYX/FYXVisitManager.h>

NSString* date();

@interface ViewController : UIViewController <QLContextPlaceConnectorDelegate, FYXServiceDelegate, FYXVisitDelegate>

@property IBOutlet UITextField *deviceDisplay;

@property (strong, nonatomic) IBOutlet UITextField *GarsTextField;
-(IBAction)textFieldReturn:(id)sender;

@property (nonatomic, strong) QLContextPlaceConnector *placeConnector;
@property (nonatomic) FYXVisitManager *visitManager;

@end

#define DeviceLog(message, ...) self.deviceDisplay.text = [self.deviceDisplay.text stringByAppendingString:[NSString stringWithFormat:message, ##__VA_ARGS__]]
