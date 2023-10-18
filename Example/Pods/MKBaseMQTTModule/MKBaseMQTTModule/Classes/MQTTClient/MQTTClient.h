//
//  MQTTClient.h
//  MQTTClient
//
//  Created by Christoph Krey on 13.01.14.
//  Copyright © 2013-2017 Christoph Krey. All rights reserved.
//

/**
 Include this file to use MQTTClient classes in your application
 
 @author Christoph Krey c@ckrey.de
 @see http://mqtt.org
 */

#import <Foundation/Foundation.h>

#import <MKBaseMQTTModule/MQTTSession.h>
#import <MKBaseMQTTModule/MQTTDecoder.h>
#import <MKBaseMQTTModule/MQTTSessionLegacy.h>
#import <MKBaseMQTTModule/MQTTSessionSynchron.h>
#import <MKBaseMQTTModule/MQTTProperties.h>
#import <MKBaseMQTTModule/MQTTMessage.h>
#import <MKBaseMQTTModule/MQTTTransport.h>
#import <MKBaseMQTTModule/MQTTCFSocketTransport.h>
#import <MKBaseMQTTModule/MQTTCoreDataPersistence.h>
#import <MKBaseMQTTModule/MQTTSSLSecurityPolicyTransport.h>
#import <MKBaseMQTTModule/MQTTLog.h>

#if __has_include(<MQTTClient/MQTTSessionManager.h>)
#import <MKBaseMQTTModule/MQTTSessionManager.h>
#endif

//! Project version number for MQTTClient.
FOUNDATION_EXPORT double MQTTClientVersionNumber;

//! Project version string for MQTTClient&lt;.
FOUNDATION_EXPORT const unsigned char MQTTClientVersionString[];

