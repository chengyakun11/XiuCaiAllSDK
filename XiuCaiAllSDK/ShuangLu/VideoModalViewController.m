
#import "VideoModalViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AnyChatDefine.h"
#import "AnyChatPlatform.h"
#import "AnyChatErrorCode.h"
#import "AnyChatObjectDefine.h"
//#import "XYZQOpenCert.h"
#import "XYZQPermissionUtil.h"
#import "UIImage+OpenExtension.h"
//#import "SVProgressHUD.h"
//#import <apexsoftiOSBaseLib/SVProgressHUD.h>
//#import "DataCollector.h"
//#import "AppDelegate.h"
#define  kFirstLineWaitTimeCnt  120
#define OpenOBJWidth(obj)  obj.frame.size.width
#define OpenOBJHeight(obj) obj.frame.size.height
#define OpenOBJOriginX(obj) obj.frame.origin.x
#define OpenOBJOriginY(obj) obj.frame.origin.y
#define OpenOBJMAXY(obj) CGRectGetMaxY(obj.frame)
#define OpenOBJMAXX(obj) CGRectGetMaxX(obj.frame)
#define OpenOBJMINY(obj) CGRectGetMinY(obj.frame)
#define OpenOBJMINX(obj) CGRectGetMinX(obj.frame)
#define kScreenWidth        [UIApplication sharedApplication].keyWindow.bounds.size.width
#define kScreenHeight       [UIApplication sharedApplication].keyWindow.bounds.size.height
#define UmeWidth(width) kScreenWidth*(width/375.0)
#define UmeHeight(height) (kScreenHeight<=568?(floor((height)*568/667)):floor((height)*MIN(kScreenHeight, 736)/667))
#define kStatusBarHeight        ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kNavBarHeight           44

#define kNavTopHeight           (kNavBarHeight+kStatusBarHeight)

#define kWebviewHeight (kScreenHeight-kStatusBarHeight)
@interface VideoModalViewController ()<AnyChatNotifyMessageDelegate, AnyChatTextMsgDelegate,UIScrollViewDelegate>{
    BOOL bConnect;
    BOOL bCallStarted;
    BOOL isExit;
    BOOL isMeSmallScreen;
    int remoteId;
    int userID;
    BOOL localLessRemote;
    BOOL hasAlertOnce;
    BOOL navigationBarHideFlag;
    BOOL navigationBarHideFlagPre;
    CGRect smallFrame;
    CGRect largeFrame;
    CGPoint smallFrameCenter;
    CGPoint largeFrameCenter;
    AVCaptureVideoPreviewLayer *localVideoSurface;
    AnyChatPlatform *anychat;
}

@property (weak, nonatomic)  UIView *selfVideoView;
@property (strong, nonatomic)  UIView *otherVideoView;
@property (weak, nonatomic)  UIImageView *remoteVideoImageView;
@property (weak, nonatomic)  UILabel *statusLabel;
@property (weak, nonatomic)  UIView *selfImageView;
@property (weak, nonatomic)  UIButton *switchButton;
@property (weak, nonatomic)  UIScrollView *statusScrollView;
@property (strong, nonatomic)  UIView *tipTextView;
@property (weak, nonatomic)  UIImageView *avatarFrameImageView;

@property(nonatomic,strong)NSTimer *statusLabelLoopTimer;
@property(nonatomic,assign)CGFloat statusScrollViewContentOffsetY;


@property(nonatomic,assign)NSInteger firstLineWaitTimeCnt;//首行等待

typedef NS_ENUM(NSInteger, TDTYPE) {
    VIDEO_WAIT_TYPE = 0,
    VIDEO_VERIFY_TYPE
};

@end

@implementation VideoModalViewController
- (void)stopVideo {
    NSLog(@"stopVideo");
    [self stopVideoChat:NO failReasonRemark:@"stopVideo"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [DWJQDialogHelper showProgressHUD:nil];
//    [SVProgressHUD show];
    // Do any additional setup after loading the view from its nib.
     self.edgesForExtendedLayout =UIRectEdgeNone;
    //权限判断
    if(![self checkVideoPerssion])
        return;
    navigationBarHideFlagPre = self.navigationController.navigationBar.hidden;
    [self setupUI];
    [self initAnyChat];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnyChatNotifyHandler:) name:@"ANYCHATNOTIFY" object:nil];
    [self connectToServer];
}
- (BOOL)checkVideoPerssion{
    XYZQPermissionUtil * permission = [[XYZQPermissionUtil alloc]init];
    if(![permission PermissionCamera:true])
    {
        return NO;
    }
    else
    {
        if(![permission PermissionMicrophone:true])
        {
            return NO;
        }
    }
     return YES;
}

