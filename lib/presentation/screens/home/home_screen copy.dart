// ignore_for_file: use_build_context_synchronously, avoid_unnecessary_containers, prefer_const_constructors, unnecessary_brace_in_string_interps, unnecessary_type_check

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/screens/home/widgets/cardMenuGrid.dart';
import 'package:lukatout/presentation/screens/home/widgets/cardMenuGridPlaceholder.dart';
import 'package:lukatout/presentation/screens/home/widgets/cardNumberCourseappbar.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/presentation/widgets/president.dart';
import 'package:lukatout/theme.dart';
import 'widgets/cardMenu.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // Add the necessary overrides
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController controller = PageController(viewportFraction: 0.8);
  int _index = 1;
  // final controller = PageController(viewportFraction: 0.8, duration: Duration(milliseconds: 500));
  String? nom, postnom, prenom;
  String? code;
  var androidState;
  var iosState;
  Timer? timer, timerdeconnect;
  String url = "https://api-bantou-store.vercel.app/api/v1/images";
  List dataImages = [];
  List actus = [];

  bool actuVisible = false;
  bool candidatVisible = false;

  List<CardMenu> menuItems = [];

  List<CardMenuGrid> cardItems = [];

  int count = 0;
  int countWinner = 0;
  int countOver = 0;
  int myNumber = 0;
  int myNumberWinner = 0;
  int myNumberOver = 0;
  double percent = 0.0;
  int myNumberCounter = 0;
  int page = 1;
  PageController _controller =
      PageController(initialPage: 1, viewportFraction: 0.7);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    decodeToken();
    loadData();
    loadPhoto();
    loadActualitesWithPagination(page);
    // loadActualites();
    // loadActualitesWithPagination(page);
    // loadActualitesWithPaginationFull(page);
    loadCandidats();
    decodeToken();
    checkVersion();
    getMyIntValue();
    timer =
        Timer.periodic(const Duration(seconds: 60), (Timer t) => loadData());
  }

  getMyIntValue() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      count = prefs.getInt('count') ?? 0;
      countWinner = prefs.getInt('countWinner') ?? 0;
      countOver = prefs.getInt('countOver') ?? 0;
      setState(() {
        myNumber = prefs.getInt('count') ?? 0;
        myNumberWinner = prefs.getInt('countWinner') ?? 0;
        myNumberOver = prefs.getInt('countOver') ?? 0;
      });
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "count", data: myNumber.toString());
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "countWinner", data: myNumberWinner.toString());
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "countOver", data: myNumberOver.toString());
    } catch (e) {
      count = 0;
      countOver = 0;
      countWinner = 0;

      setState(() {
        myNumber = count;
        myNumberCounter = countWinner;
        myNumberOver = countOver;
      });
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "count", data: myNumber.toString());
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "countWinner", data: myNumberWinner.toString());
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "countOver",
          data: myNumberOver
              .toString()); // Vous pouvez définir une valeur par défaut ici
    }

    return count;
  }

  loadActualitesWithPagination(page) async {
    var response = await SignUpRepository.getCampagnesWithPagination(page);
    // var response = await SignUpRepository.getRealisationsWithPagination(page);

    print(response);
    // setState(() {
    //   actuVisible = false;
    // });

    if (response["data"].length <= 0) {
      print("object");
    } else {
      setState(() {
        var data = response["data"];
        actus = data;
        // actus = data.where((e) => e["category"] == "Campagne").toList();
        menuItems = actus.map((data) {
          return CardMenu(
              icon: data["coverImage"],
              title: data["headLine"],
              content: data["description"],
              images: data["mediaImages"],
              date: data["createdAt"],
              videoLink: data["videoLink"] ?? "");
        }).toList();

        actuVisible = true;
        print(CardMenu);
      });
    }
  }

  loadActualites() async {
    var response = await SignUpRepository.getCampagnes();
    print(response);

    setState(() {
      var data =
          response["data"]; // Assurez-vous que data est une liste de données

      actus = data.where((e) => e["category"] == "Campagne").toList();
      menuItems = actus.map((data) {
        return CardMenu(
            icon: data["coverImage"],
            title: data["headLine"],
            content: data["description"],
            images: data["mediaImages"],
            date: data["createdAt"],
            videoLink: data["videoLink"] ?? "");
      }).toList();

      actuVisible = true;
      print(CardMenu);
    });
  }

