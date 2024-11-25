import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/presentation/widgets/appbarLuka.dart';
import 'package:lukatout/presentation/widgets/inputs/lukaAdressField.dart';
import 'package:lukatout/theme.dart';

class LivraisonHome extends StatefulWidget {
  const LivraisonHome({super.key});

  @override
  State<LivraisonHome> createState() => _LivraisonHomeState();
}

class _LivraisonHomeState extends State<LivraisonHome> {
  bool typeLivraison = true;
  final TextEditingController adresseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarLuka(isHome: false),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        typeLivraison = true;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                          color: typeLivraison == true
                              ? LukaPrimary
                              : Colors.white,
                          border: Border.all(width: 1, color: LukaPrimary),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "Livraison",
                        style: TextStyle(
                            color: typeLivraison == true
                                ? Colors.white
                                : LukaPrimary,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        typeLivraison = false;
                      });
                    },
                    child: Container(
                      height: 60,
                      width: 150,
                      decoration: BoxDecoration(
                          color: typeLivraison == false
                              ? LukaPrimary
                              : Colors.white,
                          border: Border.all(width: 1, color: LukaPrimary),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "Colis",
                        style: TextStyle(
                            color: typeLivraison == false
                                ? Colors.white
                                : LukaPrimary,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              typeLivraison == true
                  ? livraisonWidget(adresseController)
                  : colisWidget(adresseController),
            ],
          ),
        ),
      ),
    );
  }
}