-(void)viewDidLayoutSubviews{
  
    _statusScrollView.contentOffset = CGPointZero;
    _statusScrollView.showsHorizontalScrollIndicator = NO;
    
    smallFrame = self.remoteVideoImageView.frame;
    smallFrameCenter = self.remoteVideoImageView.center;
    
    largeFrame = self.selfImageView.frame;
    largeFrameCenter = self.selfImageView.center;
    
    NSLog(@"xyzqanychat small frame: %@,small frame center: %@, large frame: %@,large frame center: %@",NSStringFromCGRect(smallFrame), NSStringFromCGPoint(smallFrameCenter), NSStringFromCGRect(largeFrame), NSStringFromCGPoint(largeFrameCenter));
  
}
//
//
//
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

//
//
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    navigationBarHideFlag =  YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
//
//
//
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
//
//
//
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    isExit = YES;
    [self stopVideoChat:NO failReasonRemark:nil];
    [self.navigationController setNavigationBarHidden:navigationBarHideFlagPre];
    
}

#pragma mark - UI

- (void)setupUI{
//    kStatusBarHeight
    
//    self.params
//    headerHeight = "0.07099999999999999";
//    localVideoHeight = "0.618";
//    remoteVideoHeight = "0.185";
//    remoteVideoWidth = "0.3";
//    remoteVideoX = "0.7";
//    remoteVideoY = "0.503";
    
    NSLog(@"self.params %@",self.params);
   
    float selfVideoViewPaddingH = kWebviewHeight * [[self.params objectForKey:@"headerHeight"] floatValue] + kStatusBarHeight;
    float localVideoHeight = kWebviewHeight * [[self.params objectForKey:@"localVideoHeight"] floatValue];
    
    NSLog(@"selfVideoViewPaddingH %f",selfVideoViewPaddingH);
    NSLog(@"localVideoHeight %f",localVideoHeight);
    
    
    self.title =  @"开始视频";
 //   [self initNavBar];
//    UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight/2, kScreenWidth, kScreenHeight/2)];
//    clearView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
//    [self.view addSubview:clearView];
    isExit = NO;
    UIView *selfVideoView = [[UIView alloc]initWithFrame:CGRectMake(0, selfVideoViewPaddingH, kScreenWidth, localVideoHeight)];
    [self.view addSubview:selfVideoView];
    self.selfVideoView = selfVideoView;
    self.selfVideoView.backgroundColor = [UIColor redColor];
    
    UIView *selfImageView = [[UIView alloc]initWithFrame:selfVideoView.bounds];
    [self.selfVideoView addSubview:selfImageView];
    self.selfImageView = selfImageView;
    self.selfImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.selfImageView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:selfVideoView.bounds];
    lineView.backgroundColor = [UIColor clearColor];
       
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"PureCamera" ofType:@"bundle"]];
    lineView.image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"splz_kuan_pic_show" ofType:@"png"]];
    lineView.contentMode = UIViewContentModeScaleToFill;
    [self.selfVideoView addSubview:lineView];
    
    [self.view addSubview:self.otherVideoView];
//    [self.selfVideoView addSubview:self.tipTextView];
    
    CGFloat personHeight  = 26.0/25*OpenOBJWidth(self.selfVideoView);
    UIImageView *avatarFrameImageView = [[ UIImageView alloc]initWithFrame:CGRectMake(0, UmeHeight(110), OpenOBJWidth(self.selfVideoView), personHeight)];
    [self.selfVideoView addSubview:avatarFrameImageView];
    self.avatarFrameImageView = avatarFrameImageView;
    self.avatarFrameImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarFrameImageView setImage:[UIImage openImageName:@"XYZQOpen_pic_person"]];
    
    UIButton *switchButton = [[UIButton alloc]initWithFrame:CGRectMake(OpenOBJWidth(self.selfVideoView) - UmeWidth(57), OpenOBJMINY(self.tipTextView)-UmeHeight(39), UmeWidth(41), UmeHeight(41))];
//    [self.selfVideoView addSubview:switchButton];
    
    self.switchButton = switchButton;
    
    UIImage *image = [UIImage imageNamed:@"swapButton" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.switchButton setImage:image forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(swtichButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    _statusLabelLoopTimer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(goLoop) userInfo:nil repeats:YES];
  
    _statusScrollView.bounces = NO;
    _statusScrollView.delegate = self;
     [_statusLabelLoopTimer setFireDate:[NSDate distantFuture]];
  //  _statuLabelWidth.constant = ScreenWidth - 60-20;


    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchLocalWithRemoteAction)];
    UITapGestureRecognizer *showNaviBarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAndDissNaviBarAction)];
    
//    self.selfImageView.userInteractionEnabled = YES;
//    self.remoteVideoImageView.userInteractionEnabled = YES;
    [self.selfImageView setUserInteractionEnabled:YES];
    
