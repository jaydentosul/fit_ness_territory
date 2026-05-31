
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
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(2, 4),
              )
            ]
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.76),
                      blurRadius: 2,
                      offset: Offset(1, 4),
                    )
                  ]
                ),
                child:
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: imgPath.startsWith('assets/')
                      ? Image.asset(imgPath, width: 110, height: 110, fit: BoxFit.cover,
                  ) : Image.network(imgPath, fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 13),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        territoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 19,
                          overflow: TextOverflow.ellipsis,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: Offset(2, 2)
                            )
                          ]
                        ),
                      ),

                      SizedBox(height: 10),


                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: Offset(0, 2)
                            )
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Owner: $ownerName",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 2,
                                      offset: Offset(2, 2),
                                    )
                                  ]
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Best Time: $bestTime",
                              style: TextStyle(
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 2,
                                        offset: Offset(2, 2)
                                    )
                                  ]
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  )
              ),
            ],
          )
      ),
    );
  }
}