//
//  ViewController.h
//  PressPRNT
//
//  Created by Andres Aguaiza on 4/17/18.
//  Copyright © 2018 Andres Aguaiza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <fliclib/fliclib.h>

@interface ViewController : UIViewController <SCLFlicManagerDelegate, SCLFlicButtonDelegate>

@property(strong,nonatomic) NSString *selectedPortName;

@end





