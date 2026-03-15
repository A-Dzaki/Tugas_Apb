import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Layout part 1',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Demo Layout part 1'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            "1202230026 - Ahmad Dzaki Zayyan Sugianto",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 0, 75, 250),
            ),
          ),

          const SizedBox(height: 10),

          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              'assets/Desain tanpa judul (10) - Copy.jpg',
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4839EB), Color(0xFF7367F0)],
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(height: 20),

                Text(
                  'Status tes TOEFL Anda:',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),

                SizedBox(height: 8),

                Text(
                  'LULUS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.25,
                  ),
                ),

                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Listening\n80',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),

                      Text(
                        'Structure\n80',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),

                      Text(
                        'Reading\n90',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),

          const Text(
            'Riwayat Tes',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.25,
            ),
          ),
        ],
      ),
    );
  }
}
