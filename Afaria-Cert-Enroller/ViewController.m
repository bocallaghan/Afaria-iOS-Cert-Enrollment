//
//  ViewController.m
//  Afaria-Cert-Enroller
//
//  Created by Brenton O'Callaghan on 06/05/2014.
//  Copyright (c) 2014 Bluefin Solutions Ltd. All rights reserved.
//

#import "ViewController.h"
#import "AfariaController.h"

@interface ViewController ()

@end

@implementation ViewController

SecKeyRef privateKey;
SecKeyRef publicKey;
SecCertificateRef certRef;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Initialise the Afaria library with the URL scheme of this app so it knows where to callback to.
- (IBAction)initialiseAfariaLibrary:(id)sender {
    [AfariaController initialiseAfariaLibraryWithURLScheme:@"bface"];
}

// Popup with the current status of the Afaria library.
- (IBAction)getCurrentStatus:(id)sender {
    
    // Prepare an alert with the Afaria status info.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Afaria Library Status" message:[AfariaController afariaRegistrationStatus] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the alert.
    [alert show];
}

- (IBAction)requestCertificate:(id)sender {
    
    // If we have not got an initialised afaria library we cannot request a certificate...
    if ([AfariaController afariaRegistrationStatusCode] != kAfariaRegistration_Complete) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Request Certificate" message:[AfariaController afariaRegistrationStatus] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        // Good to go - request a certificate.
        // This seems to use an async call so don't rely on having the result straight after.
        // May want to enhance this in the future with a callback delegate for correct behaviour.
        [AfariaController requestCertificateFromAfariaWithPrivateKey:privateKey andPublicKey:publicKey andchallenge:@"test3" forUser:@"username" andPassword:@"passwordHere" intoCertBundle:certRef];
    }
}

@end
