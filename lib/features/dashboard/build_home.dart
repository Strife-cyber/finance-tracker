import 'package:finance_tracker/currents/current_account.dart';
import 'package:finance_tracker/currents/current_user.dart';
import 'package:finance_tracker/features/account/update_account.dart';
import 'package:finance_tracker/features/dashboard/builds/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuildHome extends ConsumerStatefulWidget {
  const BuildHome({super.key});

  @override
  ConsumerState<BuildHome> createState() => _BuildHomeState();
}

class _BuildHomeState extends ConsumerState<BuildHome> {
  List<Widget> userWidgets = [];
  bool showWidgetBuilder = false; // Flag to show/hide widget builder

  @override
  void initState() {
    super.initState();
  }

  // Function to add widget and hide the builder
  void _addWidget(Widget widget) {
    setState(() {
      userWidgets.add(widget);
      showWidgetBuilder = false; // Hide widget builder after saving
    });
  }

  // Toggle the widget builder's visibility
  void _toggleWidgetBuilder() {
    setState(() {
      showWidgetBuilder = !showWidgetBuilder;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(currentUserProvider);
    final accountProvider = ref.watch(currentAccountProvider);
    final user = userProvider.getCurrentUser()!;

    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        automaticallyImplyLeading: false,
        title: showWidgetBuilder
            ? const Text('Build Your Own Widget',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            : const Text('Home',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _toggleWidgetBuilder, // Toggle the in-place builder
          ),
        ],
      ),
      body: showWidgetBuilder
          ? WidgetBuilderPage(
              onSave: _addWidget, // Save and hide builder when done
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: accountProvider.getImage(user.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const CircleAvatar(
                          radius: 60,
                          child: Icon(Icons.error),
                        );
                      } else if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdateAccount(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(snapshot.data!),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UpdateAccount(),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 60,
                            child: Icon(Icons.person),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome, ${user.name}!',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Show the widget builder if the flag is true
                  Expanded(
                    child: userWidgets.isEmpty
                        ? const Center(
                            child: Text(
                              'No Widgets Yet',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: userWidgets.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: userWidgets[index],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
