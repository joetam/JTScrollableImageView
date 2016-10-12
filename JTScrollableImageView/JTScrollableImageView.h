#import <UIKit/UIKit.h>
#import "JTScrollableImageViewDataSource.h"

@interface JTScrollableImageView : UIView

@property (nonatomic, weak) id<JTScrollableImageViewDataSource> dataSource;

@end
