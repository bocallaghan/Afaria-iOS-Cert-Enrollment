//
//  ViewController.h
//  Afaria-Cert-Enroller
//
//  Created by Brenton O'Callaghan on 06/05/2014.
//  Copyright (c) 2014 Bluefin Solutions Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// Initialise the library from the button press.
- (IBAction)initialiseAfariaLibrary:(id)sender;

// Request a certificate from the button press.
- (IBAction)requestCertificate:(id)sender;

// Get the current status of the Afaria library.
- (IBAction)getCurrentStatus:(id)sender;

@end
