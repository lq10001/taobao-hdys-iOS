

#import "ProductInfoViewController.h"
#import "UIViewAdditions.h"
#import "UMSocial.h"
#import "ShopWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfo.h"
#import "UserInfoManager.h"
#import "InfoCell.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController

@synthesize product;
@synthesize tsView;
@synthesize productImgArray;
@synthesize productTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.productImgArray = [[NSMutableArray alloc] init];
    [self.productImgArray addObject:self.product.pic_url];

    self.productTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.productTableView.showsHorizontalScrollIndicator = NO;
    self.productTableView.showsVerticalScrollIndicator = NO;
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    [self.view addSubview:self.productTableView];

    
    UIImageView *priceIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_price"]];
    priceIv.frame = CGRectMake(0,0,priceIv.bWidth / 2,priceIv.bHeight / 2);
    
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0,0,priceIv.width,priceIv.height)];
    priceView.right = self.view.width+5;
    priceView.top = self.view.height - (IS_IPHONE_5 ? 120 : 100);
    [self.view addSubview:priceView];
    [priceView addSubview:priceIv];
    
    priceView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetail)];
    [priceView addGestureRecognizer:tap];

    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, priceIv.width, 20)];
    priceLbl.centerY = priceView.height / 2;
    priceLbl.textAlignment = UITextAlignmentLeft;
    priceLbl.backgroundColor = [UIColor clearColor];
    priceLbl.textColor = [UIColor whiteColor];
    priceLbl.font = [UIFont systemFontOfSize:12.0f];
    priceLbl.text = [NSString stringWithFormat:@"%@ | 查看详情",self.product.price];
    [priceView addSubview:priceLbl];

    
    UIImageView *barIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"product_bar"]];
    barIv.frame = CGRectMake(0,0,barIv.bWidth / 2,barIv.bHeight / 2);
        
    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.height - barIv.height + 5,barIv.width,barIv.height)];
    toolBarView.centerX = self.view.width / 2;
    [self.view addSubview:toolBarView];
    [toolBarView addSubview:barIv];
    
    UIButton *likeBtn = [UIButton buttonWithNormalImgName:@"like" selectedImgName:@"like2" target:self selector:@selector(onLike:)];
    likeBtn.center = CGPointMake(toolBarView.width / 2 - 45,toolBarView.height / 2 - 5);
    [toolBarView addSubview:likeBtn];
    
    likeBtn.selected = [[UserInfoManager sharedManager] isSaveProduct:self.product.num_iid];

    
    UILabel *likeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, likeBtn.bottom, 60, 20)];
    likeLbl.centerX = likeBtn.centerX;
    likeLbl.textAlignment = UITextAlignmentCenter;
    likeLbl.backgroundColor = [UIColor clearColor];
    likeLbl.textColor = [UIColor whiteColor];
    likeLbl.font = [UIFont systemFontOfSize:12.0f];
    likeLbl.text = @"收藏";
    [toolBarView addSubview:likeLbl];
    
    
    UIButton *shareBtn = [UIButton buttonWithNormalImgName:@"product_share" HighlightImgName:@"product_share" target:self selector:@selector(onShare)];
    shareBtn.center = CGPointMake(toolBarView.width / 2 + 45,toolBarView.height / 2 - 5);
    [toolBarView addSubview:shareBtn];
    
    UILabel *shareLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, shareBtn.bottom, 60, 20)];
    shareLbl.centerX = shareBtn.centerX;
    shareLbl.textAlignment = UITextAlignmentCenter;
    shareLbl.backgroundColor = [UIColor clearColor];
    shareLbl.textColor = [UIColor whiteColor];
    shareLbl.font = [UIFont systemFontOfSize:12.0f];
    shareLbl.text = @"分享";
    [toolBarView addSubview:shareLbl];
    
    UIButton *backBtn = [UIButton buttonWithNormalImgName:@"product_back" HighlightImgName:@"product_back" target:self selector:@selector(onBack)];
    backBtn.left = 0;
    backBtn.centerY = self.view.centerY - 80;
    [self.view addSubview:backBtn];
    
    self.tsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 35)];
    self.tsView.centerX = self.view.centerX;
    self.tsView.bottom = toolBarView.top - 20;
    self.tsView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tsView];
    self.tsView.hidden = YES;
    
    UILabel *tsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tsView.width, self.tsView.height)];
    tsLbl.textAlignment = UITextAlignmentCenter;
    tsLbl.backgroundColor = [UIColor clearColor];
    tsLbl.textColor = [UIColor whiteColor];
    tsLbl.font = [UIFont systemFontOfSize:16.0f];
    tsLbl.text = @"收藏产品成功!";
    [self.tsView addSubview:tsLbl];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSThread  *thread =[[NSThread alloc] initWithTarget:self selector:@selector(loadData) object:nil];
    [thread start];
}

