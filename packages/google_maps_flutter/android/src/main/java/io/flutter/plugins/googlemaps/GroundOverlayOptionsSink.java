package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

/** Receiver of GroundOverlay configuration options. */
interface GroundOverlayOptionsSink {

  void setConsumeTapEvents(boolean consumetapEvents);

  void setPosition(LatLng position);

  void setImage(BitmapDescriptor image);

  void setDimensions(float width);

  void setDimensions(float width, float height);

  void setPositionFromBounds(LatLngBounds bounds);

  void setBearing(float bearing);

  void setZIndex(float zIndex);

  void setVisible(boolean visible);

  void setTransparency(float transparency);
}
