//
//  HomeViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "HomeViewController.h"
#import "MDDirectionService.h"

@interface HomeViewController ()<SWRevealViewControllerDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *eventTableView;
    IBOutlet UIScrollView *eventScrollView;
    IBOutlet MKMapView *eventMapView;
    GMSMapView *mapView_;
//  IBOutlet UIBarButtonItem* revealButtonItem;
}

@property (strong, nonatomic) NSDictionary *responseDict;
@property (strong, nonatomic) NSMutableArray *waypoints;
@property (strong, nonatomic) NSMutableArray *waypointStrings;

-(IBAction)btnLogOutPressed:(id)sender;
-(IBAction)btnMenuPressed:(id)sender;
-(IBAction)SegmentControlActions:(id)sender;
-(void)intializeMap;

@end

@implementation HomeViewController

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
    
    NSLog(@"navigationController..%@",self.navigationController);
    
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];
    
    _responseDict = [[NSDictionary alloc] init];
    _responseDict = (NSDictionary *)[Helper ReadFromJSONStore:@"Home.json"];
    NSLog(@"responseDict..%@",_responseDict);
//    lblEvent.text = [_responseDict valueForKey:@"Event_name"];
//    lblLocation.text = [_responseDict valueForKey:@"Location"];
//    lblTimeDate.text = [_responseDict valueForKey:@"Time/Date"];
//    lblHost.text = [_responseDict valueForKey:@"Host"];
//    lblDetails.text = [_responseDict valueForKey:@"Details"];
//    [self placeMarkers];
    // Do any additional setup after loading the view.
    [self intializeMap];
//    mapView_.hidden = NO;
}

-(void)intializeMap{
    
    CLLocationManager *location = [[CLLocationManager alloc] init];
    location.delegate = self;
    [location startUpdatingLocation];
    
    [GMSServices provideAPIKey:@"AIzaSyDZXoco2krEdm_ldNM3um7OioCn9-L_cRk"];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[[[_responseDict valueForKey:@"Events"] objectAtIndex:1] valueForKey:@"lat"] doubleValue]
                                                            longitude:[[[[_responseDict valueForKey:@"Events"] objectAtIndex:1] valueForKey:@"long"] doubleValue]
                                                                 zoom:5];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 282, 320, 286) camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeNormal;
    mapView_.indoorEnabled = YES;
    mapView_.accessibilityElementsHidden = NO;
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.delegate = self;
    mapView_.hidden = YES;
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(22.25,76.02);
//    marker.title = @"Indore";
//    marker.snippet = @"India";
//    marker.map = mapView_;
    [self.view addSubview:mapView_];
//  [self.view bringSubviewToFront:mapView_];
    [self placeMarkers];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"locations...%@",locations);
}

-(void)placeMarkers
{
    // Creates a marker in the center of the map
    for (int i=0; i<[[_responseDict valueForKey:@"Events"] count]; i++) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[[[_responseDict valueForKey:@"Events"] objectAtIndex:i] valueForKey:@"lat"] doubleValue], [[[[_responseDict valueForKey:@"Events"] objectAtIndex:i] valueForKey:@"long"] doubleValue]);
        marker.title = [[[_responseDict valueForKey:@"Events"] objectAtIndex:i] valueForKey:@"Location"];
        marker.snippet = @"U.S.A";
        marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        marker.opacity = 0.9;
        marker.map = mapView_;
    }
}

- (UIView *) mapView:(GMSMapView *)  mapView markerInfoWindow: (GMSMarker *) marker
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    view.layer.cornerRadius = 5.0;
    
    UILabel *labelEvent = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 20)];
    labelEvent.textColor = [UIColor whiteColor];
    labelEvent.text = @"Event 1";
    [view addSubview:labelEvent];
    
    UILabel *labelLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 180, 20)];
    labelLocation.textColor = [UIColor whiteColor];
    labelLocation.text = @"Location 1";
    [view addSubview:labelLocation];
    return view;
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"you tapped at %f, %f", coordinate.longitude, coordinate.latitude);
    
    CLLocationCoordinate2D tapPosition = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    
    GMSMarker *tapMarker = [GMSMarker markerWithPosition:tapPosition];
    tapMarker.map = mapView_;
    [self.waypoints addObject:tapMarker];
    
    NSString *positionString = [NSString stringWithFormat:@"%f,%f", coordinate.latitude,coordinate.longitude];
    [self.waypointStrings addObject:positionString];
    
    if (self.waypoints.count > 1) {
        NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : self.waypointStrings };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}

-(void)addDirections:(NSDictionary *)json
{
    NSDictionary *routes = json[@"routes"][0];
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    //    [mapView clear];
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    NSLog(@"map became idle");
    //    [self placeMarkers];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
}

-(IBAction)btnLogOutPressed:(id)sender{
    UINavigationController *navController =(UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [navController popViewControllerAnimated:YES];
}

-(IBAction)btnMenuPressed:(id)sender{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController revealToggle:nil];
}

-(IBAction)SegmentControlActions:(id)sender{
    NSLog(@"sender..%i",[segmentControl selectedSegmentIndex]);
    
    if ([segmentControl selectedSegmentIndex] == 0) {
        eventTableView.hidden = NO;
        mapView_.hidden = YES;
        NSLog(@"ListView");
    }
    else if ([segmentControl selectedSegmentIndex] == 1)
    {
        eventTableView.hidden = YES;
        mapView_.hidden = NO;
        NSLog(@"Map View");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_responseDict valueForKey:@"Events"] count];
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,22)];
//    tempView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:161.0/255.0 alpha:1.0];
//    tempView.tag = section;
//    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,300,22)];
//    tempLabel.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:161.0/255.0 alpha:1.0];
//    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
//    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
//    
//    tempLabel.text = [[[_responseDict valueForKey:@"Events"] allKeys] objectAtIndex:section];
//    [tempView addSubview:tempLabel];
//    return tempView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventDetailCell";
    UITableViewCell *cell;
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 150, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:18.0];
    senderLabel.text = [[[_responseDict valueForKey:@"Events"]objectAtIndex:indexPath.row] valueForKey:@"event_name"];
    senderLabel.textColor = [UIColor darkGrayColor];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 80, 20)];
    locationLabel.font = [UIFont boldSystemFontOfSize:15.0];
    locationLabel.text = [[[_responseDict valueForKey:@"Events"]objectAtIndex:indexPath.row] valueForKey:@"Location"];
    locationLabel.textColor = [UIColor darkGrayColor];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 100, 20)];
    timeLabel.font = [UIFont boldSystemFontOfSize:15.0];
    timeLabel.text = [[[_responseDict valueForKey:@"Events"]objectAtIndex:indexPath.row] valueForKey:@"Time"];
    timeLabel.textColor = [UIColor darkGrayColor];

    UIImageView *eventImgView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 16, 40, 40)];
    eventImgView.image = [UIImage imageNamed:@"Home.png"];
    
    [cell.contentView addSubview:senderLabel];
    [cell.contentView addSubview:locationLabel];
    [cell.contentView addSubview:eventImgView];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