- (void)loadData
{
    NSString *url1 = [NSString stringWithFormat:@"%@%i",kPRODUCTIMG_URL,self.product.productid];
    
    DLog(@" %i  %@ ",self.product.productid,self.product.pic_url);
    
    NSDictionary *rtnDic = [Global requestServer:url1];
    NSDictionary *adDic = [rtnDic objectForKey:@"productimg_list"];
    for (NSDictionary *dic in adDic) {
        [self.productImgArray addObject:[dic objectForKey:@"imgurl"]];
    }
    [self.productTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onToolBtn:(UIButton*)btn
{
    switch (btn.tag) {
        case Favorite:
            
            break;
        case Comment:
            break;
        case Shared:
        {
            [self onShare];
            /*
            UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"UMSocialSDK" withTitle:nil];
            socialData.shareText = @"test";
            socialData.shareImage =[UIImage imageNamedAuto:[NSString stringWithFormat:@"%i.jpg",self.productId]];
            
            UMSocialControllerService *socialControllerService = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
            UINavigationController *shareListController = [socialControllerService getSocialShareListController];
            [self presentModalViewController:shareListController animated:YES];
             */
            break;
        }
        case Like:
            break;
        default:
            break;
    }
    DLog(@" %i ",btn.tag);
}

- (void)onLike:(UIButton*)btn
{
    if ([[UserInfoManager sharedManager] isSaveProduct:self.product.num_iid]) {
        btn.selected = NO;
        [[UserInfoManager sharedManager].productArray removeObject:product];
        [[UserInfoManager sharedManager] setSaveProduct:self.product.num_iid value:NO];
        [[UserInfoManager sharedManager] saveProductArray];
        [[UserInfoManager sharedManager] saveUserData];
    }else{
        btn.selected = YES;
        [[UserInfoManager sharedManager].productArray addObject:self.product];
        [[UserInfoManager sharedManager] setSaveProduct:self.product.num_iid value:YES];
        [[UserInfoManager sharedManager] saveProductArray];
        [[UserInfoManager sharedManager] saveUserData];
        
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

- (void)onDetail
{
    DLog(@"");
    ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
    shopWeb.shopUrl = [NSString stringWithFormat:@"%@%@",kTAOBAO_CLICK_URL,self.product.url];
    [self.navigationController pushViewController:shopWeb animated:YES];
}

- (void)onShare
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size,NO,kScreenScale); //currentView 当前的view
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:kUMENG_KEY
                                      shareText:@"韩都衣舍旗舰店 http://handuyishe.m.tmall.com/shop/shop_index.htm?sid=d01d10e83cd4a09d&shop_id=58501945"
                                     shareImage:viewImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechat,UMShareToQzone,UMShareToEmail,nil]
                                       delegate:nil];


}

#pragma mark - UITableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productImgArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    InfoCell *cell = (InfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[InfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //    NSString *imageName = [self.array objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    [cell loadView:[self.productImgArray objectAtIndex:indexPath.row] ];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
