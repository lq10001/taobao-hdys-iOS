

#import "NewProductViewController.h"
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
#import "ShopTopViewController.h"
#import "MBProgressHUD.h"

@interface NewProductViewController ()

@end

@implementation NewProductViewController

//@synthesize shopView;
@synthesize flipIv;
@synthesize shopBtn;
@synthesize productType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.product_url = (self.productType == 1) ?  kPRODUCT_NEW_URL : kPRODUCT_SALE_URL;
    self.productArray = NSMutableArray.new;
    
    UIImageView *titleIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_title"]];
    titleIv.frame = CGRectMake(0, 0, titleIv.bWidth / 2, titleIv.bHeight / 2);
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, titleIv.height)];
    toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:toolView];
    [toolView addSubview:titleIv];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, toolView.height)];
    nameLbl.center = CGPointMake(toolView.width / 2, toolView.height / 2);
    nameLbl.textAlignment = UITextAlignmentCenter;
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor whiteColor];
    nameLbl.font = [UIFont systemFontOfSize:20.0f];
    nameLbl.text = (self.productType == 1) ? @"新品推荐" :@"销量排行";
    [toolView addSubview:nameLbl];

    
    productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 38 , self.view.width, self.view.height - 38)];
    productTableView.showsHorizontalScrollIndicator = NO;
    productTableView.showsVerticalScrollIndicator = NO;
    productTableView.delegate = self;
    productTableView.dataSource = self;
    [self.view addSubview:productTableView];
    
    _reloading = NO;
    [self createHeaderView];
    
    self.flipIv = [[UIImageView alloc] initWithImage:[UIImage imageNamedAuto:@"flip"]];
    self.flipIv.frame = CGRectMake(0, 0, self.flipIv.bWidth, self.flipIv.bHeight);
    self.flipIv.centerY = self.view.centerY + 80;
    self.flipIv.right = self.view.right - 10;
    [self.view addSubview:self.flipIv];
//    flip
    
    
    UIButton *backBtn = [UIButton buttonWithNormalImgName:@"product_back" HighlightImgName:@"product_back" target:self selector:@selector(onBack)];
    backBtn.left = 0;
    backBtn.centerY = self.view.centerY - 80;
    [self.view addSubview:backBtn];
    
        
}

#pragma mark - On

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSThread  *thread =[[NSThread alloc] initWithTarget:self selector:@selector(loadData) object:nil];
    [thread start];
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

- (void)loadData
{
    if ([Global checkNet]) {
        [self loadProductData];
        [self performSelectorOnMainThread:@selector(mainLoadData) withObject:nil waitUntilDone:NO];
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

- (void)mainLoadData
{
    [productTableView reloadData];
    [self testFinishedLoadData];
}

- (void)loadProductData
{
    page =1;
    NSString *strUrl = [NSString stringWithFormat:@"%@%i",self.product_url,page];
    NSDictionary *productDic = [Global requestServer:strUrl];
    self.productArray = [[DataCenter sharedDataCenter] productArray:productDic];
}

- (void)synLoadProductData
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    page =1;
    NSString *strUrl = [NSString stringWithFormat:@"%@%i",self.product_url,page];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                               }else{
                                   NSDictionary *productDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                   self.productArray = [[DataCenter sharedDataCenter] productArray:productDic];
                                   [productTableView reloadData];
                                   NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                   [productTableView scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                               }
                           }];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (![Global checkNet]) {
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
    
    if ([Global checkNet]) {
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
-(void)refreshView
{
    [self loadProductData];
    
    [productTableView reloadData];
    [self testFinishedLoadData];
}
//加载调用的方法
-(void)getNextPageView{
    
    page += 1;
    NSString *strUrl = [NSString stringWithFormat:@"%@%i",self.product_url,page];
    NSDictionary *productDic = [Global requestServer:strUrl];
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
