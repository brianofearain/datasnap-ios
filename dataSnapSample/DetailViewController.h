//
//  DetailViewController.h
//  dataSnapSample
//
//  Created by Brian Feran on 2/5/15.
//  Copyright (c) 2015 Datasnapio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

