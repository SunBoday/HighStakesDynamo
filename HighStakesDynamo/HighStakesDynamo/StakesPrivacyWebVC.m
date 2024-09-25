//
//  StakesPrivacyWebVC.m
//  HighStakesDynamo
//
//  Created by SunTory on 2024/9/25.
//

#import "StakesPrivacyWebVC.h"

#import <WebKit/WebKit.h>
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <Photos/Photos.h>
#import "StakesTypeManager.h"

@interface StakesPrivacyWebVC ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, WKDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *stakes_indicatorView;
@property (weak, nonatomic) IBOutlet WKWebView *stakes_webView;
@property (weak, nonatomic) IBOutlet UIImageView *stakes_bgView;
@property (nonatomic, strong) NSURL *stakes_downloadedFileURL;
@property (nonatomic, copy) void(^stakes_backAction)(void);
@property (nonatomic, copy) NSString *stakes_extUrlstring;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stakes_bConstant;
@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation StakesPrivacyWebVC




- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
    // Do any additional setup after loading the view.
    if (StakesTypeManager.sharedInstance.stakes_scroller) {
        self.stakes_webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.stakes_webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self stakes_WebConfigNav];
    [self stakes_WebConfigView];
    
    // open toolbar
    if (StakesTypeManager.sharedInstance.StakesTOR) {
        [self stakes_initToolBarView];
    }
    self.stakes_indicatorView.hidesWhenStopped = YES;
    [self stakes_LoadWebData];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;

}
- (void)stakes_LoadWebData
{
    if (self.policyUrl.length) {
        NSURL *url = [NSURL URLWithString:self.policyUrl];
        if (url == nil) {
            NSLog(@"Invalid URL");
            return;
        }
        [self.stakes_indicatorView startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.stakes_webView loadRequest:request];
    } else {
        NSURL *url = [NSURL URLWithString:@"https://www.termsfeed.com/live/190f8853-c8d4-421d-a1c0-937135dda34b"];
        if (url == nil) {
            NSLog(@"Invalid URL");
            return;
        }
        [self.stakes_indicatorView startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.stakes_webView loadRequest:request];
    }
}

