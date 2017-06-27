//
//  VideoViewController.m
//  VideoAndPic
//
//  Created by miss on 2017/6/21.
//  Copyright © 2017年 mukr. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PATH [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()]
#define PATH_VIDEOS [PATH stringByAppendingString:@"videosArray.plist"]
#define PATH_VIDEOS_LENGTH [PATH stringByAppendingString:@"videosLengthArray.plist"]
#define PATH_VIDEO_SCREENSHOTS [PATH stringByAppendingString:@"screenshotImageArray.plsit"]

#import "VideoViewController.h"
#import "AJPhotoPickerViewController.h"
#import "VideoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "MSAlert.h"
#import "MSPlayer.h"
#import "GTMBase64.h"

@interface VideoViewController ()<AJPhotoPickerProtocol,UITableViewDelegate,UITableViewDataSource,VLCMediaThumbnailerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videosArray;
@property (nonatomic, strong) NSMutableArray *screenshotImageArray;
@property (nonatomic, strong) NSMutableArray *videoLengthArray;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDataSource];   
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 105;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)setDataSource {
    self.videosArray = [self getVideos];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:PATH_VIDEOS];
    if ([array isEqual:self.videosArray]) {
        self.videoLengthArray = [NSMutableArray arrayWithContentsOfFile:PATH_VIDEOS_LENGTH];
        NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:PATH_VIDEO_SCREENSHOTS];
        self.screenshotImageArray = [[NSMutableArray alloc]init];
        for (NSString *imageString in tempArray) {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image = [UIImage imageWithData:data];
            [self.screenshotImageArray addObject:image];
        }
    }else {
        self.screenshotImageArray = [[NSMutableArray alloc]init];
        self.videoLengthArray = [[NSMutableArray alloc]init];
        [self getImage];
    }
    [self.videosArray writeToFile:PATH_VIDEOS atomically:NO];
}

- (NSMutableArray *)getVideos{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:PATH error:nil];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSString *name in array) {
        if ([name hasSuffix:@".wmv"]||[name hasSuffix:@".avi"]||[name hasSuffix:@".mkv"]||[name hasSuffix:@".rmvb"]||[name hasSuffix:@".rm"]||[name hasSuffix:@".xvid"]||[name hasSuffix:@".mp4"]||[name hasSuffix:@".3gp"]||[name hasSuffix:@".mpg"]||[name hasSuffix:@".flv"]||[name hasSuffix:@".mpeg"]||[name hasSuffix:@".mov"]) {
            NSString *videoSize = [self getVideoSize:[PATH stringByAppendingString:name]];
            NSDictionary *dic = @{@"videoName":name,
                                  @"videoSize":videoSize};
            [tempArray addObject:dic];
        }
    }
    return tempArray;
}

- (NSString *)getVideoSize:(NSString *)path {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        unsigned long long size = [[manager attributesOfItemAtPath:path error:nil] fileSize];
        CGFloat sizeM = size/1024/1024;
        if (sizeM > 1024) {
            return [NSString stringWithFormat:@"%.2fG",sizeM/1024];
        }else {
            return [NSString stringWithFormat:@"%.2fM",sizeM];
        }
    }
    return @"0M";
}

- (void)getImage {
    static NSInteger i = 0;
    if (i >= self.videosArray.count) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.videoLengthArray writeToFile:PATH_VIDEOS_LENGTH atomically:NO];
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            for (UIImage *image in self.screenshotImageArray) {
                NSData *data = UIImageJPEGRepresentation(image, 1);
                NSString *imageString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                [tempArray addObject:imageString];
            }
            [tempArray writeToFile:PATH_VIDEO_SCREENSHOTS atomically:NO];
            
        });
        return;
    }
    NSString *path = [PATH stringByAppendingString:[self.videosArray[i] objectForKey:@"videoName"]];
    [self getVideoScreenShot:path];
    i++;
}

- (void)getVideoScreenShot:(NSString *)path {
    VLCMedia *media = [VLCMedia mediaWithPath:path];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * videoTime = media.length.stringValue;
        [self.videoLengthArray addObject:videoTime];
        [self.tableView reloadData];
    });
   
    VLCMediaThumbnailer *thumbnailer = [VLCMediaThumbnailer thumbnailerWithMedia:media andDelegate:self];
    //开始获取缩略图
    [thumbnailer fetchThumbnail];
}

//获取缩略图超时
- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    NSLog(@"getThumbnailer time out.");
}
//获取缩略图成功
- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    //获取缩略图
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    [self.screenshotImageArray addObject:image];
    [self.tableView reloadData];
    [self getImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.videoTitleLabel.text = [self.videosArray[indexPath.row] objectForKey:@"videoName"];
    cell.videoSizeLabel.text = [self.videosArray[indexPath.row] objectForKey:@"videoSize"];
    if (self.screenshotImageArray.count > indexPath.row) {
        cell.videoScreenshotImageView.image = self.screenshotImageArray[indexPath.row];
    }
    if (self.videoLengthArray.count > indexPath.row) {
        cell.videoLengthLabel.text = self.videoLengthArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MSPlayer *player = [[MSPlayer alloc]init];
    player.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9);
    player.center = self.view.center;
    player.mediaURL = [NSURL fileURLWithPath:[PATH stringByAppendingString:[self.videosArray[indexPath.row] objectForKey:@"videoName"]]];
    [player showInView:self.view.window];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *path = [PATH stringByAppendingString:[self.videosArray[indexPath.row] objectForKey:@"videoName"]];
    [MSAlert showAlertWithTitle:@"确定要删除这个视频吗？" message:nil confirmButtonAction:^{
        [self.videosArray removeObjectAtIndex:indexPath.row];
        if (self.screenshotImageArray.count-1 >= indexPath.row) {
            [self.screenshotImageArray removeObjectAtIndex:indexPath.row];
             [self.videoLengthArray removeObjectAtIndex:indexPath.row];
        }
       
        [self.tableView reloadData];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSFileManager *manager = [NSFileManager defaultManager];
            if ([manager fileExistsAtPath:path]) {
                [manager removeItemAtPath:path error:nil];
            }
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
