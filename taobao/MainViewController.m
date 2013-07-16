

#import "MainViewController.h"
#import "PersonView.h"
#import "ProductInfoViewController.h"
#import "ShopView.h"
#import "UMSocial.h"
#import "DataCenter.h"
#import "Product.h"
#import "ShopWebViewController.h"
#import "MainCell.h"
#import "ShopCollectViewController.h"
#import "ProductLikeViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize shopView;
@synthesize flipIv;
@synthesize shopBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    page = 1;
    self.productArray = NSMutableArray.new;
    if ([self checkNet]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%i",kPRODUCT_URL,page];
        NSDictionary *productDic = [self requestServer:strUrl];
        self.productArray = [[DataCenter sharedDataCenter] productArray:productDic];
    }else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                       message:@"没有网络连接，无法获取数据！"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        self.productArray = nil;
    }

    
    productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 38 , self.view.width, self.view.height - 38)];
    productTableView.showsHorizontalScrollIndicator = NO;
    productTableView.showsVerticalScrollIndicator = NO;
    productTableView.delegate = self;
    productTableView.dataSource = self;
    [self.view addSubview:productTableView];
    
    _reloading = NO;
    [self createHeaderView];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
    
    UIButton *menuBtn = [UIButton buttonWithNormalImgName:@"main_menu" HighlightImgName:nil target:self selector:@selector(onPerson:)];
    menuBtn.left = -5;
    menuBtn.bottom = self.view.height - 10;
    [self.view addSubview:menuBtn];
    
    self.flipIv = [[UIImageView alloc] initWithImage:[UIImage imageNamedAuto:@"flip"]];
    self.flipIv.frame = CGRectMake(0, 0, self.flipIv.bWidth, self.flipIv.bHeight);
    self.flipIv.centerY = self.view.centerY + 80;
    self.flipIv.right = self.view.right - 10;
    [self.view addSubview:self.flipIv];
//    flip
    
    self.shopView = [[ShopView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 38)];
    self.shopView.delegate = self;
    self.shopView.parentVc = self;
    self.shopView.top = - self.view.height ;
    [self.view addSubview:self.shopView];
        
    self.shopBtn = [UIButton buttonWithNormalImgName:@"main_tuijian1" HighlightImgName:nil target:self selector:@selector(onShop:)];
    self.shopBtn.center = CGPointMake(self.view.width - 20,50);
    [self.view addSubview:self.shopBtn];

}

#pragma mark - On

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.shopView.top = - self.view.height ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.0f
                          delay:1.5f
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.flipIv.alpha = 0;
                     } completion:NULL];
    
}

- (void)onShared:(UIButton*)btn
{
    /*
    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToTencent,UMShareToWechat,UMShareToQzone,UMShareToEmail]];
    
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"UMSocialSDK" withTitle:nil];
    socialData.shareText = @"test";
    socialData.shareImage =[UIImage imageNamedAuto:[NSString stringWithFormat:@"%i.jpg",1]];
    
    UMSocialControllerService *socialControllerService = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    UMSocialIconActionSheet *iconActionSheet = [socialControllerService getSocialIconActionSheetInController:self];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    [iconActionSheet showInView:rootViewController.view];
     */
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size,NO,kScreenScale); //currentView 当前的view
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMENG_KEY
                                      shareText:@"韩都衣舍"
                                     shareImage:viewImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechat,UMShareToQzone,UMShareToEmail,nil]
                                       delegate:nil];
}

- (void)onShop:(UIButton*)btn
{
    
    if ([self checkNet]) {
        self.shopView.hidden = NO;
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             self.shopView.top = 0;
                             shopBtn.centerY = self.shopView.height + 50;
                         } completion:NULL];
    }else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                       message:@"没有网络连接，无法获取数据！"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        self.productArray = nil;
    }

}

