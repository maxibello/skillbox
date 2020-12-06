//
//  ViewController2.m
//  s02e08-objc
//
//  Created by Maxim Kuznetsov on 06.12.2020.
//

#import "ViewController2.h"

@interface ViewController2()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController2

- (IBAction)buttonClicked:(id)sender {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([self.textField.text rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        double powered = pow(2, self.textField.text.intValue);
        self.label.text = [NSString stringWithFormat:@"%.0f", powered];
    } else {
        self.label.text = @"Введите целое число в строку";
    }
}

@end
