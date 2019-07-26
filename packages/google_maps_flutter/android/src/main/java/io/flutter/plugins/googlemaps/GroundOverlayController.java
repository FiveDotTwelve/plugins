package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

/**
 * Controller of a single GroundOverlay on the map.
 */
class GroundOverlayController implements GroundOverlayOptionsSink {
    private final GroundOverlay groundOverlay;
    private final String googleMapsGroundOverlayId;
    private boolean consumeTapEvents;

    GroundOverlayController(GroundOverlay groundOverlay, boolean consumeTapEvents) {
        this.groundOverlay = groundOverlay;
        this.consumeTapEvents = consumeTapEvents;
        this.googleMapsGroundOverlayId = groundOverlay.getId();
    }

    void remove() {
        groundOverlay.remove();
    }

    @Override
    public void setConsumeTapEvents(boolean consumeTapEvents) {
        this.consumeTapEvents = consumeTapEvents;
        groundOverlay.setClickable(consumeTapEvents);
    }

    @Override
    public void setPosition(LatLng position) {
        groundOverlay.setPosition(position);
    }

    @Override
    public void setImage(BitmapDescriptor image) {
        groundOverlay.setImage(image);
    }

    @Override
    public void setDimensions(float width) {
        groundOverlay.setDimensions(width);
    }

    @Override
    public void setDimensions(float width, float height) {
        groundOverlay.setDimensions(width, height);
    }

    @Override
    public void setPositionFromBounds(LatLngBounds bounds) {
        groundOverlay.setPositionFromBounds(bounds);
    }

    @Override
    public void setBearing(float bearing) {
        groundOverlay.setBearing(bearing);
    }

    @Override
    public void setVisible(boolean visible) {
        groundOverlay.setVisible(visible);
    }

    @Override
    public void setTransparency(float transparency) {
        groundOverlay.setTransparency(transparency);
    }

    @Override
    public void setZIndex(float zIndex) {
        groundOverlay.setZIndex(zIndex);
    }

    String getGoogleMapsGroundOverlayId() {
        return googleMapsGroundOverlayId;
    }

    boolean consumeTapEvents() {
        return consumeTapEvents;
    }
}
