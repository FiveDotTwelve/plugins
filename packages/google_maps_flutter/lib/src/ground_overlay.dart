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
    this.bearing,
    this.zIndex = 0,
    this.visible = true,
    this.transparency = 1,
    this.onTap,
  });

  /// Uniquely identifies a [GroundOverlay].
  final GroundOverlayId groundOverlayId;

  /// True if the [GroundOverlay] consumes tap events.
  ///
  /// If this is false, [onTap] callback will not be triggered.
  final bool consumeTapEvents;

  //todo description
  final LatLng position;

  //todo description
  final int bearing;

  /// The z-index of the GroundOverlay, used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final int zIndex;

  /// True if the marker is visible.
  final bool visible;

  //todo description
  final int transparency;

  /// Callbacks to receive tap events for GroundOverlay placed on this map.
  final VoidCallback onTap;

  /// Creates a new [GroundOverlay] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  GroundOverlay copyWith({
    bool consumeTapEventsParam,
    LatLng positionParam,
    int bearingParam,
    int zIndexParam,
    bool visibleParam,
    int transparencyParam,
    VoidCallback onTapParam,
  }) {
    return GroundOverlay(
      groundOverlayId: groundOverlayId,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      position: positionParam ?? position,
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
    addIfPresent('bearing', bearing);
    addIfPresent('zIndex', zIndex);
    addIfPresent('visible', visible);
    addIfPresent('transparency', transparency);

    if (position != null) {
      json['position'] = _positionToJson();
    }

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

  dynamic _positionToJson() {
    return position._toJson();
  }
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
