

#import "ShopView.h"
#import "Global.h"
#import "DWTagList.h"
#import "ShopWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataCenter.h"
#import "Search.h"
#import "Shop.h"
#import "UserInfoManager.h"
#import "Reachability.h"

#define kSHOP_IV_TAG    200
#define kSHOP_BTN_TAG    300
#define kSHOP_LBL_TAG    400


@interface ShopView ()

@end

@implementation ShopView

@synthesize delegate;
@synthesize shopArray;
@synthesize tsView;
@synthesize parentVc;
@synthesize backBtn;
@synthesize txtSearch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor clearColor];
        NSDictionary *adDic = NSDictionary.new;
        int adCount = 0;
        if ([self checkNet]){
            NSDictionary *rtnDic = [self requestServer:kSHOP_URL];
            adDic = [rtnDic objectForKey:@"ad_list"];
            adCount = adDic.count;
        }

        productScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, 300)];
        [productScrView setContentSize:CGSizeMake(frame.size.width * adCount, 300)];
        productScrView.pagingEnabled = YES;
        productScrView.bounces = NO;
        [productScrView setDelegate:self];
        productScrView.showsHorizontalScrollIndicator = NO;
        productScrView.showsVerticalScrollIndicator = NO;
        [self addSubview:productScrView];
        
        int i = 0;
        
        self.shopArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in adDic) {
            
            Shop *shop = [[Shop alloc] init];
            shop.name = [dic objectForKey:@"name"];
            shop.pic_url = [dic objectForKey:@"imgurl"];
            shop.shop_url = [dic objectForKey:@"shopurl"];
            [self.shopArray addObject:shop];
            
            UIImageView *iv1 = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, productScrView.frame.size.width, 300)];
            iv1.tag = kSHOP_IV_TAG + i;
    //        iv1.image = [UIImage imageNamedAuto:@"3.jpg"];
            [productScrView addSubview:iv1];
            
        
            
            UIButton *collectBtn = [UIButton buttonWithNormalImgName:@"collect" selectedImgName:@"collect2" target:self selector:@selector(onCellect:)];
            collectBtn.frame = CGRectMake(0, 0,collectBtn.bWidth , collectBtn.bHeight);
            collectBtn.tag = kSHOP_BTN_TAG + i;
            collectBtn.selected = [[UserInfoManager sharedManager] isSaveShop:[dic objectForKey:@"name"]];
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(iv1.left + 280, 10,collectBtn.width ,collectBtn.height)];
            view1.backgroundColor = [UIColor clearColor];
            [productScrView addSubview:view1];

            [view1 addSubview:collectBtn];
            collectBtn.center = CGPointMake(view1.width / 2, view1.height / 2);

            
            
            UILabel *shareLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, view1.width, 20)];
            shareLbl.tag = kSHOP_LBL_TAG + i;
            shareLbl.textAlignment = UITextAlignmentCenter;
            shareLbl.backgroundColor = [UIColor clearColor];
            shareLbl.textColor = [UIColor whiteColor];
            shareLbl.font = [UIFont systemFontOfSize:11.0f];
            shareLbl.text = @"收藏";
            [view1 addSubview:shareLbl];
        
            
            
            
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kSERVER_URL,[dic objectForKey:@"imgurl"]]];

            if (imageUrl)
            {
                __block UIActivityIndicatorView *activityIndicator;
                __weak UIImageView *weakImageView = iv1;
                [iv1 setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
                 {
                     if (!activityIndicator)
                     {
                         [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                         activityIndicator.center = weakImageView.center;
                         [activityIndicator startAnimating];
                     }
                 }
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
                 {
                     [activityIndicator removeFromSuperview];
                     activityIndicator = nil;
                 }];
            }
            
            
            iv1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShop:)];
            [iv1 addGestureRecognizer:tap];

            i++;
            DLog(@" %@ ",[dic objectForKey:@"imgurl"]);
        }
        
        //创建UIPageControl
        pageCtrl = [[GrayPageControl alloc] initWithFrame:CGRectMake(0, productScrView.bounds.size.height - 30, frame.size.width, 30)];
        pageCtrl.numberOfPages = adCount;
        pageCtrl.currentPage = 0;
        [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageCtrl];
        
        UIImageView *splitiv = [[UIImageView alloc] initWithImage:[UIImage imageNamedAuto:@"search_split"]];
        splitiv.contentMode = UIViewContentModeScaleAspectFit;
        splitiv.frame = CGRectMake(0, productScrView.height - 5, 320, 24);
        [self addSubview:splitiv];

        
        UIImageView *bgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamedAuto:@"search_bg2"]];
        bgIv.contentMode = UIViewContentModeScaleAspectFill;
        bgIv.frame = CGRectMake(0, splitiv.bottom - 5, 320, IS_IPHONE_5 ? 235 : 160);
        [self addSubview:bgIv];
            
        searchView = [[UIView alloc] initWithFrame:CGRectMake(0, splitiv.bottom , self.bounds.size.width, 40)];
        searchView.backgroundColor = [UIColor clearColor];
        [self addSubview:searchView];
        
        UIImageView *searchBgIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bg"]];
        searchBgIv.contentMode = UIViewContentModeScaleAspectFit;
        searchBgIv.frame = CGRectMake(0, 0, searchBgIv.bWidth / 2, searchBgIv.bHeight / 2);
        searchBgIv.center = CGPointMake(searchView.width / 2, searchView.height / 2);
        [searchView addSubview:searchBgIv];
        
        UIImageView *iconIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"search_icon.png"]];
        iconIv.frame = CGRectMake(15, 0, iconIv.bWidth / 2, iconIv.bHeight / 2);
        iconIv.centerY = searchView.height / 2;
        [searchView addSubview:iconIv];
        
        UIImageView *txtIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"search_text.png"]];
        txtIv.frame = CGRectMake(38, 0, txtIv.bWidth / 2, txtIv.bHeight / 2);
        txtIv.centerY = searchView.height / 2;
        [searchView addSubview:txtIv];
        
        self.txtSearch = UITextField.new;
        self.txtSearch.frame = CGRectMake(80, 10, self.width - 100, 30);
        self.txtSearch.delegate = self;
    //    txtSearch.keyboardType = UIKeyboardTypeDefault;
    //    txtSearch.borderStyle = UITextBorderStyleLine;
        [self.txtSearch setReturnKeyType:UIReturnKeySearch];
        [searchView addSubview:self.txtSearch];
        
        keyBordeTop = searchView.top;
        
        if ([self checkNet]){
            NSDictionary *searchDic = [self requestServer:kSEARCH_TAG_URL];
            searchArray = [[DataCenter sharedDataCenter] searchArray:searchDic];
        }
        NSMutableArray *nameArray = NSMutableArray.new;
        for (Search *search in searchArray) {
            [nameArray addObject:search.name];
        }

        
        UIView *lblView = [[UIView alloc] initWithFrame:CGRectMake(0,searchView.bottom + 10 , self.width, self.height - searchView.bottom)];
        [self addSubview:lblView];
        
        tagList = [[DWTagList alloc] initWithFrame:CGRectMake(0,0 , self.width - 20, lblView.height - 20)];
        tagList.center = CGPointMake(lblView.width / 2, lblView.height / 2);
        tagList.delegate = self;
        [tagList setTags:nameArray];
        [lblView addSubview:tagList];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        self.backBtn = [UIButton buttonWithNormalImgName:@"product_back" HighlightImgName:@"product_back" target:self selector:@selector(onBack)];
        backBtn.left = 0;
        backBtn.centerY = self.centerY - 80;
        [self addSubview:self.backBtn];
        
        self.tsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 35)];
        self.tsView.centerX = self.centerX;
        self.tsView.bottom = productScrView.bottom - 20;
        self.tsView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.tsView];
        self.tsView.hidden = YES;
        
        UILabel *collectLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tsView.width, self.tsView.height)];
        collectLbl.textAlignment = UITextAlignmentCenter;
        collectLbl.backgroundColor = [UIColor clearColor];
        collectLbl.textColor = [UIColor whiteColor];
        collectLbl.font = [UIFont systemFontOfSize:16.0f];
        collectLbl.text = @"收藏店铺成功!";
        [self.tsView addSubview:collectLbl];
        
        
        UIImageView *titleIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_title"]];
        titleIv.frame = CGRectMake(0, 0, titleIv.bWidth / 2, titleIv.bHeight / 2);
        
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 38, self.width, titleIv.height)];
        toolView.backgroundColor = [UIColor clearColor];
        [self addSubview:toolView];
        [toolView addSubview:titleIv];
        
        UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, toolView.height)];
        shareView.backgroundColor = [UIColor clearColor];
        [toolView addSubview:shareView];
        
        UIButton *shareBtn = [UIButton buttonWithNormalImgName:@"main_share1" HighlightImgName:@"main_share1" target:self selector:@selector(onShopShare)];
        shareBtn.center = CGPointMake(20,toolView.height / 2);
        [shareView addSubview:shareBtn];
        
        UILabel *shareLbl = [[UILabel alloc] initWithFrame:CGRectMake(shareBtn.right, 0, 50, 16)];
        shareLbl.bottom = shareBtn.bottom;
        shareLbl.textAlignment = UITextAlignmentLeft;
        shareLbl.backgroundColor = [UIColor clearColor];
        shareLbl.textColor = [UIColor whiteColor];
        shareLbl.font = [UIFont systemFontOfSize:12.0f];
        shareLbl.text = @"分享";
        [shareView addSubview:shareLbl];
        
        shareView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShopShare)];
        [shareView addGestureRecognizer:tap];
        
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, toolView.height)];
        nameLbl.center = CGPointMake(toolView.width / 2, toolView.height / 2 - 2);
        nameLbl.textAlignment = UITextAlignmentCenter;
        nameLbl.backgroundColor = [UIColor clearColor];
        nameLbl.textColor = [UIColor whiteColor];
        nameLbl.font = [UIFont systemFontOfSize:22.0f];
        nameLbl.text = @"韩都衣舍旗舰店";
        [toolView addSubview:nameLbl];
        
        
    }
    return self;
}