#pragma mark - toolBar View
- (void)stakes_initToolBarView
{
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.toolbar];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForward)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbar.items = @[backButton, flexibleSpace, refreshButton, flexibleSpace, forwardButton];
    [NSLayoutConstraint activateConstraints:@[
        [self.toolbar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.toolbar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.toolbar.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (StakesTypeManager.sharedInstance.StakesTOR) {
        CGFloat toolbarHeight = self.toolbar.frame.size.height + self.view.safeAreaInsets.bottom;
        self.stakes_bConstant.constant = toolbarHeight;
    }
}

- (void)goBack {
    if ([self.stakes_webView canGoBack]) {
        [self.stakes_webView goBack];
    }
}

- (void)goForward {
    if ([self.stakes_webView canGoForward]) {
        [self.stakes_webView goForward];
    }
}

- (void)reload {
    [self.stakes_webView reload];
}

#pragma mark - init
- (void)stakes_WebConfigNav
{
    if (!self.policyUrl.length) {
        return;
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor systemBlueColor];
    UIImage *image = [UIImage systemImageNamed:@"xmark"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)stakes_WebConfigView
{
    self.view.backgroundColor = UIColor.whiteColor;
    if (StakesTypeManager.sharedInstance.StakesBgColor) {
        self.view.backgroundColor = UIColor.blackColor;
        self.stakes_webView.backgroundColor = [UIColor blackColor];
        self.stakes_webView.opaque = NO;
        self.stakes_webView.scrollView.backgroundColor = [UIColor blackColor];
    }
    
    WKUserContentController *userContentC = self.stakes_webView.configuration.userContentController;
    
    // Bless
    if (StakesTypeManager.sharedInstance.stakes_LegendType == StakesTypeBL) {
        NSString *trackStr = @"window.CrccBridge = {\n    postMessage: function(data) {\n        window.webkit.messageHandlers.StakesADSEvent.postMessage({data})\n    }\n};\n";
        WKUserScript *trackScript = [[WKUserScript alloc] initWithSource:trackStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentC addUserScript:trackScript];
        [userContentC addScriptMessageHandler:self name:@"StakesADSEvent"];
    }
    
    // wg 、panda
    else {
        NSString *trackStr = @"window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.StakesMessageHandle.postMessage({name, data})\n    }\n};\n";
        WKUserScript *trackScript = [[WKUserScript alloc] initWithSource:trackStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentC addUserScript:trackScript];
        
        if (StakesTypeManager.sharedInstance.stakes_LegendType == StakesTypeWG) {
            NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if (!version) {
                version = @"";
            }
            NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
            if (!bundleId) {
                bundleId = @"";
            }
            NSString *inPPStr = [NSString stringWithFormat:@"window.WgPackage = {name: '%@', version: '%@'}", bundleId, version];
            WKUserScript *inPPScript = [[WKUserScript alloc] initWithSource:inPPStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
            [userContentC addUserScript:inPPScript];
        }
        
        [userContentC addScriptMessageHandler:self name:@"StakesMessageHandle"];
    }
    
    
    self.stakes_webView.navigationDelegate = self;
    self.stakes_webView.UIDelegate = self;
    self.stakes_webView.alpha = 0;
}

#pragma mark - action
- (void)backClick
{
    if (self.stakes_backAction) {
        self.stakes_backAction();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WKDownloadDelegate
- (void)download:(WKDownload *)download decideDestinationUsingResponse:(NSURLResponse *)response suggestedFilename:(NSString *)suggestedFilename completionHandler:(void (^)(NSURL *))completionHandler API_AVAILABLE(ios(14.5)){
    NSString *tempDir = NSTemporaryDirectory();
    NSURL *tempDirURL = [NSURL fileURLWithPath:tempDir isDirectory:YES];
    NSURL *destinationURL = [tempDirURL URLByAppendingPathComponent:suggestedFilename];
    self.stakes_downloadedFileURL = destinationURL;
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationURL.path]) {
        [self ccbSaveDownloadedFileToPhotoAlbum:self.stakes_downloadedFileURL];
    }
    completionHandler(destinationURL);
}

- (void)download:(WKDownload *)download didFailWithError:(NSError *)error API_AVAILABLE(ios(14.5)){
    NSLog(@"Download failed: %@", error.localizedDescription);
}

- (void)downloadDidFinish:(WKDownload *)download API_AVAILABLE(ios(14.5)){
    NSLog(@"Download finished successfully.");
    [self ccbSaveDownloadedFileToPhotoAlbum:self.stakes_downloadedFileURL];
}

- (void)ccbSaveDownloadedFileToPhotoAlbum:(NSURL *)fileURL API_AVAILABLE(ios(14.5)){
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetCreationRequest creationRequestForAssetFromImageAtFileURL:fileURL];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self showAlertWithTitle:@"sucesso" message:@"A imagem foi salva no álbum."];
                    } else {
                        [self showAlertWithTitle:@"erro" message:[NSString stringWithFormat:@"Falha ao salvar a imagem: %@", error.localizedDescription]];
                    }
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithTitle:@"Photo album access denied." message:@"Please enable album access in settings."];
            });
            NSLog(@"Photo album access denied.");
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *orientation = @(UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
    [[UIDevice currentDevice] setValue:orientation forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *name = message.name;
    if ([name isEqualToString:@"StakesMessageHandle"]) {
        NSDictionary *trackMessage = (NSDictionary *)message.body;
        NSString *tName = trackMessage[@"name"] ?: @"";
        NSString *tData = trackMessage[@"data"] ?: @"";
        NSData *data = [tData dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data) {
            NSError *error;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!error && [jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = jsonObject;
                if (![tName isEqualToString:@"openWindow"]) {
                    [self stakes_SendEvent:tName values:dic];
                    return;
                }
                if ([tName isEqualToString:@"rechargeClick"]) {
                    return;
                }
                NSString *adId = dic[@"url"] ?: @"";
                if (adId.length > 0) {
                    [self stakes_ReloadWebViewData:adId];
                }
            }
        } else {
            [self stakes_SendEvent:tName values:@{tName: data}];
        }
    } else if ([name isEqualToString:@"StakesADSEvent"]) {
        NSDictionary *trackMessage = (NSDictionary *)message.body;
        NSString *tData = trackMessage[@"data"] ?: @"";
        NSData *data = [tData dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSError *error;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!error && [jsonObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"bless:%@", jsonObject);
                NSString *name = jsonObject[@"event"];
                if (name && [name isKindOfClass:NSString.class]) {
                    [AppsFlyerLib.shared logEvent:name withValues:jsonObject];
                }
            }
        }
    }
}

