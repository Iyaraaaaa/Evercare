import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();
  int selectPage = 0;
  List<Map<String, String>> pageArr = [
    {
      "img": "assets/images/on_board_1.png",
      "title": "Find Your Doctor",
      "subtitle": "Find the best doctors near you.",
    },
    {
      "img": "assets/images/on_board_2.png",
      "title": "Easily Available",
      "subtitle": "Book appointments easily with specialists.",
    },
    {
      "img": "assets/images/on_board_3.png",
      "title": "Full Satisfaction",
      "subtitle": "Get full satisfaction for your health concerns.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            onPageChanged: (page) {
              setState(() {
                selectPage = page;
              });
            },
            itemBuilder: (context, index) {
              var obj = pageArr[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    obj["img"]!,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    obj["title"]!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    obj["subtitle"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  )
                ],
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectPage < pageArr.length - 1)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectPage = pageArr.length - 1;
                        controller.jumpToPage(selectPage);
                      });
                    },
                    child: const Text("Skip"),
                  ),
                if (selectPage < pageArr.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectPage += 1;
                        controller.animateToPage(
                          selectPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      });
                    },
                    child: const Text("Next"),
                  )
                else
                  const SizedBox(), // Empty widget to keep alignment
                if (selectPage == pageArr.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text("Next"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}