//
//  ViewController.h
//  BinDecHexMobileApp
//
//  Created by Jessica Kasson on 9/21/15.
//  Copyright © 2015 Jessica Kasson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController
{
    AppDelegate* appDelegate;
}
@property (nonatomic, weak) IBOutlet UIButton* convertButton;
@property (nonatomic, weak) IBOutlet UIButton* clearButton;
@property (nonatomic, weak) IBOutlet UISegmentedControl* convertMode;
@property (nonatomic, weak) IBOutlet UITextField* convertText;

@property (nonatomic, weak) IBOutlet UILabel* binaryText;
@property (nonatomic, weak) IBOutlet UILabel* decimalText;
@property (nonatomic, weak) IBOutlet UILabel* hexadecimalText;

-(void)convertButtonClick:(id)sender;
-(void)clearButtonClick:(id)sender;

-(void)displayMessage:(NSString*)title msg:(NSString*)msg;
-(NSString*)decimalToBinary:(NSInteger)decimal;
-(NSString*)decimalToHexadecimal:(NSInteger)decimal;

@end


