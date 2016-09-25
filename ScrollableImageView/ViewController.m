#import "ViewController.h"
#import "ScrollableImageView.h"
#import "ImageProvider.h"

@interface ViewController ()

@property (nonatomic ,strong) UITextView *textView1;
@property (nonatomic ,strong) UITextView *textView2;
@property (nonatomic, strong) ScrollableImageView *imageView;
@property (nonatomic, strong) ImageProvider *imageProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView1 = [UITextView new];
    self.textView1.text = @"lorem ipsum lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum";
    self.textView1.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200);
    self.textView2 = [UITextView new];
    self.textView2.text = @"lorem ipsum lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum";
    self.textView2.frame = CGRectMake(0, 600, CGRectGetWidth(self.view.frame), 200);
    self.imageView = [ScrollableImageView new];
    self.imageView.frame = CGRectMake(0, 200, CGRectGetWidth(self.view.frame), 400);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageProvider = [ImageProvider new];
    self.imageView.dataSource = self.imageProvider;
    [self.view addSubview:self.textView1];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.textView2];
}

@end
