import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oru/providers/brand_provider.dart';
import 'package:oru/widgets/email_signup.dart';
import 'package:oru/widgets/faq_section.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/banner_provider.dart';
import '../providers/product_provider.dart';
import '../utils/routes.dart';
import '../widgets/buildCategoryButton.dart';
import '../widgets/buildIconButton.dart';
import '../widgets/build_banner.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();



  bool _isBottomNavVisible = true;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() => _isBottomNavVisible = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() => _isBottomNavVisible = true);
      }
    });
    //Starting the timer for automatic banner change
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);
    bannerProvider.startTimer();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen:true);

    // Fetch products on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (productProvider.products.isEmpty && !productProvider.isLoading) {
        productProvider.fetchProducts();
      }
    });

    // Get the combined list of products and dummy products
    final combinedProducts = productProvider.getProductsWithDummies();

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            productProvider.fetchProducts();
          }
          return true;
        },

        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Sliver App Bar with Search Bar
            SliverAppBar(
              title: Row(
                  children:[
                    IconButton(onPressed: (){}, icon: const Icon(Icons.menu)),
                    SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0cBwtJxQ14kN_z1ua49yRZyt2qFzu4_vx8A&s")),
                  ]
              ),
              floating: true,
              pinned: true,
              snap: false,
              actions: [
                TextButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                    Navigator.pushNamed(context, AppRoutes.preLogin);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.yellow),
                  ),
                  child:authProvider.usernew != null ? const Text("Logout"): const Text("Login"),
                ),
              ],
              bottom: AppBar(
                title: Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.white,
                  child: const Center(
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.0
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(14))
                          ) ,
                          contentPadding: EdgeInsets.only(top: 1),
                          hintStyle: TextStyle(
                              fontSize: 14
                          ),
                          hintText: 'Search phones with make,model.....',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: Icon(Icons.mic)
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                height: 60, // Set a fixed height for horizontal ListView
                child: ListView(
                  scrollDirection: Axis.horizontal, // Make it scroll horizontally
                  children: [
                    buildCategoryButton('Sell Used Phones'),
                    buildCategoryButton('Buy Used Phones'),
                    buildCategoryButton('Compare Prices'),
                    buildCategoryButton('My Profile'),
                    buildCategoryButton('My Listings'),
                    buildCategoryButton('Services'),
                    buildCategoryButton('Register your Store'),
                    buildCategoryButton('Get the App'),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<BannerProvider>(
                builder: (context, bannerProvider, child) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: PageView(
                          controller: bannerProvider.pageController,
                          onPageChanged: (int page) {
                            bannerProvider.updatePage(page);
                          },
                          children: [
                            buildBannerCard('assets/images/BannerA.png'),
                            buildBannerCard('assets/images/BannerB.png'),
                            buildBannerCard('assets/images/BannerC.png'),
                            buildBannerCard('assets/images/BannerD.png'),
                            buildBannerCard('assets/images/BannerE.png'),
                          ],
                        ),
                      ),
                      // Add page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bannerProvider.currentPage == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Consumer<BrandProvider>(
                builder: (context, brandProvider, child) {
                  if (brandProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container(
                    height: 80,
                     padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: brandProvider.brands.map((brand) {
                        return buildIconButton(brand.imagePath, brand.make);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),

            // Sliver Grid for Products
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                childAspectRatio: 0.65, // Adjusts card height
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index == combinedProducts.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final product = combinedProducts[index];
                  return _buildProductCard(product, context);
                },
                childCount: combinedProducts.length + (productProvider.isLoading ? 1 : 0),
              ),
            ),

    SliverToBoxAdapter(
    child: SizedBox(
      height: 70,
      child: TextButton(
      onPressed: () {},
      child: const Row(
      children: [
      Expanded(
      child: Text(
      "Frequently Asked Question",
      style: TextStyle(
        fontSize: 19,
      fontWeight: FontWeight.w400,
      color: Colors.black, // Set text color to black
      ),
      ),
      ),
      Icon(
      Icons.arrow_forward_ios, // Add a suffix icon
      color: Colors.black, // Set icon color to black
      size: 16, // Adjust icon size
      ),
      ],
      ),
      ),
    ),

    ),
            SliverToBoxAdapter(
              child:EmailSignupWidget(),
            ),
            SliverToBoxAdapter(
              child:Container(
                color: Colors.black87, // Dark background color
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Download App',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/google.png', // Replace with actual QR code image
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            'assets/images/apple.png', // Replace with actual QR code image
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_play_icon.png', // Replace with actual Google Play icon
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 40),
                        Image.asset(
                          'assets/images/apple_icon.png', // Replace with actual Apple icon
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: FAQScreen(),
              ),
            ),


          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _isBottomNavVisible? BottomNavigationBar(
        backgroundColor: Colors.white,
        type:  BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ):null
    );
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  product.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      product.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: product.isLiked ? Colors.red : Colors.black54,
                    ),
                    onPressed: () {
                      if (authProvider.usernew == null) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Please login to like products')),
                        // );
                        showSignInBottomSheet(context);
                        return;
                      }else{
                        authProvider.likeProduct(product.id, true);
                        productProvider.toggleLike(product.id);
                      }

                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '₹${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Like New',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(product.city ?? 'Unknown'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class CheckboxProvider extends ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  void toggleCheckbox(bool? value) {
    _isChecked = value ?? false;
    notifyListeners();
  }
}


void showSignInBottomSheet(BuildContext context) {
  TextEditingController phoneNumberText = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return ChangeNotifierProvider(
        create:(_)=>CheckboxProvider(),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sign in to continue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text("Enter Your Phone Number"),
              const SizedBox(height: 5),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phoneNumberText,
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("+91", style: TextStyle(fontSize: 16)),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  hintText: "Mobile Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
              Consumer<CheckboxProvider>(
              builder: (context, provider, child) => Checkbox(
          value: provider.isChecked,
          onChanged: provider.toggleCheckbox,
        ),
        ),
                  const Text("Accept "),
                  GestureDetector(
                    onTap: () {}, // Add navigation to terms & conditions
                    child: const Text(
                      "Terms and condition",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    final authProvider = Provider.of<AuthProvider>(context, listen:false);
                    await authProvider.createOtp("+91${phoneNumberText.text}");
                    Navigator.pushReplacementNamed(context, AppRoutes.otp);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Next", style: TextStyle(fontSize: 16, color:Colors.white)),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, color:Colors.white),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    },
  );
}

// void showOtpBottomSheet(BuildContext context, String phoneNumber) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
//       return OTPBottomSheet(phoneNumber: phoneNumber);
//     },
//   );
// }
//
// // OTP Bottom Sheet Widget
// class OTPBottomSheet extends StatefulWidget {
//   final String phoneNumber;
//   OTPBottomSheet({required this.phoneNumber});
//
//   @override
//   _OTPBottomSheetState createState() => _OTPBottomSheetState();
// }
//
// class _OTPBottomSheetState extends State<OTPBottomSheet> {
//   final TextEditingController _otpController = TextEditingController();
//   int _timerSeconds = 30;
//   bool _canResend = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }
//
//   void _startTimer() {
//     setState(() {
//       _timerSeconds = 30;
//       _canResend = false;
//     });
//
//     Future.delayed(Duration(seconds: 1), _tickTimer);
//   }
//
//   void _tickTimer() {
//     if (_timerSeconds > 0) {
//       setState(() => _timerSeconds--);
//       Future.delayed(Duration(seconds: 1), _tickTimer);
//     } else {
//       setState(() => _canResend = true);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 20,
//         right: 20,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         top: 20,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               Text(
//                 "Verify OTP",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text(
//             "Please enter the 4-digit verification code sent to your mobile number ${widget.phoneNumber} via SMS",
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 15),
//           Pinput(
//             length: 4,
//             controller: _otpController,
//             keyboardType: TextInputType.number,
//             mainAxisAlignment: MainAxisAlignment.center,
//             defaultPinTheme: PinTheme(
//               height: 50,
//               width: 50,
//               textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//           SizedBox(height: 15),
//           Text(
//             _canResend
//                 ? "Didn't receive OTP?"
//                 : "Resend OTP in 0:${_timerSeconds.toString().padLeft(2, '0')} Sec",
//             style: TextStyle(fontSize: 14),
//           ),
//           if (_canResend)
//             TextButton(
//               onPressed: () {
//                 _startTimer();
//                 // Handle OTP resend logic
//               },
//               child: Text("Resend OTP", style: TextStyle(color: Colors.blue)),
//             ),
//           SizedBox(height: 15),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo,
//                 padding: EdgeInsets.symmetric(vertical: 15),
//               ),
//               onPressed: () {
//                 // Handle OTP verification logic
//                 Navigator.pop(context);
//               },
//               child: Text("Verify OTP", style: TextStyle(fontSize: 16)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }