
#pragma once


#import "ofMain.h"
#ifdef TARGET_OF_IPHONE
    #import "ofxiPhoneExtras.h"
#endif
//#import <Cocoa/Cocoa.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


// defaults for making device discoverable
#define BONJOUR_TYPE "_ofxBonjourIp._tcp."
#define BONJOUR_NAME "" // becomes device name
#define BONJOUR_PORT 7777
#define BONJOUR_DOMAIN "local"


class ofxBonjourIp;
/*
 ofxBonjourIp created by Trent Brooks.
 - Using Bonjour services to find an ip address or device name
 - Not setup for network comms- Bonjour streams are ugly. Use OSC, UDP or TCP instead (more OF friendly).
*/

// OBJC DELEGATE
@interface BonjourServiceDelegate : NSObject<NSNetServiceDelegate,NSNetServiceBrowserDelegate> {
    
    ofxBonjourIp * bonjourCpp; // giving the delegate access to the OF c++ implementation as well
    
	NSNetService *netService; // for server
    
    NSNetServiceBrowser *serviceBrowser; // for client
    NSMutableArray *services; // Keeps track of available services
    BOOL searching;// Keeps track of search status
}

- (id) init:(ofxBonjourIp *) bCpp;
- (void) stopService;
- (NSString *) getIPAddress;

// server
- (void) startService:(NSString*)type name:(NSString*)name port:(int)port domain:(NSString*)domain;
- (void) netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict;
- (void) netServiceDidPublish:(NSNetService *)sender;
- (void) netServiceWillPublish:(NSNetService *)sender;
- (void) handleError:(NSNumber *)error withService:(NSNetService *)service;

//client
- (void) discoverService:(NSString*)type domain:(NSString*)domain;
- (void) netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser;
- (void) netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser;
- (void) netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary *)errorDict;
- (void) netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing;
- (void) netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing;

- (void) netServiceWillResolve:(NSNetService *)sender;
- (void) netServiceDidResolveAddress:(NSNetService *)sender;
- (void) netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict;

//props
@property(nonatomic, retain) NSNetService *netService;
@property(nonatomic, retain) NSNetServiceBrowser *serviceBrowser;

@end


// OF CLASS
class ofxBonjourIp {
	public:

		ofxBonjourIp();
        ~ofxBonjourIp();
		
        BonjourServiceDelegate * bonjourDelegate; // ios delegate
    
        // BROADCAST SERVICE- MAKES DEVICE DISCOVERABLE
        void startService();
        void startService( string type, string name, int port, string domain = "" );
        void stopService();
        
        // returns name of this device- can use this to connect via osc
        string getDeviceHostName();
        string deviceHostName;
    
        // returns ip address of this device- can use this to connect via osc
        string getDeviceIp();
        string deviceIp;

    
        // CLIENT- FIND ANOTHER DEVICE (AUTO CONNECTS)
        void discoverService();
        void discoverService( string type, string domain );
        bool isConnected;
    
        // returns name of server- can use this to connect via osc
        string getServerHostName();
        string serverHostName;
    
        // returns ip address of server- can use this to connect via osc
        string getServerIp();
        string serverIp;
    
    
};


