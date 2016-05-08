//
//  LRMapViewController.m
//  LocationReminder
//
//  Created by Suchita. on 19/03/14.
//  Copyright (c) 2014 Suchita. All rights reserved.
//

#import "LRMapViewController.h"
#import "LRReminderViewController.h"

@interface LRMapViewController()
@property (strong, nonatomic) NSString *currentAddress;

@end

@implementation LRMapViewController

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
	// Do any additional setup after loading the view, typically from a nib.
    
    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    // Ensure that we can view our own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    self.edgesForExtendedLayout  = UIRectEdgeNone;
    [LRAppDelegate sharedInstance].googleAPINeedToRefresh = YES;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    [self.mapView setRegion:mapRegion animated: YES];
    [self.mapView removeOverlays:self.mapView.overlays];
    int result = [CLLocationManager authorizationStatus];
    if([LRAppDelegate sharedInstance].googleAPINeedToRefresh && result == kCLAuthorizationStatusAuthorized)
        [self performSelector:@selector(getPlaceDataFromGoogleAPI) withObject:nil afterDelay:0.35];

}

- (void)getPlaceDataFromGoogleAPI {
    if (!self.mapData) {
        NSDictionary *lastSelectedCategoryDetails = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedCategory];
        CGFloat latitude ;CGFloat longitude;NSString *categoryTypeName;
        
        if (!lastSelectedCategoryDetails) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:[LRAppDelegate sharedInstance].locationManager.location.coordinate.latitude],@"Latitiude",
                                        [NSNumber numberWithFloat:[LRAppDelegate sharedInstance].locationManager.location.coordinate.longitude],@"Longtitude",
                                        @"airport",@"LastSelectedCategory", nil];
            [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:kLastSelectedCategory];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            lastSelectedCategoryDetails = [[NSUserDefaults standardUserDefaults] objectForKey:kLastSelectedCategory];
        }
        latitude = [[lastSelectedCategoryDetails objectForKey:@"Latitiude"] floatValue];
        longitude = [[lastSelectedCategoryDetails objectForKey:@"Longtitude"] floatValue];
        categoryTypeName = [lastSelectedCategoryDetails objectForKey:@"LastSelectedCategory"];
        [self queryGooglePlaces:categoryTypeName AndCoordinate:latitude andLatitude:longitude];
    } else {
        [self fetchedData:self.mapData];
    }
}

-(void)setMapCurrentLocationAddress:(NSString*)address {
    
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            if(address.length)
                ((MKUserLocation *)annotation).title = address;
            break;
        }
    }
}



- (void)fetchedData:(NSArray *)placeData {
      if(placeData.count > 0) {
        [LRAppDelegate sharedInstance].googleAPINeedToRefresh = NO;
        [self plotPositions:placeData];
    } else {
        [self removeAllMapAnnotation];
    }
}

-(void) removeAllMapAnnotation {
    for (id<MKAnnotation> annotation in self.mapView.annotations)
    {
        if ([annotation isKindOfClass:[LRMapView class]])
        {
            [self.mapView removeAnnotation:annotation];
        }
    }
}
- (void)plotPositions:(NSArray *)data
{
    //Remove any existing custom annotations but not the user location blue dot.
    [self removeAllMapAnnotation];
    
    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name =[place objectForKey:@"name"];
        NSString *vicinity = [place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        // Icon url
        NSString *iconUrl = [place objectForKey:@"icon"];
        //Create a new annotiation.
       LRMapView *placeObject = [[LRMapView alloc] initWithName:name address:vicinity andIcon:iconUrl coordinate:placeCoord];
        [self.mapView addAnnotation:placeObject];
    }
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - MKMapViewDelegate methods.


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    //Zoom back to the user location after adding a new set of annotations.
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"LRMapView";
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
       
        NSString *currentAddress = self.currentAddress;
        if(currentAddress.length)
            ((MKUserLocation *)annotation).title = currentAddress;
        return nil;  //return nil to use default blue dot view
    }
    if ([annotation isKindOfClass:[LRMapView class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        [button setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = button;
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        LRMapView *mapViewAnnotation = (LRMapView*)annotationView.annotation;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:mapViewAnnotation.iconUrl]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [iconImageView setImage:[UIImage imageWithData:imageData]];
            });
        });
        [annotationView setLeftCalloutAccessoryView:iconImageView];
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);

    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Remove previously  added all direction overlay
    [self.mapView removeOverlays:self.mapView.overlays];
    if ([view.annotation isKindOfClass:[LRMapView class]]) {
         LRMapView *mapView = view.annotation;
         [self getDirections:mapView.mapItem];
     }
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    NSLog(@"you touched the disclosure indicator");
    LRReminderViewController* reminder = [LRReminderViewController new];
    if([view.annotation isKindOfClass:[LRMapView class]]) {
        LRMapView *mapViewAnnotation = (LRMapView*)view.annotation;
        reminder.mapItem = mapViewAnnotation.mapItem;
     reminder.isEditReminder = NO;
    }
    [self.navigationController pushViewController:reminder animated:YES];
    
    LRMapView *mapViewAnnotation = (LRMapView*)view.annotation;

    CLLocation* currentLocation = [LRAppDelegate sharedInstance].locationManager.location;
    CLLocation* destinationLocation = mapViewAnnotation.mapItem.placemark.location;

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        
        NSString* url = [NSString stringWithFormat: @"comgooglemaps://?saddr=%f,%f&daddr=%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,destinationLocation.coordinate.latitude, destinationLocation.coordinate.longitude];
        
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:url]];
    } else {
        NSLog(@"Can't use comgooglemaps://");
        NSString* url = [NSString stringWithFormat: @"https://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude,destinationLocation.coordinate.latitude, destinationLocation.coordinate.longitude];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        
    }
}

- (void)getDirections:(MKMapItem*)destination
{
    MKDirectionsRequest *request =
    [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    request.destination = destination;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}
-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.0;
    return renderer;
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(!self.firstLaunch) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = mapView.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.1f;
        mapRegion.span.longitudeDelta = 0.1f;
        [self.mapView regionThatFits:mapRegion];
        [self.mapView setRegion:mapRegion animated: YES];
    }
}


- (void)queryGooglePlaces: (NSString *) googleType AndCoordinate:(CGFloat)latitude andLatitude:(CGFloat)longitude {
    
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
        
        NSData *responseData = [NSData dataWithContentsOfURL: googleRequestURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(responseData)
                [self parseResponseData:responseData];
        });
    });
}

- (void)parseResponseData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    if (places.count > 0) {
        self.mapData = places;
        [self fetchedData:self.mapData];

    } else {
        NSString *radius = [[NSUserDefaults standardUserDefaults] objectForKey:@"Radius"];
        NSString *message = [NSString stringWithFormat:@"No places found around %ld KM. Please increase the radius value from settings.",(long)radius.integerValue];
        if ((long)radius.integerValue == 50) {
            // Change the alert message if user is already selected the radius to 50
            message = @"No Places found within 50 km from your current location.";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
