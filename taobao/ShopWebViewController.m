

#import "ShopWebViewController.h"
#import "MBProgressHUD.h"

@interface ShopWebViewController ()

@end

@implementation ShopWebViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    DLog(@" %@ ",NSStringFromCGRect(bounds));
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, bounds.size.height)];
    webView.delegate = self;
    DLog(@" %@ ",self.shopUrl);
    NSURL *url = [NSURL URLWithString: [self.shopUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURL *url =[NSURL URLWithString:@"www.baidu.com"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    UIButton *backBtn = [UIButton buttonWithNormalImgName:@"product_back" HighlightImgName:@"product_back" target:self selector:@selector(onBack)];
    backBtn.left = 0;
    backBtn.centerY = self.view.centerY - 80;
    [self.view addSubview:backBtn];

}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView*)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    DLog(@"");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
