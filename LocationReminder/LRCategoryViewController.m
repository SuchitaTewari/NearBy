//
//  LRCategoryViewController.m
//  LocationReminder
//
//  Created by Suchita on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRCategoryViewController.h"
#import "LRCategoryCell.h"
#import "LRListViewController.h"

@interface LRCategoryViewController ()

@property (strong,nonatomic) NSArray *categoryList;
@property (strong,nonatomic) NSDictionary *categoryDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation LRCategoryViewController
   static NSString *cellIdentifier  = @"Cell";
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
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Category"];
    // Write method for accessing plist and fill category list here
    [self getCategoriesFromPlist];
    [self.tableview registerNib:[UINib nibWithNibName:@"LRCategoryCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (NSArray *)sortCategoryNameList:(NSArray *)publisherList {
    
   NSMutableArray *publisherLists = [[NSMutableArray alloc]initWithArray:publisherList];
   NSMutableArray *sortedLists = [[NSMutableArray alloc]init];
    [sortedLists addObjectsFromArray: [publisherLists sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    return (NSArray *)sortedLists;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCategoriesFromPlist {
 // Access the plist and fill category list
    // plist will return dictionary
    // Set category list useing fiuction dictionary.allkeys
    self.categoryDictionary = [[LRAppDelegate sharedInstance] getCategoriesFromPlist];
    self.categoryList = [self sortCategoryNameList:[self.categoryDictionary  allKeys]];
}

-(NSString*)imageNameForCategory:(NSString*)keyName {
    
    // Accessing category image name from categoryDictionary
    NSDictionary *valuDict = [self.categoryDictionary objectForKey:keyName];
    return [valuDict objectForKey:@"image"];
}

-(NSString*)typeNameForCategory:(NSString*)keyName {
    
    // Accessing category type name from categoryDictionary
    NSDictionary *valuDict = [self.categoryDictionary objectForKey:keyName];
    return [valuDict objectForKey:@"type"];
}

#pragma mark ------------------------
#pragma mark Tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return self.categoryList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    LRCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
     cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.name.text = [self.categoryList objectAtIndex:indexPath.section];
    cell.backImage.layer.cornerRadius = 12.0;
//    NSString* imageName = [self imageNameForCategory:[self.categoryList objectAtIndex:indexPath.row]];
//    UIImage *cellImage = [LRCategoryViewController imageResize:[UIImage imageNamed:imageName] andResizeTo:CGSizeMake(380, 380)];
//    cell.imageView.image = cellImage;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSLog(@" ImageViewFrame In WillDisplayCell %@",NSStringFromCGRect(cell.imageView.frame));

}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    [self getPlaceDataFromGoogleAPI:indexPath];
        
}


+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)getPlaceDataFromGoogleAPI:(NSIndexPath*)indexPath {
    CGFloat latitude = [LRAppDelegate sharedInstance].locationManager.location.coordinate.latitude;
    CGFloat longitude = [LRAppDelegate sharedInstance].locationManager.location.coordinate.longitude;
    NSString* selectedCategory = [self.categoryList objectAtIndex:indexPath.section];
    NSString* categoryTypeName = [self typeNameForCategory:selectedCategory];
    if(categoryTypeName.length) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:latitude],@"Latitiude",
                                    [NSNumber numberWithFloat:longitude],@"Longtitude",
                                    categoryTypeName,@"LastSelectedCategory", nil];
        [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:kLastSelectedCategory];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self queryGooglePlaces:categoryTypeName AndCoordinate:latitude andLatitude:longitude];
    }
    
}

-(void) queryGooglePlaces: (NSString *) googleType AndCoordinate:(CGFloat)latitude andLatitude:(CGFloat)longitude
{
    googleType = [googleType lowercaseString];
    NSString *radius = [[NSUserDefaults standardUserDefaults] objectForKey:@"Radius"];
    NSInteger radiusInMeter = radius.integerValue*1000;
    if(radiusInMeter == 0)
        radiusInMeter = kDefaultRadius;
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", latitude,longitude, [NSString stringWithFormat:@"%li", (long)radiusInMeter], googleType, kGOOGLE_API_KEY];
    NSLog(@"Google Url:\n%@",url);
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(data)
                [self fetchedData:data];
        });
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    // push new table view
    if(places.count > 0) {
        LRListViewController* listViewController = [LRListViewController new];
        listViewController.title = [self.categoryList objectAtIndex:self.selectedIndexPath.section];
        listViewController.mapResults = places;
        [self.navigationController pushViewController:listViewController animated:YES];
    } else {
        [self showAlertAndPopToCategory];
    }
}

-(void)showAlertAndPopToCategory {
    
    NSString *radius = [[NSUserDefaults standardUserDefaults] objectForKey:@"Radius"];
    NSString* message = [NSString stringWithFormat:@"No places found around %ld KM. Please increase the radius value from settings.",(long)radius.integerValue];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
