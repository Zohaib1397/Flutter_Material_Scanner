import 'dart:math';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../model/InputFieldHandler.dart';
import '../model/document.dart';
import '../model/layout.dart';
import '../utils/constants.dart';
import '../viewModel/image_view_model.dart';
import 'custom_widgets/document_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = "Home_Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchField = InputFieldHandler();

  final imagePicker = ImagePicker();

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer<ImageViewModel>(
                    builder: (context, imageController, _) {
                      List<Document> documentList =
                          imageController.documentList;
                      List<Widget> widgetTree = documentList
                          .map((element) => _buildDismissibleDocument(element))
                          .toList();
                      if (activeLayout == Layout.LIST) {
                        ListView.builder(
                            itemCount: widgetTree.length,
                            itemBuilder: (BuildContext context, int index) {
                            return _buildDismissibleDocument(documentList[index]);
                        });
                        return Column(
                          children: [
                            ...widgetTree,
                            imageController.isEmpty()
                                ? const SizedBox(
                                    height: 400,
                                    width: 400,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Image(
                                        ListTile(
                                          title: Image(
                                            image: AssetImage(
                                                "assets/empty_list.png"),
                                            height: 90,
                                            width: 90,
                                          ),
                                          subtitle: Text(
                                            "List is Empty",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              height: 400,
                              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ), itemBuilder: (BuildContext context, int index){
                                if (index < documentList.length) {
                                  // Check if the index is within the bounds of the list
                                  return Image.file(
                                    File(documentList[index].uri),
                                    width: 40,
                                    height: 40,
                                  );
                                } else {
                                  // Handle the case where the index is out of bounds
                                  return SizedBox(); // Return an empty widget or handle it differently
                                }
                              }),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleDocument(Document element) => Dismissible(
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            Provider.of<ImageViewModel>(context, listen: false)
                .deleteDocument(element);
            setState(() {});
          }
        },
        // confirmDismiss: (direction) async {
        //   await Utils.showAlertDialog(context, "Delete Image", "Are you sure you want to delete this image?", "Delete", () => true);
        // },
        direction: DismissDirection.endToStart,
        key: ObjectKey(element),
        background: buildSwipingContainer(
            Colors.red, "Delete", Icons.delete, Alignment.centerRight),
        // background: buildSwipingContainer(
        //     Colors.green, "Done", Icons.check_circle, Alignment.centerLeft),
        child: DocumentView(document: element),
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
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(context).colorScheme.secondaryContainer,
      ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: screenWidth > 600 ? 8 : 3,
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
          Flexible(
              flex: screenWidth > 600 ? 1 : 1,
              child: _buildCustomFilterSwitcher()),
        ],
      ),
    );
  }

  Widget _buildCustomFilterSwitcher() {
    return AnimatedToggleSwitch.rolling(
      borderWidth: 0,
      borderColor: Colors.transparent,
      innerColor: Theme.of(context).colorScheme.surfaceVariant,
      indicatorColor: Theme.of(context).colorScheme.onPrimary,
      height: 46,
      indicatorBorder: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant, width: 3.0),
      indicatorSize: const Size(46, double.infinity),
      current: activeLayout == Layout.GRID ? 0 : 1,
      values: const [0, 1],
      iconBuilder: (value, size, above) {
        IconData data = Icons.list_rounded;
        if (value.isEven) data = Icons.grid_view_rounded;
        return Icon(
          data,
          size: min(size.width, size.height),
          color: Theme.of(context).colorScheme.primary,
        );
      },
      onChanged: (value) {
        if (value == 0) {
          setState(() {
            activeLayout = Layout.GRID;
          });
        } else if (value == 1) {
          setState(() {
            activeLayout = Layout.LIST;
          });
        }
      },
    );
    //
  }

  NavigationBar buildBottomNavigationBar() {
    return NavigationBar(
      onDestinationSelected: (value) {},
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_filled),
          label: "Home",
          tooltip: "Home Screen",
        ),
        NavigationDestination(
            icon: Icon(Icons.image_outlined), label: "Import"),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined), label: "Settings"),
      ],
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      tooltip: "Scan Document",
      child: const Icon(Icons.camera_alt_outlined),
      onPressed: () async {
        if (Platform.isIOS) {
          XFile? image =
              await imagePicker.pickImage(source: ImageSource.gallery);
          Provider.of<ImageViewModel>(context, listen: false)
              .importFromCameraRoll(context, image!);
        } else {
          Provider.of<ImageViewModel>(context, listen: false)
              .performDocumentScan(context);
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
