//
//  ViewController.h
//  TestDHlibxls
//
//  Created by David Hoerl on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *contentArray;
@property (weak, nonatomic) IBOutlet UITextField *rowCount1;
@property (weak, nonatomic) IBOutlet UITextField *rowCount2;
@property (nonatomic,strong)NSString *segmentString;

@end