- (BOOL)checkNet
{
    BOOL isExistenceNetwork = NO;
    Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            break;
    }
    return isExistenceNetwork;
}


- (NSDictionary*)requestServer:(NSString*)str_url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str_url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}

#pragma mark - Share 

- (void)onShopShare
{
    [self.delegate shopViewReturn:1];
}

- (void)onGoShop
{
    [self.delegate shopViewReturn:2];
}


#pragma mark - Tap

- (void)tapShop:(UITapGestureRecognizer*)tap
{
    int index = tap.view.tag - kSHOP_IV_TAG;
    Shop *shop = [self.shopArray objectAtIndex:index];
    
    ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
    shopWeb.shopUrl = shop.shop_url;
    [self.parentVc.navigationController pushViewController:shopWeb animated:YES];
}

- (void)onCellect:(UIButton*)btn
{
    int index = btn.tag - kSHOP_BTN_TAG;
//    UILabel *lbl = (UILabel*)[productScrView viewWithTag:kSHOP_LBL_TAG + index];
    
//    [btn1 removeFromSuperview];
//    [lbl removeFromSuperview];
    Shop *shop = [self.shopArray objectAtIndex:index];
    if ([[UserInfoManager sharedManager] isSaveShop:shop.name]) {
        btn.selected = NO;
        [[UserInfoManager sharedManager].shopArray removeObject:shop];
        [[UserInfoManager sharedManager] setSaveShop:shop.name value:NO];
    }else{
        btn.selected = YES;
        [[UserInfoManager sharedManager].shopArray addObject:shop];
        [[UserInfoManager sharedManager] setSaveShop:shop.name value:YES];
        
        self.tsView.alpha = 0.8f;
        self.tsView.hidden = NO;
        self.tsView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.5f
            animations:^{
                self.tsView.alpha = 1.0f;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:1.0f
                                 animations:^{
                                     self.tsView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
                                     self.tsView.alpha = 0.0f;
                                 } completion:^(BOOL finished){
                                     self.tsView.hidden = YES;
                                 }];
            }];
    }
}