//    [self.selfImageView addGestureRecognizer:tap];
    [self.selfImageView addGestureRecognizer:showNaviBarTap];
//    [self.remoteVideoImageView addGestureRecognizer:tap];
}
//
//
//
- (void)initNavBar
{
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, kBarButtonWidth, kBarButtonHeight);
//    [backBtn setImage: [ENOTheme imageWithImageType:ENOImageTypeHeaderBackBtn] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    objc_setAssociatedObject(self, &backBtnKey, backBtn, OBJC_ASSOCIATION_RETAIN);
//
//    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UmeWidth(258), kNavBarHeight)];
//    titleView.backgroundColor = [UIColor clearColor];
//    titleView.font = [UIFont systemFontOfSize:18.0f];
//    titleView.textColor = [ENOTheme colorWithColorType:ENOColorTypeHeaderFont];
//    titleView.textAlignment = NSTextAlignmentCenter;
//    titleView.text = self.title;
//    titleView.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.navigationItem.titleView = titleView;
//    objc_setAssociatedObject(self, &titleViewKey, titleView, OBJC_ASSOCIATION_RETAIN);
}



//
//
//
-(UIView*)tipTextView{
    if(_tipTextView==nil){
        _tipTextView = [[UIView alloc]initWithFrame:CGRectMake(0, OpenOBJHeight(self.selfVideoView)-UmeHeight(64), OpenOBJWidth(self.selfVideoView), UmeHeight(64))];
        _tipTextView.backgroundColor = [UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1];
        UIScrollView *statusScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(UmeWidth(10), UmeHeight(8), OpenOBJWidth(_tipTextView), OpenOBJHeight(_tipTextView)-UmeHeight(16))];
        [_tipTextView addSubview:statusScrollView];
        self.statusScrollView = statusScrollView;
        
        
        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(UmeWidth(30), 0, OpenOBJWidth(self.statusScrollView)-UmeWidth(60), OpenOBJHeight(self.statusScrollView))];
        [self.statusScrollView addSubview:statusLabel];
        self.statusLabel = statusLabel;
        
        self.statusLabel.font = [UIFont systemFontOfSize:15];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.textAlignment = NSTextAlignmentLeft;
        self.statusLabel.text = @"视频验证开始了，请不要随意挂断或切换界面。";
        self.statusLabel.numberOfLines = 0;
    }
    return _tipTextView;
}
//
//
//
-(UIView*)otherVideoView{
        if(_otherVideoView==nil){
            float remoteVideoHeight = kWebviewHeight * [[self.params objectForKey:@"remoteVideoHeight"] floatValue];
            float remoteVideoWidth = kScreenWidth * [[self.params objectForKey:@"remoteVideoWidth"] floatValue];
            
            float remoteVideoX = kScreenWidth * [[self.params objectForKey:@"remoteVideoX"] floatValue];
            float remoteVideoY = kWebviewHeight * [[self.params objectForKey:@"remoteVideoY"] floatValue] + kStatusBarHeight;
            
            NSLog(@"remoteVideoHeight %f",remoteVideoHeight);
            NSLog(@"remoteVideoWidth %f",remoteVideoWidth);
            
             NSLog(@"remoteVideoX %f",remoteVideoX);
             NSLog(@"remoteVideoY %f",remoteVideoY);
            
//            _otherVideoView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-UmeWidth(100), kScreenHeight/2-UmeHeight(140), UmeWidth(100), UmeHeight(140))];
            _otherVideoView = [[UIView alloc]initWithFrame:CGRectMake(remoteVideoX, remoteVideoY,remoteVideoWidth, remoteVideoHeight)];
            
            UIImageView *remoteVideoImageView = [[ UIImageView alloc]initWithFrame:_otherVideoView.bounds];
            [_otherVideoView addSubview:remoteVideoImageView];
            self.remoteVideoImageView = remoteVideoImageView;
            self.remoteVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.remoteVideoImageView.clipsToBounds = YES;
            self.remoteVideoImageView.backgroundColor = [UIColor clearColor];
           _otherVideoView.backgroundColor = [UIColor whiteColor];
        }
        return _otherVideoView;
    return nil;
}




