import 'package:flutter/material.dart';
import 'package:lukatout/presentation/screens/home/widgets/cardMenuLuka.dart';
import 'package:lukatout/presentation/screens/livraison/homelivraison.dart';
import 'package:lukatout/presentation/screens/shopping/routestackmarketplace.dart';
import 'package:lukatout/presentation/widgets/appbarLuka.dart';
import 'package:lukatout/theme.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarLuka(isHome: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                children: [
                  Text(
                    "Catégories",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
            // SizedBox(
            //   height: 70,
            //   child: ListView.builder(
            //     scrollDirection: Axis
            //         .horizontal, // Vous pouvez ajuster la direction du défilement en fonction de vos besoins
            //     itemCount: 2, // Définissez le nombre d'éléments ici
            //     itemBuilder: (BuildContext context, int index) {
            //       return categoryWidget();
            //     },
            //   ),
            // ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis
                    .horizontal, // Vous pouvez ajuster la direction du défilement en fonction de vos besoins
                children: [
                  pubWidget("O Poeta",
                      "https://scontent.ffih1-2.fna.fbcdn.net/v/t39.30808-6/414106486_678251787764076_2261218363219216026_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=3635dc&_nc_eui2=AeHuJmpJI0Za6Q0l2vzdkOF6NoJucU9c8dg2gm5xT1zx2LBrUttLeLqJcttCv6_-0kR7yQcTKph_t3nDE8tHDo3u&_nc_ohc=KcNFYqy8Yh4AX--lwvu&_nc_zt=23&_nc_ht=scontent.ffih1-2.fna&oh=00_AfCCqqut10tpuoRqVtVFQOLoR3hPnlXFBvmHVAxN_U80ww&oe=65AD57D6"),
                  pubWidget("Kin Tacos",
                      "https://scontent.ffih1-2.fna.fbcdn.net/v/t45.1600-4/413844243_6571968973306_6981315217079194975_n.jpg?stp=cp0_dst-jpg_q75_s1080x2048_spS444&_nc_cat=103&ccb=1-7&_nc_sid=528f85&_nc_eui2=AeHQjwPPU64yKjRXX8xfQrwv9h17pLoalc_2HXukuhqVz1__YrDPD_pZSwAS-vovchew2gBa7jYpFFRsnpSC0vtF&_nc_ohc=jprr0kqMaWcAX-L2sXI&_nc_ht=scontent.ffih1-2.fna&oh=00_AfBycdYJqVz-rkYYjMMfQrgSkOKzyPenALicKagfYkjRqg&oe=65AE247A"),
                  // pubWidget("Restaurants"),
                  // pubWidget("Boissons"),
                  // pubWidget("Vêtements"),
                  // pubWidget("Electroniques")
                ],
              ),
            ),
            Divider(
              thickness: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Marchands du moment",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Tout voir >",
                    style: TextStyle(fontSize: 15, color: LukaPrimary),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis
                    .horizontal, // Vous pouvez ajuster la direction du défilement en fonction de vos besoins
                children: [
                  merchentWidget("O Poeta",
                      "https://scontent.ffih1-2.fna.fbcdn.net/v/t39.30808-6/347857840_3662748007344909_1390269127375057954_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeHfNIADnqOrl_2bmG-TleBQt8pG80o1YrC3ykbzSjVisOQvioRXIMswL_2rNQ5MWWB_0AYfNi2p7W5NSv8yXh06&_nc_ohc=Rm4iAErEMOgAX9nfyNb&_nc_zt=23&_nc_ht=scontent.ffih1-2.fna&oh=00_AfA-yfZ4PYJ8Cl1TVvHngRkUzkDZmoRxvDqGJFA9zQiyFw&oe=65AD7707"),
                  merchentWidget("UAC",
                      "https://uacrdc.com/wp-content/uploads/2021/07/cropped-512x512-1.png"),
                  merchentWidget("Kin Tacos",
                      "https://media-cdn.tripadvisor.com/media/photo-i/1b/c7/ab/6f/premier-restaurant-specialise.jpg"),
                  merchentWidget("Kin marché",
                      "https://scontent.ffih1-2.fna.fbcdn.net/v/t39.30808-6/386598123_708873171270166_6496536078689029973_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeEmN1ns1t5ZK0Ni9aLpHDWInMCXiuwcGFmcwJeK7BwYWZR3Tkka8zouppIa3WhO8SiyiaXenkabZDN5pqtdLhsj&_nc_ohc=BN-yl3k43I8AX_ynB3C&_nc_zt=23&_nc_ht=scontent.ffih1-2.fna&oh=00_AfAqfpkV_eeHUQL0fr34rENkHwRUrA8C_uqvr0bUFYXthQ&oe=65AE3A04"),
                  merchentWidget("SK",
                      "https://scontent.ffih1-2.fna.fbcdn.net/v/t39.30808-6/341048378_914809576298413_5175442938205129103_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeF60DO205IWVqBvy-7trR4_Pm0CKq6ugZo-bQIqrq6BmrdUbnJzBGSpJ7CypyB2ojorJn29Deg0L3kSVkchhtMW&_nc_ohc=t531pQsvze4AX8g04QA&_nc_zt=23&_nc_ht=scontent.ffih1-2.fna&oh=00_AfACTGj4PP1-YBNjrpjqErpbCg98jH9KvjeuHid-cU7Zsw&oe=65AEEB15"),
                ],
              ),
            ),
            Divider(
              thickness: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nos services",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 850,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Nombre d'éléments par ligne
                    crossAxisSpacing:
                        5.0, // Espacement horizontal entre les éléments
                    mainAxisSpacing:
                        5.0, // Espacement vertical entre les lignes
                  ),
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LivraisonHome(),
                          ),
                        );
                      },
                      child: CardMenuLuka(
                        icon: "assets/icons/lukamoto.svg",
                        title: "Luka Livraison",
                        active: true,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         const ControlleClientScreen(),
                        //   ),
                        // );
                      },
                      child: CardMenuLuka(
                        icon: "assets/icons/lukataxi.svg",
                        title: "Luka Taxi",
                        active: true,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const QrCopyScreen(),
                        //   ),
                        // );
                      },
                      child: CardMenuLuka(
                        icon: "assets/icons/lukashop10.svg",
                        title: "Luka Marchand",
                        active: true,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const QrCopyScreen(),
                        //   ),
                        // );
                      },
                      child: CardMenuLuka(
                        icon: "assets/icons/lukashop10.svg",
                        title: "Luka ndaku",
                        active: true,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const QrCopyScreen(),
                        //   ),
                        // );
                      },
                      child: CardMenuLuka(
                        icon: "assets/icons/lukashop10.svg",
                        title: "Luka Kisi (Pharma)",
                        active: true,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const QrCopyScreen(),
                        //   ),
                        // );
                      },
                      child: CardMenuLuka(
                        icon: "assets/icons/lukashop10.svg",
                        title: "Luka Musala",
                        active: true,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const QrCopyScreen(),
                        //   ),
                        // );
                      },
                      child: CardMenuLuka(
                        icon: "assets/icons/lukashop10.svg",
                        title: "Luka Buku",
                        active: true,
                      ),
                    ),
                  ], // Nombre total d'éléments
                ),
              ),
            ),
            Divider(
              thickness: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nouveautés",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 450,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Nombre d'éléments par ligne
                    crossAxisSpacing:
                        5.0, // Espacement horizontal entre les éléments
                    mainAxisSpacing:
                        5.0, // Espacement vertical entre les lignes
                  ),
                  children: [
                    newsWidget("yo"),
                    newsWidget("yo"),
                    newsWidget("yo"),
                    newsWidget("yo"),
                  ], // Nombre total d'éléments
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

Widget pubWidget(String title, String url) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start, // Ajustez l'alignement vertical de la colonne
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold, // Ajoutez du style au texte si nécessaire
              ),
            ),
          ),
        ],
      ),
      Container(
        width: 300,
        height: 200,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: LukaPrimary),
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
    ],
  );
}

Widget merchentWidget(String title, String url) {
  return Column(
    // Ajustez l'alignement vertical de la colonne
    children: [
      Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.bold, // Ajoutez du style au texte si nécessaire
          ),
        ),
      ),
    ],
  );
}

Widget newsWidget(String title) {
  return Column(
    // Ajustez l'alignement vertical de la colonne
    children: [
      Container(
        // width: 190,
        height: 190,
        // margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/images/splashluka.png"),
              fit: BoxFit.cover),
        ),
      ),
    ],
  );
}

Widget nosServices(String title) {
  return Column(
    // Ajustez l'alignement vertical de la colonne
    children: [
      Container(
        width: 165,
        height: 165,
        // margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage("assets/images/splashluka.png"),
              fit: BoxFit.cover),
        ),
      ),
    ],
  );
}
