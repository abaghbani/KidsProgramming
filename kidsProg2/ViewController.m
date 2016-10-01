//
//  ViewController.m
//  kidsProg2
//
//  Created by Akbar Baghbani on 25/05/2016.
//  Copyright © 2016 Akbar Baghbani. All rights reserved.
//

#import "ViewController.h"
#import "MeBlePopover.h"

int8_t indexNum;
int8_t actionArray[6];
const uint8_t Right_Motor = 0x0a;
const uint8_t Left_Motor = 0x09;

@interface ViewController ()

@end



@implementation ViewController

//@synthesize MeBlePopover;

@synthesize dropTarget;
@synthesize dragObject;
@synthesize touchOffset;
@synthesize homePosition;

/*
 ff 55 len idx action device port slot data a
 0  1  2   3   4      5      6    7    8
 
 Set left DC motor speed 255:   ff 55 06 60 02 0a 09 ff 00
 Set right DC motor speed 255:  ff 55 06 60 02 0a 0a ff 00
*/

void moveForward(short speed)
{
    short invertSpeed = -(speed*1.06);
    unsigned char a[9]={0xff,0x55,0x06,0x60,0x02,0x0a,0x0a,0x00,0x00};
    a[6]=Right_Motor;
    a[7]=(uint8_t)(speed & 0xff);
    a[8]=(uint8_t)(speed>>8 & 0xff);
    NSData * cmd = [NSData dataWithBytes:a length:9];
    [[BLECentralManager sharedManager].activePeripheral sendDataMandatory:cmd];
    a[6]=Left_Motor;
    a[7]=(uint8_t)(invertSpeed & 0xff);
    a[8]=(uint8_t)(invertSpeed>>8 & 0xff);
    cmd = [NSData dataWithBytes:a length:9];
    [[BLECentralManager sharedManager].activePeripheral sendDataMandatory:cmd];
}

void moveLeft(short speed)
{
    short invertSpeed = 0.8*(speed*1.06);
    unsigned char a[]={0xff,0x55,0x06,0x60,0x02,0x0a, Right_Motor, (uint8_t)(speed & 0xff), (uint8_t)(speed>>8 & 0xff), '\n'};
    NSData * cmd = [NSData dataWithBytes:a length:10];
    [[BLECentralManager sharedManager].activePeripheral sendDataMandatory:cmd];
    a[6]=Left_Motor;
    a[7]=(uint8_t)(invertSpeed & 0xff);
    a[8]=(uint8_t)(invertSpeed>>8 & 0xff);
    cmd = [NSData dataWithBytes:a length:10];
    [[BLECentralManager sharedManager].activePeripheral sendDataMandatory:cmd];
}

void moveRight(short speed)
{
    short invertSpeed = 0.8*(-(speed*1.06));
    unsigned char a[]={0xff,0x55,0x06,0x60,0x02,0x0a, Left_Motor, (uint8_t)((short)(-speed) & 0xff), (uint8_t)(((short)(-speed))>>8 & 0xff), '\n'};
    NSData * cmd = [NSData dataWithBytes:a length:10];
    [[BLECentralManager sharedManager].activePeripheral sendDataMandatory:cmd];
    a[6]=Right_Motor;
    a[7]=(uint8_t)(invertSpeed & 0xff);
    a[8]=(uint8_t)(invertSpeed>>8 & 0xff);
    cmd = [NSData dataWithBytes:a length:10];
    [[BLECentralManager sharedManager].activePeripheral sendDataMandatory:cmd];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        for (UIImageView *iView in self.view.subviews) {
            if ([iView isMemberOfClass:[UIImageView class]]) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
                {
                    self.dragObject = iView;
                    self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x, touchPoint.y - iView.frame.origin.y);
                    self.homePosition = CGPointMake(iView.frame.origin.x, iView.frame.origin.y);
                    [self.view bringSubviewToFront:self.dragObject];
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x, touchPoint.y - touchOffset.y, self.dragObject.frame.size.width, self.dragObject.frame.size.height);
    self.dragObject.frame = newDragObjectFrame;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y, self.dragObject.frame.size.width, self.dragObject.frame.size.height);

    if(indexNum == 0)
        self.dropTarget.image = self.dragObject.image;
    else if(indexNum == 1)
        self.drop2Target.image = self.dragObject.image;
    else if(indexNum == 2)
        self.drop3Target.image = self.dragObject.image;
    else if(indexNum == 3)
        self.drop4Target.image = self.dragObject.image;
    else if(indexNum == 4)
        self.drop5Target.image = self.dragObject.image;
    else if(indexNum == 5)
        self.drop6Target.image = self.dragObject.image;

    if(self.homePosition.x == 100)
    {
        actionArray[indexNum] = 1;
    }
    else if(self.homePosition.x == 300)
    {
        actionArray[indexNum] = 2;
    }
    else if(self.homePosition.x == 500)
    {
        actionArray[indexNum] = 3;
    }
    else if(self.homePosition.x >= 700)
    {
        for(int i=0;i<indexNum;i++)
        {
            switch (actionArray[i])
            {
                case 1:
                    moveForward(135);
                    sleep(1);
                    moveForward(0);
                    break;
                    
                case 2:
                    moveRight(90);
                    sleep(1);
                    moveForward(135);
                    sleep(1);
                    moveForward(0);
                    break;
                case 3:
                    moveLeft(90);
                    sleep(1);
                    moveForward(135);
                    sleep(1);
                    moveForward(0);
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    indexNum++;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Hello");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning is evaluating");
}

/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    [self.myLable1 setCenter:touchPoint];
    //[self.myGoStraitBtn setCenter:touchPoint];
}
*/
- (IBAction)myConnect:(UIButton *)sender
{
    MeBlePopover *blepop = [[MeBlePopover alloc] init];
    [self presentViewController:blepop animated:YES completion:nil];
    
}

- (IBAction)myButton12:(UIButton *)sender
{
    if([self.myLable1.text isEqualToString:(@"Maneli")])
        self.myLable1.text = @"Melina";
    else
        self.myLable1.text = @"Maneli";
    
    
}

- (IBAction)myStart:(UIButton *)sender
{
    indexNum = 0;
    for(int i=0;i<6; i++)
    {
        actionArray[i] = 0;
    }
    self.dropTarget.image = NULL;
    self.drop2Target.image = NULL;
    self.drop3Target.image = NULL;
    self.drop4Target.image = NULL;
    self.drop5Target.image = NULL;
    self.drop6Target.image = NULL;

}

@end