-(void)goLoop{
    
    if(self.firstLineWaitTimeCnt){
        if(self.firstLineWaitTimeCnt > kFirstLineWaitTimeCnt)return;
        self.firstLineWaitTimeCnt--;
        return;
    }
    
    CGFloat  contentHeight = self.statusScrollView.contentSize.height;
    CGFloat  scrollViewHeight = self.statusScrollView.frame.size.height;
    CGFloat  contentOffsetY = _statusScrollViewContentOffsetY;
    if((contentOffsetY + scrollViewHeight)>=contentHeight){
        if((contentOffsetY + scrollViewHeight)==contentHeight){
           self.firstLineWaitTimeCnt = kFirstLineWaitTimeCnt;
            _statusScrollViewContentOffsetY =  _statusScrollView.contentOffset.y + 0.5;//
        }
        if(self.firstLineWaitTimeCnt==0){
           [_statusScrollView setContentOffset:CGPointZero];
            self.firstLineWaitTimeCnt = kFirstLineWaitTimeCnt +1;
 
        }
        return;
       
    }
     _statusScrollViewContentOffsetY =  _statusScrollView.contentOffset.y + 0.5;//


    if(_statusScrollViewContentOffsetY>_statusScrollView.contentSize.height){
        _statusScrollViewContentOffsetY = 0;
        self.firstLineWaitTimeCnt = kFirstLineWaitTimeCnt;
    }
    _statusScrollView.contentOffset = CGPointMake(0,_statusScrollViewContentOffsetY );

}

- (void)dealloc
{
    //  退出anychat，释放资源
    anychat.notifyMsgDelegate = nil;
    anychat.textMsgDelegate =nil;
   dispatch_async(dispatch_get_global_queue(0, 0), ^{ // anychat建议放后台执行，不要放主线程
       [AnyChatPlatform Release];
   });
  
    
    NSLog(@"xyzqanychat startVideo dealloc");
}
#pragma mark - Action
//
//
//
- (void)back:(id)sender{
    NSLog(@"xyzqanychat 用户退出");
//    @weakify(self);
//    [self alertWithMessage:@"正在进行视频认证，是否确定要退出？" cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(XYZQOpenUIAlertView *alert, NSInteger buttonIndex) {
//        @strongify(self);
//        if(buttonIndex==1){
            [self stopVideoChat:NO failReasonRemark:@"9999"];// 用户退出视频传9999作为代号

//        }
//    }];
    
   
}


//
- (void)initAnyChat{

    [self performSelector:@selector(exceptionPop) withObject:nil afterDelay:15];
    
    [AnyChatPlatform InitSDK:0];
    anychat = [[AnyChatPlatform alloc]init];
    
    anychat.notifyMsgDelegate = self;
    anychat.textMsgDelegate = self;

    NSLog(@"xyzqanychat InitAnyChat: " );
}

- (IBAction)swtichButtonAction:(id)sender {
    static int CurrentCameraDevice = 1;
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if(cameraDeviceArray.count == 2)
    {
        CurrentCameraDevice = (CurrentCameraDevice+1) % 2;
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:CurrentCameraDevice]];
    }
}

- (void)switchLocalWithRemoteAction{
    localLessRemote = !localLessRemote;
    if (localLessRemote) {

        self.remoteVideoImageView.frame = largeFrame;
        self.remoteVideoImageView.center = self.view.center;
    
        self.selfImageView.frame = smallFrame;
        self.selfImageView.center = smallFrameCenter;
    
        localVideoSurface.frame = self.selfImageView.bounds;
        localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
        [self.selfVideoView sendSubviewToBack:self.otherVideoView];
        self.avatarFrameImageView.hidden = YES;
    }
    
    if (!localLessRemote) {
    
        self.remoteVideoImageView.frame = smallFrame;
        self.remoteVideoImageView.center = smallFrameCenter;
    
        self.selfImageView.frame = largeFrame;
        self.selfImageView.center = self.view.center;
    
        localVideoSurface.frame = self.selfImageView.bounds;
        localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;

        [self.selfVideoView sendSubviewToBack:self.selfImageView];
        self.avatarFrameImageView.hidden = NO;
    }
}

- (void)showAndDissNaviBarAction{
    navigationBarHideFlag = !navigationBarHideFlag;
     CGRect switchFrame =   self.switchButton.frame;
    CGRect textViewFrame  = self.tipTextView.frame;
    if (navigationBarHideFlag) {
        switchFrame.origin.y =  switchFrame.origin.y + kNavTopHeight;
        textViewFrame.origin.y =  textViewFrame.origin.y +kNavTopHeight;
    }
   else {
        switchFrame.origin.y =  switchFrame.origin.y -kNavTopHeight;
        textViewFrame.origin.y =  textViewFrame.origin.y -kNavTopHeight;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.switchButton.frame = switchFrame;
        self.tipTextView.frame = textViewFrame;
        [self.navigationController setNavigationBarHidden:navigationBarHideFlag animated:NO];
    }];
   
    NSLog(@"xyzqanychat 显示Nav Bar: %s", navigationBarHideFlag ? "true" : "false");
}

