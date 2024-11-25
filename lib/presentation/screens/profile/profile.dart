// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_string_interpolations, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:lukatout/presentation/widgets/buttons/buttonSpeak.dart';

import 'package:animate_do/animate_do.dart';
import 'package:lukatout/theme.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.backNavigation}) : super(key: key);
  bool backNavigation = false;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String text =
      "Né le 13 juin 1963 à Kinshasa, Félix-Antoine TSHISEKEDI TSHILOMBO est un homme d’État de la République démocratique du Congo (RDC), Président de la République depuis le 24 janvier 2019. Haut cadre de l’UDPS (Union pour la Démocratie et le Progrès Social), parti dirigé par son père, feu Étienne TSHISEKEDI, il est élu député national en 2011; mais refusant de siéger à l’Assemblée Nationale pour dénoncer les fraudes, il sera déchu de son mandat en 2013.\n\nAprès le décès de son père, en février 2017, il deviendra en mars 2017 Président du « Rassemblement ». En mars 2018, lors du congrès extraordinaire de l’UDPS, il est élu Président de ce parti. Il est l’un des initiateurs du Dialogue Congolais pour le respect de la Constitution et pour l’alternance pacifique en RDC. \n\nUn processus qu’il défend inlassablement et qui le pousse à s’allier à l’Union pour la Nation Congolaise (UNC) de Vital Kamerhe à Nairobi, en Novembre 2018 afin de constituer la plateforme « CACH » (Cap pour le Changement) pour les élections de décembre 2018. Le 30 décembre 2018, il est élu Président de la République pour un mandat de 5 ans. À 55 ans, il devient le 5ème Président de la République Démocratique du Congo, à la faveur de la toute première passation pacifique de pouvoir dans le plus grand pays d’Afrique centrale.\n\nLe 09 février 2020, Félix-Antoine Tshisekedi Tshilombo a été élu par ses pairs, Premier Vice-président de l’Union Africaine pour l’année 2020, et par anticipation pour l’année 2021, Président de la même institution régionale, lors du 33ème Sommet des Chefs d’État et de Gouvernements qui s’est tenu du 9 au 10 février à Addis-Abeba, en Éthiopie.";

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // brightness: Brightness.light,
        leading: widget.backNavigation == false
            ? null
            : FadeInDown(
                from: 30,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AdaptiveTheme.of(context).mode.name != "dark"
                          ? Colors.white
                          : Colors.white,
                    )),
              ),
        title: FadeInDown(
          from: 30,
          child: Text(
            "Le Président",
            style: TextStyle(
              fontSize: 14,
              color: AdaptiveTheme.of(context).mode.name != "dark"
                  ? Colors.white
                  : Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: ftPrimary,
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      20.0), // Ajustez le rayon comme vous le souhaitez
                  topRight: Radius.circular(
                      20.0), // Ajustez le rayon comme vous le souhaitez
                ),
                child: Image.asset(
                  "assets/images/troupes.jpg",
                  fit: BoxFit.cover,
                  height: 300.0,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.blue.shade50],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, .2])),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInUp(
                          from: 50,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/icons/ft.png")),
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                    width: 2, color: Color(0xFFffa020))),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                      from: 50,
                      child: Text(
                        "Félix-Antoine Tshisekedi Tshilombo",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    // PresidentWidget(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: FadeInUp(
                                from: 50,
                                child: Text(
                                  textAlign: TextAlign.justify,
                                  text,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              )
            ]),
          ),
          Positioned(
              top: height * 0.15,
              right: 40,
              child: FadeInUp(
                from: 50,
                child: ButtonSpeak(
                  text: text,
                ),
              )),
        ],
      ),
    );
  }
}
