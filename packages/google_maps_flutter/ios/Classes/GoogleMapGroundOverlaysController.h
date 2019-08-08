#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GoogleMapMarkerController.h"
#import "JsonConversions.h"

// Defines ground overlay UI operations writable from Flutter.
@protocol FLTGoogleMapGroundOverlaySink
- (void)setConsumeTapEvents:(BOOL)consumes;
- (void)setVisible:(BOOL)visible;
- (void)setPosition:(CLLocationCoordinate2D)position;
- (void)setImage:(UIImage*)image;
- (void)setPositionFromBound:(GMSCoordinateBounds*)bounds;
- (void)setBearing:(CLLocationDirection)bearing;
- (void)setZIndex:(int)zIndex;
- (void)setOpacity:(float)opacity;
- (void)setAnchor:(CGPoint)anchor;
- (void)setTitle:(NSString*)title;
@end

// Defines ground overlay controllable by Flutter.
@interface FLTGoogleMapGroundOverlayController : NSObject <FLTGoogleMapGroundOverlaySink>
@property(atomic, readonly) NSString* groundOverlayId;
- (instancetype)initGroundOverlayWithBound:(GMSCoordinateBounds*)bounds
                           groundOverlayId:(NSString *)groundOverlayId
                                      icon:(UIImage*)icon
                                   mapView:(GMSMapView*)mapView;
- (void)removeGroundOverlay;
@end

@interface FLTGroundOverlaysController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addGroundOverlays:(NSArray*)groundOverlaysToAdd;
- (void)changeGroundOverlays:(NSArray*)groundOverlaysToChange;
- (void)removeGroundOverlaysIds:(NSArray*)groundOverlaysIdsToRemove;
- (void)onGroundOverlayTap:(NSString*)groundOverlayId;
- (bool)hasGroundOverlayWithId:(NSString*)groundOverlayId;
@end



