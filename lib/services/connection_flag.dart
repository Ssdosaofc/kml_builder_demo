import 'package:flutter/material.dart';

class ConnectionFlag extends StatelessWidget {
  ConnectionFlag({required this.status});
  final bool status;

  @override
  Widget build(BuildContext context) {
    Color? color = status? Colors.green : Colors.red;
    Color? green = status? Colors.green : Colors.black;
    Color? red = status? Colors.black : Colors.redAccent;
    String label = status? 'CONNECTED' : 'DISCONNECTED';
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Material(
            elevation: 2.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              radius: 15.0,
              backgroundColor: Colors.black,
              child: Container(
                  width: 15, height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: green,
                    boxShadow: [
                      if (status)
                        BoxShadow(
                          color: Colors.green[200]!.withOpacity(1),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                    ],
                  )
               ),
            )
          ),

          SizedBox(width: 15.0,),
          Material(
            elevation: 2.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Container(
                  width: 15, height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: red,
                    boxShadow: [
                      if (!status)
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(1),
                          blurRadius: 12,
                          spreadRadius: 5,
                        ),
                    ],
                  )
              ),
              radius: 15.0,
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w800,fontSize: 18),
          )
        ],
      ),
    );
  }
}
