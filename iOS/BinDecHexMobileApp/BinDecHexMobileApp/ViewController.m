//
//  ViewController.m
//  BinDecHexMobileApp
//
//  Created by Jessica Kasson on 9/21/15.
//  Copyright © 2015 Jessica Kasson. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Get the AppDelegate
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // UI Modification I don't get how to do elsewhere
    _convertText.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _convertText.layer.borderWidth = 1.0;
    _convertButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _convertButton.layer.borderWidth = 1.0;
    _clearButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _clearButton.layer.borderWidth = 1.0;
    _binaryText.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _binaryText.layer.borderWidth = 1.0;
    _decimalText.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _decimalText.layer.borderWidth = 1.0;
    _hexadecimalText.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _hexadecimalText.layer.borderWidth = 1.0;
    
    // Delegate setting
    [_convertButton addTarget:self action:@selector(convertButtonClick:)
             forControlEvents:(UIControlEventTouchUpInside)];
    [_clearButton addTarget:self action:@selector(clearButtonClick:)
             forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)convertButtonClick:(id)sender
{
    NSString* givenText = _convertText.text;
    NSInteger state = _convertMode.selectedSegmentIndex;
    
    if (givenText.length == 0) {
        printf("There is nothing in the text box. Here's an attempt at an alert.\n");
        [self displayMessage: @"Warning" msg:@"Nothing is in the textbox."];
    }
    else {
        printf("Not-empty! Attempting to convert now.\n");
        
        if (state == 0) {
            printf("Selected Binary.\n");
            NSCharacterSet* notDigits = [[NSCharacterSet
                characterSetWithCharactersInString:@"01"] invertedSet];
            if ([givenText rangeOfCharacterFromSet:notDigits].location == NSNotFound)
            {
                // Binary to Binary
                _binaryText.text = givenText;
            
                // Binary to Decimal
                NSInteger temp = 0;
                for (long i = givenText.length - 1; i >= 0; i--)
                    temp += ([givenText characterAtIndex:(i)] - '0') * pow(2, givenText.length - 1 - i);
                _decimalText.text = [@(temp) stringValue];

                // Binary to Hexadecimal (Using calculated decimal)
                _hexadecimalText.text = [self decimalToHexadecimal:temp];
                
            } else {
                [self displayMessage:@"Warning" msg:@"Invaid binary input."];
            }
        } else if (state == 1) {
            printf("Selected Decimal.\n");
            NSCharacterSet* notDigits = [[NSCharacterSet
            characterSetWithCharactersInString:@"0123456789"] invertedSet];
            if ([givenText rangeOfCharacterFromSet:notDigits].location == NSNotFound)
            {
                // Decimal to Decimal
                _decimalText.text = givenText;
            
                // Decimal to Binary
                _binaryText.text = [self decimalToBinary:([givenText integerValue])];
                    
                // Decimal to Hexadecimal
                _hexadecimalText.text = [self decimalToHexadecimal:([givenText integerValue])];
                
            } else {
                [self displayMessage:@"Warning" msg:@"Invaid decimal input."];
            }
        } else if (state == 2) {
            printf("Selected Hexadecimal.\n");
            NSCharacterSet* notDigits = [[NSCharacterSet
                    characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
            if ([givenText rangeOfCharacterFromSet:notDigits].location == NSNotFound)
            {
                // Hexadecimal to Hexadecimal
                _hexadecimalText.text = givenText;
        
                // Hexadecimal to Decimal
                NSInteger temp = 0;
                for (long i = givenText.length - 1; i >= 0; i--)
                {
                    int charAtIndex;
                    char c = [givenText characterAtIndex:(i)];
                    if (c == 'A' || c == 'a') charAtIndex = 10;
                    else if (c == 'B' || c == 'b') charAtIndex = 11;
                    else if (c == 'C' || c == 'c') charAtIndex = 12;
                    else if (c == 'D' || c == 'd') charAtIndex = 13;
                    else if (c == 'E' || c == 'e') charAtIndex = 14;
                    else if (c == 'F' || c == 'f') charAtIndex = 15;
                    else charAtIndex = c - '0';
                    
                    temp += (charAtIndex) * pow(16, givenText.length - 1 - i);
                }
                _decimalText.text = [@(temp) stringValue];
                
                // Hexadecimal to Binary
                _binaryText.text = [self decimalToBinary:temp];
            
            } else {
                [self displayMessage:@"Warning" msg:@"Invaid hexadecimal input."];
            }
        } else {
            [self displayMessage: @"Warning" msg:@"lol apparently indices don't exist, complain to Jess.\n"];
        }
    }
}

-(void)clearButtonClick:(id)sender
{
    _binaryText.text = @"0";
    _decimalText.text = @"0";
    _hexadecimalText.text = @"0";
}

-(void)displayMessage:(NSString*)title msg:(NSString*)msg
{
    // I don't care if this is first deprecated in iOS 9
    // it works perfectly fine
    // I don't want to instantiate a controller or anything
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title message:msg
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

-(NSString*)decimalToBinary:(NSInteger)decimal
{
    float decimalCopy = (float)decimal;
    float temp;
    NSMutableString *hexString = [NSMutableString stringWithString:@""];
    
    while (decimalCopy > 0)
    {
        temp = (float)decimalCopy / 2.0f;
        
        float remainder = temp - (int)temp;
        
        // Store the floor of temp in decimalCopy.
        decimalCopy = temp - remainder;
        
        // Multiply by 16 to get true remainder.
        remainder *= 2.0f;
        
        char c;
        if (remainder == 0) c = '0';
        else c = '1';
        
        [hexString insertString:[NSString stringWithFormat:@"%c", c] atIndex:0];
    }
    
    return hexString;
}

-(NSString*)decimalToHexadecimal:(NSInteger)decimal
{
    float decimalCopy = (float)decimal;
    float temp;
    NSMutableString *hexString = [NSMutableString stringWithString:@""];
    
    while (decimalCopy > 0)
    {
        temp = (float)decimalCopy / 16.0f;
        
        float remainder = temp - (int)temp;
        
        // Store the floor of temp in decimalCopy.
        decimalCopy = temp - remainder;
        
        // Multiply by 16 to get true remainder.
        remainder *= 16.0f;
        
        char c;
        if (remainder == 10) c = 'A';
        else if (remainder == 11) c = 'B';
        else if (remainder == 12) c = 'C';
        else if (remainder == 13) c = 'D';
        else if (remainder == 14) c = 'E';
        else if (remainder == 15) c = 'F';
        else c = (char)(remainder + '0');
        
        [hexString insertString:[NSString stringWithFormat:@"%c", c] atIndex:0];
    }
    
    return hexString;
}


@end
