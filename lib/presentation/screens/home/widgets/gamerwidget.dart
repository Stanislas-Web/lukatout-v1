import 'package:flutter/material.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/utils/string.util.dart';

class GoodGamer extends StatefulWidget {
  final List? gamers;

  const GoodGamer({Key? key, required this.gamers}) : super(key: key);

  @override
  State<GoodGamer> createState() => _GoodGamerState();
}

class _GoodGamerState extends State<GoodGamer> {
  @override
  void initState() {
    super.initState();
    triGammer();
  }

  triGammer() {
    widget.gamers!.sort((a, b) {
      int totalSuccessA = a['totalSuccess'] ?? 0;
      int totalSuccessB = b['totalSuccess'] ?? 0;

      return totalSuccessB.compareTo(totalSuccessA);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.gamers?.length ?? 0,
      itemBuilder: (context, index) {
        Map<String, dynamic> gamer = widget.gamers![index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("${index + 1}."),
                      SizedBox(
                        width: 10,
                      ),
                      ImageViewerWidget(
                          height: 40,
                          width: 40,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(width: 1, color: Colors.orange),
                          url: StringFormat.photoUrl(gamer['userAvatar'] ?? "")),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gamer['name'] ?? "",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                      
                        ],
                      ),
                    ],
                  ),
                  Text(gamer['totalSuccess'].toString()),
                ],
              ),
            ),
            Divider(), // Ajout du Divider entre les éléments de la liste
          ],
        );
      },
    );
  }
}
