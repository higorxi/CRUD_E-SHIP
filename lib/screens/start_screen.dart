import 'package:crud_e_ship/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe4e2dd), 
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/image1.png'),
                  fit: BoxFit.scaleDown, 
                ),
              ),
              alignment: Alignment.center,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 440),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffdb4a2b), 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainScreen()),
                          );
                        },
                        child: const Text(
                          'Iniciar',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
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
}
