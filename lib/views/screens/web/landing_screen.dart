import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/widgets/web/guestappbar.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen> {
  // Scroll controller
  final ScrollController _scrollController = ScrollController();
  
  // Form controllers and keys
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormSubmitting = false;
  
  // Section keys
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  
  // Active section index
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Add listener to update the active section based on scroll position
    _scrollController.addListener(_updateActiveSection);
    
    // Initialize with a small delay to ensure all widgets are laid out
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateActiveSection();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveSection);
    _scrollController.dispose();
    
    // Dispose of form controllers
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    
    super.dispose();
  }
  
  // Update the active section based on scroll position with improved thresholds
  void _updateActiveSection() {
    if (!_scrollController.hasClients) return;
    
    final double scrollPosition = _scrollController.position.pixels;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate the index based on relative scroll position with adjusted thresholds
    if (scrollPosition < screenHeight * 0.6) {
      setState(() => _activeIndex = 0); // Home
    } else if (scrollPosition < screenHeight * 1.5) {
      setState(() => _activeIndex = 1); // Features
    } else if (scrollPosition < screenHeight * 2.5) {
      setState(() => _activeIndex = 2); // About
    } else {
      setState(() => _activeIndex = 3); // Contact
    }
  }
  
  // Scroll to section with fixed offsets
  void _scrollToSection(int index) {
    if (!_scrollController.hasClients) return;
    
    setState(() => _activeIndex = index);
    
    final double screenHeight = MediaQuery.of(context).size.height;
    double targetPosition;
    
    // Use fixed positions for reliable navigation with adjusted spacing
    switch (index) {
      case 0: // Home
        targetPosition = 0;
        break;
      case 1: // Features
        targetPosition = screenHeight * 1.0;  // Just below first screen
        break;
      case 2: // About
        targetPosition = screenHeight * 2.0;  // Below features
        break;
      case 3: // Contact
        targetPosition = screenHeight * 3.0;  // Below about
        break;
      default:
        targetPosition = 0;
    }
    
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _login(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
  
  void _register(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;
    final isTablet = screenWidth > 600 && screenWidth <= 1000;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ResponsiveGuestAppBar(
        onLoginTap: () => _login(context),
        onMenuItemTap: _scrollToSection,
        activeIndex: _activeIndex,
      ),
      endDrawer: GuestAppBarDrawer(
        menuItems: const ['Home', 'Features', 'About', 'Contact'],
        onLoginTap: () => _login(context),
        onMenuItemTap: _scrollToSection,
        activeIndex: _activeIndex,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ConstantString.darkBlue, ConstantString.lightBlue],
          ),
        ),
        child: SafeArea(
          child: isDesktop 
              ? _buildDesktopLayout(screenWidth, screenHeight)
              : _buildMobileLayout(screenWidth, screenHeight, isTablet),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(double width, double height) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          // Home Section with gradient background
          Container(
            key: _homeKey,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ConstantString.darkBlue,
                  ConstantString.lightBlue,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background circle decoration
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150,
                  left: -100,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Content
                Row(
                  children: [
                    // Left side - Text content
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 80.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: ConstantString.white,
                                  fontFamily: ConstantString.fontFredoka,
                                  height: 1.1,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Vult\$",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: ConstantString.fontFredokaOne,
                                    ),
                                  ),
                                  TextSpan(text: " the\nbest mobile\nbank App."),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Description
                            Text(
                              "Secure, fast, and seamless financial management anytime, anywhere.",
                              style: TextStyle(
                                color: ConstantString.white,
                                fontSize: 24,
                                fontFamily: ConstantString.fontFredoka,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 40),
                            // Buttons
                            Row(
                              children: [
                                _buildGradientButton(
                                  "Get Started",
                                  onTap: () => _register(context),
                                  isPrimary: true,
                                ),
                                const SizedBox(width: 20),
                                _buildGradientButton(
                                  "Learn More",
                                  onTap: () {},
                                  isPrimary: false,
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            // Trust badges
                            Row(
                              children: [
                                _buildTrustBadge(Icons.security_rounded, "Secure"),
                                const SizedBox(width: 40),
                                _buildTrustBadge(Icons.speed_rounded, "Fast"),
                                const SizedBox(width: 40),
                                _buildTrustBadge(Icons.thumb_up_rounded, "Trusted"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Right side - App mockup
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: _buildAppMockup(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Features Section with light background
          Container(
            key: _featuresKey,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Features",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Everything you need in a modern banking app",
                  style: TextStyle(
                    fontSize: 20,
                    color: ConstantString.darkGrey,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _buildFeatureCard(
                          "Easy Payments",
                          "Send money instantly to anyone, anywhere in the world.",
                          Icons.payment_rounded,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _buildFeatureCard(
                          "Smart Analytics",
                          "Track your spending habits with AI-powered insights.",
                          Icons.analytics_rounded,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _buildFeatureCard(
                          "Secure Banking",
                          "Your data is protected with military-grade encryption.",
                          Icons.security_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // About Section with gradient background
          Container(
            key: _aboutKey,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ConstantString.lightBlue.withOpacity(0.9),
                  ConstantString.darkBlue,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "About Vult\$",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.white,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Our mission is to revolutionize banking for everyone",
                  style: TextStyle(
                    fontSize: 20,
                    color: ConstantString.white,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Our Story",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ConstantString.white,
                                fontFamily: ConstantString.fontFredokaOne,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Founded in 2023, Vult\$ was created with a simple goal: make banking accessible, affordable, and enjoyable for everyone. We believe financial services should be a right, not a privilege.\n\nOur team of experts from fintech and banking industries came together to build something truly revolutionary. Today, we serve over 1 million customers across the globe, with a satisfaction rate of 98%.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildGradientButton(
                              "Join Our Team",
                              onTap: () {},
                              isPrimary: false,
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              size: 80,
                              color: ConstantString.white,
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Our Growth",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ConstantString.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStat("1M+", "Users"),
                                _buildStat("150+", "Countries"),
                                _buildStat("\$500M", "Transactions"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Contact Section with light background
          Container(
            key: _contactKey,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Have questions? We're here to help!",
                  style: TextStyle(
                    fontSize: 20,
                    color: ConstantString.darkGrey,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact form
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContactForm(),
                        ],
                      ),
                    ),
                    // Contact info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Get in Touch",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: ConstantString.darkBlue,
                                fontFamily: ConstantString.fontFredokaOne,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildContactInfo(Icons.email, "support@vults.com"),
                            const SizedBox(height: 20),
                            _buildContactInfo(Icons.phone, "+1 (555) 123-4567"),
                            const SizedBox(height: 20),
                            _buildContactInfo(Icons.location_on, "123 Fintech St, San Francisco, CA 94105"),
                            const SizedBox(height: 40),
                            Text(
                              "Follow Us",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ConstantString.darkBlue,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _buildSocialIcon(Icons.facebook, () {}),
                                const SizedBox(width: 20),
                                _buildSocialIcon(Icons.telegram, () {}),
                                const SizedBox(width: 20),
                                _buildSocialIcon(Icons.chat, () {}),
                                const SizedBox(width: 20),
                                _buildSocialIcon(Icons.email, () {}),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 80),
            color: ConstantString.darkBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "© 2023 Vult\$. All rights reserved.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Terms of Service",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(double width, double height, bool isTablet) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          // Home Section
          Container(
            key: _homeKey,
            height: height,
            child: Stack(
              children: [
                // Background circle decoration
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -100,
                  left: -50,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.08),
                      // Title
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: isTablet ? 60 : 48,
                            fontWeight: FontWeight.bold,
                            color: ConstantString.white,
                            fontFamily: ConstantString.fontFredoka,
                            height: 1.1,
                          ),
                          children: [
                            TextSpan(
                              text: "Vult\$",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: ConstantString.fontFredokaOne,
                              ),
                            ),
                            TextSpan(text: " the\nbest mobile\nbank App."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        "Secure, fast, and seamless financial management anytime, anywhere.",
                        style: TextStyle(
                          color: ConstantString.white,
                          fontSize: isTablet ? 24 : 18,
                          fontFamily: ConstantString.fontFredoka,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // App mockup for mobile view
                      Center(
                        child: SizedBox(
                          height: height * 0.4,
                          child: _buildAppMockup(),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Buttons
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _buildGradientButton(
                            "Get Started",
                            onTap: () => _register(context),
                            isPrimary: true,
                            width: isTablet ? 200 : double.infinity,
                          ),
                          _buildGradientButton(
                            "Learn More",
                            onTap: () {},
                            isPrimary: false,
                            width: isTablet ? 200 : double.infinity,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Trust badges
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _buildTrustBadge(Icons.security_rounded, "Secure"),
                          _buildTrustBadge(Icons.speed_rounded, "Fast"),
                          _buildTrustBadge(Icons.thumb_up_rounded, "Trusted"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Features Section
          Container(
            key: _featuresKey,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Features",
                  style: TextStyle(
                    fontSize: isTablet ? 42 : 36,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Discover what makes Vult\$ the best banking app",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: ConstantString.darkGrey,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 40),
                _buildFeatureCard(
                  "Easy Payments",
                  "Send and receive money instantly with zero fees between Vult\$ users.",
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  "Smart Analytics",
                  "Track your spending habits and get personalized insights for better financial decisions.",
                  Icons.analytics_rounded,
                ),
                const SizedBox(height: 20),
                _buildFeatureCard(
                  "Secure Banking",
                  "State-of-the-art encryption and biometric authentication keeps your money safe.",
                  Icons.lock_rounded,
                ),
              ],
            ),
          ),
          
          // About Section
          Container(
            key: _aboutKey,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [ConstantString.lightBlue.withOpacity(0.9), ConstantString.darkBlue],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "About Vult\$",
                  style: TextStyle(
                    fontSize: isTablet ? 42 : 36,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.white,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Our mission is to revolutionize banking for everyone",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: ConstantString.white,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Our Story",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ConstantString.white,
                        fontFamily: ConstantString.fontFredokaOne,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Founded in 2023, Vult\$ was created with a simple goal: make banking accessible, affordable, and enjoyable for everyone. We believe financial services should be a right, not a privilege.\n\nOur team of experts from fintech and banking industries came together to build something truly revolutionary. Today, we serve over 1 million customers across the globe, with a satisfaction rate of 98%.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: _buildGradientButton(
                        "Join Our Team",
                        onTap: () {},
                        isPrimary: false,
                        width: isTablet ? 200 : double.infinity,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 60,
                        color: ConstantString.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Our Growth",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ConstantString.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        spacing: 30,
                        runSpacing: 30,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildStat("1M+", "Users"),
                          _buildStat("150+", "Countries"),
                          _buildStat("\$500M", "Transactions"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Contact Section
          Container(
            key: _contactKey,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Contact Us",
                  style: TextStyle(
                    fontSize: isTablet ? 42 : 36,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Have questions? We're here to help!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: ConstantString.darkGrey,
                    fontFamily: ConstantString.fontFredoka,
                  ),
                ),
                const SizedBox(height: 40),
                _buildContactForm(),
                const SizedBox(height: 40),
                Text(
                  "Get in Touch",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                    fontFamily: ConstantString.fontFredokaOne,
                  ),
                ),
                const SizedBox(height: 20),
                _buildContactInfo(Icons.email, "support@vults.com"),
                const SizedBox(height: 16),
                _buildContactInfo(Icons.phone, "+1 (555) 123-4567"),
                const SizedBox(height: 16),
                _buildContactInfo(Icons.location_on, "123 Fintech St, San Francisco, CA 94105"),
                const SizedBox(height: 30),
                Text(
                  "Follow Us",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantString.darkBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(Icons.facebook, () {}),
                    const SizedBox(width: 20),
                    _buildSocialIcon(Icons.telegram, () {}),
                    const SizedBox(width: 20),
                    _buildSocialIcon(Icons.chat, () {}),
                    const SizedBox(width: 20),
                    _buildSocialIcon(Icons.email, () {}),
                  ],
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            color: ConstantString.darkBlue,
            child: Column(
              children: [
                Text(
                  "© 2023 Vult\$. All rights reserved.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Terms of Service",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text, {required VoidCallback onTap, bool isPrimary = true, double? width}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    ConstantString.orange, 
                    ConstantString.orange.withRed(255)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isPrimary ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isPrimary ? Colors.transparent : ConstantString.white,
            width: isPrimary ? 0 : 2,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: ConstantString.orange.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                  )
                ]
              : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ConstantString.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: ConstantString.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: ConstantString.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAppMockup() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Shadow
        Container(
          width: 280,
          height: 15,
          margin: const EdgeInsets.only(top: 600),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        // Phone outer case
        Container(
          width: 280,
          height: 580,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),
        // Phone screen
        Container(
          width: 260,
          height: 560,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ConstantString.darkBlue.withOpacity(0.9),
                ConstantString.lightBlue.withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: ConstantString.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/vultsicon.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Vult\$",
                style: TextStyle(
                  color: ConstantString.white,
                  fontFamily: ConstantString.fontFredokaOne,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Mock balance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Balance",
                        style: TextStyle(
                          color: ConstantString.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$12,456.78",
                            style: TextStyle(
                              color: ConstantString.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: ConstantString.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.arrow_upward, color: ConstantString.green, size: 12),
                                SizedBox(width: 2),
                                Text(
                                  "2.4%",
                                  style: TextStyle(
                                    color: ConstantString.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Mock features
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFeatureCircle(Icons.send_rounded),
                    _buildFeatureCircle(Icons.credit_card),
                    _buildFeatureCircle(Icons.account_balance),
                    _buildFeatureCircle(Icons.insights),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Mock transaction
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ConstantString.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          color: ConstantString.orange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Middle text - use Flexible to prevent overflow
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Shopping",
                              style: TextStyle(
                                color: ConstantString.white,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Today",
                              style: TextStyle(
                                color: ConstantString.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Right price
                      Text(
                        "-\$24.99",
                        style: TextStyle(
                          color: ConstantString.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Notch
        Positioned(
          top: 15,
          child: Container(
            width: 120,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCircle(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: ConstantString.white,
        size: 20,
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ConstantString.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: ConstantString.orange,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ConstantString.darkBlue,
              fontFamily: ConstantString.fontFredokaOne,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: ConstantString.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: ConstantString.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: ConstantString.fontFredokaOne,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Send us a message",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ConstantString.darkBlue,
                fontFamily: ConstantString.fontFredokaOne,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextFormField(
              controller: _nameController,
              label: "Your name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your name";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _emailController,
              label: "Your email",
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _subjectController,
              label: "Subject",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a subject";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _messageController,
              label: "Your message",
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a message";
                } else if (value.length < 10) {
                  return "Message should be at least 10 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            _isFormSubmitting 
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ConstantString.orange),
                    ),
                  )
                : _buildGradientButton(
                    "Send Message",
                    onTap: _submitForm,
                    isPrimary: true,
                    width: double.infinity,
                  ),
          ],
        ),
      ),
    );
  }
  
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isFormSubmitting = true);
      
      // Simulate form submission with a delay
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isFormSubmitting = false);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Message sent successfully!'),
            backgroundColor: ConstantString.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      });
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: label,
        hintStyle: TextStyle(
          color: ConstantString.grey.withOpacity(0.7),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ConstantString.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ConstantString.red, width: 1),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: validator,
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ConstantString.lightBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: ConstantString.lightBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: ConstantString.darkGrey,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ConstantString.darkBlue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: ConstantString.darkBlue,
          size: 24,
        ),
      ),
    );
  }
}