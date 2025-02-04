class LookAt {
  double lng;
  double lat;
  double alt;
  String range;
  String tilt;
  String heading;

  LookAt(this.lng, this.lat,
      this.alt,
      this.range, this.tilt, this.heading);

  generateTag() {
    return '''
       <LookAt>
        <longitude>${this.lng}</longitude>
        <latitude>${this.lat}</latitude>
        <altitude>${this.alt}</altitude>
        <range>${this.range}</range>
        <tilt>${this.tilt}</tilt>
        <heading>${this.heading}</heading>
        <gx:altitudeMode>relativeToGround</gx:altitudeMode>
      </LookAt>
    ''';
  }

  generateLinearString() {
    return '<LookAt><longitude>${this.lng}</longitude><latitude>${this.lat}</latitude><altitude>${this.alt}</altitude><range>${this.range}</range><tilt>${this.tilt}</tilt><heading>${this.heading}</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
  }

}
