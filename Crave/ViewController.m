//
//  ViewController.m
//  Crave
//
//  Created by Sony Theakanath on 6/28/15.
//  Copyright (c) 2015 Kuriakose Sony Theakanath. All rights reserved.
//

#import "ViewController.h"
#import "ShowDetails.h"
#import "TFHpple.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.showList = [[NSMutableArray alloc] init];
    [self pullShowList];
}

- (void)pullShowList {
    NSString *showURL = @"http://series-cravings.me/tv-show-1";
    NSData *showListData = [NSData dataWithContentsOfURL:[NSURL URLWithString:showURL]];
    TFHpple *parser = [TFHpple hppleWithHTMLData:showListData];
    NSArray *nodes = [parser searchWithXPathQuery:@"//ul[@class='a']/li"];
    for (TFHppleElement *element in nodes) {
        NSString *showTitle = [[element firstChild] content];
        NSString *showURL = [[element firstChild] objectForKey:@"href"];
        NSArray *showDetails = @[showTitle, showURL];
        [self.showList addObject:showDetails];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.showList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [[self.showList objectAtIndex:indexPath.row] objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowDetails *show = [[ShowDetails alloc] init];
    show.showName = [[self.showList objectAtIndex:indexPath.row] objectAtIndex:0];
    show.showURL = [[self.showList objectAtIndex:indexPath.row] objectAtIndex:1];
    [self.navigationController pushViewController:show animated:YES];
}

@end
