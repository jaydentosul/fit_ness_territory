
import 'package:flutter/material.dart';

class MyList extends StatelessWidget{
  final String text;
  final IconData icon;
  final double fontSize;
  final void Function()? onTap;

  const MyList({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey,
        ),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}

//for the scoreboard
class MyListTerritory extends StatelessWidget {
  final String imgPath;
  final String territoryName;
  final String ownerName;
  final String bestTime;
  final void Function()? onTap;

  const MyListTerritory({
    super.key,
    required this.onTap,
    required this.imgPath,
    required this.territoryName,
    required this.bestTime,
    required this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(10),
          height: 130,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              //image
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset(imgPath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 13),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(territoryName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),

                      SizedBox(height: 13),

                      Text("Owner: $ownerName",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          backgroundColor: Colors.grey.shade600,
                        ),
                      ),

                      SizedBox(height: 3),

                      Text("Best Time: $bestTime",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
              ),
            ],
          )
      ),
    );
  }
}