- (void)stakes_ReloadWebViewData:(NSString *)adurl
{
    if (StakesTypeManager.sharedInstance.stakes_LegendType == StakesTypePD) {
        NSURL *url = [NSURL URLWithString:adurl];
        if (url) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.stakes_extUrlstring isEqualToString:adurl] && StakesTypeManager.sharedInstance.StakesBJU) {
                return;
            }
            
            StakesPrivacyWebVC *adView = [self.storyboard instantiateViewControllerWithIdentifier:@"StakesPrivacyWebVC"];
            adView.policyUrl = adurl;
            __weak typeof(self) weakSelf = self;
            adView.stakes_backAction = ^{
                NSString *close = @"window.closeGame();";
                [weakSelf.stakes_webView evaluateJavaScript:close completionHandler:nil];
            };
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:adView];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:YES completion:nil];
        });
    }
}

- (void)stakes_SendEvent:(NSString *)event values:(NSDictionary *)value
{
    if (StakesTypeManager.sharedInstance.stakes_LegendType == StakesTypePD) {
        if ([event isEqualToString:@"firstrecharge"] || [event isEqualToString:@"recharge"]) {
            id am = value[@"amount"];
            NSString * cur = value[@"currency"];
            if (am && cur) {
                double niubi = [am doubleValue];
                NSDictionary *values = @{
                    AFEventParamRevenue: @(niubi),
                    AFEventParamCurrency: cur
                };
                [AppsFlyerLib.shared logEvent:event withValues:values];
            }
        } else {
            [AppsFlyerLib.shared logEvent:event withValues:value];
        }
    } else {
        if ([event isEqualToString:@"firstrecharge"] || [event isEqualToString:@"recharge"] || [event isEqualToString:@"withdrawOrderSuccess"]) {
            id am = value[@"amount"];
            NSString * cur = value[@"currency"];
            if (am && cur) {
                double niubi = [am doubleValue];
                NSDictionary *values = @{
                    AFEventParamRevenue: [event isEqualToString:@"withdrawOrderSuccess"] ? @(-niubi) : @(niubi),
                    AFEventParamCurrency: cur
                };
                [AppsFlyerLib.shared logEvent:event withValues:values];
            }
        } else {
            [AppsFlyerLib.shared logEvent:event withValues:value];
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.stakes_webView.alpha = 1;
        self.stakes_bgView.hidden = YES;
        [self.stakes_indicatorView stopAnimating];
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.stakes_webView.alpha = 1;
        self.stakes_bgView.hidden = YES;
        [self.stakes_indicatorView stopAnimating];
    });
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction preferences:(WKWebpagePreferences *)preferences decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences *))decisionHandler {
    if (@available(iOS 14.5, *)) {
        if (navigationAction.shouldPerformDownload) {
            decisionHandler(WKNavigationActionPolicyDownload, preferences);
            NSLog(@"%@", navigationAction.request);
            [webView startDownloadUsingRequest:navigationAction.request completionHandler:^(WKDownload *down) {
                down.delegate = self;
            }];
        } else {
            decisionHandler(WKNavigationActionPolicyAllow, preferences);
        }
    } else {
        decisionHandler(WKNavigationActionPolicyAllow, preferences);
    }
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (navigationAction.targetFrame == nil) {
        NSURL *url = navigationAction.request.URL;
        if (url) {
            self.stakes_extUrlstring = url.absoluteString;
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
    return nil;
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSString *authenticationMethod = challenge.protectionSpace.authenticationMethod;
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = nil;
        if (challenge.protectionSpace.serverTrust) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        }
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}
@end

