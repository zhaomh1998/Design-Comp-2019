import 'package:flutter/material.dart';

class Menu {
  String title;
  IconData icon;
  String image;
  BuildContext context;
  Color menuColor;
  String routeName;

  Menu(
      {this.title,
        this.icon,
        this.image,
        this.context,
        this.routeName,
        this.menuColor = Colors.black});
}

//menuStack
Widget menuStack(BuildContext context, Menu menu) => InkWell(
  onTap: () => Navigator.of(context).pushNamed(menu.routeName),
  splashColor: Colors.orange,
  child: Card(
    clipBehavior: Clip.antiAlias,
    elevation: 2.0,
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        menuImage(menu),
        menuColor(),
        menuData(menu),
      ],
    ),
  ),
);

//stack 1/3
Widget menuImage(Menu menu) => Image.asset(
  menu.image,
  fit: BoxFit.cover,
);

//stack 2/3
Widget menuColor() => new Container(
  decoration: BoxDecoration(boxShadow: <BoxShadow>[
    BoxShadow(
      color: Colors.black.withOpacity(0.8),
      blurRadius: 5.0,
    ),
  ]),
);

//stack 3/3
Widget menuData(Menu menu) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    Icon(
      menu.icon,
      color: Colors.white,
    ),
    SizedBox(
      height: 10.0,
    ),
    Text(
      menu.title,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    )
  ],
);

Widget bodyGrid(List<Menu> menu, BuildContext context) => SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount:
    MediaQuery.of(context).orientation == Orientation.portrait
        ? 2
        : 3,
    mainAxisSpacing: 0.0,
    crossAxisSpacing: 0.0,
    childAspectRatio: 1.0,
  ),
  delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
    return menuStack(context, menu[index]);
  }, childCount: menu.length),
);

List<Menu> mainPageItems = [
  Menu(
    title: "Dashboard",
    menuColor: Color(0xff261d33),
    icon: Icons.dashboard,
    routeName: "/walker",
    image: "assets/images/dashboard.jpg",),
  Menu(
    title: "Dashboard",
    menuColor: Color(0xff261d33),
    icon: Icons.dashboard,
    routeName: "/walker",
    image: "assets/images/dashboard.jpg",),
  Menu(
    title: "Dashboard",
    menuColor: Color(0xff261d33),
    icon: Icons.dashboard,
    routeName: "/walker",
    image: "assets/images/dashboard.jpg",),
  Menu(
    title: "Dashboard",
    menuColor: Color(0xff261d33),
    icon: Icons.dashboard,
    routeName: "/walker",
    image: "assets/images/dashboard.jpg",),
];