// Future<void> loadActualitesWithPaginationFull(page) async {
//   setState(() {
//     actuVisible = false;
//   });

//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var savedData = prefs.getStringList("actualites") ?? [];

//   if (savedData.isNotEmpty) {
//     // Charger les données depuis SharedPreferences
//     actus = savedData.map((jsonString) => json.decode(jsonString)).toList();
//   }

//   // Charger les nouvelles données depuis l'API
//   var response = await SignUpRepository.getActualitesWithPagination(page);

//   setState(() {
//     var data = response["data"];
//     List? newActus =
//         data.where((e) => e["category"] == "Campagne").toList();

//     // Ajouter les nouvelles actualités à la liste existante si elles ne sont pas nulles
//     if (newActus != null) {
//       actus.addAll(newActus);
//       updateMenuItems();
//     }

//     actuVisible = true;
//     print(CardMenu);
//   });

//   // Sauvegarder la liste mise à jour dans SharedPreferences
//   List<String> jsonList = actus.map((data) => json.encode(data)).toList();
//   prefs.setStringList("actualites", jsonList);
// }

  void updateMenuItems() {
    menuItems = actus.map((data) {
      return CardMenu(
        icon: data["coverImage"],
        title: data["headLine"],
        content: data["description"],
        images: data["mediaImages"],
        date: data["createdAt"],
        videoLink: data["videoLink"] ?? "",
      );
    }).toList();
  }

  loadCandidats() async {
    // var response = await SignUpRepository.getCandidats();
    var response = await SignUpRepository.getCandidatsOnTopAll();
    print(response);

    setState(() {
      List<dynamic> data = response["data"].length < 9
          ? response["data"]
          : response["data"]
              .sublist(0, 9); // Assurez-vous que data est une liste de données

      cardItems = data.map((data) {
        return CardMenuGrid(
          profile: data["profileImage"],
          cover: data["coverImage"],
          category: data["category"],
          name: data["name"],
          message: data["message"],
          images: data["galleryImages"],
          itCandidate: data["itCandidate"],
          ceniNumber: data["ceniNumber"],
          //
          countryName: data["countryName"] ?? "",
          regionName: data["regionName"] ?? "",
          cityName: data["cityName"] ?? "",
          townshipName: data["townshipName"] ?? "",
          quarterName: data["quarterName"] ?? "",
          partyName: data["partyName"] ?? "",
          videoLink: data["videoLink"] ?? "",
        );
      }).toList();

      candidatVisible = true;
      print(CardMenuGrid);
    });
  }

  loadData() async {
    loadPhoto();
    loadActualites();
    loadCandidats();
    var response = await SignUpRepository.getPayment();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    String? sign = prefs.getString("currency") == "usd" ? "\$" : "Fc";

    if (response["data"].toString() == "[]") {
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "cotisation", data: "0.0 ${sign}");
    } else {
      double totalAmount = 0.0;

      if (response["status"] == 200) {
        for (var payment in response["data"]) {
          totalAmount += double.parse(payment["amount"]);
        }
        print(totalAmount);
        BlocProvider.of<SignupCubit>(context).updateField(context,
            field: "cotisation", data: "${totalAmount} ${sign}");
      } else {
        BlocProvider.of<SignupCubit>(context)
            .updateField(context, field: "cotisation", data: "0.0 ${sign}");
      }
    }
  }

  loadPhoto() async {
    var response = await SignUpRepository.getPhoto();

    print(response['avatar']);

    if (response["status"] == 200) {
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "totalSuccess", data: response['totalSuccess'].toString());
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "totalFailed", data: response['totalFailed'].toString());
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "totalPlay", data: response['totalPlay'].toString());
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "photo",
          data: "https://kampeni.injolab.com${response["avatar"]}");
    } else {
      print("error");
    }
  }

  decodeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    prefs.setString('id', decodedToken["id"].toString());
    prefs.setString('nom', decodedToken["name"].toString());
    prefs.setString('username', decodedToken["username"].toString());
    prefs.setBool("first", false);
    prefs.setBool("authorizedVideo", decodedToken["authorizedVideo"]);

    BlocProvider.of<SignupCubit>(context).updateField(context,
        field: "authorizedVideo", data: decodedToken["authorizedVideo"]);

    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "id", data: decodedToken["id"].toString());

    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "nom", data: prefs.getString("nom"));
    BlocProvider.of<SignupCubit>(context).updateField(context,
        field: "username", data: prefs.getString("username"));
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "phone", data: prefs.getString("phone"));
    BlocProvider.of<SignupCubit>(context).updateField(context,
        field: "phonePayment", data: prefs.getString("phone"));

    setState(() {
      prenom = prefs.getString('prenom');
      nom = prefs.getString('nom');
    });
  }

  void _startTimerDeconnect() {
    const timeLimit = Duration(minutes: 10);
    timerdeconnect = Timer(timeLimit, () async {
      // Code de déconnexion ici
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "phone", data: "");
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "motdepasse", data: "");
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "nom", data: "");

      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "postnom", data: "");
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "prenom", data: "");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    });
  }

  void _resetTimer() {
    if (timerdeconnect != null) {
      timerdeconnect!.cancel();
    }
    _startTimerDeconnect();
  }

  @override
  void dispose() {
    timer?.cancel();
    if (timerdeconnect != null) {
      timerdeconnect!.cancel();
    }
    super.dispose();
  }

  checkVersion() async {
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print('build' + buildNumber);

    final response = await http
        .get(Uri.parse('https://api-mobpay.vercel.app/api/v1/versions'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      print(data["android"]);

      androidState = data["android"];
      iosState = data["ios"];
      List<String> descriptionList = data["description"].split(",");

      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "descriptionVersion", data: data["description"]);

      if (Platform.isIOS == true) {
        if (int.parse(buildNumber) < int.parse(iosState)) {
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "iconVersion", data: "assets/images/update.json");
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "titreVersion", data: "Découvrez les nouveautés");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/version', (Route<dynamic> route) => false,
              arguments: descriptionList);
        } else {
          print('ok');
          return;
        }
      }

      if (Platform.isIOS == false) {
        if (int.parse(buildNumber) < int.parse(androidState)) {
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "iconVersion", data: "assets/images/update.json");
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "titreVersion", data: "Découvrez les nouveautés");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/version', (Route<dynamic> route) => false,
              arguments: descriptionList);
          // return;
        } else {
          print('ok');
        }
      }
    } else {
      print('error');
    }
  }

  String stateInfoUrl = 'https://api.trans-academia.cd/';
  void getCourse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await http.post(
        Uri.parse("https://tag.trans-academia.cd/Api_view_courses_user.php"),
        body: {'IDetudiant': prefs.getString('code')}).then((response) {
      var data = json.decode(response.body);
      int status;
      print(data['donnees']);
      status = data['status'];
      if (status == 200) {
        BlocProvider.of<SignupCubit>(context).updateField(context,
            field: "course", data: data['donnees'][0]["Nombre Course"] ?? "");
        BlocProvider.of<SignupCubit>(context).updateField(context,
            field: "date", data: data['donnees'][0]["Date Expiration"] ?? "");
      } else {
        print('ok');
      }
    });
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  Widget element(String text, Color color) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 100,
      width: 100,
      color: color,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: Colors.white,
      color: Colors.blueAccent,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        loadData();
      },
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(25.0))),
          //   onPressed: () async {
          //     SharedPreferences prefs = await SharedPreferences.getInstance();
          //     var token = prefs.getString('token');

          //     decodeToken();

          //     ChallengeDialog.show(context, "Challenge", () {
          //       if (kDebugMode) {
          //         print("modal");
          //       }
          //     });

          //     // Navigator.push(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //         builder: (context) => WebViewApp(
          //     //               url:
          //     //                   "https://fatshi.dillhub.com?token=$token ",
          //     //               backNavigation: true,
          //     //               title: "Fatshi Challange",
          //     //             )));
          //   },
          //   child: SvgPicture.asset(
          //               "assets/icons/video.svg",
          //               width: 25,
          //             ),
          //   backgroundColor: ftRed,
          // ),
          appBar: CardNumberOfCourseAppbar(
              actus: actus,
              myNumberWinner: myNumberWinner,
              myNumber: myNumber,
              myNumberOver: myNumberOver),
          key: _scaffoldKey,
          backgroundColor: Colors.blue.withOpacity(0.1),
          // drawer: drawerMenu(context),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // FadeInUp(
                    //   from: 50,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(bottom: 10.0),
                    //     child: CardNumberOfCourse(
                    //         actus: actus,
                    //         myNumberWinner: myNumberWinner,
                    //         myNumber: myNumber,
                    //         myNumberOver: myNumberOver),
                    //   ),
                    // ), // Deuxième widget
                    // Le reste de votre contenu

                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: PresidentWidget(),
                    ),
                    FadeInUp(
                      from: 50,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Row(
                          children: const [
                            Text(
                              "Actualités",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    actuVisible == false
                        ? SizedBox(
                            height: 350,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListView.builder(
                                scrollDirection: Axis
                                    .horizontal, // Pour un défilement horizontal
                                itemCount:
                                    2, // Le nombre d'éléments que vous avez, dans cet exemple, 2
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal:
                                            10.0), // Espacement entre les éléments
                                    child: ImageViewerWidget(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          width: 5, color: Color(0xFFffa020)),
                                      height: 280.0,
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      url: "url",
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        // :FadeInUp(
                        //     from: 50,
                        //     child: Center(
                        //       child: SizedBox(
                        //         height: 380.0,
                        //         width: MediaQuery.of(context).size.width - 0,
                        //         // card height
                        //         child: PageView.builder(
                        //           itemCount: menuItems.length,
                        //           controller:
                        //               _controller, // Utilisez votre propre contrôleur PageController
                        //           onPageChanged: (int index) {
                        //             setState(() => _index = index);
                        //           },
                        //           itemBuilder: (_, i) {
                        //             return Transform.scale(
                        //               scale: i == _index ? 1 : 0.8,
                        //               child: menuItems.elementAt(i),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        : NotificationListener<ScrollEndNotification>(
                            onNotification: (notification) {
                              if (notification is ScrollEndNotification){
                                // Vérifier si nous sommes à la fin de la liste
                                if (_controller.page == menuItems.length - 1) {
                                  page++;

                                  loadActualitesWithPagination(page);
                                  // Ajouter un délai avant de déclencher le scroll
                                  // Future.delayed(Duration(milliseconds: 500),
                                  //     () {
                                  //   // Déclencher le scroll après un délai de 15 éléments
                                  //   _controller.animateToPage(_index + 5,
                                  //       duration: Duration(milliseconds: 500),
                                  //       curve: Curves.easeInOut);
                                  // });
                                  // Vous êtes arrivé à la fin de la liste, faites quelque chose ici
                                  // Par exemple, chargez plus de données ou affichez un message
                                  print(
                                      "Vous êtes arrivé à la fin de la liste !");
                                }
                              }
                              return true;
                            },
                            child: FadeInUp(
                              from: 50,
                              child: Center(
                                child: SizedBox(
                                  height: 380.0,
                                  width: MediaQuery.of(context).size.width - 0,
                                  // card height
                                  child: PageView.builder(
                                    itemCount: menuItems.length,
                                    controller:
                                        _controller, // Utilisez votre propre contrôleur PageController
                                    onPageChanged: (int index) {
                                      setState(() => _index = index);
                                    },
                                    itemBuilder: (_, i) {
                                      return Transform.scale(
                                        scale: i == _index ? 1 : 0.8,
                                        child: menuItems.elementAt(i),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ils soutiennent le chef de l’Etat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                            },
                            child: Text(
                              "voir plus >",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: candidatVisible == false
                          ? SizedBox(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      CardMenuGridPlaceholder(),
                                      CardMenuGridPlaceholder(),
                                      CardMenuGridPlaceholder(),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 140 - 20,
                                  childAspectRatio: 1 / 2,
                                ),
                                itemCount: cardItems
                                    .length, // le nombre d'éléments à afficher
                                itemBuilder: (context, index) {
                                  return FadeInUp(
                                      from: 50,
                                      child: cardItems.elementAt(index));
                                },
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 350,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
