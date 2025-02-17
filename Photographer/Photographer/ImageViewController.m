//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Earl Gerald Mendoza on 3/20/24.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController



- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self startDownloadingImage];
}


- (void)startDownloadingImage
{
    self.image = nil;
    if(self.imageURL) {
        [self.spinner startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
            if(!error) {
                if([request.URL isEqual:self.imageURL]) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                    dispatch_async(dispatch_get_main_queue(), ^{self.image = image;});                }
            }
        }];
        [task resume];
    }
}



- (UIImageView *)imageView
{
    if( !_imageView ) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}


- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

@end
