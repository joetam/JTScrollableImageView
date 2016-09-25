#import <UIKit/UIKit.h>
#import "MultiImageDataSource.h"

@interface ScrollableImageView : UIView

@property (nonatomic, weak) id<MultiImageDataSource> dataSource;

@end
