//
//  BAListTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAAppDelegate.h"
#import "BAListTableViewController.h"
#import "BADetailViewController.h"
#import "BAItemCell.h"
#import "BAEntry.h"
#import "BADetailScrollViewController.h"

@interface BAListTableViewController ()

@end

@implementation BAListTableViewController

@synthesize dummyBooksMerkliste;
@synthesize position;
@synthesize currentItem;
@synthesize listTableView;
@synthesize didReturnFromDetail;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    [self setCurrentItem: [[BAEntryWork alloc] init]];
    
    [self setDidReturnFromDetail:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadEntries];
    [self.listTableView reloadData];
    if ([self.dummyBooksMerkliste count] > 0 && self.didReturnFromDetail) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.position inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.dummyBooksMerkliste count] == 0) {
        [self.trashIcon setEnabled:NO];
    } else {
        [self.trashIcon setEnabled:YES];
    }
    
    [self.listTableView setEditing:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dummyBooksMerkliste count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BAItemCell *cell;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    // Configure the cell...
    BAEntry *entry;
    entry = [self.dummyBooksMerkliste objectAtIndex:indexPath.row];
	[cell.titleLabel setText:entry.title];
    [cell.subtitleLabel setText:entry.subtitle];
    [cell.image setImage:[UIImage imageNamed:entry.matcode]];
    [cell.authorLabel setText:entry.author];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BAEntry *tempEntry = [self.dummyBooksMerkliste objectAtIndex:[indexPath row]];
    
    [self.currentItem setPpn:[tempEntry ppn]];
    [self.currentItem setTitle:[tempEntry title]];
    [self.currentItem setSubtitle:[tempEntry subtitle]];
    [self.currentItem setMatstring:[tempEntry matstring]];
    [self.currentItem setMatcode:[tempEntry matcode]];
    [self.currentItem setLocal:[tempEntry local]];

    [self setPosition:[indexPath row]];
    [self setDidReturnFromDetail:YES];
    
    [self performSegueWithIdentifier:@"ItemDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ItemDetailSegue"]) {
        BADetailScrollViewController *detailScrollViewController = (BADetailScrollViewController *)[segue destinationViewController];
        [detailScrollViewController setBookList:self.dummyBooksMerkliste];
        [detailScrollViewController setScrollViewDelegate:self];
        [detailScrollViewController setMaximumPosition:[self.dummyBooksMerkliste count]];
        [detailScrollViewController setStartPosition:self.position];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObject *entryToDelete = [[self dummyBooksMerkliste] objectAtIndex:indexPath.row];
        [appDelegate.managedObjectContext deleteObject:entryToDelete];
        NSError *error = nil;
        if (![[appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
        }
        [self loadEntries];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [self.listTableView reloadData];
        
        if ([self.dummyBooksMerkliste count] == 0) {
            [self.trashIcon setEnabled:NO];
        }
	}
}

- (void)loadEntries
{
    self.dummyBooksMerkliste = [[NSMutableArray alloc] init];
    
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BAEntry" inManagedObjectContext:[appDelegate managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    [self setDummyBooksMerkliste: [[appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy]];
    
    if ([self dummyBooksMerkliste] == nil) {
        // Deal with error...
    }
}

- (void)viewDidUnload
{
    [self setTrashIcon:nil];
    [super viewDidUnload];
}

- (IBAction)trashAction:(id)sender {
    if (!self.listTableView.editing) {
        [self.listTableView setEditing:YES animated:YES];
    } else {
        [self.listTableView setEditing:NO animated:YES];
    }
}

- (void)continueSearch
{
    // no need to implement
}

- (void)updatePosition:(int)updatePosition
{
    [self setPosition:updatePosition];
}

@end
