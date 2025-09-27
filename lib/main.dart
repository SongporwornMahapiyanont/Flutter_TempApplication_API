import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Air Quality App',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> observationData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.waqi.info/feed/@5773/?token=9a891c5fc7419a37e5d0ac8a200ded512ce6f729',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          observationData = {
            "Index": data['data']['aqi']?.toString() ?? "N/A",
            "Temperature": data['data']['iaqi']['t']?['v']?.toString() ?? "N/A",
            "Humidity": data['data']['iaqi']['h']?['v']?.toString() ?? "N/A",
            "Wind Speed": data['data']['iaqi']['w']?['v']?.toString() ?? "N/A",
            "Pressure": data['data']['iaqi']['p']?['v']?.toString() ?? "N/A",
            "Rain": data['data']['iaqi']['r']?['v']?.toString() ?? "N/A",
            "CO": data['data']['iaqi']['co']?['v']?.toString() ?? "N/A",
            "NO₂": data['data']['iaqi']['no2']?['v']?.toString() ?? "N/A",
            "O₃": data['data']['iaqi']['o3']?['v']?.toString() ?? "N/A",
            "SO₂": data['data']['iaqi']['so2']?['v']?.toString() ?? "N/A",
            "PM10": data['data']['iaqi']['pm10']?['v']?.toString() ?? "N/A",
            "PM2.5": data['data']['iaqi']['pm25']?['v']?.toString() ?? "N/A",
            "Dominant Pollutant":
                data['data']['dominentpol']?.toString() ?? "N/A",
            "City": data['data']['city']?['name']?.toString() ?? "N/A",
            "Latitude": data['data']['city']?['geo']?[0]?.toString() ?? "N/A",
            "Longitude": data['data']['city']?['geo']?[1]?.toString() ?? "N/A",
            "Time": data['data']['time']?['s']?.toString() ?? "N/A",
          };
        });
      } else {
        print('Status : ${response.statusCode}');
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  /// กล่องเล็กสำหรับแสดงค่า Observation
  Widget observationBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.blueGrey[700]),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Color(0xFF7F8C8D)),
          ),
        ],
      ),
    );
  }

  /// ฟังก์ชันบอกระดับ AQI (ห้ามแก้สี)
  Map<String, dynamic> getAqiInfo(int aqi) {
    if (aqi <= 50) {
      return {"color": Colors.green, "level": "Good - ดี"};
    } else if (aqi <= 100) {
      return {"color": Colors.yellow, "level": "Moderate - ปานกลาง"};
    } else if (aqi <= 150) {
      return {
        "color": Colors.orange,
        "level": "Unhealthy for Sensitive Groups - ไม่ดีต่อกลุ่มเสี่ยง",
      };
    } else if (aqi <= 200) {
      return {"color": Colors.pink.shade400, "level": "Unhealthy - ไม่ดี"};
    } else if (aqi <= 300) {
      return {"color": Colors.purple, "level": "Very Unhealthy - แย่มาก"};
    } else {
      return {"color": Colors.red.shade900, "level": "Hazardous - อันตราย"};
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("By Songporworn Mahapiyaont"),
        backgroundColor: const Color.fromARGB(255, 155, 198, 228),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7FAEDB), // ฟ้าอ่อนด้านบน
              Color(0xFF95C0E0), // ฟ้าอ่อนกลาง
              Color(0xFFADD4E6), // ฟ้าอ่อนขึ้นอีก
              Color(0xFFC5E2EB), // ฟ้าอ่อนใกล้ล่าง
              Color(0xFFE0F0F5), // ฟ้าอ่อนสุดด้านล่าง
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ไอคอน Location + ชื่อเมือง
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.redAccent,
                          size: 35,
                        ),
                      ),
                      TextSpan(
                        text: ' ${observationData['City'] ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  '(Time : ${observationData['Time'] ?? ''})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF34495E),
                  ),
                ),

                const SizedBox(height: 20),

                // ปุ่ม Reset
                // ปุ่ม Reset พร้อม SnackBar
                ElevatedButton.icon(
                  onPressed: () async {
                    await fetchData(); // รีโหลดข้อมูลจาก API
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Updated Success - ข้อมูลถูกรีโหลดเรียบร้อย',
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.blueAccent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Current AQI Big Box
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 50,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(6, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${observationData['Index']}' ?? 'N/A',
                        style: TextStyle(
                          fontSize: 150,
                          fontWeight: FontWeight.bold,
                          color:
                              getAqiInfo(
                                    int.tryParse(
                                          observationData['Index'] ?? '0',
                                        ) ??
                                        0,
                                  )['color']
                                  as Color?,
                          shadows: [
                            Shadow(
                              offset: const Offset(6, 8),
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "µg/m³ - Air Quality Index ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        getAqiInfo(
                              int.tryParse(observationData['Index'] ?? '0') ??
                                  0,
                            )['level']?.toString() ??
                            'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: getAqiInfo(
                            int.tryParse(observationData['Index'] ?? '0') ?? 0,
                          )['color'],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Observation Small Boxes
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                      minWidth: 200,
                    ),
                    child: Container(
                      width: screenWidth * 0.9,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(8, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Current Observation",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              observationBox(
                                "Temperature",
                                "${observationData['Temperature']} °C",
                                Icons.thermostat,
                              ),
                              observationBox(
                                "Humidity",
                                "${observationData['Humidity']} %",
                                Icons.water_drop,
                              ),
                              observationBox(
                                "Wind Speed",
                                "${observationData['Wind Speed']} m/s",
                                Icons.air,
                              ),
                              observationBox(
                                "Pressure",
                                "${observationData['Pressure']} hPa",
                                Icons.speed,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
