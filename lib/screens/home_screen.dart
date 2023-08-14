import 'package:flutter/material.dart';

import '../Structure/InputFieldHandler.dart';
import '../Structure/Layout.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchField = InputFieldHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: false,
            titleSpacing: 16,
            pinned: true,
            title: const Text(
              "Your Documents",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            floating: true,
            actions: _buildAppBarTrailingIcon(),
            expandedHeight: 115,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildSearchBarAndFilter()),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Column(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Text(
                        "Some Large Large Text",
                        style: TextStyle(fontSize: 100),
                      ),
                      Text(
                        "Some Large Large Text",
                        style: TextStyle(fontSize: 100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                controller: _searchField.controller,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search document, folder",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10.0),
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

  Widget _buildCustomFilterSwitcher() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 46),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 70),
            alignment: activeLayout == Layout.LIST
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 40, maxHeight: 40),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: "Grid View",
              onPressed: () {
                if (activeLayout == Layout.LIST) {
                  setState(() {
                    activeLayout = Layout.GRID;
                  });
                }
              },
              icon: Icon(Icons.grid_view_rounded,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: "List View",
              onPressed: () {
                if (activeLayout == Layout.GRID) {
                  setState(() {
                    activeLayout = Layout.LIST;
                  });
                }
              },
              icon: Icon(Icons.list_outlined,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Container(
          margin: EdgeInsets.zero,
          child: IconButton.filledTonal(
            icon: const Icon(Icons.create_new_folder_outlined),
            onPressed: () {},
          ),
        ),
      ),
    ];
  }
}
