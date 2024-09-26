import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MutationApp());
}

class MutationApp extends StatelessWidget {
  const MutationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MutationAppState(),
      child: MaterialApp(
        title: "Mutation App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            tertiary: AppColors.tertiary,
          ),
        ),
        home: HomePage(),
        // home: BibliothequePage(),
      ),
    );
  }
}

class MutationAppState extends ChangeNotifier {
  var username = "Hassan";
  var index = 0;

  void testName() {
    username += "n";
    notifyListeners();
  }

  changeIndex(newIndex) {
    index = newIndex;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  final bottomLinks = ["Formations", "Boutique", "Bibliothèque"];

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MutationAppState>();
    var username = state.username;
    var pageIndex = state.index;
    Widget currentPage;
    /**
     * Page Indexes:
     * 0 : Formations
     * 1 : Boutique
     * 2 : Bibiliothèque
     * 3 : Profil
     * 4 : Détails Formation
     * 5 : Détails Livre
     * 6 : Lecture
   */
    switch (pageIndex) {
      case 0:
        currentPage = FormationsPage();
      case 1:
        currentPage = BoutiquePage(); // BoutiquePage
      case 2:
        currentPage = BibliothequePage(); // BibliothequePage
      case 3:
        currentPage = Placeholder(); // ProfilPage
      case 4:
        currentPage = Placeholder(); // DetailsFormation
      case 5:
        currentPage = Placeholder(); // DetailsLivrePage
      default:
        throw UnimplementedError("no widget for $pageIndex");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: ListView(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: currentPage,
            )
          ],
        ),
        bottomNavigationBar: BottomBar(),
        appBar: TopBar(username: username),
      );
    });
  }
}

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    required this.username,
  });

  final String username;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MutationAppState>();
    return AppBar(
      title: Text("👋Bonjour, $username"),
      titleSpacing: 00.0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        IconButton(
            onPressed: () {
              state.changeIndex(3);
            },
            icon: Icon(Icons.person)),
        IconButton(
            onPressed: () {
              print("More");
            },
            icon: Icon(Icons.do_not_touch))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MutationAppState>();
    var index = state.index;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.video_file, semanticLabel: "Formations"),
            label: "Formations"),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, semanticLabel: "Boutique"),
            label: "Boutique"),
        BottomNavigationBarItem(
            icon: Icon(Icons.book, semanticLabel: "Bibiliothèque"),
            label: "Bibiliothèque"),
      ],
      backgroundColor: Theme.of(context).colorScheme.secondary,
      // fixedColor: Theme.of(context).colorScheme.tertiary,
      selectedItemColor: Colors.red,
      currentIndex: (index < 3) ? index : 0,
      onTap: (i) {
        state.changeIndex(i);
        print("Index is $i");
      },
    );
  }
}

// Pages
class FormationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormationHistoryInfo(0),
            SizedBox(width: 10),
            FormationHistoryInfo(1),
          ],
        ),
        FormationHero()
      ],
    );
  }
}

class BibliothequePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        BibleWidget()
      ],
    );
  }
}

class BoutiquePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        LivreWidget()
      ],
    );
  }
}

// Components
class FormationHistoryInfo extends StatelessWidget {
  const FormationHistoryInfo(
    this.period, {
    super.key,
  });

  final int period; // 0 - Present, 1 - Past

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary),
      width: 180,
      height: 64,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(period == 0
                ? "Formations \nen cours: "
                : "Formations \nterminées: "),
            SizedBox(
              width: 10,
            ),
            Text("0")
          ],
        ),
      ),
    );
  }
}

class FormationWidget extends StatelessWidget {
  const FormationWidget(
      {super.key,
      required this.title,
      required this.price,
      required this.imageLink});
  final String imageLink;
  final String title;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary),
        width: 370,
        height: 100,
        // color: Theme.of(context).colorScheme.primary,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: NetworkImage(imageLink, scale: 5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(title),
                  SizedBox(
                    height: 10,
                  ),
                  Text(price.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FormationHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormationWidget(
          title: "Challenge 2023",
          price: 5000,
          imageLink:
              "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
        ),
        FormationWidget(
          title: "Formation Digitale",
          price: 5000,
          imageLink:
              "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
        ),
        FormationWidget(
          title: "Challenge 2022",
          price: 5000,
          imageLink:
              "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
        ),
        FormationWidget(
          title: "Challenge 2021",
          price: 5000,
          imageLink:
              "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
        ),
        FormationWidget(
          title: "Challenge 2023",
          price: 5000,
          imageLink:
              "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
        ),
        FormationWidget(
          title: "Challenge 2023",
          price: 5000,
          imageLink:
              "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
        ),
        FormationWidget(
          title: "Challenge 2023",
          price: 5000,
          imageLink:
              "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
        ),
      ],
    );
  }
}

class LivreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary),
      width: 370,
      height: 100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: NetworkImage(
                  "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg",
                  scale: 5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text("Titre de livre"),
              Text("Prix du livre"),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.tertiary),
                  ),
                  onPressed: () {
                    print("Plus d'infos");
                  },
                  child: Text("Plus d'infos"))
            ]),
          ),
        ],
      ),
    );
  }
}

class BibleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.primary),
      width: 370,
      height: 100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: NetworkImage(
                "https://i.pinimg.com/564x/9b/37/04/9b3704335e8ec736966f0846c08841c6.jpg", /*scale: 5*/
              ),
              width: 100,
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text("Titre de livre"),
              Text("Prix du livre"),
              Row(
                children: [
                  ButtonTheme(
                    minWidth: 100,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.tertiary),
                        ),
                        onPressed: () {
                          print("Lire");
                        },
                        child: Text("Lire")),
                  ),
                  ButtonTheme(
                      minWidth: 100,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.tertiary),
                          ),
                          onPressed: () {
                            print("Plus d'infos");
                          },
                          child: Text("Plus d'infos"))),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}

// Configuration Data
class AppColors {
  static const primary = Color(0xFF333333);
  static const secondary = Color(0xFF555555);
  static const tertiary = Color(0xFFEEEEEE);

  const AppColors();
}
