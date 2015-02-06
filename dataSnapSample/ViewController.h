//
//  Copyright (c) 2014 Datasnap.io. All rights reserved.
//  Datasnap Generic Sample

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property IBOutlet UITextField *deviceDisplay;

@property(strong, nonatomic) IBOutlet UITextField *GarsTextField;

- (IBAction)textFieldReturn:(id)sender;


@end

#define DeviceLog(message, ...) self.deviceDisplay.text = [self.deviceDisplay.text stringByAppendingString:[NSString stringWithFormat:message, ##__VA_ARGS__]]
