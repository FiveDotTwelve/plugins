package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

class GroundOverlayBuilder implements GroundOverlayOptionsSink {
    private final GroundOverlayOptions groundOverlayOptions;
    private boolean consumeTapEvents;

    GroundOverlayBuilder() {
        this.groundOverlayOptions = new GroundOverlayOptions();
    }

    GroundOverlayOptions build() {
        return groundOverlayOptions;
    }

    boolean consumeTapEvents() {
        return consumeTapEvents;
    }

    @Override
    public void setConsumeTapEvents(boolean consumeTapEvents) {
        this.consumeTapEvents = consumeTapEvents;
        groundOverlayOptions.clickable(consumeTapEvents);
    }

    @Override
    public void setPosition(LatLng position) {
        groundOverlayOptions.position(position, 0);
    }

    @Override
    public void setImage(BitmapDescriptor image) {
        groundOverlayOptions.image(image);
    }

    @Override
    public BitmapDescriptor getImage() {
        return groundOverlayOptions.getImage();
    }

    @Override
    public void setDimensions(float width) {
    }

    @Override
    public void setDimensions(float width, float height) {
    }

    @Override
    public void setPositionFromBounds(LatLngBounds bounds) {
        groundOverlayOptions.positionFromBounds(bounds);
    }

    @Override
    public LatLngBounds getPositionFromBounds() {
        return groundOverlayOptions.getBounds();
    }

    @Override
    public void setBearing(float bearing) {
        groundOverlayOptions.bearing(bearing);
    }


    @Override
    public void setVisible(boolean visible) {
        groundOverlayOptions.visible(visible);
    }

    @Override
    public void setTransparency(float transparency) {
        groundOverlayOptions.transparency(transparency);
    }

    @Override
    public float getTransparency() {
        return groundOverlayOptions.getTransparency();
    }

    @Override
    public void setZIndex(float zIndex) {
        groundOverlayOptions.zIndex(zIndex);
    }
}
