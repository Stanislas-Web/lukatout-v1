import 'package:flutter/material.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/utils/string.util.dart';

class CardMenuGrid extends StatefulWidget {
  final String? profile;
  final String? cover;
  final String? category;
  final String? name;
  final String? message;
  final List? images;
  final bool? itCandidate;
  final String? ceniNumber;
  //
  final String? countryName;
  final String? regionName;
  final String? cityName;
  final String? townshipName;
  final String? quarterName;
  final String? partyName;
  final String? videoLink;

  const CardMenuGrid({
    super.key,
    this.profile,
    this.cover,
    this.category,
    this.name,
    this.message,
    this.images,
    this.ceniNumber,
    this.itCandidate,
    //
    this.countryName,
    this.regionName,
    this.cityName,
    this.townshipName,
    this.quarterName,
    this.partyName,
    this.videoLink
  });

  @override
  State<CardMenuGrid> createState() => _CardMenuGridState();
}

class _CardMenuGridState extends State<CardMenuGrid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () {

        },
        child: Ink(
          child: Container(
            padding: EdgeInsets.only(left: 5.0),
            margin: EdgeInsets.only(left: 15, bottom: 10, right: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  offset: Offset(0, 3),
                  blurRadius: 10,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                width: 2,
                color: Color(0xFFffa020).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    ImageViewerWidget(
                      height: 70.0,
                      width: 70.0,
                      url: StringFormat.photoUrl(widget.profile.toString()),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFffa020),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.message.toString(),
                            style: const TextStyle(fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
