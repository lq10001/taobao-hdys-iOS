

#import "PersonView.h"
#import "UIViewAdditions.h"


@implementation PersonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6f;
        [self addSubview:bgView];
        bgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBack)];
        [bgView addGestureRecognizer:tap];
        
        //new
        UIButton *newBtn = [UIButton buttonWithNormalImgName:@"person_btn_bg1" HighlightImgName:@"person_btn_bg1" target:self selector:@selector(onPerson:)];
        newBtn.tag = NewType;
        newBtn.center = CGPointMake(self.width / 2 - 60,self.height / 2 - 60);
        [self addSubview:newBtn];
        
        UIImageView *newIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_new"]];
        newIv.frame = CGRectMake(0, 0, newIv.bWidth / 2, newIv.bHeight / 2);
        newIv.center = CGPointMake(newBtn.centerX, newBtn.centerY - 5);
        [self addSubview:newIv];
        
        UILabel *newLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newBtn.width, 30)];
        newLbl.center = CGPointMake(newBtn.centerX, newBtn.centerY + 30);
        newLbl.textAlignment = UITextAlignmentCenter;
        newLbl.backgroundColor = [UIColor clearColor];
        newLbl.textColor = [UIColor whiteColor];
        newLbl.font = [UIFont systemFontOfSize:16.0f];
        newLbl.text = @"新品推荐";
        [self addSubview:newLbl];

        
        //sale
        UIButton *saleBtn = [UIButton buttonWithNormalImgName:@"person_btn_bg1" HighlightImgName:@"person_btn_bg1" target:self selector:@selector(onPerson:)];
        saleBtn.tag = SaleType;
        saleBtn.center = CGPointMake(self.width / 2 + 60,self.height / 2 - 60);
        [self addSubview:saleBtn];
        
        UIImageView *saleIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_sale"]];
        saleIv.frame = CGRectMake(0, 0, saleIv.bWidth / 2, saleIv.bHeight / 2);
        saleIv.center = CGPointMake(saleBtn.centerX, saleBtn.centerY - 5);
        [self addSubview:saleIv];
        
        UILabel *saleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newBtn.width, 30)];
        saleLbl.center = CGPointMake(saleBtn.centerX, saleBtn.centerY + 30);
        saleLbl.textAlignment = UITextAlignmentCenter;
        saleLbl.backgroundColor = [UIColor clearColor];
        saleLbl.textColor = [UIColor whiteColor];
        saleLbl.font = [UIFont systemFontOfSize:16.0f];
        saleLbl.text = @"销售排行";
        [self addSubview:saleLbl];

        
        //shop
        UIButton *shopBtn = [UIButton buttonWithNormalImgName:@"person_btn_bg1" HighlightImgName:@"person_btn_bg1" target:self selector:@selector(onPerson:)];
        shopBtn.tag = ShopType;
        shopBtn.center = CGPointMake(self.width / 2 - 60,self.height / 2 + 60);
        [self addSubview:shopBtn];
        
        UIImageView *shopIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_shop"]];
        shopIv.frame = CGRectMake(0, 0, shopIv.bWidth / 2, shopIv.bHeight / 2);
        shopIv.center = CGPointMake(shopBtn.centerX, shopBtn.centerY - 5);
        [self addSubview:shopIv];
        
        UILabel *shopLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newBtn.width, 30)];
        shopLbl.center = CGPointMake(shopBtn.centerX, shopBtn.centerY + 30);
        shopLbl.textAlignment = UITextAlignmentCenter;
        shopLbl.backgroundColor = [UIColor clearColor];
        shopLbl.textColor = [UIColor whiteColor];
        shopLbl.font = [UIFont systemFontOfSize:16.0f];
        shopLbl.text = @"收藏的店铺";
        [self addSubview:shopLbl];

        
        //product
        UIButton *productBtn = [UIButton buttonWithNormalImgName:@"person_btn_bg1" HighlightImgName:@"person_btn_bg1" target:self selector:@selector(onPerson:)];
        productBtn.tag = ProductType;
        productBtn.center = CGPointMake(self.width / 2 + 60,self.height / 2 + 60);
        [self addSubview:productBtn];
        
        UIImageView *productIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_product"]];
        productIv.frame = CGRectMake(0, 0, productIv.bWidth / 2, productIv.bHeight / 2);
        productIv.center = CGPointMake(productBtn.centerX, productBtn.centerY - 5);
        [self addSubview:productIv];
        
        UILabel *productLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, newBtn.width, 30)];
        productLbl.center = CGPointMake(productBtn.centerX, productBtn.centerY + 30);
        productLbl.textAlignment = UITextAlignmentCenter;
        productLbl.backgroundColor = [UIColor clearColor];
        productLbl.textColor = [UIColor whiteColor];
        productLbl.font = [UIFont systemFontOfSize:16.0f];
        productLbl.text = @"收藏的宝贝";
        [self addSubview:productLbl];
    }
    return self;
}

- (void)onPerson:(UIButton*)btn
{
    [self.delegate personRtn:btn.tag];
    [self onBack];
}

- (void)onBack
{
    [UIView animateWithDuration:0.8f
                     animations:^{
                         self.alpha = 0.0f;
                     } completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}


@end
