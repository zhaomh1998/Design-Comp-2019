import 'package:flutter/material.dart';
import 'menu.dart';
import '../util/uidata.dart';

class MenuViewModel {
  List<Menu> menuItems;

  MenuViewModel({this.menuItems});

  getMenuItems() {
    return menuItems = <Menu>[
      Menu(
          title: "Patients",
          menuColor: Color(0xff050505),
          icon: Icons.person,
          image: UIData.profileImage,
          routeName: '/walker'),
      Menu(
          title: "Map",
          menuColor: Color(0xffc8c4bd),
          icon: Icons.navigation,
          image: UIData.shoppingImage,
          routeName: '/map'),
      Menu(
          title: "Login",
          menuColor: Color(0xffc7d8f4),
          icon: Icons.send,
          image: UIData.loginImage,
          routeName: '/dev'),
      Menu(
          title: "Notifications",
          menuColor: Color(0xff7f5741),
          icon: Icons.notifications_active,
          image: UIData.timelineImage,
          routeName: '/notification'),
    ];
  }
}
