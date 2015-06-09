//
//  JESPCollectionViewController.h
//  RRCameraDemo
//
//  Created by 尹现伟 on 15/6/8.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRCamera.h"

#define JESPC_CAMERAIMAGE @"LLReviewCamera"



@protocol JESPCollectionViewControllerDelegate <NSObject>

@optional
- (void)chooseAPicture:(UIImage *)image;


@end



@interface JESPCollectionViewController : UICollectionViewController

@property (nonatomic, assign) CGSize sizeCropPicture;

@property (nonatomic, assign) id<JESPCollectionViewControllerDelegate> delegate;

@end





@interface JEPhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@end


@interface UIView (snapshot)


- (UIImage *)JESPSnapshotImage;

@end

