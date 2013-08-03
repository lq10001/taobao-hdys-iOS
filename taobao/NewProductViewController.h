

#import <UIKit/UIKit.h>
#import "ParentViewController.h"
#import "PersonView.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "ShopView.h"


@interface MainViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableDelegate,PersonViewDelegate,ShopViewDelegate>
{
    int page;
    UITableView *productTableView;
    
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    //
    BOOL _reloading;
}

@property(nonatomic,strong)NSMutableArray *productArray;
@property(nonatomic,strong)ShopView *shopView;
@property(nonatomic,strong)UIImageView *flipIv;
@property(nonatomic,strong)UIButton *shopBtn;
@property(nonatomic,strong)NSString *product_url;



@end
