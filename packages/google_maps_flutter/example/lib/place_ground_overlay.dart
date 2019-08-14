import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class PlaceGroundOverlayPage extends Page {
  PlaceGroundOverlayPage()
      : super(const Icon(Icons.linear_scale), 'Place ground overlay');

  @override
  Widget build(BuildContext context) {
    return const PlaceGroundOverlayBody();
  }
}

class PlaceGroundOverlayBody extends StatefulWidget {
  const PlaceGroundOverlayBody();

  @override
  State<StatefulWidget> createState() => PlaceGroundOverlayBodyState();
}

class PlaceGroundOverlayBodyState extends State<PlaceGroundOverlayBody> {
  PlaceGroundOverlayBodyState();

  GoogleMapController controller;
  Map<GroundOverlayId, GroundOverlay> groundOverlays =
      <GroundOverlayId, GroundOverlay>{};
  int _groundOverlayIdCounter = 1;
  GroundOverlayId selectedGroundOverlay;
  BitmapDescriptor _groundOverlayImage;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onGroundOverlayTapped(GroundOverlayId groundOverlayId) {
    setState(() {
      selectedGroundOverlay = groundOverlayId;
    });
  }

  void _remove() {
    setState(() {
      if (groundOverlays.containsKey(selectedGroundOverlay)) {
        groundOverlays.remove(selectedGroundOverlay);
      }
      selectedGroundOverlay = null;
    });
  }

  void _add() {
    final int groundOverlayCount = groundOverlays.length;

    if (groundOverlayCount == 5) {
      return;
    }

    final String groundOverlayIdVal =
        'ground_overlay_id_$_groundOverlayIdCounter';
    _groundOverlayIdCounter++;
    final GroundOverlayId groundOverlayId = GroundOverlayId(groundOverlayIdVal);

    final GroundOverlay groundOverlay = GroundOverlay(
      groundOverlayId: groundOverlayId,
      consumeTapEvents: true,
      image: _groundOverlayImage,
      latLngBounds: _createLatLngBounds(),
      onTap: () {
        _onGroundOverlayTapped(groundOverlayId);
      },
    );

    setState(() {
      groundOverlays[groundOverlayId] = groundOverlay;
    });
  }

  void _setRandomBearing() {
    final GroundOverlay groundOverlay = groundOverlays[selectedGroundOverlay];
    setState(() {
      groundOverlays[selectedGroundOverlay] = groundOverlay.copyWith(
        bearingParam: Random().nextInt(360),
      );
    });
  }

  void _toggleVisible() {
    final GroundOverlay groundOverlay = groundOverlays[selectedGroundOverlay];
    setState(() {
      groundOverlays[selectedGroundOverlay] = groundOverlay.copyWith(
        visibleParam: !groundOverlay.visible,
      );
    });
  }

  void _setRandomTransparency() {
    final GroundOverlay groundOverlay = groundOverlays[selectedGroundOverlay];
    setState(() {
      groundOverlays[selectedGroundOverlay] = groundOverlay.copyWith(
        transparencyParam: Random().nextDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(52.4478, -3.5402),
                zoom: 7.0,
              ),
              groundOverlays: Set<GroundOverlay>.of(groundOverlays.values),
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed:
                              (selectedGroundOverlay == null) ? null : _remove,
                        ),
                        FlatButton(
                          child: const Text('toggle visible'),
                          onPressed: (selectedGroundOverlay == null)
                              ? null
                              : _toggleVisible,
                        ),
                        FlatButton(
                          child: const Text('random bearing'),
                          onPressed: (selectedGroundOverlay == null)
                              ? null
                              : _setRandomBearing,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('random transparency'),
                          onPressed: (selectedGroundOverlay == null)
                              ? null
                              : _setRandomTransparency,
                        ),
                        Slider(
                            value: groundOverlays[selectedGroundOverlay]
                                    ?.transparency ??
                                0,
                            onChanged: (value) => setState(() {
                                  groundOverlays[selectedGroundOverlay] =
                                      groundOverlays[selectedGroundOverlay]
                                          .copyWith(
                                    transparencyParam: value,
                                  );
                                }))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  LatLngBounds _createLatLngBounds() {
    final double offset = _groundOverlayIdCounter.ceilToDouble();
    return LatLngBounds(
      southwest: LatLng(51.2395 + offset, -3.4314),
      northeast: LatLng(52.1231 + offset, 0.0829),
    );
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_groundOverlayImage == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/red_square.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    _groundOverlayImage = bitmap;
  }
}
