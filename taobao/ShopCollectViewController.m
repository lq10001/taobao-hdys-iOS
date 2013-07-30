

#import "ShopCollectViewController.h"
#import "UserInfoManager.h"
#import "Shop.h"
#import "ShopWebViewController.h"
#import "ShopTopViewController.h"

#define kSHOP_ICON  100
#define kSHOP_TITLE  200
#define kSHOP_DEL  300
#define kSHOP_CONTAINVIEW  500
#define kSHOP_TAPBTN  600



@interface ShopCollectViewController ()

@end

@implementation ShopCollectViewController

@synthesize shopCollectArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shopCollectArray = [NSMutableArray new];
    [self initArray];
        
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
    nameLbl.text = @"收藏的店铺";
    [toolView addSubview:nameLbl];
    
    UIButton *shopBtn = [UIButton buttonWithNormalImgName:@"addShopBtn" HighlightImgName:@"addShopBtn" target:self selector:@selector(onAdd)];
    shopBtn.center = CGPointMake(self.view.width - 30,toolView.height / 2);
    [toolView addSubview:shopBtn];
        
    shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, toolView.bottom , self.view.width, self.view.height - toolView.height)];
    shopTableView.showsHorizontalScrollIndicator = NO;
    shopTableView.showsVerticalScrollIndicator = NO;
    shopTableView.delegate = self;
    shopTableView.dataSource = self;
    shopTableView.separatorColor=UIColor.clearColor;
    [self.view addSubview:shopTableView];
    
    
    UIButton *backBtn = [UIButton buttonWithNormalImgName:@"product_back" HighlightImgName:@"product_back" target:self selector:@selector(onBack)];
    backBtn.left = 0;
    backBtn.centerY = self.view.centerY - 80;
    [self.view addSubview:backBtn];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initArray];
    [shopTableView reloadData];
}

- (void)initArray
{
    [self.shopCollectArray removeAllObjects];
    for (Shop *shop in [UserInfoManager sharedManager].shopArray) {
        [self.shopCollectArray addObject:shop];
    }
    Shop *addShop = [Shop new];
    addShop.shop_url = @"addshop";
    addShop.name = @"addshop";
    addShop.pic_url = @"addshop";
    [self.shopCollectArray addObject:addShop];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onAdd
{
    ShopTopViewController *vc = [[ShopTopViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.shopCollectArray count];
    if (count % 3 > 0) {
        count = count / 3 + 1;
    }else{
        count = count / 3;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
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
//    Shop *shop = [[UserInfoManager sharedManager].shopArray objectAtIndex:indexPath.row];
    int index = indexPath.row * 3;
    
    for (int i = 0 ; i < 3; i++) {
        [self loadCellView:cell index:(index + i) cellIndex:i];
    }    

    return cell;
}


- (void)createCellView:(UITableViewCell*)cell
{
    
    int width = self.view.width / 3;
    for (int i = 0; i < 3; i++)
    {
        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, 130)];
        containView.tag = kSHOP_CONTAINVIEW + i;
        containView.backgroundColor = [UIColor clearColor];
        [cell addSubview:containView];
        
        containView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShop:)];
        tap.delegate = self;
        [containView addGestureRecognizer:tap];
        UILongPressGestureRecognizer *tap2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self  action:@selector(onLong:)];
        tap2.minimumPressDuration = 1.0f;
        [containView addGestureRecognizer:tap2];
        
        UILabel *numLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        numLbl.tag = kSHOP_TAPBTN;
        [containView addSubview:numLbl];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,5, 100, 100)];
        iv.tag = kSHOP_ICON;
        iv.centerX = containView.width / 2;
        [containView addSubview:iv];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, iv.bottom + 2, containView.width, 20)];
        titleLbl.tag = kSHOP_TITLE;
        titleLbl.centerX = containView.width / 2;
        titleLbl.textAlignment = UITextAlignmentCenter;
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.textColor = [UIColor redColor];
        titleLbl.font = [UIFont systemFontOfSize:12.0f];
        [containView addSubview:titleLbl];
        
        UIButton *delBtn = [UIButton buttonWithNormalImgName:@"rmoneshop" HighlightImgName:@"rmoneshop" target:self selector:@selector(onDel:)];
        delBtn.size = CGSizeMake(40, 40);
        delBtn.tag = kSHOP_DEL;
        delBtn.center = CGPointMake(20,20);
        [containView addSubview:delBtn];
        delBtn.layer.borderColor = [[UIColor redColor] CGColor];
        delBtn.layer.borderWidth = 1.0f;
    }

}

- (void)loadCellView:(UITableViewCell*)cell  index:(int)index cellIndex:(int)cellIndex
{
    int count = [self.shopCollectArray count];
    
    UIView *containView = [cell viewWithTag:kSHOP_CONTAINVIEW + cellIndex];
    if ((index + 1) > count) {
        containView.hidden = YES;
    }else{
        containView.hidden = NO;
        UIImageView *iv = (UIImageView*)[containView viewWithTag:kSHOP_ICON];
        UILabel *lbl = (UILabel*)[containView viewWithTag:kSHOP_TITLE];
        UILabel *numLbl = (UILabel*)[containView viewWithTag:kSHOP_TAPBTN];
        UIButton *delBtn = (UIButton*)[containView viewWithTag:kSHOP_DEL];
        
        numLbl.text = [NSString stringWithFormat:@"%i",index];
                
        Shop *shop = [self.shopCollectArray objectAtIndex:index];
        if ([shop.name isEqualToString:@"addshop"]) {
            delBtn.hidden = YES;
            numLbl.hidden = YES;
            lbl.hidden = YES;
            iv.image = [UIImage imageNamedAuto:@"addshop"];
        }else{
            delBtn.hidden = ! isDel;
            
            lbl.text = shop.name;
            NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kSERVER_URL,shop.pic_url]];
            if (imageUrl)
            {
                __block UIActivityIndicatorView *activityIndicator;
                __weak UIImageView *weakImageView = iv;
                [iv setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
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
        }
    }
    
}


- (void)onShop:(UIGestureRecognizer*)tap
{
    if (isDel) {
        isDel = NO;
        [shopTableView reloadData];
    }else{
        UILabel *numLbl = (UILabel*)[tap.view viewWithTag:kSHOP_TAPBTN];
        int index = [numLbl.text intValue];
        
        if ((index + 1) == [self.shopCollectArray count]) {
            [self onAdd];
        }else{
            Shop *shop = [self.shopCollectArray objectAtIndex:index];
            ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
            shopWeb.shopUrl = shop.shop_url;
            [self.navigationController pushViewController:shopWeb animated:YES];
        }
    }
    
}

- (void)onDel:(UIButton*)btn
{
    //    UILabel *lbl = (UILabel*)[productScrView viewWithTag:kSHOP_LBL_TAG + index];
    
    //    [btn1 removeFromSuperview];
    //    [lbl removeFromSuperview];
    UILabel *numLbl = (UILabel*)[btn.superview viewWithTag:kSHOP_TAPBTN];
    int index = [numLbl.text intValue];
    
    Shop *shop = [self.shopCollectArray objectAtIndex:index];
    [[UserInfoManager sharedManager].shopArray removeObject:shop];
    [[UserInfoManager sharedManager] setSaveShop:shop.name value:NO];
    [[UserInfoManager sharedManager] saveShopArray];
    [[UserInfoManager sharedManager] saveUserData];
    [self initArray];
    [shopTableView reloadData];
 

}

- (void)onLong:(UIGestureRecognizer*)tap
{
    isDel = YES;
    [shopTableView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
