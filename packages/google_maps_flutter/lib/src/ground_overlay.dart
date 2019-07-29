part of google_maps_flutter;

/// Uniquely identifies a [GroundOverlay] among [GoogleMap] GroundOverlays.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class GroundOverlayId {
  GroundOverlayId(this.value) : assert(value != null);

  /// value of the [GroundOverlayId].
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GroundOverlayId typedOther = other;
    return value == typedOther.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'GroundOverlayId{value: $value}';
  }
}

/// Draws a GroundOverlay through geographical locations on the map.
@immutable
class GroundOverlay {
  const GroundOverlay({
    @required this.groundOverlayId,
    this.consumeTapEvents = false,
    this.position,
    this.latLngBounds,
    this.image = BitmapDescriptor.defaultMarker,
    this.bearing = 0,
    this.zIndex = 0.0,
    this.visible = true,
    this.transparency = 0.0,
    this.onTap,
  }) : assert(transparency == null ||
            (0.0 <= transparency && transparency <= 1.0));

  /// Uniquely identifies a [GroundOverlay].
  final GroundOverlayId groundOverlayId;

  /// True if the [GroundOverlay] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  /// Geographical location of the [GroundOverlay].
  final LatLng position;

  /// The geographical bounding box for the [GroundOverlay].
  final LatLngBounds latLngBounds;

  /// A description of the bitmap used to draw the groundOverlay.
  final BitmapDescriptor image;

  /// Specifies the bearing of the [GroundOverlay] in degrees clockwise from north.
  /// The rotation is performed about the anchor point. If not specified, the default
  /// is 0 (i.e., up on the image points north).
  /// Note that latitude-longitude bound applies before the rotation.
  /// The bearing in degrees clockwise from north. Values outside the range [0, 360)
  /// will be normalized.
  final int bearing;

  /// The z-index of the [GroundOverlay], used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final double zIndex;

  /// True if the marker is visible.
  final bool visible;

  /// The transparency of the [GroundOverlay], between 0.0 and 1.0 inclusive.
  ///
  /// 0.0 means fully opaque, 1.0 means fully transparent.
  final double transparency;

  /// Callbacks to receive tap events for GroundOverlay placed on this map.
  final VoidCallback onTap;

  /// Creates a new [GroundOverlay] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  GroundOverlay copyWith({
    bool consumeTapEventsParam,
    LatLng positionParam,
    LatLngBounds latLngBoundsParam,
    BitmapDescriptor imageParam,
    int bearingParam,
    double zIndexParam,
    bool visibleParam,
    double transparencyParam,
    VoidCallback onTapParam,
  }) {
    return GroundOverlay(
      groundOverlayId: groundOverlayId,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      position: positionParam ?? position,
      latLngBounds: latLngBoundsParam ?? latLngBounds,
      image: imageParam ?? image,
      bearing: bearingParam ?? bearing,
      zIndex: zIndexParam ?? zIndex,
      visible: visibleParam ?? visible,
      transparency: transparencyParam ?? transparency,
      onTap: onTapParam ?? onTap,
    );
  }

  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('groundOverlayId', groundOverlayId.value);
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('position', position?._toJson());
    addIfPresent('latLngBounds', latLngBounds?._toList());
    addIfPresent('image', image?._toJson());
    addIfPresent('bearing', bearing);
    addIfPresent('zIndex', zIndex);
    addIfPresent('visible', visible);
    addIfPresent('transparency', transparency);
    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final GroundOverlay typedOther = other;
    return groundOverlayId == typedOther.groundOverlayId;
  }

  @override
  int get hashCode => groundOverlayId.hashCode;
}

Map<GroundOverlayId, GroundOverlay> _keyByGroundOverlayId(
    Iterable<GroundOverlay> groundOverlays) {
  if (groundOverlays == null) {
    return <GroundOverlayId, GroundOverlay>{};
  }
  return Map<GroundOverlayId, GroundOverlay>.fromEntries(groundOverlays.map(
      (GroundOverlay groundOverlay) => MapEntry<GroundOverlayId, GroundOverlay>(
          groundOverlay.groundOverlayId, groundOverlay)));
}

List<Map<String, dynamic>> _serializeGroundOverlaySet(
    Set<GroundOverlay> groundOverlays) {
  if (groundOverlays == null) {
    return null;
  }
  return groundOverlays
      .map<Map<String, dynamic>>((GroundOverlay p) => p._toJson())
      .toList();
}
