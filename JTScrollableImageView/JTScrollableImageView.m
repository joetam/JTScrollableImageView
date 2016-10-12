#import "JTScrollableImageView.h"

const CGFloat ScrollableImageViewSnappingThreshold = 30.0f;
const CGFloat ScrollableImageViewAnimationRate = 25.0f; // larger number means faster animation

@interface JTScrollableImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *prevImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGFloat scrollStartX;
@property (nonatomic, assign) CGPoint scrollStartContentOffset;

@end

@implementation JTScrollableImageView

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
    self.nextImageView.frame = CGRectOffset(self.currentImageView.frame, CGRectGetWidth(self.currentImageView.bounds),0);
    self.prevImageView.frame = CGRectOffset(self.currentImageView.frame, -CGRectGetWidth(self.currentImageView.bounds),0);

    self.scrollView.contentSize = [self contentSizeForViews:self.scrollView.subviews];
}

- (void)setDataSource:(id<JTScrollableImageViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self refreshImages];
}

- (void)refreshImages
{
    [self.dataSource currentImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentImageView.image = image;
        });
    }];
    [self.dataSource nextImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nextImageView.image = image;
        });
    }];
    [self.dataSource prevImage:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.prevImageView.image = image;
        });
    }];
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
            [self snapCurrentAnimated:YES];
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

- (void)snapCurrentAnimated:(BOOL)animated
{
    CGPoint offset = CGPointMake(CGRectGetMinX(self.currentImageView.frame), self.scrollView.contentOffset.y);
    if (animated) {
        [self animateOffset:offset completion:nil];
    } else {
        [self.scrollView setContentOffset:offset animated:NO];
    }
}

- (void)snapNext
{
    if (![self.dataSource hasNext]) {
        [self snapCurrentAnimated:YES];
        return;
    }

    CGPoint offset = CGPointMake(CGRectGetMinX(self.nextImageView.frame), self.scrollView.contentOffset.y);
    [self animateOffset:offset completion:^(BOOL finished) {
        [self.dataSource next];
        [self refreshImages];
        [self snapCurrentAnimated:NO];
    }];
}

- (void)snapPrev
{
    if (![self.dataSource hasPrev]) {
        [self snapCurrentAnimated:YES];
        return;
    }

    CGPoint offset = CGPointMake(CGRectGetMinX(self.prevImageView.frame), self.scrollView.contentOffset.y);
    [self animateOffset:offset completion:^(BOOL finished) {
        [self.dataSource prev];
        [self refreshImages];
        [self snapCurrentAnimated:NO];
    }];
}

#pragma mark - Animation

- (void)animateOffset:(CGPoint)offset completion:(void (^)(BOOL finished))completion
{
    CGFloat dx = fabs(self.scrollView.contentOffset.x - offset.x);
    NSTimeInterval duration = (log(dx+0.01)+2)/ScrollableImageViewAnimationRate;  // + 0.01 to avoid log(x) -> INF
    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.scrollView setContentOffset:offset animated:NO];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
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

#pragma mark - Misc

- (void)setContentMode:(UIViewContentMode)contentMode
{
    self.currentImageView.contentMode = contentMode;
    self.nextImageView.contentMode = contentMode;
    self.prevImageView.contentMode = contentMode;
}

@end
