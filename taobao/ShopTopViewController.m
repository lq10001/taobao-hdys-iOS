

#import "ShopTopViewController.h"
#import "UserInfoManager.h"
#import "Shop.h"
#import "ShopWebViewController.h"

#define kSHOP_ICON  100
#define kSHOP_TITLE  200
#define kSHOP_ADD  300


@interface ShopTopViewController ()

@end

@implementation ShopTopViewController


@synthesize shopArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    adDic = NSDictionary.new;
    if ([Global checkNet]){
        NSDictionary *rtnDic = [Global requestServer:kSHOP_URL];
        adDic = [rtnDic objectForKey:@"ad_list"];
        
        self.shopArray = NSMutableArray.new;
        for (NSDictionary *dic in adDic) {
            Shop *shop = [[Shop alloc] init];
            shop.name = [dic objectForKey:@"name"];
            shop.pic_url = [dic objectForKey:@"imgurl"];
            shop.shop_url = [dic objectForKey:@"shopurl"];
            [self.shopArray addObject:shop];
        }
    }
    
    UIImageView *titleIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_title"]];
    titleIv.frame = CGRectMake(0, 0, titleIv.bWidth / 2, titleIv.bHeight / 2);
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, titleIv.height)];
    toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:toolView];
    [toolView addSubview:titleIv];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width, toolView.height)];
    nameLbl.center = CGPointMake(toolView.width / 2, toolView.height / 2);
    nameLbl.textAlignment = UITextAlignmentCenter;
    nameLbl.backgroundColor = [UIColor clearColor];
    nameLbl.textColor = [UIColor whiteColor];
    nameLbl.font = [UIFont systemFontOfSize:18.0f];
    nameLbl.text = @"最受买家欢迎天猫品牌TOP20";
    [toolView addSubview:nameLbl];
    
        
    shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, toolView.bottom , self.view.width, self.view.height - toolView.height)];
    shopTableView.showsHorizontalScrollIndicator = NO;
    shopTableView.showsVerticalScrollIndicator = NO;
    shopTableView.delegate = self;
    shopTableView.dataSource = self;
    [self.view addSubview:shopTableView];
    
    
    UIButton *backBtn = [UIButton buttonWithNormalImgName:@"product_back" HighlightImgName:@"product_back" target:self selector:@selector(onBack)];
    backBtn.left = 0;
    backBtn.centerY = self.view.centerY - 80;
    [self.view addSubview:backBtn];

    
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return adDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [self createCellView:cell];
    }
    Shop *shop = [shopArray objectAtIndex:indexPath.row];
    [self loadCellView:cell shop:shop index:indexPath.row];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shop *shop = [shopArray objectAtIndex:indexPath.row];
    ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
    shopWeb.shopUrl = shop.shop_url;
    [self.navigationController pushViewController:shopWeb animated:YES];
}


- (void)createCellView:(UITableViewCell*)cell
{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 50, 50)];
    iv.tag = kSHOP_ICON;
    iv.center = CGPointMake(30, 30);
    [cell addSubview:iv];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(iv.right + 10, 0, 200, 30)];
    titleLbl.tag = kSHOP_TITLE;
    titleLbl.centerY = 30;
    titleLbl.textAlignment = UITextAlignmentLeft;
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [cell addSubview:titleLbl];
    
    
    UIButton *delBtn = [UIButton buttonWithNormalImgName:@"addonshop" selectedImgName:@"rmoneshop"  target:self selector:@selector(onAdd:)];
    delBtn.tag = kSHOP_ADD;
    delBtn.left = titleLbl.right + 10;
    delBtn.centerY = 30;
    delBtn.backgroundColor = [UIColor whiteColor];
    [cell addSubview:delBtn];
}

- (void)loadCellView:(UITableViewCell*)cell shop:(Shop*)shop index:(int)index
{
    UIImageView *iv = (UIImageView*)[cell viewWithTag:kSHOP_ICON];
    UILabel *lbl = (UILabel*)[cell viewWithTag:kSHOP_TITLE];
    UIButton *btn = (UIButton*)[cell viewWithTag:kSHOP_ADD];

    lbl.text = shop.name;
    btn.titleLabel.tag = index;
    if([[UserInfoManager sharedManager] isSaveShop:shop.name])
    {
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
    
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kSERVER_URL,shop.pic_url]];
    
    if (imageUrl)
    {
        __block UIActivityIndicatorView *activityIndicator;
        __weak UIImageView *weakImageView = iv;
        [iv sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!activityIndicator)
            {
                [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                activityIndicator.center = weakImageView.center;
                [activityIndicator startAnimating];
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }];
    }
}




- (void)onAdd:(UIButton*)btn
{
    int index = btn.titleLabel.tag;
    //    UILabel *lbl = (UILabel*)[productScrView viewWithTag:kSHOP_LBL_TAG + index];
    
    //    [btn1 removeFromSuperview];
    //    [lbl removeFromSuperview];
    Shop *shop = [self.shopArray objectAtIndex:index];
    if ([[UserInfoManager sharedManager] isSaveShop:shop.name]) {
        btn.selected = NO;
        [[UserInfoManager sharedManager].shopArray removeObject:shop];
        [[UserInfoManager sharedManager] setSaveShop:shop.name value:NO];
        [[UserInfoManager sharedManager] saveShopArray];
        [[UserInfoManager sharedManager] saveUserData];
        [shopTableView reloadData];
    }else{
        btn.selected = YES;
        [[UserInfoManager sharedManager].shopArray addObject:shop];
        [[UserInfoManager sharedManager] setSaveShop:shop.name value:YES];
        [[UserInfoManager sharedManager] saveShopArray];
        [[UserInfoManager sharedManager] saveUserData];
        [shopTableView reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
