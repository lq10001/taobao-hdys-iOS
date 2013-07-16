

#import "ProductLikeViewController.h"
#import "UserInfoManager.h"
#import "Product.h"
#import "ShopWebViewController.h"

#define kSHOP_ICON  100
#define kSHOP_TITLE  200
#define kSHOP_DEL  300


@interface ProductLikeViewController ()

@end

@implementation ProductLikeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    nameLbl.text = @"喜欢的宝贝";
    [toolView addSubview:nameLbl];
    
        
    productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, toolView.bottom , self.view.width, self.view.height - toolView.height)];
    productTableView.showsHorizontalScrollIndicator = NO;
    productTableView.showsVerticalScrollIndicator = NO;
    productTableView.delegate = self;
    productTableView.dataSource = self;
    [self.view addSubview:productTableView];
    
    
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
    return [[UserInfoManager sharedManager].productArray count];
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
    Product *product = [[UserInfoManager sharedManager].productArray objectAtIndex:indexPath.row];
    [self loadCellView:cell product:product index:indexPath.row];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [[UserInfoManager sharedManager].productArray objectAtIndex:indexPath.row];
    ShopWebViewController *shopWeb = [[ShopWebViewController alloc] initWithNibName:nil bundle:nil];
    shopWeb.shopUrl = product.url;
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

- (void)loadCellView:(UITableViewCell*)cell product:(Product*)product index:(int)index
{
    UIImageView *iv = (UIImageView*)[cell viewWithTag:kSHOP_ICON];
    UILabel *lbl = (UILabel*)[cell viewWithTag:kSHOP_TITLE];

    lbl.text = product.title;
    NSString *str_url = [NSString stringWithFormat:@"%@_60x60.jpg",product.pic_url];
    
    NSURL *imageUrl = [NSURL URLWithString:str_url];
    
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
    Product *product = [[UserInfoManager sharedManager].productArray objectAtIndex:index];

    [[UserInfoManager sharedManager] setSaveProduct:product.num_iid value:NO];
    [[UserInfoManager sharedManager].productArray removeObjectAtIndex:index];
    [productTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
