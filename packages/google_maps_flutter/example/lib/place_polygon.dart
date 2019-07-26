import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class PlacePolygonPage extends Page {
  PlacePolygonPage() : super(const Icon(Icons.linear_scale), 'Place polygon');

  @override
  Widget build(BuildContext context) {
    return const PlacePolygonBody();
  }
}

class PlacePolygonBody extends StatefulWidget {
  const PlacePolygonBody();

  @override
  State<StatefulWidget> createState() => PlacePolygonBodyState();
}

class PlacePolygonBodyState extends State<PlacePolygonBody> {
  PlacePolygonBodyState();

  GoogleMapController controller;
  Map<GroundOverlayId, GroundOverlay> polygons = <GroundOverlayId, GroundOverlay>{};
  int _polygonIdCounter = 1;
  GroundOverlayId selectedGroundOverlay;

  // Values when toggling polygon color
  int strokeColorsIndex = 0;
  int fillColorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polygon width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onGroundOverlayTapped(GroundOverlayId polygonId) {
    setState(() {
      selectedGroundOverlay = polygonId;
    });
  }

  void _remove() {
    setState(() {
      if (polygons.containsKey(selectedGroundOverlay)) {
        polygons.remove(selectedGroundOverlay);
      }
      selectedGroundOverlay = null;
    });
  }

  void _add() {
    final int polygonCount = polygons.length;

    if (polygonCount == 12) {
      return;
    }

    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygonIdCounter++;
    final GroundOverlayId polygonId = GroundOverlayId(polygonIdVal);

    final GroundOverlay polygon = GroundOverlay(
      groundOverlayId: polygonId,
      consumeTapEvents: true,
      transparency: 0,
      bearing: 0,
      position: _createPosition(),
      visible: true,
      onTap: () {
        _onGroundOverlayTapped(polygonId);
      },
    );

    setState(() {
      polygons[polygonId] = polygon;
    });
  }

  void _toggleGeodesic() {
//    final GroundOverlay polygon = polygons[selectedGroundOverlay];
//    setState(() {
//      polygons[selectedGroundOverlay] = polygon.copyWith(
//        geodesicParam: !polygon.geodesic,
//      );
//    });
  }

  void _toggleVisible() {
    final GroundOverlay polygon = polygons[selectedGroundOverlay];
    setState(() {
      polygons[selectedGroundOverlay] = polygon.copyWith(
        visibleParam: !polygon.visible,
      );
    });
  }

  void _changeStrokeColor() {
//    final GroundOverlay polygon = polygons[selectedGroundOverlay];
//    setState(() {
//      polygons[selectedGroundOverlay] = polygon.copyWith(
//        strokeColorParam: colors[++strokeColorsIndex % colors.length],
//      );
//    });
  }

  void _changeFillColor() {
//    final GroundOverlay polygon = polygons[selectedGroundOverlay];
//    setState(() {
//      polygons[selectedGroundOverlay] = polygon.copyWith(
//        fillColorParam: colors[++fillColorsIndex % colors.length],
//      );
//    });
  }

  void _changeWidth() {
//    final GroundOverlay polygon = polygons[selectedGroundOverlay];
//    setState(() {
//      polygons[selectedGroundOverlay] = polygon.copyWith(
//        strokeWidthParam: widths[++widthsIndex % widths.length],
//      );
//    });
  }

  @override
  Widget build(BuildContext context) {
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
              groundOverlays: Set<GroundOverlay>.of(polygons.values),
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
                          onPressed: (selectedGroundOverlay == null) ? null : _remove,
                        ),
                        FlatButton(
                          child: const Text('toggle visible'),
                          onPressed:
                              (selectedGroundOverlay == null) ? null : _toggleVisible,
                        ),
                        FlatButton(
                          child: const Text('toggle geodesic'),
                          onPressed: (selectedGroundOverlay == null)
                              ? null
                              : _toggleGeodesic,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change stroke width'),
                          onPressed:
                              (selectedGroundOverlay == null) ? null : _changeWidth,
                        ),
                        FlatButton(
                          child: const Text('change stroke color'),
                          onPressed: (selectedGroundOverlay == null)
                              ? null
                              : _changeStrokeColor,
                        ),
                        FlatButton(
                          child: const Text('change fill color'),
                          onPressed: (selectedGroundOverlay == null)
                              ? null
                              : _changeFillColor,
                        ),
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

  LatLng _createPosition() {
    final double offset = _polygonIdCounter.ceilToDouble();
    return _createLatLng(52.1231 + offset, -5.0829);
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}
