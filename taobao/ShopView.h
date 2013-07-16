

#import <UIKit/UIKit.h>
#import "DWTagList.h"
#import "ParentViewController.h"
#import "GrayPageControl.h"

@protocol ShopViewDelegate <NSObject>

@optional

- (void)shopViewReturn:(int)type;

@end

@class MainViewController;
@interface ShopView : UIView<UIScrollViewDelegate,UISearchBarDelegate,DWTagListDelegate,UITextFieldDelegate>
{
    UIScrollView* productScrView;
    GrayPageControl* pageCtrl;
    
    UIView *searchView;
    
    NSArray *searchArray;

    DWTagList *tagList;
    int keyBordeTop;
}
@property(nonatomic,assign)id<ShopViewDelegate> delegate;
@property(nonatomic)int modelId;
@property(nonatomic,strong)NSMutableArray *shopArray;
@property(nonatomic,strong)UIView *tsView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UITextField *txtSearch;
@property(nonatomic,assign)UIViewController *parentVc;




@end
