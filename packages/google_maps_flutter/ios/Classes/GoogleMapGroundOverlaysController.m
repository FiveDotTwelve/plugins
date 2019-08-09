#import <Foundation/Foundation.h>
#import "GoogleMapGroundOverlaysController.h"

@implementation FLTGoogleMapGroundOverlayController {
    GMSGroundOverlay* _groundOverlay;
    GMSMapView* _mapView;
}
- (instancetype)initGroundOverlayWithBound:(GMSCoordinateBounds *)bounds
                           groundOverlayId:(NSString *)groundOverlayId
                                      icon:(UIImage *)icon
                                   mapView:(GMSMapView *)mapView {
    self = [super init];
    if (self) {
        _groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:bounds icon:icon];
        _mapView = mapView;
        _groundOverlayId = groundOverlayId;
        _groundOverlay.userData = @[ groundOverlayId ];
    }
    return self;
}

- (void)removeGroundOverlay {
    _groundOverlay.map = nil;
}

#pragma mark - FLTGoogleMapFroundOverlayOptionsSink methods

- (void)setConsumeTapEvents:(BOOL)consumes {
    _groundOverlay.tappable = consumes;
}
- (void)setVisible:(BOOL)visible {
    _groundOverlay.map = visible ? _mapView : nil;
}
- (void)setPosition:(CLLocationCoordinate2D)position {
    _groundOverlay.position = position;
}
- (void)setImage:(UIImage *)image {
    _groundOverlay.icon = image;
}
- (void)setPositionFromBound:(GMSCoordinateBounds *)bounds {
    _groundOverlay.bounds = bounds;
}
- (void)setBearing:(CLLocationDirection)bearing {
    _groundOverlay.bearing = bearing;
}
- (void)setZIndex:(int)zIndex {
    _groundOverlay.zIndex = zIndex;
}
- (void)setOpacity:(float)opacity {
    _groundOverlay.opacity = opacity;
}
- (void)setAnchor:(CGPoint)anchor {
    _groundOverlay.anchor = anchor;
}
- (void)setTitle:(NSString *)title {
    _groundOverlay.title = title;
}
@end

@implementation FLTGroundOverlaysController {
    NSMutableDictionary* _groundOverlayIdToController;
    FlutterMethodChannel* _methodChannel;
    NSObject<FlutterPluginRegistrar>* _registrar;
    GMSMapView* _mapView;
}
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _methodChannel = methodChannel;
        _mapView = mapView;
        _groundOverlayIdToController = [NSMutableDictionary dictionaryWithCapacity:1];
        _registrar = registrar;
    }
    return self;
}
- (void)addGroundOverlays:(NSArray *)groundOverlaysToAdd {
    for (NSDictionary* groundOverlay in groundOverlaysToAdd) {
        NSString* groundOverlayId = [FLTGroundOverlaysController getGroundOverlayId:groundOverlay];
        GMSCoordinateBounds* bounds = [FLTGroundOverlaysController getGroundOverlayBounds:groundOverlay];
        NSArray* iconData = groundOverlay[@"image"];
        UIImage* icon = ExtractIcon(_registrar, iconData);
        FLTGoogleMapGroundOverlayController* controller =
            [[FLTGoogleMapGroundOverlayController alloc]
             initGroundOverlayWithBound:bounds
             groundOverlayId:groundOverlayId
             icon:icon
             mapView:_mapView];
        InterpretGroundOverlayOptions(groundOverlay, controller, _registrar);
        _groundOverlayIdToController[groundOverlayId] = controller;
    }
}
- (void)changeGroundOverlays:(NSArray *)groundOverlaysToChange {
    for (NSDictionary* groundOverlay in groundOverlaysToChange) {
        NSString* groundOverlayId = [FLTGroundOverlaysController getGroundOverlayId:groundOverlay];
        FLTGoogleMapGroundOverlayController* controller = _groundOverlayIdToController[groundOverlayId];
        if (!controller) {
            continue;
        }
        InterpretGroundOverlayOptions(groundOverlay, controller, _registrar);
    }
}
- (void)removeGroundOverlaysIds:(NSArray *)groundOverlaysIdsToRemove {
    for (NSString* groundOverlayId in groundOverlaysIdsToRemove) {
        if (!groundOverlayId) {
            continue;
        }
        FLTGoogleMapGroundOverlayController* controller = _groundOverlayIdToController[groundOverlayId];
        if (!controller) {
            continue;
        }
        [controller removeGroundOverlay];
        [_groundOverlayIdToController removeObjectForKey:groundOverlayId];
    }
}
- (bool)hasGroundOverlayWithId:(NSString *)groundOverlayId {
    if (!groundOverlayId) {
        return false;
    }
    return _groundOverlayIdToController[groundOverlayId] != nil;
}

