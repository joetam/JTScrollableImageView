#import "ScrollableImageView.h"

const CGFloat ScrollableImageViewSnappingThreshold = 30.0f;

@interface ScrollableImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *prevImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGFloat scrollStartX;
@property (nonatomic, assign) CGPoint scrollStartContentOffset;

@end

@implementation ScrollableImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollView = [UIScrollView new];
        _currentImageView = [UIImageView new];
        _nextImageView = [UIImageView new];
        _prevImageView = [UIImageView new];
        _currentImageView.userInteractionEnabled = NO;
        _nextImageView.userInteractionEnabled = NO;
        _prevImageView.userInteractionEnabled = NO;

        [self addSubview:_scrollView];
        [_scrollView addSubview:_currentImageView];
        [_scrollView addSubview:_nextImageView];
        [_scrollView addSubview:_prevImageView];

        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [_scrollView addGestureRecognizer:_panRecognizer];
        _scrollView.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.scrollView.frame = self.bounds;

    self.currentImageView.frame = self.scrollView.bounds;

    if ([self.dataSource nextImage]) {
        self.nextImageView.frame = CGRectOffset(self.currentImageView.frame, CGRectGetWidth(self.currentImageView.bounds),0);
    } else {
        self.nextImageView.frame = CGRectZero;
    }

    if ([self.dataSource prevImage]) {
        self.prevImageView.frame = CGRectOffset(self.currentImageView.frame, -CGRectGetWidth(self.currentImageView.bounds),0);
    } else {
        self.prevImageView.frame = CGRectZero;
    }

    self.scrollView.contentSize = [self contentSizeForViews:self.scrollView.subviews];
}

- (void)setDataSource:(id<MultiImageDataSource>)dataSource
{
    _dataSource = dataSource;
    [self refreshImages];
}

- (void)refreshImages
{
    self.currentImageView.image = self.dataSource.currentImage;
    self.prevImageView.image = self.dataSource.prevImage;
    self.nextImageView.image = self.dataSource.nextImage;
}

#pragma mark - Panning logic

- (void)didPan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.scrollStartX = [recognizer locationInView:recognizer.view].x;
        self.scrollStartContentOffset = self.scrollView.contentOffset;
    }

    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat deltaX = [recognizer locationInView:recognizer.view].x - self.scrollStartX;
        CGPoint currentOffset = self.scrollView.contentOffset;
        self.scrollView.contentOffset = CGPointMake(currentOffset.x - deltaX, currentOffset.y);
        self.scrollStartX = [recognizer locationInView:recognizer.view].x;
    }

    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat finalOffset = self.scrollView.contentOffset.x - self.scrollStartContentOffset.x;
        if (fabs(finalOffset) < ScrollableImageViewSnappingThreshold) {
            [self snapCurrent];
        } else {
            if (finalOffset > 0) {
                [self snapNext];
            } else {
                [self snapPrev];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollStartX = scrollView.contentOffset.x;
}

- (void)snapCurrent
{
//    self.scrollView.contentOffset = self.scrollStartContentOffset;
    self.scrollView.contentOffset = CGPointMake(CGRectGetMinX(self.currentImageView.frame), self.scrollView.contentOffset.y);
}

- (void)snapNext
{
    CGPoint offset = CGPointMake(CGRectGetMinX(self.nextImageView.frame), self.scrollView.contentOffset.y);
    [UIView animateWithDuration:0.5 animations:^{
        [self.scrollView setContentOffset:offset animated:YES];
    } completion:^(BOOL finished) {
        [self.dataSource next];
        [self refreshImages];
        [self snapCurrent];
    }];
}

- (void)snapPrev
{
    CGPoint offset = CGPointMake(CGRectGetMinX(self.prevImageView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:offset animated:YES];
}


#pragma mark - Helpers

- (CGSize)contentSizeForViews:(NSArray *)views
{
    if (views.count == 0) {
        return CGSizeZero;
    }
    CGRect result = CGRectZero;
    for (int i = 1; i < views.count; i++) {
        result = CGRectUnion([views[i] frame], result);
    }
    return result.size;
}

@end
