//
//  JECustomView.m
//  RRCameraDemo
//
//  Created by 尹现伟 on 15/6/8.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

#import "JECustomView.h"



@implementation JECustomView

- (void) initUI {

    CGFloat h = (self.frame.size.height - self.frame.size.width)/2;
    CGFloat pia_h = h * 0.56;
    UIButton *piaBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, pia_h, pia_h)];
    piaBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - h/2 + 10);
    piaBtn.tag = 1;
    [piaBtn setImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [self addSubview:piaBtn];

    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 35)];
    cancelBtn.center = CGPointMake(70/2, piaBtn.center.y);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.tag = 2;
    [self addSubview:cancelBtn];
    
    
    UIButton *switchBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 44, 0, 44, 44)];
    switchBtn.tag = 3;
    [switchBtn setImage:[UIImage imageNamed:@"xiangji"] forState:UIControlStateNormal];
    [self addSubview:switchBtn];
    
    
    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    flashBtn.tag = 4;
    [flashBtn setImage:[UIImage imageNamed:@"shandian1"] forState:UIControlStateNormal];
    [self addSubview:flashBtn];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}



@end
