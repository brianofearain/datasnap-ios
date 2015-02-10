//
// Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property IBOutlet UITextField *deviceDisplay;

@property(strong, nonatomic) IBOutlet UITextField *GarsTextField;

- (IBAction)textFieldReturn:(id)sender;

@end

#define DeviceLog(message, ...) self.deviceDisplay.text = [self.deviceDisplay.text stringByAppendingString:[NSString stringWithFormat:message, ##__VA_ARGS__]]
