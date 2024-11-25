// ignore_for_file: prefer_const_constructors, prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lukatout/presentation/screens/home/home_screen.dart';
import 'package:lukatout/presentation/screens/shopping/marketplace.dart';
import 'package:lukatout/sizeconfig.dart';
import 'package:lukatout/theme.dart';

class RouteStackMarketplace extends StatefulWidget {
  const RouteStackMarketplace({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RouteStackMarketplaceState createState() => _RouteStackMarketplaceState();
}

class _RouteStackMarketplaceState extends State<RouteStackMarketplace>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _screens = [
    Marketplace(),  
    Marketplace(),   
  ];

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    super.build(context);
    return Scaffold(
        // backgroundColor: const Color(0xFFFFFFFF),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _screens,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar:
            bottomNavigationBar(_selectedIndex, _onItemTapped, context));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget bottomNavigationBar(_selectedIndex, _onItemTapped, context) {
  return Container(
    color: Colors.white,
    child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: const Color(0xFFffffff),
        backgroundColor: Colors.white,
        selectedItemColor: LukaPrimary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
              label: "Accueil",
              icon: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: _selectedIndex == 0 ? 2.0 : 0,
                          color: _selectedIndex == 0
                              ? LukaPrimary
                              : Colors.transparent),
                    ),
                    // borderRadius: BorderRadius.circular(50.0)
                  ),
                  
                  child: Icon(Ionicons.home_outline)
    
                  )
                  ),
          BottomNavigationBarItem(
              label: "Favoris",
              icon: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: _selectedIndex == 1 ? 2.0 : 0,
                          color: _selectedIndex == 1
                              ? LukaPrimary
                              : Colors.transparent),
                    ),
                    // borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: Icon(Ionicons.heart_outline)
                  )),
          BottomNavigationBarItem(
              label: "",
              icon: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: _selectedIndex == 2 ? 1.0 : 0,
                          color: _selectedIndex == 2
                              ? LukaSecondary
                              : Colors.transparent),
                    ),
                    // borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: Icon(Ionicons.add_circle_outline, size: 30,)
                  )),

          BottomNavigationBarItem(
              label: "Notifications",
              icon: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: _selectedIndex == 3 ? 1.0 : 0,
                          color: _selectedIndex == 3
                              ? LukaSecondary
                              : Colors.transparent),
                    ),
                    // borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: Icon(Ionicons.notifications_outline)
                  )),
          BottomNavigationBarItem(
              label: "Profil",
              icon: Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: _selectedIndex == 3 ? 1.0 : 0,
                          color: _selectedIndex == 3
                              ? LukaSecondary
                              : Colors.transparent),
                    ),
                    // borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: Icon(Ionicons.person_outline)
                  )),
        ]),
  );
}
