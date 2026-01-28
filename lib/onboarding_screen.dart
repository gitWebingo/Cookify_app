import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover',
      'highlight': 'Perfect',
      'subtitle': 'Recipes',
      'description':
          'Browse through thousands of high-quality recipes from professional chefs worldwide.',
      'image':
          'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=1000&q=80',
    },
    {
      'title': 'Get',
      'highlight': 'Expert',
      'subtitle': 'Tips',
      'description':
          'Learn secret techniques and insights from top culinary masters to elevate your skills.',
      'image':
          'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=1000&q=80',
    },
    {
      'title': 'Cook with',
      'highlight': 'Absolute',
      'subtitle': 'Joy',
      'description':
          'Follow simple, intuitive steps to create restaurant-quality meals in your own home.',
      'image':
          'https://images.unsplash.com/photo-1493770348161-369560ae357d?w=1000&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full-screen PageView for Integrated Experience
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Full-bleed Background Image
                  Image.network(
                    _onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                  ),

                  // Sophisticated Gradient Blend (Single Section Feel)
                  // Top blend for 'SKIP' button and bottom white blend for text
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.4, 0.7, 1.0],
                        colors: [
                          Colors.black.withOpacity(0.9), // Top shadow
                          Colors.transparent, // Clear visual area
                          Colors.white.withOpacity(1.0), // Start of white fade
                          Colors.white, // Solid white base
                        ],
                      ),
                    ),
                  ),

                  // Text Content (Floating Over the White Fade)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 160),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: _currentPage == index ? 1.0 : 0.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _onboardingData[index]['title']!,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w300,
                                color: Colors.black45,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _onboardingData[index]['highlight']!,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6B35),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _onboardingData[index]['subtitle']!,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _onboardingData[index]['description']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Permanent Overlays
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 1),
                                blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                // Bottom UI Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Modern Indicators
                      Row(
                        children:
                            List.generate(_onboardingData.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.only(right: 8),
                            height: 4,
                            width: _currentPage == index ? 28 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? const Color(0xFFFF6B35)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),

                      // Refined 'Next' / 'Get Started' Pill
                      GestureDetector(
                        onTap: () {
                          if (_currentPage == _onboardingData.length - 1) {
                            Navigator.pushReplacementNamed(context, '/login');
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 700),
                              curve: Curves.fastOutSlowIn,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                _currentPage == _onboardingData.length - 1
                                    ? 32
                                    : 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFFFF6B35).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _onboardingData.length - 1
                                    ? 'GET STARTED'
                                    : 'NEXT',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              if (_currentPage !=
                                  _onboardingData.length - 1) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: 18),
                              ],
                            ],
                          ),
                        ),
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
}