#pragma mark - Page Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageCtrl setCurrentPage:offset.x / bounds.size.width];
}

- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = productScrView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [productScrView scrollRectToVisible:rect animated:YES];
}

#pragma mark - UISearchBarDelegate Methods

- (void)keyboardWillShow:(NSNotification *)notification
{            
    //自适应代码
    [UIView animateWithDuration:.4
                     animations:^{
                         self.top = - 160;
                         self.backBtn.top = self.centerY + 105;
                     }
                     completion:^(BOOL finished){
                         //whatever else you may need to do
                     }];

}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    [UIView animateWithDuration:.1
                     animations:^{
                         self.top = 0;
                         backBtn.centerY = self.centerY - 80;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    if (![theTextField.text isEqualToString:@""]) {
        [self goSearchView:theTextField.text];
    }
    return YES;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    keyBordeTop = searchBar.top;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:.1
                     animations:^{
                         searchBar.frame = CGRectMake(searchBar.frame.origin.x,
                                                      keyBordeTop,
                                                      searchBar.frame.size.width,
                                                      searchBar.frame.size.height);
                     }
                     completion:^(BOOL finished){

                     }];
    return YES;
}

 // called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar1
{
    [searchBar1 resignFirstResponder];
}

- (void)onBack
{
//    self.backBtn.top = 5;
    [self.delegate shopViewReturn:2];
    [self.txtSearch resignFirstResponder];
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.top = - ([UIScreen mainScreen].bounds.size.height - 20);
                     } completion:NULL];
}


#pragma mark - Tag Delegate
- (void)onTag:(int)index
{    
    Search *search = [searchArray objectAtIndex:index];
    [self goSearchView:search.name];
}

- (void)goSearchView:(NSString*)searchValue
{
    ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
    shopWeb.shopUrl = [NSString stringWithFormat:@"%@%@",kSEARCH_URL,searchValue];
    [self.parentVc.navigationController pushViewController:shopWeb animated:YES];
}

@end
