//
//  PIXYFeedViewController.m
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYFeedViewController.h"
#import "PIXYUtilities.h"
#import "PIXYFeedTableViewCell.h"
#import "PIXYPostsDatasource.h"
#import "PIXYPostModel.h"
#import "PIXYImageViewController.h"
#import <POP/POP.h>
@import SVPullToRefresh;

@interface PIXYFeedViewController ()    <UITableViewDelegate,
                                        UITableViewDataSource,
                                        PIXYFeedTableViewCellDelegate>

@property (strong, nonatomic) PIXYPostsDatasource *postsDatasource;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (nonatomic, strong) UIView *refreshView;
@property (nonatomic, strong) UIView *loadMoreView;

@end

@implementation PIXYFeedViewController

static NSString *kPostsTableViewCellIdentifier = @"pixy_feedCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"r/pics";
    [self setupTableView];
    [self fetchPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTableView
{
    UINib *cellNib = [UINib nibWithNibName:@"PIXYFeedTableViewCell" bundle:nil];
    [self.postsTableView registerNib:cellNib
              forCellReuseIdentifier:kPostsTableViewCellIdentifier];
    self.postsTableView.rowHeight = UITableViewAutomaticDimension;
    self.postsTableView.estimatedRowHeight = 132.0;
    
    [self.postsTableView addPullToRefreshWithActionHandler:^{
        [self refreshDatasource];
    }];
    
    [self.postsTableView addInfiniteScrollingWithActionHandler:^{
        
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.postsTableView.pullToRefreshView setCustomView:self.refreshView
                                                forState:SVPullToRefreshStateAll];
    
    [self.postsTableView.infiniteScrollingView setCustomView:self.loadMoreView
                                                    forState:SVInfiniteScrollingStateAll];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObservers];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeObservers];
}

#pragma ------------------------------------------------------------------------
#pragma mark - Object Creators
#pragma ------------------------------------------------------------------------

- (PIXYPostsDatasource *)postsDatasource
{
    return !_postsDatasource ? _postsDatasource =
    ({
        PIXYPostsDatasource *object = [[PIXYPostsDatasource alloc] init];
        object;
    }) : _postsDatasource;
}

- (UIView *)refreshView
{
    return !_refreshView ? _refreshView =
    ({
        UIView *object = [[UIView alloc] initWithFrame:self.postsTableView.pullToRefreshView.bounds];
        [object setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Activity Indicator Dark"]];
        [object addSubview:imageView];
        [PIXYUtilities centerView:imageView];
        
        POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotationAnimation.duration = 0.8f;
        rotationAnimation.toValue = @(M_PI * 2.0f);
        rotationAnimation.repeatForever = YES;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [imageView.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnim"];
        
        object;
    }) : _refreshView;
}

- (UIView *)loadMoreView
{
    return !_loadMoreView ? _loadMoreView =
    ({
        UIView *object = [[UIView alloc] initWithFrame:self.postsTableView.infiniteScrollingView.bounds];
        [object setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Activity Indicator Dark"]];
        [object addSubview:imageView];
        [PIXYUtilities centerView:imageView];
        
        POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotationAnimation.duration = 0.8f;
        rotationAnimation.toValue = @(M_PI * 2.0f);
        rotationAnimation.repeatForever = YES;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [imageView.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnim"];
        
        object;
    }) : _loadMoreView;
}

#pragma ------------------------------------------------------------------------
#pragma mark - Table View Datasource
#pragma ------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.postsDatasource.numberOfPosts;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Infinite Scroll
    [self loadMore:indexPath];
    
    PIXYPostModel *post = [self.postsDatasource postAtIndexPath:indexPath];
    PIXYFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostsTableViewCellIdentifier
                                                                  forIndexPath:indexPath];
    [cell setupWithPost:post];
    cell.delegate = self;
    return cell;
}

- (void)refreshDatasource
{
    [self.postsDatasource refresh:^{
        
        [self.postsTableView.pullToRefreshView stopAnimating];
        [self.postsTableView.infiniteScrollingView stopAnimating];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.postsTableView reloadData];
        });
        
    } andFailure:^{
        [self.postsTableView.pullToRefreshView stopAnimating];
        [self.postsTableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)loadMore:(NSIndexPath *)indexPath
{
    if ([self.postsDatasource loadMore:indexPath]) {
        [self loadMore];
    }
    
    if ([self.postsDatasource canLoadMore]) {
        [self.postsTableView setShowsInfiniteScrolling:YES];
    } else {
        [self.postsTableView setShowsInfiniteScrolling:NO];
    }
}

- (void)loadMore
{
    [self.postsTableView triggerInfiniteScrolling];
    [self fetchPosts];
}

#pragma ------------------------------------------------------------------------
#pragma mark - PIXYTableViewCell Delegate
#pragma ------------------------------------------------------------------------

- (void)thumbnailTapped:(PIXYFeedTableViewCell *)cell
{
    if (cell.post.thumbnailURL) {
        CGRect thumbnailFrame = [self.view convertRect:cell.thumbnailButton.frame
                                              fromView:cell.contentView];
        
        if ([self.navigationController.navigationBar.barTintColor isEqual:[UIColor blackColor]]) {
            UIColor *barColor = [UIColor colorWithRed:(101.0/255.0)
                                                green:(175.0/255.0)
                                                 blue:(255.0/255.0)
                                                alpha:1.0f];
            [PIXYUtilities setNavigationBarColor:barColor
                                        animated:YES];
        } else {
            [PIXYUtilities setNavigationBarColor:[UIColor blackColor]
                                        animated:YES];
            
            PIXYImageViewController *imageVC = [[PIXYImageViewController alloc] initWithNibName:@"PIXYImageViewController"
                                                                                         bundle:nil];
            imageVC.post = cell.post;
            imageVC.backgroundImage = [PIXYUtilities snapshot:self.view];
            imageVC.initialThumbnailFrame = thumbnailFrame;
            [self.navigationController pushViewController:imageVC
                                                 animated:NO];
        }
    }
}

#pragma ------------------------------------------------------------------------
#pragma mark - Private Methods
#pragma ------------------------------------------------------------------------

- (void)fetchPosts
{
    [self.postsDatasource fetchPosts:^{
        [self.postsTableView reloadData];
    } failure:^{
       
    }];
}

#pragma ------------------------------------------------------------------------
#pragma mark - NSNotification Observers
#pragma ------------------------------------------------------------------------

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationNowInForeground)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:NULL];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationNowInForeground
{
    // Refresh data when app is brought back into foreground
}

@end