- (void)connectToServer{

    NSLog(@"userVideoInfo:%@",self.userVideoInfo);
//    @property(nonatomic,strong)NSString *anyChatStreamIpOut; // anychat服务器地址
//    @property(nonatomic,strong)NSString *anyChatStreamPort; // anychat服务器端口
//    @property(nonatomic,strong)NSString *userName;          // anychat服务器用户登录名
//    @property(nonatomic,strong)NSString *loginPwd;          // anychat服务器用户登录密码
//    @property(nonatomic,strong)NSString *roomId;            // anychat服务器房间号
//    @property(nonatomic,strong)NSString *roomPwd;           // anychat服务器房间密码
//    @property(nonatomic,strong)NSString *empId;           //  服务器返回的坐席ID 需要加两千万
//    @property(nonatomic,strong)NSString *remoteId;
    
    NSLog(@"anyChatStreamIpOut:%@",self.userVideoInfo.anyChatStreamIpOut);
    NSLog(@"anyChatStreamPort:%@",self.userVideoInfo.anyChatStreamPort);
    NSLog(@"userName:%@",self.userVideoInfo.userName);
    NSLog(@"loginPwd:%@",self.userVideoInfo.loginPwd);
    NSLog(@"roomId:%@",self.userVideoInfo.roomId);
    NSLog(@"roomPwd:%@",self.userVideoInfo.roomPwd);
    NSLog(@"empId:%@",self.userVideoInfo.empId);
    NSLog(@"remoteId:%@",self.userVideoInfo.remoteId);
    
    int error = [AnyChatPlatform Connect:self.userVideoInfo.anyChatStreamIpOut :[self.userVideoInfo.anyChatStreamPort intValue]];

    NSLog(@"xyzqanychat Connect To Server: ip = %@, port = %d, Error = %d", self.userVideoInfo.anyChatStreamIpOut, [self.userVideoInfo.anyChatStreamPort intValue], error);
}

- (void)loginServer{
    int login = [AnyChatPlatform Login:self.userVideoInfo.userName :self.userVideoInfo.loginPwd];
    NSLog(@"xyzqanychat LoginServer: username = %@, loginPwd = %@, login = %d", self.userVideoInfo.userName, self.userVideoInfo.loginPwd, login);
    NSLog(@"xyzqanychat LoginServer: empId = %@", self.userVideoInfo.empId);
}

-(void)setRemoteVideo:(int) dwUserId{

    bCallStarted = YES;

    remoteId = dwUserId;
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_NETWORK_P2PPOLITIC : 0];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_APPLYPARAM :0];
    [self StartVideoChat:remoteId];
}

- (void) StartVideoChat:(int) userid
{
    NSLog(@"xyzqanychat StartVideoChat : userid = %d", userid);
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    userID = userid;
    //Get a camera, Must be in the real machine.
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if (cameraDeviceArray.count == 0) {
//        [self alertWithMessage:@"没有可用的摄像头！"];
        NSLog(@"没有可用的摄像头！");
        return;
    }
    
    if (cameraDeviceArray.count > 1) {
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:1]];
    } else {
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:0]];
    }
    
    // open local video
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_OVERLAY :1];
    [AnyChatPlatform UserSpeakControl: -1:YES];
    [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
    [AnyChatPlatform UserCameraControl:-1 : YES];

    // request other user video
    [AnyChatPlatform UserSpeakControl: userid:YES];
    [AnyChatPlatform SetVideoPos:userid: self.remoteVideoImageView:0:0:0:0];
    [AnyChatPlatform UserCameraControl:userid : YES];
    //远程视频显示时随设备的方向改变而旋转（参数为int型， 0表示关闭， 1 开启[默认]，视频旋转时需要参考本地视频设备方向参数）

    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_ORIENTATION : 0];
    
    if ([self.params objectForKey:@"VideoWidth"]){
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_WIDTHCTRL :[[self.params objectForKey:@"VideoWidth"] intValue]];
    }
    if ([self.params objectForKey:@"VideoHeight"]){
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_HEIGHTCTRL :[[self.params objectForKey:@"VideoHeight"] intValue]];
    }
    if ([self.params objectForKey:@"VideoFPS"]){
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_FPSCTRL :[[self.params objectForKey:@"VideoFPS"] intValue]];
    }
    if ([self.params objectForKey:@"VideoGOPSize"]){
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_GOPCTRL :[[self.params objectForKey:@"VideoGOPSize"] intValue]];
    }
    if ([self.params objectForKey:@"VideoBitrate"]){
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_BITRATECTRL :[[self.params objectForKey:@"VideoBitrate"] intValue]];
    }
    if ([self.params objectForKey:@"VideoQuality"]){
        [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_QUALITYCTRL :[[self.params objectForKey:@"VideoQuality"] intValue]];
    }
    
//    [[self.params objectForKey:@"headerHeight"] floatValue]
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_WIDTHCTRL : 320];
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_HEIGHTCTRL : 240];
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_FPSCTRL : 15];
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_GOPCTRL : 40];
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_BITRATECTRL : 60000];
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_QUALITYCTRL : 3];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(exceptionPop) object:nil];
    
    NSLog(@"xyzqanychat StartVideoChat");
}

