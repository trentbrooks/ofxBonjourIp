#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);

	ofBackground(255,255,0);

    
    // start bonjour
    bonjour = new ofxBonjourIp();
    
    // find me (server)
    bonjour->startService(); // make device 'discoverable' with defaults. 
    //bonjour->startService("_ofxBonjourIp._tcp.", "", 7777, "local");
    
    // find another device (client)- note will not discover itself
    bonjour->discoverService(); // discover other device with defaults.
    //bonjour->discoverService(type, domain);
}


//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){
	
    ofEnableAlphaBlending();
    ofSetColor(0);

    ofDrawBitmapString("BONJOUR IP: ", 20, 20);
    
    // device name- can use this to connect via osc or udp or tcp
    ofDrawBitmapString("Device name: ", 20, 45);
    ofDrawBitmapStringHighlight(bonjour->getDeviceHostName(), 20, 70);
    
    // device ip- can use this to connect via osc or udp or tcp
    ofDrawBitmapString("Device IP: ", 20, 95);
    ofDrawBitmapStringHighlight(bonjour->getDeviceIp(), 20, 120);
    
    // is connected to a service
    ofDrawBitmapString("Connected to other device: ", 20, 145);
    ofDrawBitmapStringHighlight((bonjour->isConnected) ? "YES" : "NO", 20, 170);
    
    // device name- can use this to connect via osc or udp or tcp
    ofDrawBitmapString("Other device's name: ", 20, 195);
    ofDrawBitmapStringHighlight(bonjour->getServerHostName(), 20, 220);
    
    // device ip- can use this to connect via osc or udp or tcp
    ofDrawBitmapString("Other device's IP: ", 20, 245);
    ofDrawBitmapStringHighlight(bonjour->getServerIp(), 20, 270);
    
    
    
    
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

