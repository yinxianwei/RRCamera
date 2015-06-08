//
//  ViewController.m
//  RRCameraDemo
//
//  Created by 尹现伟 on 15/6/8.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

#import "ViewController.h"
#import "RRCamera.h"


@interface ViewController ()<RRCameraDelegate>

@property (strong, nonatomic) RRCamera *camera;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void) take {
    self.camera = [[RRCamera alloc] init];
    UIView *customUI = [[JECustomView alloc] initWithFrame:self.view.frame];
    self.camera.customView = customUI;
    self.camera.delegate = self;
    CGFloat w = self.view.frame.size.width;
    self.camera.sizeCropPicture = CGSizeMake(w, w);
    [self presentViewController:self.camera animated:YES completion:^{
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

}

- (IBAction)pia:(UIButton *)sender {
    
    [self take];
    
    
}

- (void) cameraCanceled{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.camera dismissViewControllerAnimated:YES completion:^{
    }];

    
    
}

- (void) switchCamera:(AVCaptureDevicePosition)cameraPosition{
    
    
    
}

- (void) takePictureDone:(UIImage *)image{
    
    [self.camera dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