- (void)stopVideoChat:(BOOL)isSuccess failReasonRemark:(NSString*)failReasonRemark{
//    [SVProgressHUD dismiss];
//    [DWJQDialogHelper dismissWaitHUD];
    NSLog(@"xyzqanychat stopVideoChat : isExit %d stopVideoChat%@",isExit,failReasonRemark);
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if(bCallStarted)
    {
        [self FinishVideoChat];
        remoteId = -1;
        
        if(!isExit)
        {
            [self startVideoCallBackM:isSuccess reason:failReasonRemark];
            isExit = YES;
        }
    }
    
    if(!bCallStarted){
        
        [self FinishVideoChat];
        remoteId = -1;
        bCallStarted = NO;
        
        //查询视频结果
        if (!isExit) {
            [self startVideoCallBackM:isSuccess reason:failReasonRemark];
            isExit = YES;
        }
    }
    
    if(bConnect)
    {
        [AnyChatPlatform LeaveRoom:-1];
        [AnyChatPlatform Logout];
        bConnect = NO;
        NSLog(@"xyzqanychat Logout Anychat Resource");
    }
}

- (void) FinishVideoChat
{
    NSLog(@"xyzqanychat --xie_log--关闭摄像头");
    //关闭本地音频，视频
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    //关闭远程音频，视频
    [AnyChatPlatform UserSpeakControl: remoteId : NO];
    [AnyChatPlatform UserCameraControl: remoteId : NO];
    remoteId = -1;


}

