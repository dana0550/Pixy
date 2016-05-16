//
//  PIXYFeedViewController.m
//  pixy
//
//  Created by Dana Shakiba on 5/14/16.
//  Copyright © 2016 Appadana. All rights reserved.
//

#import "PIXYFeedViewController.h"
#import "PIXYFeedTableViewCell.h"
#import "PIXYPostsDatasource.h"
#import "PIXYPostModel.h"

@interface PIXYFeedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PIXYPostsDatasource *postsDatasource;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;

@end

@implementation PIXYFeedViewController

static NSString *kPostsTableViewCellIdentifier = @"pixy_feedCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"r/pics";
    
    UINib *cellNib = [UINib nibWithNibName:@"PIXYFeedTableViewCell" bundle:nil];
    [self.postsTableView registerNib:cellNib
              forCellReuseIdentifier:kPostsTableViewCellIdentifier];
    self.postsTableView.rowHeight = UITableViewAutomaticDimension;
    self.postsTableView.estimatedRowHeight = 100.0;
    
    [self fetchPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    PIXYPostModel *post = [self.postsDatasource postAtIndexPath:indexPath];
    PIXYFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostsTableViewCellIdentifier
                                                                  forIndexPath:indexPath];
    [cell setupWithPost:post];
    return cell;
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

@end