

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ParentViewController.h"

typedef enum {
    Favorite,
    Comment,
    Shared,
    Like,
}ToolType;

@interface ProductInfoViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)int productId;
@property(nonatomic,strong)Product *product;
@property(nonatomic,strong)UIView *tsView;

@property(nonatomic,strong)NSMutableArray *productImgArray;


@end