- (void)showConnectStatus:(NSString *)statusStr
{
    self.statusLabel.text = statusStr;
    [self.statusLabel setNeedsDisplay];

    if((statusStr ==nil) ||([statusStr isEqualToString:@""])){
        [_statusLabelLoopTimer setFireDate:[NSDate distantFuture]];
        }
    else{
        CGRect frame =  _statusLabel.frame;
        frame.size.height = 10000000;

        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.numberOfLines = 0;
        label.font = _statusLabel.font;
        label.text = statusStr;
        [label sizeToFit];
        [_statusScrollView setContentOffset:CGPointZero];
         self.statusScrollViewContentOffsetY = 0;
        if(label.frame.size.height>_statusScrollView.frame.size.height){
            self.firstLineWaitTimeCnt = kFirstLineWaitTimeCnt;
            self.statusLabel.frame = label.frame;
            [self.statusScrollView setContentSize:label.frame.size];
            [_statusLabelLoopTimer setFireDate:[NSDate distantPast]]; // 改成手动的，保留现有机制，防止回改
            //[_statusLabelLoopTimer setFireDate:[NSDate distantFuture]];
        }
        else{
              frame.size.height = _statusScrollView.frame.size.height;
            [self.statusLabel setFrame:frame];
             [self.statusScrollView setContentSize:CGSizeMake(_statusScrollView.frame.size.width, _statusScrollView.frame.size.height)];
            [_statusLabelLoopTimer setFireDate:[NSDate distantFuture]];
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([scrollView isEqual:self.statusScrollView]){
        self.firstLineWaitTimeCnt = kFirstLineWaitTimeCnt+1;
        _statusScrollViewContentOffsetY = _statusScrollView.contentOffset.y;
    }
   
}

- (void)AnyChatNotifyHandler:(NSNotification*)notify
{
    NSDictionary* dict = notify.userInfo;
    [anychat OnRecvAnyChatNotify:dict];
}


#pragma mark - Delegate
- (void) OnLocalVideoRelease:(id)sender
{
    if(localVideoSurface)
    {
        localVideoSurface = nil;
    }
}

- (void) OnLocalVideoInit:(id)session
{
    localVideoSurface = [AVCaptureVideoPreviewLayer layerWithSession: (AVCaptureSession*)session];
    localVideoSurface.frame = CGRectMake(0, 0, self.selfImageView.frame.size.width, self.selfImageView.frame.size.height);
    localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.selfImageView.layer addSublayer:localVideoSurface];
    NSLog(@"xyzqanychat OnLocalVideInit: session = %@", session);
}

// 连接服务器消息
- (void)OnAnyChatConnect:(BOOL)bSuccess{
    
    NSLog(@"xyzqanychat OnAnyChatConnect: bSuccess = %@", bSuccess? @"yes": @"no");
    if (bSuccess) {

        bConnect = YES;
        [self loginServer];

    }else {
        [self stopVideoChat:NO failReasonRemark:@"连接服务器失败"];
    }
}

// 用户登陆消息
- (void)OnAnyChatLogin:(int)dwUserId :(int)dwErrorCode{
    
    NSLog(@"xyzqanychat OnAnyChatLogin: dwUserId = %d, dwErrorCode = %d", dwUserId, dwErrorCode);
    
    if (dwErrorCode == GV_ERR_SUCCESS) {
//       int error = [AnyChatPlatform EnterRoom:[self.userVideoInfo.roomId intValue] :self.userVideoInfo.roomPwd];
        int error = [AnyChatPlatform EnterRoomEx:self.userVideoInfo.roomId :@""];
        NSLog(@"xyzqanychat login : roomid = %@, roomPwd = %@, error = %d", self.userVideoInfo.roomId, self.userVideoInfo.roomPwd, error);
    }
    else
    {
//         [DWJQDialogHelper dismissWaitHUD];
//        [SVProgressHUD dismiss];
      // 视频登录失败
       // [self stopVideoChat];
        // [self stopVideoChat:NO failReasonRemark:@"视频登录失败"];
        NSLog(@"xyzqanychat OnAnyChatLogin dwErrorCode = %d",dwErrorCode);

    }
}

// 用户进入房间消息
- (void) OnAnyChatEnterRoom:(int) dwRoomId : (int) dwErrorCode
{
//    [SVProgressHUD dismiss];
//     [DWJQDialogHelper dismissWaitHUD];
    NSLog(@"xyzqanychat OnAnyChatEnterRoom : dwRoomId = %d, dwErrorCode = %d", dwRoomId, dwErrorCode);
    
    if (dwErrorCode == GV_ERR_SUCCESS)
    {
        
        [self tdSendEventData:VIDEO_WAIT_TYPE label: [NSString stringWithFormat:@"用户先进入房间，坐席进入正确房间号，财人汇坐席ID：%@", self.userVideoInfo.empId]];
        
    }
    else
    {
        
        [self tdSendEventData:VIDEO_WAIT_TYPE label: [NSString stringWithFormat:@"用户先进入房间，坐席进入错误房间号，财人汇坐席ID：%@", self.userVideoInfo.empId]];
        [self stopVideoChat:NO failReasonRemark:@"进入房间失败"];
        
    }
}

//坐席进入房间消息 坐席先进入房间时会进这个委托
- (void)OnAnyChatUserEnterRoom:(int)dwUserId{
    
    NSLog(@"xyzqanychat 坐席进入房间 OnAnychatEnterRoom with dwUserId 坐席ID:%d",dwUserId);
    if (dwUserId == [self.userVideoInfo.empId intValue]) {
       
        [self setRemoteVideo: dwUserId];
        [self tdSendEventData:VIDEO_WAIT_TYPE label: [NSString stringWithFormat:@"坐席先进入房间，用户进入正确房间号，财人汇坐席ID：%@，Anycha坐席ID：%d", self.userVideoInfo.empId, dwUserId]];
        
    }else{
        //坐席端先进入房间代理
        [self tdSendEventData:VIDEO_WAIT_TYPE label: [NSString stringWithFormat:@"坐席先进入房间，用户进入错误房间号，正确坐席ID：%@，错误坐席ID：%d", self.userVideoInfo.empId, dwUserId]];
    }
}

// 用户退出房间消息
- (void) OnAnyChatUserLeaveRoom:(int) dwUserId
{
    if (dwUserId == [self.userVideoInfo.empId intValue]) {
        [self stopVideoChat:NO failReasonRemark:@"坐席离开房间"];
        [self tdSendEventData:VIDEO_WAIT_TYPE label: [NSString stringWithFormat:@"正确坐席离开房间，财人汇坐席ID：%@, Anycha坐席ID：%d", self.userVideoInfo.empId, dwUserId]];
        
    }else{
        
       [self tdSendEventData:VIDEO_WAIT_TYPE label: [NSString stringWithFormat:@"错误坐席离开房间，财人汇坐席ID：%@, Anycha坐席ID：%d", self.userVideoInfo.empId, dwUserId]];
        
    }
    
    NSLog(@"xyzqanychat 坐席离开房间 OnAnyChatUserLeaveRoom : dwUserId = %d", dwUserId);
}

// 房间在线用户消息
- (void) OnAnyChatOnlineUser:(int) dwUserNum : (int) dwRoomId
{
    NSLog(@"xyzqanychat 获取当前房间人数 OnAnyChatOnlineUser : dwUserNum = %d, dwRoomId = %d", dwUserNum, dwRoomId);
    
    if(dwUserNum >= 2)
    {
        
        NSArray *users = [AnyChatPlatform GetRoomOnlineUsers:dwRoomId];
        [self setRemoteVideo:[users[0] intValue]];

    }
}


// 网络断开消息
- (void)OnAnyChatLinkClose:(int)dwErrorCode{
    NSString *resason  = @"";
    if (dwErrorCode != 0) {
        resason = [NSString stringWithFormat:@"异常中断,中断代码:%d", dwErrorCode];
        [self tdSendEventData:VIDEO_WAIT_TYPE label:resason];
    }
    
    if (dwErrorCode == 0) {
        resason = [NSString stringWithFormat:@"网络中断,中断代码:%d", dwErrorCode];
      [self tdSendEventData:VIDEO_WAIT_TYPE label:resason];
    }
    
    [self stopVideoChat:NO failReasonRemark:resason];
    NSLog(@"xyzqanychat OnAnyChatLinkClose : resason = %@", resason);

    
#ifdef XYLogFile
    LogFile * logfile= [LogFile new];
    [logfile logAnychatErr:[@"网络异常中断:" stringByAppendingString:[NSString stringWithFormat:@"%d" , dwErrorCode]]];
#endif
}



- (void)OnAnyChatTextMsgCallBack:(int)dwFromUserid:(int)dwToUserid :(BOOL)bSecret :(NSString *)lpMsgBuf{
    
    NSLog(@"xyzqanychat OnAnyChatTextMsgCallBack : dwFromUserid = %d, dwToUserid = %d, bSecret = %@, lpMsgBuf = %@", dwFromUserid, dwToUserid, bSecret? @"yes": @"no", lpMsgBuf);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         if (self.anyChatTextMsgCallBack){
               self.anyChatTextMsgCallBack(lpMsgBuf);
           }
    });
   
    
