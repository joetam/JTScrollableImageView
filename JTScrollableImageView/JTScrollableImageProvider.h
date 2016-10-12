#import <Foundation/Foundation.h>
#import "JTScrollableImageView.h"

@interface JTScrollableImageProvider : NSObject <JTScrollableImageViewDataSource>

/**
 *  @param imageURLS an array of NSURLs pointing to the images to be displayed.
 *  @discussion supports http, https and file
 */
- (instancetype)initWithURLs:(NSArray *)imageURLs NS_DESIGNATED_INITIALIZER;

@end
