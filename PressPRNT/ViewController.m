//
//  ViewController.m
//  PressPRNT
//
//  Created by Andres Aguaiza on 4/17/18.
//  Copyright © 2018 Andres Aguaiza. All rights reserved.
//



#import "ViewController.h"
#import "AppDelegate.h"
#import <StarIO_Extension/ISCBBuilder.h>
#import <StarIO/SMPort.h>
#import <StarIO_Extension/StarIoExt.h>
#import <StarIO_Extension/StarIoExtManager.h>
#import "Communication.h"
#import "searchPrinterViewController.h"

NSString *appID = @"c750caa5-be1c-427e-953d-91ff9723e6e7";
NSString *appSecret = @"ded1feab-5bf3-4d0a-9960-8e69027db313";


@interface CustomUIImagePickerController : UIImagePickerController

@end

@implementation CustomUIImagePickerController

- (BOOL)shouldAutorotate {
    return YES;
}
/*
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
 if (IS_IPAD()) {
 return UIInterfaceOrientationMaskAll;
 }
 
 
 return UIInterfaceOrientationMaskAllButUpsideDown;
 }
 */

@end
 

@interface ViewController ()<SCLFlicManagerDelegate, SCLFlicButtonDelegate>

@property (nonatomic) NSString *portName;
@property (nonatomic) NSString *portSettings;
@property (nonatomic) NSString *modelName;
@property (nonatomic) NSString *macAddress;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *imageTwo;

@property (nonatomic) StarIoExtEmulation emulation;


@end


@implementation ViewController


- (IBAction)buttonPress:(id)sender {
    
    [[SCLFlicManager sharedManager] grabFlicFromFlicAppWithCallbackUrlScheme:@"pressPRNT"];
    

    
}

-(void)flicManagerDidRestoreState:(SCLFlicManager *)manager{
    NSLog(@"I'm back");
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options; {
    
    return [[SCLFlicManager sharedManager] handleOpenURL:url];
    
}

- (void)flicManager:(SCLFlicManager *)manager didGrabFlicButton:(SCLFlicButton *)button withError:(NSError *)error; {
    if (error) {
        NSLog(@"Could not grab: %@", error);
        
    }
    
    
    // un-comment the following line if you need lower click latency for your application
    // this will consume more battery so don't over use it
    button.lowLatency = YES;
}

-(void) flicButton:(SCLFlicButton *)button didReceiveButtonDoubleClick:(BOOL)queued age:(NSInteger)age{
    
    UIImage *promoB = _imageTwo;
    
    
    
    ISCBBuilder *build2 = [StarIoExt createCommandBuilder:StarIoExtEmulationStarPRNT]; //Instanciate the builder for the graphic document
    
    [build2 beginDocument];
    
    [build2 appendBitmap:promoB diffusion:false width:576 bothScale:TRUE];
    
    [build2 appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [build2 endDocument];
    
    NSData *dataTest2 = [build2.commands copy];//somehow takes the ISCBBuilder data type and transfers it to a NSData type which sendCommands requires below
    
    
    
    [Communication sendCommands:dataTest2
                       portName:_selectedPortName
                   portSettings:@""
                        timeout:10000
              completionHandler:NULL];
    
    

    
    
}

-(void) flicButton:(SCLFlicButton *)button didReceiveButtonClick:(BOOL)queued age:(NSInteger)age{
    
    
    UIImage *promoA = _image;
    
    
    
    ISCBBuilder *build = [StarIoExt createCommandBuilder:StarIoExtEmulationStarPRNT]; //Instanciate the builder for the graphic document
    
    [build beginDocument];
    
    [build appendBitmap:promoA diffusion:false width:576 bothScale:TRUE];
    
    [build appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [build endDocument];
    
    NSData *dataTest = [build.commands copy];//somehow takes the ISCBBuilder data type and transfers it to a NSData type which sendCommands requires below
    
    
    
    [Communication sendCommands:dataTest
                       portName:_selectedPortName
                   portSettings:@""
                        timeout:10000
              completionHandler: NULL];
    
    
}

- (void) flicButton:(SCLFlicButton *) button didReceiveButtonDown:(BOOL) queued age: (NSInteger) age; {

    //This should set that we are looking for a single and double click...
    [button setTriggerBehavior:SCLFlicButtonTriggerBehaviorClickAndDoubleClick];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:appID appSecret:appSecret backgroundExecution:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)selectPromotion:(id)sender {
    
    CustomUIImagePickerController *imagePickerController = [[CustomUIImagePickerController alloc] init];
    
    imagePickerController.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = NO;
    imagePickerController.delegate      = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)selectSecondPromo:(id)sender {
    
    CustomUIImagePickerController *imagePickerControllerTwo = [[CustomUIImagePickerController alloc] init];
    
    imagePickerControllerTwo.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerControllerTwo.allowsEditing = NO;
    imagePickerControllerTwo.delegate      = self;
    
    [self presentViewController:imagePickerControllerTwo animated:YES completion:nil];
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(_image==NULL){
        
          _image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else{
        _imageTwo = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    }
  

    [self dismissViewControllerAnimated:YES completion: NULL];
    
}



@end


