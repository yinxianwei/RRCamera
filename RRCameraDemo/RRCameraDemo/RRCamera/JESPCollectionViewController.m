//
//  JESPCollectionViewController.m
//  RRCameraDemo
//
//  Created by 尹现伟 on 15/6/8.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

#import "JESPCollectionViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLImageCrop.h"

@interface JESPCollectionViewController ()<UICollectionViewDelegateFlowLayout,RRCameraDelegate,MLImageCropDelegate>


@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) RRCamera *camera;

@end

@implementation JESPCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    
    [self getAllPhotos:^(NSArray *array) {
        self.photoArray = [NSMutableArray arrayWithArray:array];
        
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)initSubViews{
    [self.collectionView registerClass:[JEPhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(disMiss)];
    
    if (self.title.length == 0) {
        self.title = @"选择照片";
    }
}

- (void)disMiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (RRCamera *)camera{
    if (_camera == nil) {
        _camera = [[RRCamera alloc] init];
        UIView *customUI = [[JECustomView alloc] initWithFrame:self.view.frame];
        self.camera.customView = customUI;
        self.camera.delegate = self;
        CGFloat w = self.view.frame.size.width;
        if (self.sizeCropPicture.height == 0) {
            self.sizeCropPicture = CGSizeMake(w, w);
        }
//        self.camera.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        self.camera.sizeCropPicture = self.sizeCropPicture;
    }
    return _camera;
}
- (void)take{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self presentViewController:self.camera animated:YES completion:^{
        
    }];
}


#pragma mark - MLImageCropDelegate

- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage{
    //裁剪
    [self dismissViewControllerAnimated:YES completion:nil];

    if ([self.delegate respondsToSelector:@selector(chooseAPicture:)]) {
        [self.delegate chooseAPicture:cropImage];
    }
}

#pragma mark - RRCameraDelegate
- (void) cameraCanceled{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [self.camera dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) takePictureDone:(UIImage *)image{
    
    //dismiss
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];

    imageView.image = [self.camera.view JESPSnapshotImage];
    [self.navigationController setNavigationBarHidden:true animated:NO];
    [self.view addSubview:imageView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

    [self.camera dismissViewControllerAnimated:NO completion:^{

    }];
    if ([self.delegate respondsToSelector:@selector(chooseAPicture:)]) {
        [self.delegate chooseAPicture:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photoArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JEPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        cell.imageView.image = [UIImage imageNamed:JESPC_CAMERAIMAGE];
    }
    else{
        ALAsset *result = self.photoArray[indexPath.row-1];
        cell.imageView.image = [UIImage imageWithCGImage:result.thumbnail];
    }
    
    cell.imageView.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self take];
    }else{
        ALAsset *result = self.photoArray[indexPath.row-1];
        UIImage *image = [UIImage imageWithCGImage:result.defaultRepresentation.fullScreenImage];
        
        MLImageCrop *imageCrop = [MLImageCrop new];
        imageCrop.delegate = self;
        
        if (self.sizeCropPicture.width == 0) {
            self.sizeCropPicture = CGSizeMake(600.0, 600.0);
        }
        
        imageCrop.ratioOfWidthAndHeight = self.sizeCropPicture.width/self.sizeCropPicture.height;
        imageCrop.image = image;
        [imageCrop showWithAnimation:YES];

    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.frame.size.width - 10) / 3, (self.view.frame.size.width - 10) / 3);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (ALAssetsLibrary *)assetsLibrary{
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc]init];
    }
    return _assetsLibrary;
}
typedef void (^errorBlock)(NSError *error);
typedef void (^successfulBlock)(NSArray *array);

- (void)getAllPhotos:(successfulBlock)successful failure:(errorBlock)failure{
    NSMutableArray *ary = [NSMutableArray new];
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != NULL) {
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
//                        result.defaultRepresentation.fullScreenImage//图片的大图
//                        NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                        
//                           NSRange range1=[urlstr rangeOfString:@"id="];
//                           NSString *resultName=[urlstr substringFromIndex:range1.location+3];
//                           resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                        [ary addObject:result];

                    }
                }
            }];
        }
        else{
            successful([ary reverseObjectEnumerator].allObjects);
        }
        
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
    
}


@end

    


@implementation JEPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.imageView];

    }
    
    return self;
}

@end


@implementation UIView (snapshot)

- (UIImage *)JESPSnapshotImage{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
