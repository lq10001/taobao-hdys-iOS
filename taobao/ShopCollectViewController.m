

#import "ShopCollectViewController.h"
#import "UserInfoManager.h"
#import "Shop.h"
#import "ShopWebViewController.h"
#import "ShopTopViewController.h"

#define kSHOP_ICON  100
#define kSHOP_TITLE  200
#define kSHOP_DEL  300
#define kSHOP_CONTAINVIEW  500



@interface ShopCollectViewController ()

@end

@implementation ShopCollectViewController

@synthesize shopCollectArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shopCollectArray = [NSMutableArray new];
    for (Shop *shop in [UserInfoManager sharedManager].shopArray) {
        [self.shopCollectArray addObject:shop];
    }
    Shop *addShop = [Shop new];
    addShop.shop_url = @"addshop";
    addShop.name = @"addshop";
    addShop.pic_url = @"addshop";
    [self.shopCollectArray addObject:addShop];
        
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
    
        
    shopTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, toolView.bottom , self.view.width, self.view.height - toolView.height)];
    shopTableView.showsHorizontalScrollIndicator = NO;
    shopTableView.showsVerticalScrollIndicator = NO;
    shopTableView.delegate = self;
    shopTableView.dataSource = self;
    shopTableView.separatorColor=UIColor.clearColor;
    [self.view addSubview:shopTableView];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addBtn.frame = CGRectMake(nameLbl.right + 5, 0, 40, 30);
    addBtn.centerY = 30;
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont fontWithName:@"helvetica" size:12];
    [addBtn addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:addBtn];

    
    
    UIButton *backBtn = [UIButton buttonWithNormalImgName:@"product_back" HighlightImgName:@"product_back" target:self selector:@selector(onBack)];
    backBtn.left = 0;
    backBtn.centerY = self.view.centerY - 80;
    [self.view addSubview:backBtn];

    
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
        [self createCellView:cell];
    }
//    Shop *shop = [[UserInfoManager sharedManager].shopArray objectAtIndex:indexPath.row];
    int index = indexPath.row * 3;
    
    for (int i = 0 ; i < 3; i++) {
        [self loadCellView:cell index:(index + i) cellIndex:i];
    }    

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shop *shop = [[UserInfoManager sharedManager].shopArray objectAtIndex:indexPath.row];
    ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
    shopWeb.shopUrl = shop.shop_url;
    [self.navigationController pushViewController:shopWeb animated:YES];
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
        
//        containView.layer.borderColor = [[UIColor redColor] CGColor];
//        containView.layer.borderWidth = 1.0f;
    }
    
    
    
    
    /*
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    delBtn.tag = kSHOP_DEL;
    delBtn.frame = CGRectMake(titleLbl.right + 5, 0, 40, 30);
    delBtn.centerY = 30;
    delBtn.backgroundColor = [UIColor whiteColor];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];                      
    delBtn.titleLabel.font = [UIFont fontWithName:@"helvetica" size:12];
    [delBtn addTarget:self action:@selector(onDel:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:delBtn];
     */

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
        //    UIButton *btn = (UIButton*)[cell viewWithTag:kSHOP_DEL];
        Shop *shop = [self.shopCollectArray objectAtIndex:index];
        if ([shop.name isEqualToString:@"addshop"]) {
            iv.image = [UIImage imageNamedAuto:@"addshop"];
        }else{
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    Shop *shop = [[UserInfoManager sharedManager].shopArray objectAtIndex:index];
    [[UserInfoManager sharedManager] setSaveShop:shop.name value:NO];
    [[UserInfoManager sharedManager].shopArray removeObjectAtIndex:index];
    [shopTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
