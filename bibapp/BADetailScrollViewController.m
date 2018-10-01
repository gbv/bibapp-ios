//
//  BADetailScrollViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 21.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BADetailScrollViewController.h"
#import "BADetailViewController.h"
#import "BACoverViewControllerIPhone.h"
#import "BATocListTableViewController.h"
#import "BALocationViewControllerIPhone.h"
#import "BALocalizeHelper.h"

@interface BADetailScrollViewController ()

@end

@implementation BADetailScrollViewController

@synthesize pageControlUsed;
@synthesize bookList;
@synthesize views;
@synthesize scrollPosition;
@synthesize startPosition;
@synthesize scrollViewDelegate;
@synthesize maximumPosition;
@synthesize tempCover;
@synthesize tempTocArray;
@synthesize tempLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    self.views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.bookList count]; i++)
    {
		[self.views addObject:[NSNull null]];
    }
    
    self.scrollPosition = self.startPosition;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * [self.bookList count], 200);
    self.scrollView.contentOffset = CGPointMake([[UIScreen mainScreen] bounds].size.width * self.startPosition, 0);
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:[[NSString alloc] initWithFormat:BALocalizedString(@"Detail (%ld / %ld)"), self.scrollPosition+1, self.maximumPosition]];
    [self loadScrollViewWithPage:self.startPosition];
    [self loadScrollViewWithPage:self.startPosition-1];
    [self loadScrollViewWithPage:self.startPosition+1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (int i = 1; i < 2; i++) {
        [self loadScrollViewWithPage:self.scrollPosition + i];
        [self loadScrollViewWithPage:self.scrollPosition - i];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = [[UIScreen mainScreen] bounds].size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.navigationItem setTitle:[[NSString alloc] initWithFormat:BALocalizedString(@"Detail (%ld / %ld)"), page+1, self.maximumPosition]];
    if (pageControlUsed)
    {
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
    CGFloat pageWidth = [[UIScreen mainScreen] bounds].size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.navigationItem setTitle:[[NSString alloc] initWithFormat:BALocalizedString(@"Detail (%ld / %ld)"), page+1, self.maximumPosition]];
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    for (int i = 1; i < 5; i++) {
        [self loadScrollViewWithPage:page + i];
    }
    self.scrollPosition = page;
    if (![(BADetailViewController *)[self.views objectAtIndex:page] entryOnList]) {
        [self.listButton setEnabled:YES];
    } else {
        [self.listButton setEnabled:NO];
    }
}

- (void)loadScrollViewWithPage:(long)page
{
    if (page < 0) {
        return;
    }
    if (page < self.maximumPosition) {
        if (page >= [self.bookList count]) {
            if (page == [self.bookList count]) {
                long newCount = [self.bookList count] + [self.appDelegate.configuration.currentBibSearchMaximumRecords integerValue];
                if (newCount > self.maximumPosition) {
                    newCount = self.maximumPosition;
                }
                for (long i = page; i < (newCount); i++)
                {
                    [self.views addObject:[NSNull null]];
                }
                self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * newCount, 200);
                [self.scrollViewDelegate continueSearch];
            }
            return;
        }
        if ((NSNull *)[[self views] objectAtIndex:page] == [NSNull null]) {
            CGRect frame = self.scrollView.frame;
            frame.origin.x = [[UIScreen mainScreen] bounds].size.width * page;
            frame.origin.y = 0;
            frame.size.width = [[UIScreen mainScreen] bounds].size.width;
            frame.size.height = self.view.frame.size.height - CGRectGetHeight(self.tabBarController.tabBar.frame) - CGRectGetHeight(self.navigationController.navigationBar.frame) - CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
            BADetailViewController *subViewController = [[BADetailViewController alloc] initWithFrame:frame];
            [subViewController setBookList:self.bookList];
            [subViewController setCurrentEntry:[self.bookList objectAtIndex:page]];
            [subViewController setScrollViewController:self];
            [[self views] replaceObjectAtIndex:page withObject:subViewController];
            [[self scrollView] addSubview:subViewController.view];
        } else {
            [[self scrollView] addSubview:((BADetailViewController *)[self.views objectAtIndex:page]).view];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.navigationItem setTitle:BALocalizedString(@"Detail")];
    if ([[segue identifier] isEqualToString:@"coverSegue"]) {
        BACoverViewControllerIPhone *coverViewController = (BACoverViewControllerIPhone *)[segue destinationViewController];
        [coverViewController setCoverImage:self.tempCover];
    } else if ([[segue identifier] isEqualToString:@"tocListSegue"]) {
        BATocListTableViewController *tocListTableViewController = (BATocListTableViewController *)[segue destinationViewController];
        [tocListTableViewController setTocArray: self.tempTocArray];
    } else if ([[segue identifier] isEqualToString:@"ItemDetailLocationSegue"]) {
        BALocationViewControllerIPhone *locationViewController = (BALocationViewControllerIPhone *)[segue destinationViewController];
        [locationViewController setCurrentLocation:self.tempLocation];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.scrollViewDelegate updatePosition:self.scrollPosition];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setListButton:nil];
    [super viewDidUnload];
}

- (IBAction)actionButton:(id)sender {
    [(BADetailViewController *)[self.views objectAtIndex:self.scrollPosition] actionButton];
}

@end
