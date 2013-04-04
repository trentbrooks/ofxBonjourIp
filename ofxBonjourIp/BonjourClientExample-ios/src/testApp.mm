#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);

	ofBackground(255,255,0);
    
    string type = "_ofxBonjourIp._tcp."; // arbitrary name with type. Could use _http._tcp.
    string name = ""; // if empty becomes device name
    int port = 7777;
    string domain = "local";
    
    // start bonjour
    bonjour = new ofxBonjourIp();
    
    // server (startService)
    //bonjour->startService(type, name, port, domain);
    
    // client (discoverService)
    bonjour->discoverService(type, domain);
}


//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
	
    ofEnableAlphaBlending();
    ofSetColor(0);

    if(bonjour->isServer) {
        
        ofDrawBitmapString("SERVER: ", 20, 20);
        
        // device name- can use this to connect via osc or udp or tcp
        ofDrawBitmapString("Device name: ", 20, 45);
        ofDrawBitmapStringHighlight(bonjour->getDeviceHostName(), 20, 70);
        
        // device ip- can use this to connect via osc or udp or tcp
        ofDrawBitmapString("Device IP: ", 20, 95);
        ofDrawBitmapStringHighlight(bonjour->getDeviceIp(), 20, 120);
        

    } else {
        
        ofDrawBitmapString("CLIENT: ", 20, 20);
        
        // device name- can use this to connect via osc or udp or tcp
        ofDrawBitmapString("Device name: ", 20, 45);
        ofDrawBitmapStringHighlight(bonjour->getDeviceHostName(), 20, 70);
        
        // device ip- can use this to connect via osc or udp or tcp
        ofDrawBitmapString("Device IP: ", 20, 95);
        ofDrawBitmapStringHighlight(bonjour->getDeviceIp(), 20, 120);
        
        // is connected to a service
        ofDrawBitmapString("Connected to server: ", 20, 145);
        ofDrawBitmapStringHighlight((bonjour->isConnected) ? "YES" : "NO", 20, 170);
        
        // device name- can use this to connect via osc or udp or tcp
        ofDrawBitmapString("Server's name: ", 20, 195);
        ofDrawBitmapStringHighlight(bonjour->getServerHostName(), 20, 220);
        
        // device ip- can use this to connect via osc or udp or tcp
        ofDrawBitmapString("Server's IP: ", 20, 245);
        ofDrawBitmapStringHighlight(bonjour->getServerIp(), 20, 270);
    }
    
    
    
    ofDisableAlphaBlending();
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    //ofLog() << bonjour->getDeviceHostName();
    //ofLog() << bonjour->getServiceHostName();
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