- (void)onPerson:(UIButton*)btn
{
    PersonView *personView = [[PersonView alloc] initWithFrame:self.view.bounds];
    personView.delegate = self;
    personView.alpha = .0f;
    [self.view addSubview:personView];
    
    [UIView animateWithDuration:0.8f
                     animations:^{
                         personView.alpha = 1.0f;
                     } completion:^(BOOL finished){

                     }];
    

//    CAAnimation *fadeAnimation=[self fadeAnimation];
//    [personView.layer addAnimation:fadeAnimation forKey:@"fade"];

}

- (CAAnimation*) fadeAnimation
{
    CATransition *fadeTransition=[CATransition animation];
    fadeTransition.type=kCATransitionFade;
    fadeTransition.fillMode=kCAFillModeRemoved;
    fadeTransition.removedOnCompletion=YES;
    fadeTransition.duration=3.0f;
    return fadeTransition;
}

#pragma mark personView delegate
-(void)personRtn:(int)index
{
    /*
    NSDictionary *productDic = [self requestServer:kPRODUCT_URL];
    self.array = [[DataCenter sharedDataCenter] productArray:productDic];
    productTableView.scrollsToTop = YES;
    [productTableView reloadData];
    */
    
    if (![self checkNet]) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                       message:@"没有网络连接，无法获取数据！"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    switch (index) {
        case NewType:
        {
            ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
            shopWeb.shopUrl = kNEW_PRODUCT_URL;
            [self.navigationController pushViewController:shopWeb animated:YES];
            break;
        }case SaleType:
        {
            ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
            shopWeb.shopUrl = kSALE_PRODUCT_URL;
            [self.navigationController pushViewController:shopWeb animated:YES];
            break;
        }case ShopType:
        {
            ShopCollectViewController *vc = [[ShopCollectViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }case ProductType:
        {
            ProductLikeViewController *vc = [[ProductLikeViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];

            
            break;
        }
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MainCell *cell = (MainCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    Product *product = [self.productArray objectAtIndex:indexPath.row];
//    NSString *imageName = [self.array objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    [cell loadView:product.pic_url title:product.title price:product.price];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self checkNet]) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                       message:@"没有网络连接，无法获取数据！"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    ProductInfoViewController *pivc = [[ProductInfoViewController alloc] initWithNibName:nil bundle:nil];
    pivc.product = [self.productArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pivc animated:YES];

}

#pragma mark - MainCellDelegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mrk - EGO
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[productTableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(productTableView.contentSize.height, productTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              productTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         productTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [productTableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

#pragma mark - ShopView delegate

- (void)shopViewReturn:(int)type
{
    if (type == 1) {
        [self onShared:nil];
    }else if(type == 2){
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.shopBtn.centerY = 50;
                         } completion:NULL];
    }
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		productTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [productTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
        productTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[productTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}
//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    if ([self checkNet]) {
        //  should be calling your tableviews data source model to reload
        _reloading = YES;
        
        if (aRefreshPos == EGORefreshHeader) {
            // pull down to refresh data
            [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
        }else if(aRefreshPos == EGORefreshFooter){
            // pull up to load more data
            [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
        }
    }else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil
                                                       message:@"没有网络连接，无法获取数据！"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        self.productArray = nil;
    }
	
    
	// overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:productTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:productTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新调用的方法
-(void)refreshView{
    page = 1;
    NSString *strUrl = [NSString stringWithFormat:@"%@%i",kPRODUCT_URL,page];
    NSDictionary *productDic = [self requestServer:strUrl];
    self.productArray = [[DataCenter sharedDataCenter] productArray:productDic];
    [productTableView reloadData];
    [self testFinishedLoadData];
}
//加载调用的方法
-(void)getNextPageView{
    
    page += 1;
    NSString *strUrl = [NSString stringWithFormat:@"%@%i",kPRODUCT_URL,page];
    NSDictionary *productDic = [self requestServer:strUrl];
    NSArray *temp_array = [[DataCenter sharedDataCenter] productArray:productDic];
    for (Product *pro in temp_array) {
        [self.productArray addObject:pro];
    }
    
    [self removeFooterView];
    [productTableView reloadData];
    [self testFinishedLoadData];
    
}
-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
}


@end