Widget colisWidget(TextEditingController adresseController) {
  return BlocBuilder<SignupCubit, SignupState>(
    builder: (context, state) {
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    "Adresse de retrait",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                  height: 50.0,
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 50.0,
                    child: LukaAdresseInput(
                      controller: adresseController,
                      hintText: "Où récupérons-nous le colis ?",
                      color: Colors.white,
                      label: "Entrez votre adresse de livraison",
                      // field: "nom",
                      fieldValue: state.field!["adresseLivraison"],
                    ),
                  )),
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    "Adresse de livraison",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                  height: 50.0,
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 50.0,
                    child: LukaAdresseInput(
                      controller: adresseController,
                      hintText: "Où va le colis ?",
                      color: Colors.white,
                      label: "Entrez votre adresse de livraison",
                      // field: "nom",
                      fieldValue: state.field!["adresseLivraison"],
                    ),
                  )),
            ),
            Divider(
              thickness: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Envoyer un colis",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sélectionnez un type de colis c-dessous.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      BlocProvider.of<SignupCubit>(context).updateField(context,
                          field: "typeColis", data: "boite");
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(width: 2, color: state.field!["typeColis"] == "boite"? LukaPrimary : Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/colis.png"))),
                          ),
                          Text("Boîte"),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<SignupCubit>(context).updateField(context,
                          field: "typeColis", data: "document");
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(width: 2, color: state.field!["typeColis"] == "document"? LukaPrimary : Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/lettre.png"))),
                          ),
                          Text("Document"),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BlocProvider.of<SignupCubit>(context).updateField(context,
                          field: "typeColis", data: "autre");
                    },
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(width: 2, color: state.field!["typeColis"] == "autre"? LukaPrimary : Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/fleur.png"))),
                          ),
                          Text("Autre"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

Widget livraisonWidget(TextEditingController adresseController) {
  return BlocBuilder<SignupCubit, SignupState>(
    builder: (context, state) {
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    "Adresse de livraison",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                  height: 50.0,
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 50.0,
                    child: LukaAdresseInput(
                      controller: adresseController,
                      hintText: "Entrez votre adresse de livraison",
                      color: Colors.white,
                      label: "Entrez votre adresse de livraison",
                      // field: "nom",
                      fieldValue: state.field!["adresseLivraison"],
                    ),
                  )),
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis
                    .horizontal, // Vous pouvez ajuster la direction du défilement en fonction de vos besoins
                children: [
                  categoryWidget("Supermarché"),
                  categoryWidget("Restaurants"),
                  categoryWidget("Boissons"),
                  categoryWidget("Vêtements"),
                  categoryWidget("Electroniques")
                ],
              ),
            ),
            Divider(
              thickness: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "En vedette",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView(
                  // physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Nombre d'éléments par ligne
                    crossAxisSpacing:
                        5.0, // Espacement horizontal entre les éléments
                    mainAxisSpacing:
                        5.0, // Espacement vertical entre les lignes
                  ),
                  children: [
                    newsWidget("Chez flore", "Restaurant",
                        "https://pbs.twimg.com/media/D9L0hHSWwAQWwTU.jpg:large"),
                    newsWidget("Kin Tacos", "Restaurant",
                        "https://scontent.ffih1-2.fna.fbcdn.net/v/t45.1600-4/413844243_6571968973306_6981315217079194975_n.jpg?stp=cp0_dst-jpg_q75_s1080x2048_spS444&_nc_cat=103&ccb=1-7&_nc_sid=528f85&_nc_eui2=AeHQjwPPU64yKjRXX8xfQrwv9h17pLoalc_2HXukuhqVz1__YrDPD_pZSwAS-vovchew2gBa7jYpFFRsnpSC0vtF&_nc_ohc=jprr0kqMaWcAX-L2sXI&_nc_ht=scontent.ffih1-2.fna&oh=00_AfBycdYJqVz-rkYYjMMfQrgSkOKzyPenALicKagfYkjRqg&oe=65AE247A"),
                    newsWidget("O Poeta", "Restaurant",
                        "https://scontent.ffih1-2.fna.fbcdn.net/v/t39.30808-6/414106486_678251787764076_2261218363219216026_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=3635dc&_nc_eui2=AeHuJmpJI0Za6Q0l2vzdkOF6NoJucU9c8dg2gm5xT1zx2LBrUttLeLqJcttCv6_-0kR7yQcTKph_t3nDE8tHDo3u&_nc_ohc=KcNFYqy8Yh4AX--lwvu&_nc_zt=23&_nc_ht=scontent.ffih1-2.fna&oh=00_AfCCqqut10tpuoRqVtVFQOLoR3hPnlXFBvmHVAxN_U80ww&oe=65AD57D6"),
                    newsWidget("Kin Tacos", "Restaurant",
                        "https://scontent.ffih1-2.fna.fbcdn.net/v/t45.1600-4/413844243_6571968973306_6981315217079194975_n.jpg?stp=cp0_dst-jpg_q75_s1080x2048_spS444&_nc_cat=103&ccb=1-7&_nc_sid=528f85&_nc_eui2=AeHQjwPPU64yKjRXX8xfQrwv9h17pLoalc_2HXukuhqVz1__YrDPD_pZSwAS-vovchew2gBa7jYpFFRsnpSC0vtF&_nc_ohc=jprr0kqMaWcAX-L2sXI&_nc_ht=scontent.ffih1-2.fna&oh=00_AfBycdYJqVz-rkYYjMMfQrgSkOKzyPenALicKagfYkjRqg&oe=65AE247A"),
                  ], // Nombre total d'éléments
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget categoryWidget(String title) {
  return Container(
    width: 200,
    height: 50,
    margin: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        border: Border.all(width: 2, color: LukaPrimary),
        borderRadius: BorderRadius.circular(50)),
    child: Row(children: [
      SizedBox(width: 5),
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
              image: AssetImage("assets/images/splashluka.png"),
              fit: BoxFit.cover),
        ),
      ),
      SizedBox(width: 20),
      Text(title)
    ]),
  );
}

Widget newsWidget(String nom, String category, String url) {
  return Column(
    // Ajustez l'alignement vertical de la colonne
    children: [
      Container(
        // width: 190,
        height: 300,
        // margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nom,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(category),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(child: Text("5.0")),
          ),
        ],
      )
    ],
  );
}
