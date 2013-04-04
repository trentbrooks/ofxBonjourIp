#include "ofxBonjourIp.h"

#ifndef TARGET_OF_IPHONE
// util methods copied and renamed from ofxIphoneExtras- so can use on osx
string ofxNSStringToString(NSString * s) {
 return string([s UTF8String]);
}
 
NSString * ofxStringToNSString(string s) {
 return [[[NSString alloc] initWithCString: s.c_str()] autorelease];
}
#endif

//--------------------------------------------------------------
ofxBonjourIp::ofxBonjourIp(){
    
    deviceHostName = "";
    deviceIp = "";
    serverIp = "";
    serverHostName = "";
    isServer = true;
    isConnected = false;
    
    // setup objc style delegate
    bonjourDelegate = [[BonjourServiceDelegate alloc] init: this] ;
}

ofxBonjourIp::~ofxBonjourIp(){
    [bonjourDelegate dealloc];
}

void ofxBonjourIp::startService( string type, string name, int port, string domain ){

    isServer = true;    
    [bonjourDelegate startService:ofxStringToNSString(type) name:ofxStringToNSString(name) port:port domain:ofxStringToNSString(domain)];
}

void ofxBonjourIp::stopService(){
    
    [bonjourDelegate stopService];
}

string ofxBonjourIp::getDeviceHostName() {
    
    //return ofxNSStringToString( [[NSProcessInfo processInfo] hostName] );
    return deviceHostName;
}

string ofxBonjourIp::getDeviceIp() {
    
    return deviceIp;
}




// CLIENT
void ofxBonjourIp::discoverService( string type, string domain ){
    
    isServer = false;
    isConnected = false;
    [bonjourDelegate discoverService:ofxStringToNSString(type) domain:ofxStringToNSString(domain)];
}

string ofxBonjourIp::getServerHostName() {

    return serverHostName;
}

string ofxBonjourIp::getServerIp() {

    return serverIp;
}
//--------------------------------------------------------------




@implementation BonjourServiceDelegate

@synthesize netService;
@synthesize serviceBrowser;

- (id) init :(ofxBonjourIp *) bCpp {
	if(self = [super init])	{
		NSLog(@"ofxBonjourService initiated");
        
        // ref to OF instance
        bonjourCpp = bCpp;
        
        // create an acitivty indicator view for when stuff is happening
        //busyAnimation = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //busyAnimation.frame = CGRectMake(0, 0, ofGetWidth(), ofGetHeight());
        //[busyAnimation stopAnimating];
        //[ofxiPhoneGetGLParentView() addSubview:busyAnimation];
	}
	return self;
}

-(void)dealloc {
    bonjourCpp = nil;
    [self stopService];
    [super dealloc];
}

-(void)startService:(NSString*)type name:(NSString*)name port:(int)port domain:(NSString*)domain {

    netService = [[NSNetService alloc] initWithDomain:domain type:type name:name port:port];
    netService.delegate = self;
    NSLog(@"Publishing... %@", [netService hostName]);
    [netService publish];

}

-(void)stopService {
    [netService stop];
    [netService release];
    netService = nil;
    
    [services release];
    [serviceBrowser stop];
    [serviceBrowser release];
    serviceBrowser = nil;
}



//#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"* Successful publish *\n");
    NSString* serviceHostName = [sender hostName];
    NSLog(@"service hostname: %@", serviceHostName);
    NSLog(@"service port: %i", [sender port]);
    NSLog(@"service name: %@", [sender name]);
    NSLog(@"service addresses: %@", [sender addresses]);
    //NSLog(@"count: %i", [[sender addresses] count]);
    NSLog(@"description: %@", [sender description]);
    
    NSLog(@"Process host name: %@",[[NSProcessInfo processInfo] hostName]); // trentsiphone4.local
    //NSLog(@" -- %@", [[UIDevice currentDevice] name]);
    
    // this can only be set after a bonjour service is published
    bonjourCpp->deviceHostName = ofxNSStringToString( [[NSProcessInfo processInfo] hostName] );       
    bonjourCpp->deviceIp = ofxNSStringToString( [self getIPAddress] );
}

