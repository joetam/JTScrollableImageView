#import <UIKit/UIKit.h>
#import "MultiImageDataSource.h"

@interface JTScrollableImageView : UIView

@property (nonatomic, weak) id<MultiImageDataSource> dataSource;

@end
