import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin pluginNotifikasi =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings pengaturanAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings pengaturanAwal = InitializationSettings(
    android: pengaturanAndroid,
  );

  await pluginNotifikasi.initialize(settings: pengaturanAwal);

  runApp(
    const MaterialApp(
      home: HalamanNotifikasi(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HalamanNotifikasi extends StatefulWidget {
  const HalamanNotifikasi({super.key});

  @override
  State<HalamanNotifikasi> createState() => _HalamanNotifikasiState();
}

class _HalamanNotifikasiState extends State<HalamanNotifikasi> {
  @override
  void initState() {
    super.initState();
    _mintaIzinNotifikasi();
  }

  void _mintaIzinNotifikasi() {
    pluginNotifikasi
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // Fungsi utama untuk memunculkan notifikasi
  Future<void> _buatNotifikasiWaktu() async {
    // Ambil waktu saat ini
    final DateTime sekarang = DateTime.now();

    final String jam = sekarang.hour.toString().padLeft(2, '0');
    final String menit = sekarang.minute.toString().padLeft(2, '0');
    final String detik = sekarang.second.toString().padLeft(2, '0');
    final String waktuDitekan = "$jam:$menit:$detik";

    const AndroidNotificationDetails detailAndroid = AndroidNotificationDetails(
      'channel_waktu',
      'Notifikasi Tombol',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails detailNotifikasi = NotificationDetails(
      android: detailAndroid,
    );

    await pluginNotifikasi.show(
      id: 0,
      title: 'Informasi Sistem',
      body: 'Anda menekan tombol pada waktu $waktuDitekan',
      notificationDetails: detailNotifikasi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi Waktu'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text(
          'Silakan tekan tombol di sudut kanan bawah.',
          style: TextStyle(fontSize: 16),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _buatNotifikasiWaktu,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.notifications_active),
      ),
    );
  }
}
