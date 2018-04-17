//
//  ViewController.m
//  WEShow
//
//  Created by ZDB on 2018/2/27.
//  Copyright © 2018年 we. All rights reserved.
//

#import "ViewController.h"
#import <AlivcLivePusher/AlivcLivePusherHeader.h>
#import <AliyunPlayerSDK/AliyunPlayerSDK.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
@interface ViewController ()<AlivcLivePusherErrorDelegate,AlivcLivePusherInfoDelegate,AlivcLivePusherNetworkDelegate,AliyunVodPlayerDelegate>

@property (nonatomic ,strong) AlivcLivePushConfig *config;
@property (nonatomic ,strong) AlivcLivePusher *livePusher;
@property (nonatomic ,strong) AliyunVodPlayer *aliPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPushConfig];
    [self initLivePusher];
    [self initAliPlayer];
    
//    [self aliPlayerPlay];//播放
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - 推流
//设置推流参数配置
- (void)initPushConfig
{
    AlivcLivePushConfig *config = [[AlivcLivePushConfig alloc] init];
    config.fps = AlivcLivePushFPS20;
    config.qualityMode = AlivcLivePushQualityModeResolutionFirst;
    config.enableAutoBitrate = true;
    config.enableAutoResolution = true;
    config.videoEncodeGop = AlivcLivePushVideoEncodeGOP_2;
    config.connectRetryInterval = 2000;
    config.previewMirror = false;
    //    config.beautyOn = false;
    //    config.beautyMode = AlivcLivePushBeautyModeProfessional;
    config.orientation = AlivcLivePushOrientationLandscapeLeft;
    config.externMainStream = true; // 打开外部主流
    self.config = config;
}

//初始化推流类
- (void)initLivePusher
{
    self.livePusher = [[AlivcLivePusher alloc] initWithConfig:_config];
    [self.livePusher setInfoDelegate:self];
    [self.livePusher setErrorDelegate:self];
    [self.livePusher setNetworkDelegate:self];
    [self.livePusher startPreview:self.view];
}

#pragma mark - AlivcLivePusherInfoDelegate
- (void)onPreviewStarted:(AlivcLivePusher *)pusher
{
    //通过 “api.we.show/live/getMyStreamUrl?token=” 获取推流地址
    [self.livePusher startPushWithURLAsync:@"填入获取的推流地址"];
}

#pragma mark - AlivcLivePusherErrorDelegate
- (void)onSDKError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error
{
    [self.livePusher restartPush];
}

- (void)onSystemError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error
{
    [self.livePusher restartPush];
}

#pragma mark - AlivcLivePusherNetworkDelegate
/**
 网络差回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onNetworkPoor:(AlivcLivePusher *)pusher
{
    
}


/**
 推流链接失败
 
 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onConnectFail:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error
{
    
}


/**
 网络恢复
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onConnectRecovery:(AlivcLivePusher *)pusher
{
    
}


/**
 重连开始回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onReconnectStart:(AlivcLivePusher *)pusher
{
    
}


/**
 重连成功回调
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onReconnectSuccess:(AlivcLivePusher *)pusher
{
//    [self.livePusher reconnectPushAsync];
}


/**
 重连失败回调
 
 @param pusher 推流AlivcLivePusher
 @param error error
 */
- (void)onReconnectError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error
{
    
}


/**
 发送数据超时
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onSendDataTimeout:(AlivcLivePusher *)pusher
{
    
}


/**
 推流URL的鉴权时长即将过期(将在过期前1min内发送此回调)
 
 @param pusher 推流AlivcLivePusher
 @return 新的推流URL
 */
- (NSString *)onPushURLAuthenticationOverdue:(AlivcLivePusher *)pusher
{
    //通过 “api.we.show/live/getMyStreamUrl?token=” 重新获取推流地址
    NSString *pusherUrl = @"";
    return pusherUrl;
}


/**
 发送SEI Message 通知
 
 @param pusher 推流AlivcLivePusher
 */
- (void)onSendSeiMessage:(AlivcLivePusher *)pusher
{
    
}


#pragma mark - 播放器
- (void)initAliPlayer
{
    //创建播放器对象，可以创建多个示例
    AliyunVodPlayer *aliPlayer = [[AliyunVodPlayer alloc] init];
    //设置播放器代理
    aliPlayer.delegate = self;
    //获取播放器视图
    UIView *playerView = aliPlayer.playerView;
    playerView.frame = [UIScreen mainScreen].bounds;
    //添加播放器视图到需要展示的界面上
    [self.view addSubview:playerView];
    self.aliPlayer = aliPlayer;
}

- (void)aliPlayerPlay{
    
    //通过 “api.we.show/live/getStreamUrl?roomId=\” 获取拉流地址
    NSURL *strUrl = [NSURL URLWithString:@""];
    NSURL *url = strUrl;
    [self.aliPlayer prepareWithURL:url];
    
    
    //开始播放
    [self.aliPlayer start];
//    //停止播放，在开始播放之后调用
//    [self.aliPlayer stop];
//    //暂停播放
//    [self.aliPlayer pause];
//    //恢复播放，在调用暂停播放之后调用
//    [self.aliPlayer resume];
}


#pragma mark AliyunVodPlayerDelegate
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event
{
    //这里监控播放事件回调
    //主要事件如下：  
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            //播放准备完成时触发
            break;
        case AliyunVodPlayerEventPlay:
            //暂停后恢复播放时触发
            break; 
        case AliyunVodPlayerEventFirstFrame:
            //播放视频首帧显示出来时触发
            break; 
        case AliyunVodPlayerEventPause:
            //视频暂停时触发
            break; 
        case AliyunVodPlayerEventStop:
            //主动使用stop接口时触发
            break;
        case AliyunVodPlayerEventFinish:
            //视频正常播放完成时触发
            break; 
        case AliyunVodPlayerEventBeginLoading:
            //视频开始载入时触发
            break; 
        case AliyunVodPlayerEventEndLoading:
            //视频加载完成时触发
            break; 
        case AliyunVodPlayerEventSeekDone:
            //视频Seek完成时触发
            break;
        default:
            break;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(ALPlayerVideoErrorModel *)errorModel
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
