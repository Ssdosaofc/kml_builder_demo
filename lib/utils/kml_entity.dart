class KMLEntity {
  String name;

  String content;

  String desc;

  KMLEntity({
    required this.name,
    required this.content,
    required this.desc,
  });

  String get body => '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>$name</name>
    <description>
        $desc
      </description>
    $content
  </Document>
</kml>
  ''';
}