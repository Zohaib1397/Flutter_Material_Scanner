import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        titleSpacing: 16,
        title: const Text(
          "Your Documents",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: _buildAppBarTrailingIcon(),
      ),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: Column(
        children: [
          _buildSearchBarAndFilter(),
        ],
      ),
    );
  }

  Padding _buildSearchBarAndFilter() {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 46),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search document, folder",
                      contentPadding: const EdgeInsets.symmetric(vertical:10),
                    ),

                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: _buildCustomFilterSwitcher(),
              ),
            ],
          ),
        );
  }

  Widget _buildCustomFilterSwitcher(){
    return Container(
      constraints: const BoxConstraints(maxHeight: 46),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (value) {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
          tooltip: "Home Screen",
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.image_outlined), label: "Import"),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: "Settings"),
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      tooltip: "Scan Document",
      child: const Icon(Icons.camera_alt_outlined),
      onPressed: () {},
    );
  }

  List<Widget> _buildAppBarTrailingIcon() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filledTonal(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.create_new_folder_outlined),
          onPressed: () {},
        ),
      ),
    ];
  }
}
