#import "WebViewNativeModule.h"
#import <WebKit/WebKit.h>
#import <React/RCTLog.h>

@interface WebViewController : UIViewController <WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *html;
@end

@implementation WebViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
  WKWebViewConfiguration *config = [WKWebViewConfiguration new];
  self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
  self.webView.navigationDelegate = self;
  self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.view addSubview:self.webView];
  if (self.html.length > 0) {
    [self.webView loadHTMLString:self.html baseURL:nil];
  } else if (self.url.length > 0) {
    NSURL *u = [NSURL URLWithString:self.url];
    if (u) [self.webView loadRequest:[NSURLRequest requestWithURL:u]];
  }
}

- (void)close { [self dismissViewControllerAnimated:YES completion:nil]; }
@end

@implementation WebViewNativeModule
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents { return @[]; }

RCT_EXPORT_METHOD(open:(NSDictionary *)config
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *url = config[@"url"] ?: @"";
    NSString *html = config[@"html"] ?: @"";
    UIViewController *root = UIApplication.sharedApplication.delegate.window.rootViewController;
    WebViewController *vc = [WebViewController new];
    vc.url = url;
    vc.html = html;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [root presentViewController:nav animated:YES completion:^{ resolve(@(YES)); }];
  });
}
@end