static void InterpretGroundOverlayOptions(NSDictionary* data, id<FLTGoogleMapGroundOverlaySink> sink, NSObject<FlutterPluginRegistrar>* registrar) {
    NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
    if (consumeTapEvents) {
        [sink setConsumeTapEvents:ToBool(consumeTapEvents)];
    }
    
    NSNumber* bearing = data[@"bearing"];
    if (bearing) {
        [sink setBearing:ToDouble(bearing)];
    }
    
    NSNumber* zIndex = data[@"zIndex"];
    if (zIndex) {
        [sink setZIndex:ToInt(zIndex)];
    }
    
    NSNumber* visible = data[@"visible"];
    if (visible) {
        [sink setVisible:ToBool(visible)];
    }
    
    NSNumber* transparency = data[@"transparency"];
    if (transparency) {
        [sink setOpacity:1.0 - ToFloat(transparency)];
    }
}

static UIImage* scaleImage(UIImage* image, NSNumber* scaleParam) {
    double scale = 1.0;
    if ([scaleParam isKindOfClass:[NSNumber class]]) {
        scale = scaleParam.doubleValue;
    }
    if (fabs(scale - 1) > 1e-3) {
        return [UIImage imageWithCGImage:[image CGImage]
                                   scale:(image.scale * scale)
                             orientation:(image.imageOrientation)];
    }
    return image;
}

static BOOL ToBool(NSNumber* data) { return [FLTGoogleMapJsonConversions toBool:data]; }

static int ToInt(NSNumber* data) { return [FLTGoogleMapJsonConversions toInt:data]; }

static float ToFloat(NSNumber* data) { return [FLTGoogleMapJsonConversions toFloat:data]; }

static double ToDouble(NSNumber* data) { return [FLTGoogleMapJsonConversions toDouble:data]; }

static UIImage* ExtractIcon(NSObject<FlutterPluginRegistrar>* registrar, NSArray* iconData) {
    UIImage* image;
    if ([iconData.firstObject isEqualToString:@"defaultMarker"]) {
        CGFloat hue = (iconData.count == 1) ? 0.0f : ToDouble(iconData[1]);
        image = [GMSMarker markerImageWithColor:[UIColor colorWithHue:hue / 360.0
                                                           saturation:1.0
                                                           brightness:0.7
                                                                alpha:1.0]];
    } else if ([iconData.firstObject isEqualToString:@"fromAsset"]) {
        if (iconData.count == 2) {
            image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
        } else {
            image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]
                                                         fromPackage:iconData[2]]];
        }
    } else if ([iconData.firstObject isEqualToString:@"fromAssetImage"]) {
        if (iconData.count == 3) {
            image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
            NSNumber* scaleParam = iconData[2];
            image = scaleImage(image, scaleParam);
        } else {
            NSString* error =
            [NSString stringWithFormat:@"'fromAssetImage' should have exactly 3 arguments. Got: %lu",
             iconData.count];
            NSException* exception = [NSException exceptionWithName:@"InvalidBitmapDescriptor"
                                                             reason:error
                                                           userInfo:nil];
            @throw exception;
        }
    } else if ([iconData[0] isEqualToString:@"fromBytes"]) {
        if (iconData.count == 2) {
            @try {
                FlutterStandardTypedData* byteData = iconData[1];
                CGFloat screenScale = [[UIScreen mainScreen] scale];
                image = [UIImage imageWithData:[byteData data] scale:screenScale];
            } @catch (NSException* exception) {
                @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                               reason:@"Unable to interpret bytes as a valid image."
                                             userInfo:nil];
            }
        } else {
            NSString* error = [NSString
                               stringWithFormat:@"fromBytes should have exactly one argument, the bytes. Got: %lu",
                               iconData.count];
            NSException* exception = [NSException exceptionWithName:@"InvalidByteDescriptor"
                                                             reason:error
                                                           userInfo:nil];
            @throw exception;
        }
    }
    
    return image;
}

+ (GMSCoordinateBounds*)getGroundOverlayBounds:(NSDictionary*)groundOverlay {
    NSArray* latLngBounds = groundOverlay[@"latLngBounds"];
    NSArray<NSNumber*>* coord1Array = latLngBounds[0];
    NSArray<NSNumber*>* coord2Array = latLngBounds[1];
    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(coord1Array[0].doubleValue, coord1Array[1].doubleValue);
    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(coord2Array[0].doubleValue, coord2Array[1].doubleValue);
    return [[GMSCoordinateBounds alloc] initWithCoordinate:coord1 coordinate:coord2];
}
+ (NSString*)getGroundOverlayId:(NSDictionary*)groundOverlay {
    return groundOverlay[@"groundOverlayId"];
}
@end
