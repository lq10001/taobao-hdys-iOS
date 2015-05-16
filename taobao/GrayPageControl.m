

#import "GrayPageControl.h"

@implementation GrayPageControl

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    activeImage = [UIImage imageNamed:@"page1.png"];
    inactiveImage = [UIImage imageNamed:@"page2.png"];
    return self;
}
-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* view1 = [self.subviews objectAtIndex:i];
        if ([view1 isKindOfClass:[UIImageView class]]) {
            UIImageView *dot = (UIImageView*)view1;
            if (i == self.currentPage)
            {
                dot.image = activeImage;
            }
            else
            {
                dot.image = inactiveImage;
            }
        }        
    }
}
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}



@end
