part of google_maps_flutter;

/// [GroundOverlay] update events to be applied to the [GoogleMap].
///
/// Used in [GoogleMapController] when the map is updated.
class _GroundOverlayUpdates {
  /// Computes [_GroundOverlayUpdates] given previous and current [GroundOverlay]s.
  _GroundOverlayUpdates.from(Set<GroundOverlay> previous, Set<GroundOverlay> current) {
    if (previous == null) {
      previous = Set<GroundOverlay>.identity();
    }

    if (current == null) {
      current = Set<GroundOverlay>.identity();
    }

    final Map<GroundOverlayId, GroundOverlay> previousGroundOverlays = _keyByGroundOverlayId(previous);
    final Map<GroundOverlayId, GroundOverlay> currentGroundOverlays = _keyByGroundOverlayId(current);

    final Set<GroundOverlayId> prevGroundOverlayIds = previousGroundOverlays.keys.toSet();
    final Set<GroundOverlayId> currentGroundOverlayIds = currentGroundOverlays.keys.toSet();

    GroundOverlay idToCurrentGroundOverlay(GroundOverlayId id) {
      return currentGroundOverlays[id];
    }

    final Set<GroundOverlayId> _groundOverlayIdsToRemove =
    prevGroundOverlayIds.difference(currentGroundOverlayIds);

    final Set<GroundOverlay> _groundOverlaysToAdd = currentGroundOverlayIds
        .difference(prevGroundOverlayIds)
        .map(idToCurrentGroundOverlay)
        .toSet();

    final Set<GroundOverlay> _groundOverlaysToChange = currentGroundOverlayIds
        .intersection(prevGroundOverlayIds)
        .map(idToCurrentGroundOverlay)
        .toSet();

    groundOverlaysToAdd = _groundOverlaysToAdd;
    groundOverlayIdsToRemove = _groundOverlayIdsToRemove;
    groundOverlaysToChange = _groundOverlaysToChange;
  }

  Set<GroundOverlay> groundOverlaysToAdd;
  Set<GroundOverlayId> groundOverlayIdsToRemove;
  Set<GroundOverlay> groundOverlaysToChange;

  Map<String, dynamic> _toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('groundOverlaysToAdd', _serializeGroundOverlaySet(groundOverlaysToAdd));
    addIfNonNull('groundOverlaysToChange', _serializeGroundOverlaySet(groundOverlaysToChange));
    addIfNonNull('groundOverlayIdsToRemove',
        groundOverlayIdsToRemove.map<dynamic>((GroundOverlayId m) => m.value).toList());

    return updateMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final _GroundOverlayUpdates typedOther = other;
    return setEquals(groundOverlaysToAdd, typedOther.groundOverlaysToAdd) &&
        setEquals(groundOverlayIdsToRemove, typedOther.groundOverlayIdsToRemove) &&
        setEquals(groundOverlaysToChange, typedOther.groundOverlaysToChange);
  }

  @override
  int get hashCode =>
      hashValues(groundOverlaysToAdd, groundOverlayIdsToRemove, groundOverlaysToChange);

  @override
  String toString() {
    return '_GroundOverlayUpdates{groundOverlaysToAdd: $groundOverlaysToAdd, '
        'groundOverlayIdsToRemove: $groundOverlayIdsToRemove, '
        'groundOverlaysToChange: $groundOverlaysToChange}';
  }
}
