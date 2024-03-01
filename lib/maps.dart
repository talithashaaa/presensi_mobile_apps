import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile_apps/controller/maps_controller.dart';
import 'package:presensi_mobile_apps/model/maps_model.dart';
import 'package:presensi_mobile_apps/services/maps_services.dart';

import 'package:presensi_mobile_apps/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: MapsPage(),
    );
  }
}

class MapsPage extends StatefulWidget {
  MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController googleMapController;
  // GlobalKey<ScaffoldState> _scaffoldKEy = GlobalKey<ScaffoldState>();
  String realtimeClock = '00:00:00';
  String realtimeDate = 'Hari, Tanggal Bulan Tahun';

  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(-6.966667, 110.416664), zoom: 14);
  Set<Marker> markers = {};

  String _address = ''; // Store the retrieved address
  TextEditingController _noteController = TextEditingController();
  EntryController _entryController = EntryController();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          realtimeClock = parseTime(
            rawDateTime: DateTime.now(),
          );
          realtimeDate = parseDate(
            rawDateTime: DateTime.now(),
          );
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "Token not found";
      // // checkGetProfile();
      // final String uid = await getUid();

      // profileController.fetchProfile(token);
      // statisticController.fetchStatistic(token);
    });
  }

  String parseTime({required DateTime rawDateTime}) {
    String hour = rawDateTime.hour.toString().padLeft(2, '0');
    String minute = rawDateTime.minute.toString().padLeft(2, '0');
    String second = rawDateTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String parseDate({required DateTime rawDateTime}) {
    String locale = "id_ID";
    // print("Raw DateTime: $rawDateTime");

    return DateFormat("EEE, dd MMMM yyyy", locale).format(rawDateTime);
  }

  void _handleAbsensiMasuk() async {
    try {
      Position position = await _determinePosition();
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18,
          ),
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = _buildCompleteAddress(placemarks);

      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );

      setState(() {
        _address = address;
      });

      String currentTime = parseTime(rawDateTime: DateTime.now());
      String status =
          currentTime.compareTo('10:00:00') > 0 ? 'Terlambat' : 'Tepat Waktu';

      Entry entry = Entry(
        day: DateFormat('EEEE').format(DateTime.now()),
        date: DateTime.now().day,
        month: DateTime.now().month,
        year: DateTime.now().year,
        time: parseTime(rawDateTime: DateTime.now()),
        latitude: position.latitude,
        longitude: position.longitude,
        status: status,
        entryNote: _noteController.text,
      );

      print('Entry Details:');
      print('Day: ${entry.day}');
      print('Date: ${entry.date}');
      print('Month: ${entry.month}');
      print('Year: ${entry.year}');
      print('Time: ${entry.time}');
      print('Latitude: ${entry.latitude}');
      print('Longitude: ${entry.longitude}');
      print('Status: ${entry.status}');
      print('Entry Note: ${entry.entryNote}');

      _entryController.postEntry(entry);
      setState(() {
        _absensiSuccess = true;
        _absensiMessage = 'Presensi berhasil!';
      });

      // Redirect to RealtimeClock after successful absensi
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RealtimeClock()),
        );
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _absensiSuccess = false;
        _absensiMessage = 'Presensi gagal, coba lagi';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double circleWidth = 1423;
    double circleHeight = 1423;
    double circleTop = 479;
    double circleLeft = -517;

    double rectangleWidth = 360;
    double rectangleHeight = 413;
    double rectangleTop = 435;
    double rectangleLeft =
        (MediaQuery.of(context).size.width - rectangleWidth) / 2;
    return Scaffold(
      // key: _scaffoldKEy,
      body: Stack(
        children: [
          GoogleMap(
            // mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0, left: 30), // Atur ruang di atas tombol
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RealtimeClock()),
                    );
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50.0, right: 30), // Atur ruang di atas tombol
                child: FloatingActionButton(
                  onPressed: () async {
                    Position position = await _determinePosition();
                    googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          zoom: 18,
                        ),
                      ),
                    );

                    // Retrieve address
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      position.latitude,
                      position.longitude,
                    );

                    String address = _buildCompleteAddress(placemarks);

                    markers.clear();
                    markers.add(
                      Marker(
                        markerId: MarkerId('currentLocation'),
                        position: LatLng(position.latitude, position.longitude),
                        icon: BitmapDescriptor.defaultMarker,
                      ),
                    );

                    // Update state to display the address
                    setState(() {
                      _address = address;
                    });
                  },
                  child: Icon(Icons.location_history),
                ),
              ),
            ],
          ),
          Positioned(
            top: circleTop,
            left: circleLeft,
            child: Container(
              width: circleWidth,
              height: circleHeight,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffC9002B),
              ),
            ),
          ),
          Positioned(
            top: rectangleTop,
            left: rectangleLeft,
            child: Container(
              width: rectangleWidth,
              height: rectangleHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xff004B93),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            realtimeDate,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xff004B93),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            realtimeClock,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xff004B93),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        // SizedBox(height: 10),
                        Text(
                          'Lokasi Saya',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _address,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Note (Opsional)', // Align this text to the left
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _noteController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle:
                                  const TextStyle(color: Colors.blueGrey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(height: 10),
                        // SizedBox(
                        //   height: 45,
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //       hintStyle:
                        //           const TextStyle(color: Colors.blueGrey),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(5),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),

                        // LOGIN Button
                        SizedBox(
                          width: 320,
                          height: 47,
                          child: ElevatedButton(
                            onPressed: () {
                              _handleAbsensiMasuk();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff004B93),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              'ABSENSI MASUK',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Positioned(
                          child: Center(
                            child: Text(
                              _absensiMessage ??
                                  '', // Display the success or failure message
                              style: TextStyle(
                                color:
                                    _absensiSuccess ? Colors.green : Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _absensiMessage;
  bool _absensiSuccess = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi mati');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Layanan Lokasi ditolak");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Layanan lokasi ditolak secara permanen");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  String _buildCompleteAddress(List<Placemark> placemarks) {
    if (placemarks.isEmpty) {
      return 'No address available';
    }

    Placemark placemark = placemarks[0];

    String address =
        '${placemark.street ?? ''}, ${placemark.subLocality ?? ''}, '
        '${placemark.locality ?? ''}, ${placemark.subAdministrativeArea ?? ''}, '
        '${placemark.administrativeArea ?? ''} ${placemark.postalCode ?? ''}';

    // Add the establishment name if available
    String establishmentName = placemark.name ?? '';
    if (establishmentName.isNotEmpty) {
      address += ' ($establishmentName)';
    }

    return address.trim();
  }
}
