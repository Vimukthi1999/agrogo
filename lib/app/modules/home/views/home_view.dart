import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 320,
              decoration: const BoxDecoration(
                color: Color(0xFF1E7044),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, Good Morning",
                            // style: GoogleFonts.poppins(
                            //   color: Colors.white,
                            //   fontSize: 20,
                            //   fontWeight: FontWeight.w600,
                            // ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Sunday, 01 Dec 2024",
                                // style: GoogleFonts.poppins(
                                //   color: Colors.white70,
                                //   fontSize: 14,
                                // ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.white70)
                            ],
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'), // Dummy User
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search here...",
                        hintStyle: TextStyle(color: Colors.white60),
                        icon: Icon(Icons.search, color: Colors.white60),
                        suffixIcon: Icon(Icons.mic, color: Colors.white60),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Weather Widget Card
                  // _buildWeatherCard(),

                  const SizedBox(height: 25),

                  // Invest By Category
                  Text(
                    "Invest by Category",
                    // style: GoogleFonts.poppins(
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.bold,
                    //   color: Colors.black87,
                    // ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controller.categories.map((cat) {
                      return _buildCategoryItem(cat);
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  // Best Offers Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Best Offers",
                        // style: GoogleFonts.poppins(
                        //   fontSize: 18,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.black87,
                        // ),
                      ),
                      Text(
                        "View all",
                        // style: GoogleFonts.poppins(
                        //   fontSize: 14,
                        //   fontWeight: FontWeight.w500,
                        //   color: const Color(0xFF1E7044),
                        // ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Offers List
                  // SizedBox(
                  //   height: 160,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: controller.offerImages.length,
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //         width: 250,
                  //         margin: const EdgeInsets.only(right: 15),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(20),
                  //           image: DecorationImage(
                  //             image: NetworkImage(controller.offerImages[index]),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20),
                  //             gradient: LinearGradient(
                  //               begin: Alignment.bottomCenter,
                  //               end: Alignment.topCenter,
                  //               colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

          ],
        )
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> cat) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          child: Icon(cat['icon'], color: cat['color'], size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          cat['label'],
          // style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
        )
      ],
    );
  }

}




// Container(
//     width: double.infinity,
//     height: double.infinity,
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: [
//           Color.fromARGB(255, 238, 143, 59), // Warm Peach/Cream (Top Left)
//           Color(0xFFFFFBF7), // Very Light Cream/White (Bottom Right)
//         ],
//         // You can adjust stops to control how far the peach color spreads
//         stops: [0.0, 1.0], 
//       ),
//     ),
//     child: SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Your UI content goes here...
//           Text("Hello, Harris", style: TextStyle(fontSize: 24)),
//         ],
//       ),
//     ),
//   ),