//    if ([lpMsgBuf rangeOfString:@"unverified"].location != NSNotFound){
//
//
//        NSString *errorMsgTmp = [lpMsgBuf stringByReplacingOccurrencesOfString:@"unverified" withString:@""];
//        if([errorMsgTmp hasPrefix:@";"]||[errorMsgTmp hasPrefix:@"；"]){
//            errorMsgTmp = [errorMsgTmp stringByReplacingOccurrencesOfString:@";" withString:@""];
//            errorMsgTmp = [errorMsgTmp stringByReplacingOccurrencesOfString:@"；" withString:@""];
//        }
//
//
//       NSString *errorMsg= [errorMsgTmp stringByReplacingOccurrencesOfString:@"；" withString:@""];
//        if(errorMsg.length>0){
//         [self stopVideoChat:NO failReasonRemark:errorMsg];
//        }
//        else{
//            if(hasAlertOnce){
//               [self stopVideoChat:NO failReasonRemark:errorMsg];
//            }
//            else{
//                hasAlertOnce = YES;
//            }
//        }
//    }
//    else if ([lpMsgBuf rangeOfString:@"verified"].location != NSNotFound) {
//
//        [self stopVideoChat:YES failReasonRemark:@""];
//
//    }
//    else{
//        [self showConnectStatus:lpMsgBuf];
//    }

}


- (void)exceptionPop{
    [self startVideoCallBackM:NO reason:@"登录超时"];// 网络层失败
    isExit = YES;
}



-(void)tdSendEventData:(TDTYPE)eventId label:(NSString *)eventLabel
{

    NSString *thisversion= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if(eventId ==VIDEO_WAIT_TYPE)
    {
        NSString * VIDEO_WAIT =@"VIDEO_WAIT_";
        VIDEO_WAIT = [VIDEO_WAIT stringByAppendingString:thisversion];
      //  [[DataCollector sharedInstance] trackEvent: VIDEO_WAIT label:eventLabel ];
    }
    else if(eventId == VIDEO_VERIFY_TYPE)
    {
       NSString *  VIDEO_VERIFY =@"VIDEO_VERIFY_";
        VIDEO_VERIFY =[VIDEO_VERIFY stringByAppendingString:thisversion];
      // [[DataCollector sharedInstance] trackEvent: VIDEO_VERIFY label:eventLabel];
    }

}
//
//
//
-(void)startVideoCallBackM:(BOOL)isSuccess reason:(NSString*)reason{
   // NSLog(@"startVideoCallBackM  tu");
    NSLog(@"xyzqanychat startVideoCallBackM : isSuccess = %d, reason = %@",isSuccess,reason);
 
    if([reason hasPrefix:@";"]||[reason hasPrefix:@"；"]){
      reason = [reason stringByReplacingOccurrencesOfString:@";" withString:@""];
      reason = [reason stringByReplacingOccurrencesOfString:@"；" withString:@""];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(self.startVideoCallBackBlk){
            self.startVideoCallBackBlk(isSuccess,reason);
        }
    });

    [self quiteVideoVC];
    
}
//
//
//
-(void)quiteVideoVC{
    [_statusLabelLoopTimer invalidate];
    _statusLabelLoopTimer = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

   
    if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.navigationController setNavigationBarHidden:navigationBarHideFlagPre];

}

@end