// http://stackoverflow.com/questions/7072989/iphone-ipad-how-to-get-my-ip-address-programmatically
- (NSString *)getIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name]; //en0
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                //NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([name isEqualToString:@"pdp_ip0"]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

- (void)netServiceWillPublish:(NSNetService *)sender {
    NSLog(@"netServiceWillPublish");
    //[services addObject:netService];
    NSLog(@"**** service hostname: %@", [sender hostName]);
}


// Error handling code
- (void)handleError:(NSNumber *)error withService:(NSNetService *)service
{
    NSLog(@"An error occurred with service %@.%@.%@, error code = %@",
          [service name], [service type], [service domain], error);
    // Handle error here
}


// CLIENT
-(void)discoverService:(NSString*)type domain:(NSString*)domain {
    NSLog(@"type is %@", type);
    NSLog(@"domain is %@", domain);
    
    services = [[NSMutableArray alloc] init];
    searching = NO;
   
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    serviceBrowser.delegate = self;
    [serviceBrowser searchForServicesOfType:type inDomain:domain];
    
    // client may need to know own address
    bonjourCpp->deviceHostName = ofxNSStringToString( [[NSProcessInfo processInfo] hostName] );
    bonjourCpp->deviceIp = ofxNSStringToString( [self getIPAddress] );
}

// Sent when browsing begins
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"netServiceBrowser browsing begin");
    searching = YES;
    //[self updateUI];
}

// Sent when browsing stops
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser
{
    NSLog(@"netServiceBrowser browsing stopped");
    searching = NO;
    //[self updateUI];
}

// Sent if browsing fails
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
             didNotSearch:(NSDictionary *)errorDict
{
    NSLog(@"netServiceBrowser browsing failed");
    searching = NO;
}

// Sent when a service appears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    
    NSLog(@"netServiceBrowser service found ");
    NSLog(@"netServiceBrowser service hostname %@", [aNetService hostName]);
    NSLog(@"netServiceBrowser service name %@", [aNetService name]);
    NSLog(@"netServiceBrowser service domain %@", [aNetService domain]);
    NSLog(@"netServiceBrowser service description %@", [aNetService description]);
    NSLog(@"netServiceBrowser service addresses %@", [aNetService addresses]);
    if(!moreComing) {}
    
    // service is found. resolve address
    aNetService.delegate = self;
    [aNetService resolveWithTimeout:0];
    [services addObject:aNetService];
}

// Sent when a service disappears
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing
{
    [services removeObject:aNetService];
    NSLog(@"netServiceBrowser service disappeared");
    bonjourCpp->serverHostName = "";
    bonjourCpp->serverIp = "";
    bonjourCpp->isConnected = false;
    if(!moreComing) {}
}



// address resolved
- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    NSLog(@"netServiceDidResolveAddress");
    for (NSData *address in [sender addresses]) {
        struct sockaddr_in *socketAddress = (struct sockaddr_in *) [address bytes];
        string ip = inet_ntoa(socketAddress->sin_addr);
        if(ip != "0.0.0.0") {
            NSLog(@"Service name: %@ , ip: %s , port %i", [sender name], inet_ntoa(socketAddress->sin_addr), [sender port]);
            NSLog(@"Service host: %@ ", [sender hostName]);
            NSLog(@"Service port: %i ", [sender port]);
            bonjourCpp->isConnected = true;
            bonjourCpp->serverHostName = ofxNSStringToString( [sender hostName] );
            bonjourCpp->serverIp = ip;
        }
        
    }
}

- (void)netServiceWillResolve:(NSNetService *)sender {
    NSLog(@"netServiceWillResolve");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"didNotResolve");
}




@end