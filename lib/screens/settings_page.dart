import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kml_builder_demo/services/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/connection_flag.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool connectionStatus = false;
  late Ssh ssh;

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  @override
  void initState() {
    super.initState();
    ssh = Ssh();
    _loadSettings();
    //diff from the one in ssh
    _connectToLG();
  }

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sshPortController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _sshPortController.dispose();
    _rigsController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('ipAddress') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _sshPortController.text = prefs.getString('sshPort') ?? '';
      _rigsController.text = prefs.getString('numberOfRigs') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_ipController.text.isNotEmpty) {
      await prefs.setString('ipAddress', _ipController.text);
    }
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }
    if (_passwordController.text.isNotEmpty) {
      await prefs.setString('password', _passwordController.text);
    }
    if (_sshPortController.text.isNotEmpty) {
      await prefs.setString('sshPort', _sshPortController.text);
    }
    if (_rigsController.text.isNotEmpty) {
      await prefs.setString('numberOfRigs', _rigsController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      Navigator.pop(context, connectionStatus);
      return true;
    },
    child:Scaffold(
        backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text("Settings",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey.shade700
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
          Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 50,
            child: ConnectionFlag(
              status: connectionStatus,
            ),
          ),
          ),
      TextField(
        controller: _ipController,
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.computer,color: Colors.white),
          labelText: 'IP address',
          hintText: 'Enter Master IP',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 10),
      TextField(
        controller: _usernameController,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person,color: Colors.white),
          labelText: 'LG Username',
          hintText: 'Enter your username',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
        ),
      ),const SizedBox(height: 10),
      TextField(
        controller: _passwordController,
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.lock,color: Colors.white),
          labelText: 'LG Password',
          hintText: 'Enter your password',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
        ),
        obscureText: true,
      ),
      const SizedBox(height: 10),
      TextField(
        controller: _sshPortController,
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.settings_ethernet,color: Colors.white),
          labelText: 'SSH Port',
          hintText: '22',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 10),
      TextField(
        controller: _rigsController,
        style: TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.memory,color: Colors.white),
          labelText: 'No. of LG rigs',
          hintText: 'Enter the number of rigs',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
      const SizedBox(
        height: 20,
      ),
      TextButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
        ),
        onPressed: () async {
          //only connect to LG
          await _saveSettings();
          Ssh ssh = Ssh();
          bool? result = await ssh.connectToLG();
          if (result == true) {
            setState(() {
              connectionStatus = true;
            });
            print('Connected to LG successfully');
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cast,
                  color: Colors.black
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'CONNECT TO LG',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          ),
        ),
        onPressed: () async {
          //connect to LG and also send command
          Ssh ssh =
          Ssh(); //Re-initialization of the SSH instance to avoid errors for beginners
          await ssh.connectToLG();
          SSHSession? execResult = await ssh.execute();
          if (execResult != null) {
            print('Command executed successfully');
          } else {
            print('Failed to execute command');
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cast,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'SEND COMMAND TO LG',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ,
    ])
    )
    )
    )
    ;

  }
}
