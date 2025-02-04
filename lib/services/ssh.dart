import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartssh2/dartssh2.dart';

import '../utils/LookAt.dart';
import '../utils/kml_entity.dart';

class Ssh{
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  final String _url = 'http://lg1:81';

  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool?> connectToLG() async {
    await initConnectionDetails();
    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(socket, username: _username,
        onPasswordRequest: () =>_passwordOrKey,
      );

      print('IP: $_host, port: $_port ');
      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      return false;
    }
  }

  Future<SSHSession?> execute() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final execResult = await _client!.execute('echo "search=Lleida" > /tmp/query.txt');
      print('Exec successful');
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession> sendKml(String kmlContent, String name, String desc
      ,LookAt flyto
      ) async {

    final sftp = await _client!.sftp();
    final file = await sftp.open('/var/www/html/dummy.kml',
        mode: SftpFileOpenMode.create |
        SftpFileOpenMode.truncate |
        SftpFileOpenMode.write);

    KMLEntity kmlEntity = KMLEntity(name: name, content: kmlContent, desc: desc);

    var bytes = utf8.encode(kmlEntity.body);

    file.writeBytes(bytes);

    await _client!.execute('echo "$_url/dummy.kml" > /var/www/html/kmls.txt');

    final execResult = await _client!.execute('echo "flytoview=${flyto.generateLinearString()})}" > /tmp/query.txt');

    return execResult;
  }

  Future<SSHSession?> clearKml() async{
    try{
      if(_client == null){
        print('SSH Client not initialized');
        return null;
      }

      String kml = '';
      final execResult = await _client!.execute("echo '$kml' > /var/www/html/kmls.txt");

      return execResult;
    }
    catch(e){
      print("Error occured: $e");
      return null;
    }
  }

}


