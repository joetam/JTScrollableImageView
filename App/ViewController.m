#import "ViewController.h"
#import "JTScrollableImageView.h"
#import "JTScrollableImageProvider.h"

@interface ViewController ()

@property (nonatomic, strong) JTScrollableImageView *imageView;
@property (nonatomic, strong) JTScrollableImageProvider *imageProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:79/255.0 alpha:1.0];

    self.imageView = [JTScrollableImageView new];
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 330);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageProvider = [JTScrollableImageProvider new];
    self.imageView.dataSource = self.imageProvider;
    [self.view addSubview:self.imageView];
}

@end
