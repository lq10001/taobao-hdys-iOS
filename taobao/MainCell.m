

#import "MainCell.h"
#import "UIViewAdditions.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kPRODUCT_IV_TAG     100
#define kTITLE_LBL_TAG     110
#define kPRICE_LBL_TAG     120


@implementation MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        view1.backgroundColor = [UIColor whiteColor];
        [self addSubview:view1];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10,5, 300, 300)];
        iv.tag = kPRODUCT_IV_TAG;
        [view1 addSubview:iv];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, iv.bottom + 5, 260, 20)];
        titleLbl.tag = kTITLE_LBL_TAG;
        titleLbl.textAlignment = UITextAlignmentLeft;
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.textColor = [UIColor blackColor];
        
        titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [view1 addSubview:titleLbl];
        
        UILabel *tsLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x + 20, titleLbl.bottom, 50, 20)];
        tsLbl.textAlignment = UITextAlignmentRight;
        tsLbl.backgroundColor = [UIColor clearColor];
        tsLbl.textColor = [UIColor blackColor];
        tsLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        tsLbl.text = @"只需";
        [view1 addSubview:tsLbl];

        
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLbl.bottom, 100, 20)];
        priceLbl.left = tsLbl.right;
        priceLbl.tag = kPRICE_LBL_TAG;
        priceLbl.textAlignment = UITextAlignmentLeft;
        priceLbl.backgroundColor = [UIColor clearColor];
        priceLbl.textColor = [UIColor redColor];
        priceLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [view1 addSubview:priceLbl];
        
    }
    return self;
}

- (void)loadView:(NSString*)imageName title:(NSString*)title price:(NSString*)price
{
    UIImageView *iv = (UIImageView*)[self viewWithTag:kPRODUCT_IV_TAG];
    UILabel *titleLbl = (UILabel*)[self viewWithTag:kTITLE_LBL_TAG];
    UILabel *priceLbl = (UILabel*)[self viewWithTag:kPRICE_LBL_TAG];
    
    titleLbl.text = title;
    priceLbl.text = [NSString stringWithFormat:@"%@",price];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *str_url = [NSString stringWithFormat:@"%@_600x600.jpg",imageName];
    NSURL *imageUrl = [NSURL URLWithString:str_url];
    
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
    
//    [iv setImageWithURL:[NSURL URLWithString:imageName]
//                   placeholderImage:[UIImage imageNamed:@"placeholder"] options: SDWebImageRefreshCached];
//    
//    iv.image = [UIImage imageNamed:imageName];
}



@end
