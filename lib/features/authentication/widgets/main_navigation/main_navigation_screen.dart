import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final screens = [
    const Center(
      child: Text("Home"),
    ),
    const Center(
      child: Text("Search"),
    ),
    const Center(
      child: Text("Search"),
    ),
    const Center(
      child: Text("Search"),
    ),
    const Center(
      child: Text("Search"),
    ),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTap,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: Colors.white,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.white,
            ),
            label: "Search ",
          ),
        ],
      ),
    );
  }
}



// Material Design 2 
// BottomNavigationBar(
//         아이템이 4개이상이면 자동으로 shifting,
//         type: BottomNavigationBarType.shifting,
//         onTap: _onTap,
//         currentIndex: _selectedIndex,
//         //selectedItemColor: Theme.of(context).primaryColor,
//         items: const [
//           BottomNavigationBarItem(
//             icon: FaIcon(FontAwesomeIcons.house),
//             label: "Home",
//             tooltip: "What are you? ",
//             backgroundColor: Colors.amber,
//           ),
//           BottomNavigationBarItem(
//             icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
//             label: "Search ",
//             tooltip: "What are you? ",
//             backgroundColor: Colors.blue,
//           ),
//         ],
//       )