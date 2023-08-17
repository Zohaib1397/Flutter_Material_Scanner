import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:material_scanner/utils/save_image_path.dart';
import 'package:provider/provider.dart';
import '../model/InputFieldHandler.dart';
import '../model/document.dart';
import '../model/layout.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../viewModel/image_view_model.dart';
import 'custom_widgets/document_view.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchField = InputFieldHandler();

  // Future<void> addImagesToList() async {
  //   List<Document> documents =
  //       Provider.of<ImageViewModel>(context, listen: false).documentList;
  //   for (var newDoc in documents) {
  //     list.add(
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: DocumentView(
  //           document: newDoc,
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
      /*Using Custom Scroll View to implement Sliver App Bar
      * As the application design contains a search bar at top along
      * with custom toggle switch for layout management*/
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Today"),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: DocumentView(),
                        ),
                        const Text("Yesterday"),
                        Consumer<ImageViewModel>(
                            builder: (context, imageController, _) {
                          List<Document> list = [];
                          list = imageController.documentList;
                          List<Widget> widgetTree = [];
                          widgetTree = list
                              .map((element) =>
                                  _buildDismissibleDocument(element))
                              .toList();
                          return Column(
                            children: widgetTree,
                          );
                        }),
                        // ...list,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleDocument(Document element) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Dismissible(
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // setState(() =>
                //     Provider.of<TaskControllerProvider>(context, listen: false)
                //         .removeTaskFromList(task));
              }
              // else if (direction == DismissDirection.startToEnd) {
              //   task.isCompleted = true;
              // }
            },
            key: ObjectKey(element),
            direction: DismissDirection.endToStart,
            background: buildSwipingContainer(
                Colors.red, "Delete", Icons.delete, Alignment.centerRight),
            // background: buildSwipingContainer(
            //     Colors.green, "Done", Icons.check_circle, Alignment.centerLeft),
            child: DocumentView(document:  element),
          ),
        ),
      );

  Widget buildSwipingContainer(
      Color color, String text, IconData icon, Alignment alignment) =>
      Container(
        color: color,
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              Text(text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      //A sliver app bar with a title and just one trailing icon to create a new folder
      centerTitle: false,
      titleSpacing: 16,
      pinned: true,
      title: const Text(
        "Your Documents",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      floating: true,
      //Following action widget is used to create new folder
      actions: _buildAppBarTrailingIcon(),
      expandedHeight: 115,
      //The sliver app bar contains the Searchbar and custom toggle switch
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // Aligning the search bar + toggle switch to bottom
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildSearchBarAndFilter()),
        ),
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
      onPressed: () async {
        try {
          final scannedImages = await CunningDocumentScanner.getPictures();
          if (scannedImages != null) {
            for (var image in scannedImages) {
              String uri = await SaveImagePath.saveImageFromPath(image);
              Document newDoc = Document(
                  uri: uri,
                  name: "New Image",
                  timeStamp: DateTime.now().toIso8601String());
              Provider.of<ImageViewModel>(context, listen: false)
                  .addDocument(newDoc);
            }
            print(scannedImages);
          }
        } catch (exception) {
          Utils.showErrorMessage(context, exception.toString());
        }
      },
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
            onPressed: () {
              setState(() {
                // addImagesToList();
              });
            },
          ),
        ),
      ),
    ];
  }
}
