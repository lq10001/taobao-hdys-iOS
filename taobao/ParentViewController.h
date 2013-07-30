

#import <UIKit/UIKit.h>
#import "Global.h"
#import "UIViewAdditions.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ParentViewController : UIViewController<NSURLConnectionDelegate>

- (NSDictionary*)requestServer:(NSString*)str_url;
- (BOOL)checkNet;

@end
