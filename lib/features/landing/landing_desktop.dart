import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../registration/build_desktop.dart';

class LandingDesktop extends ConsumerStatefulWidget {
  const LandingDesktop({super.key});

  @override
  ConsumerState<LandingDesktop> createState() => _LandingDesktopState();
}

class _LandingDesktopState extends ConsumerState<LandingDesktop> {
  List<TextEditingController> controllers =
      List.generate(3, (index) => TextEditingController());

  final List<String> images = [
    "assets/images/background.jpg",
    "assets/images/monet.jpg",
    "assets/images/base.jpg",
    "assets/images/player.jpg",
    "assets/images/accountant.jpg"
  ];

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Current page index for navigation
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexus Finance Tracker',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Row(
          children: [
            // Image Carousel
            Flexible(
              flex: 1,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                ),
                items: images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // Navigation and content area
            // Navigation Rail
            Container(
              color: Colors.blueGrey[100],
              child: NavigationRail(
                selectedIndex: _currentIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    selectedIcon: Icon(Icons.home_filled),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.login),
                    selectedIcon: Icon(Icons.login),
                    label: Text('Login'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_add),
                    selectedIcon: Icon(Icons.person_add_alt_1),
                    label: Text('Sign Up'),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: Container(
                color: Colors.blueGrey[50],
                padding: const EdgeInsets.all(20.0),
                child: _getPageContent(_currentIndex, ref, controllers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to switch between pages
  Widget _getPageContent(int index, var ref, var controllers) {
    switch (index) {
      case 1:
        return buildLoginPage(ref, controllers);
      case 2:
        return buildSignUpPage(ref, controllers);
      default:
        return buildHomePage();
    }
  }
}
