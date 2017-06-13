//
//  ViewController.m
//  VideoAndPic
//
//  Created by miss on 17/3/16.
//  Copyright © 2017年 mukr. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"
#import "HUPhotoBrowser.h"
#import "CollectionViewLayout.h"
#import "AJPhotoPickerViewController.h"
#import "MBProgressHUD.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PATH [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()]

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate,AJPhotoPickerProtocol>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *heightArray;
@property (assign, nonatomic) NSInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _array = [NSMutableArray arrayWithContentsOfFile:[PATH stringByAppendingString:@"array.plist"]];
        if (!_array) {
            _array = [[NSMutableArray alloc]init];
            [_array addObjectsFromArray:[self getImagesDataSource]];
            [self saveArray];
        }
        [self setImageArrayAndHeightArray];
    });
    
    _imageArray = [[NSMutableArray alloc]init];
    _collectionView.collectionViewLayout = [self layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
}

- (void)showHUD{
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
}

- (void)hideHUD{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
}

- (UICollectionViewLayout *)layout{
    CollectionViewLayout *layout = [[CollectionViewLayout alloc] initWithItemsHeightBlock:^CGFloat(NSIndexPath *indexPath) {
            return [self.heightArray[indexPath.item]floatValue];
        }];
    
    return layout;
}


- (void)setImageArrayAndHeightArray{
    _imageArray = [[NSMutableArray alloc]init];
    _heightArray = [[NSMutableArray alloc]init];
    for (NSString *name in _array) {
        UIImage *image = [UIImage imageWithContentsOfFile:[PATH stringByAppendingString:name]];
        CGFloat height = (SCREEN_WIDTH-2)/3*image.size.height/image.size.width;
        [_heightArray addObject:@(height)];
        [_imageArray addObject:image];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_collectionView reloadData];
        [_activityIndicatorView stopAnimating];
    });

}

- (NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *date = [NSDate date];
    return [formatter stringFromDate:date];
}

- (IBAction)addImageFromPhoto:(id)sender {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.maximumNumberOfSelection = 100;
    picker.multipleSelection = YES;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:nil];
    for (NSInteger i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        if (!imageData){
            imageData = UIImagePNGRepresentation(image);
        }
    
        NSString *path = [PATH stringByAppendingString:[NSString stringWithFormat:@"%@%@",[self dateString],[NSString stringWithFormat:@"%ld.png",i]]];
        [imageData writeToFile:path atomically:NO];
    }
  
    [_array removeAllObjects];
    [_array addObjectsFromArray:[self getImagesDataSource]];
    [self saveArray];
    
    [self setImageArrayAndHeightArray];
    [_collectionView reloadData];
}

- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker{

}

- (IBAction)refreshDataSource:(id)sender {
    [_array removeAllObjects];
    [_array addObjectsFromArray:[self getImagesDataSource]];
    [self saveArray];
    [self setImageArrayAndHeightArray];
    [_collectionView reloadData];
   
}

- (NSMutableArray *)getImagesDataSource{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:PATH error:nil];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSString *name in array) {
        if ([name hasSuffix:@".jpg"]||[name hasSuffix:@".png"]||[name hasSuffix:@".jpeg"]||[name hasSuffix:@".bmp"]) {
            [tempArray addObject:name];
        }
    }
    return tempArray;
}

- (void)saveArray{
    [_array writeToFile:[PATH stringByAppendingString:@"array.plist"] atomically:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImage *image = _imageArray[indexPath.item];
    cell.cellImageView.image = image;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPress];
    return cell;
}

- (void)longPress:(UIGestureRecognizer *)lpGR {
    if (lpGR.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [lpGR locationInView:self.collectionView];
        NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:point];
        _index = index.item;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除这张图片？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *path = [PATH stringByAppendingString:_array[_index]];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        [_array removeObjectAtIndex:_index];
        [_imageArray removeObjectAtIndex:_index];
        [_heightArray removeObjectAtIndex:_index];
        [self saveArray];
        [_collectionView reloadData];
        
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [HUPhotoBrowser showFromImageView:cell.cellImageView withImages:self.imageArray atIndex:indexPath.item];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
