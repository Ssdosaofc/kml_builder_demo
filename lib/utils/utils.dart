import 'package:google_maps_flutter/google_maps_flutter.dart';

class Utility{
  Set<Marker> markers;
  List<LatLng> vertices;
  List<LatLng> path;

  Utility({Set<Marker>? markers, List<LatLng>? vertices, List<LatLng>? path})
      : markers = markers ?? {},
        vertices = vertices ?? [],
        path = path ?? [];

  String toVerticesKml(List<LatLng> vertices){
    String val = '';
    for(var vertex in vertices){
      val += '${vertex.longitude},${vertex.latitude},0 ';
    }
    return val;
  }
  String toPathKml(List<LatLng> vertices){
    String val = '';
    for(var vertex in vertices){
      val += '${vertex.longitude},${vertex.latitude},0 ';
    }
    return val;
  }

  createPolyline(List<LatLng> vertices){
    return '''
    <StyleMap id="m_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl</styleUrl>
		</Pair>
	</StyleMap>
	<Style id="s_ylw-pushpin">
		<LineStyle>
			<color>ff0000ff</color>
			<width>3</width>
		</LineStyle>
	</Style>
	<Style id="s_ylw-pushpin_hl">
		<LineStyle>
			<color>ff0000ff</color>
			<width>3</width>
		</LineStyle>
	</Style>
	<Placemark>
		<styleUrl>#m_ylw-pushpin</styleUrl>
		<LineString>
			<tessellate>1</tessellate>
			<coordinates>
			  ${toPathKml(vertices)}
			</coordinates>
		</LineString>
	</Placemark>
    ''';
  }

  createPolygon(List<LatLng> vertices){
    return '''
    <StyleMap id="msn_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#sn_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#sh_ylw-pushpin</styleUrl>
		</Pair>
	</StyleMap>
	<Style id="sh_ylw-pushpin">
		<LineStyle>
			<color>ffff9300</color>
		</LineStyle>
		<PolyStyle>
			<color>4cff6400</color>
		</PolyStyle>
	</Style>
	<Style id="sn_ylw-pushpin">
		<LineStyle>
			<color>ffff9300</color>
		</LineStyle>
		<PolyStyle>
			<color>4cff6400</color>
		</PolyStyle>
	</Style>
	<Placemark>
		<name>Untitled Polygon</name>
		<styleUrl>#msn_ylw-pushpin</styleUrl>
		<Polygon>
			<tessellate>1</tessellate>
			<outerBoundaryIs>
				<LinearRing>
					<coordinates>
						${toVerticesKml(vertices)}
					</coordinates>
				</LinearRing>
			</outerBoundaryIs>
		</Polygon>
	</Placemark>
    ''';
  }

  createMarker(Marker marker){
    return '''
    <StyleMap id="m_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl</styleUrl>
		</Pair>
	</StyleMap>
	<Style id="s_ylw-pushpin">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/paddle/red-circle.png</href>
			</Icon>
			<hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<ListStyle>
			<ItemIcon>
				<href>http://maps.google.com/mapfiles/kml/paddle/red-circle-lv.png</href>
			</ItemIcon>
		</ListStyle>
	</Style>
	<Style id="s_ylw-pushpin_hl">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/paddle/red-circle.png</href>
			</Icon>
			<hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<ListStyle>
			<ItemIcon>
				<href>http://maps.google.com/mapfiles/kml/paddle/red-circle-lv.png</href>
			</ItemIcon>
		</ListStyle>
	</Style>
	<Placemark>
		<styleUrl>#m_ylw-pushpin</styleUrl>
		<Point>
			<gx:drawOrder>1</gx:drawOrder>
			<coordinates>${marker.position.longitude},${marker.position.latitude},0</coordinates>
		</Point>
	</Placemark>
    ''';
  }
}