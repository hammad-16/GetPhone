import 'package:flutter/material.dart';
import 'package:oru/utils/routes.dart';

class PreLogin extends StatefulWidget {
  const PreLogin({super.key});

  @override
  State<PreLogin> createState() => _PreLoginState();
}

class _PreLoginState extends State<PreLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF4F4F4)
      ,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(

                padding: const EdgeInsets.only(left:10,top: 20),
                child: Row(
                  children: [
                    SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0cBwtJxQ14kN_z1ua49yRZyt2qFzu4_vx8A&s")),
                    const SizedBox(width: 190),
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.clear))
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
          onPressed: () {
            try{
              Navigator.pushNamed(context, AppRoutes.login);
            }
            catch(e)
            {
              print(e);
            }

          },
          style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3E468F), // Button color
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded edges
          ),
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
          ),
          child: const Text(
          "Login/SignUp",
          style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
    ),
    ),
    ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {// Add your action here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF6C018), // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded edges
              ),
              padding: const EdgeInsets.symmetric(horizontal: 92, vertical: 15),
            ),

            child: const Text(
              "Sell Your Phone",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
