//
//  AfariaController.m
//  Afaria-Cert-Enroller
//
//  Created by Brenton O'Callaghan on 06/05/2014.
//  Copyright (c) 2014 Bluefin Solutions Ltd. All rights reserved.
//

#import "AfariaController.h"
#import "SeedDataAPI.h"

@implementation AfariaController

static NSString *bundleID;
static NSString *urlScheme;
static NSString *statusMessage = @"Not yet initialised";
static int afariaClientStatus = kAfariaRegistration_NotReady;

#pragma mark - Static initialisation & callback methods

// First method to be called to setup the Afaria Library
+ (id)initialiseAfariaLibraryWithURLScheme:(NSString *)appUrlScheme{
    
    // Retrieve and store the bundle ID.
    bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"The bundle ID of this application is: %@.", bundleID);
    
    // Set our status to connecting.
    afariaClientStatus = kAfariaRegistration_InProgress;
    NSLog(@"Afaria Client status changed to in-progress.");
    
    // Store the URL scheme to be used within all calls.
    urlScheme = appUrlScheme;
    NSLog(@"Application callback URL scheme is %@.", urlScheme);
    
    // Initialise the library (triggers the call to the Afaria app on the device).
    [SeedingAPISynchronous initializeLibrary:NULL inUrlScheme:urlScheme forceSigning:NO withBundleID:bundleID];
    return nil;
}

// Callback handler for when the afaria app responds with settings etc.
// Called from the App Delegate URL handler
+ (int)handleAfariaCallbackWithURL:(NSURL *)url{
    
    // Re-initialise the Afaria library with the Afaria URL as provided by the Afaria app on the device.
    int value = [SeedingAPISynchronous initializeLibrary:url inUrlScheme:urlScheme forceSigning:NO withBundleID:bundleID];
    
    // Update our own afaria status value.
    [AfariaController updateAfariaStatus:value];
    
    return value;
}

// 0 = ready, 1 = registration in-progress, 2 = Not Ready / Error
+ (int)afariaRegistrationStatusCode{
    return afariaClientStatus;
}

// Return the current status message for the afaria registration.
+ (NSString *)afariaRegistrationStatus{
    return statusMessage;
}

// Method to request a certificate from Afaria
+ (void)requestCertificateFromAfariaWithPrivateKey:(SecKeyRef)privateKey
                                                       andPublicKey:(SecKeyRef)publicKey
                                                       andchallenge:(NSString *)challenge
                                                            forUser:(NSString *)username
                                                        andPassword:(NSString *)password
                                                     intoCertBundle:(SecCertificateRef)certBundle{
    
    // Request the certificate from the Afaria library.
    [SeedingAPISynchronous retrieveUserCertificate:privateKey andPublicKey:publicKey andUserName:username andPassword:password andChallenge:challenge outCertificate:&certBundle];
}

#pragma mark - Private Methods

// Decode the current status code and store the correct message.
+ (void)updateAfariaStatus:(NSInteger)code
{
	switch(code)
	{
		case kAfariaSettingsRequested:
            statusMessage = @"Afaria Request in Progress.";
            afariaClientStatus = kAfariaRegistration_InProgress;
            break;
		case kUrlNotFromAfaria:
            statusMessage = @"URL received is not from Afaira - Cannot Continue.";
            afariaClientStatus = kAfariaRegistration_NotReady;
			break;
		case kAfariaClientNotInstalled:
            statusMessage = @"Afaria client not installed - Cannot Continue.";
            afariaClientStatus = kAfariaRegistration_NotReady;
			break;
        case kLibraryConfigured:
            statusMessage = @"Afaria Library Configured Correctly.";
            afariaClientStatus = kAfariaRegistration_Complete;
			break;
		case kInvalidSignature:
            statusMessage = @"Invalid signature on URL - Cannot Continue";
            afariaClientStatus = kAfariaRegistration_NotReady;
            break;
		case kValidBundleID:
			statusMessage = @"Bundle ID invalid - Cannot Continue.";
            afariaClientStatus = kAfariaRegistration_NotReady;
		default:
			statusMessage =  [NSString stringWithFormat:@"Library returned error: %d", code];
            afariaClientStatus = kAfariaRegistration_NotReady;
			break;
	}
    NSLog(@"Afaria Library status updated to: %@", statusMessage);
}

@end
