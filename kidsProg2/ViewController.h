//
//  ViewController.h
//  kidsProg2
//
//  Created by Akbar Baghbani on 25/05/2016.
//  Copyright © 2016 Akbar Baghbani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEPeripheral.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *myLable1;
- (IBAction)myConnect:(UIButton *)sender;
- (IBAction)myButton12:(UIButton *)sender;
- (IBAction)myStart:(UIButton *)sender;

@property (nonatomic, strong) IBOutlet UIImageView * dropTarget;
@property (nonatomic, strong) IBOutlet UIImageView * drop2Target;
@property (nonatomic, strong) IBOutlet UIImageView * drop3Target;
@property (nonatomic, strong) IBOutlet UIImageView * drop4Target;
@property (nonatomic, strong) IBOutlet UIImageView * drop5Target;
@property (nonatomic, strong) IBOutlet UIImageView * drop6Target;

@property (nonatomic, strong) UIImageView * dragObject;
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;


@end

