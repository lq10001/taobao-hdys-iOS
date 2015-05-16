

#import "InfoCell.h"
#import "UIViewAdditions.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kPRODUCT_IV_TAG     100
#define kTITLE_LBL_TAG     110
#define kPRICE_LBL_TAG     120


@implementation InfoCell

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
        
    }
    return self;
}

- (void)loadView:(NSString*)imageName
{
    UIImageView *iv = (UIImageView*)[self viewWithTag:kPRODUCT_IV_TAG];
        
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *str_url = [NSString stringWithFormat:@"%@_640x640.jpg",imageName];
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
