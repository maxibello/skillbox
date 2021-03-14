//
//  ViewController.m
//  s02e08-objc
//
//  Created by Maxim Kuznetsov on 06.12.2020.
//

#import "ViewController1.h"

@interface ViewController1 ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController1

NSMutableArray* textFieldValues;

- (void)viewDidLoad {
    [super viewDidLoad];
    textFieldValues = [NSMutableArray array];
}

- (IBAction)buttonClicked:(id)sender {
    [textFieldValues addObject: [self.textField text]];
    self.label.text = [textFieldValues componentsJoinedByString:@" "];
}

@end
