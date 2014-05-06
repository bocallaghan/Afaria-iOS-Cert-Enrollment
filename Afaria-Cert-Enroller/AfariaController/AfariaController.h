//
//  AfariaController.h
//  Afaria-Cert-Enroller
//
//  Created by Brenton O'Callaghan on 06/05/2014.
//  Copyright (c) 2014 Bluefin Solutions Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAfariaRegistration_Complete    0
#define kAfariaRegistration_InProgress  1
#define kAfariaRegistration_NotReady    2

@interface AfariaController : NSObject

#pragma mark - Static initialisation & callback methods

// First method to be called to setup the Afaria Library
+ (id)initialiseAfariaLibraryWithURLScheme:(NSString *)appUrlScheme;

// Callback handler for when the afaria app responds with settings etc.
+ (int)handleAfariaCallbackWithURL:(NSURL *)url;

// 0 = ready, 1 = registration in-progress, 2 = Not Ready / Error
+ (int)afariaRegistrationStatusCode;
// Status text of the current Afaria registration status.
+ (NSString *)afariaRegistrationStatus;

// Method to request a certificate from Afaria
+ (void)requestCertificateFromAfariaWithPrivateKey:(SecKeyRef)privateKey
                                                       andPublicKey:(SecKeyRef)publicKey
                                                          andchallenge:(NSString *)challenge
                                                            forUser:(NSString *)username
                                                        andPassword:(NSString *)password
                                                      intoCertBundle:(SecCertificateRef)certBundle;

@end
