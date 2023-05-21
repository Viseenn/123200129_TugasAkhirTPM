import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhirtpm_123200129/model/list_resep.dart';
import 'package:tugasakhirtpm_123200129/view/profile_page.dart';
import 'package:tugasakhirtpm_123200129/view/saran_kesan_page.dart';
import 'list_resep.dart';
import 'login_page.dart';

class DetailResep extends StatefulWidget {
  final String name;
  final String thumbnail;
  final String totalTime;
  final String description;
  final String videoUrl;
  final List<Instruction> instructions;
  final List<Section> sections;
  final String price;

  DetailResep({
    required this.name,
    required this.thumbnail,
    required this.totalTime,
    required this.description,
    required this.videoUrl,
    required this.instructions,
    required this.sections,
    required this.price,
  });

  @override
  _DetailResepState createState() => _DetailResepState();
}

class _DetailResepState extends State<DetailResep> {
  late SharedPreferences data;
  List<Component> components = [];
  String mataUang = 'IDR';
  int _currentIndex = 0;

  Map<String, double> exchangeRates = {
    'USD': 0.0000671908, // Kurs pertukaran IDR ke USD
    'EUR': 0.000062088, // Kurs pertukaran IDR ke EUR
    'IDR': 1.0, // Kurs pertukaran IDR ke IDR (1 IDR = 1 IDR)
    'GBP': 0.000053983, // Kurs pertukaran IDR ke GBP
    'JPY': 0.0092703, // Kurs pertukaran IDR ke JPY
  };

  double convertPriceToSelectedCurrency(double price, String mataUang) {
    double selectedRate = exchangeRates[mataUang]!;
    double convertedPrice = price * selectedRate;
    return convertedPrice;
  }

  String formatCurrency(double amount, String mataUang) {
    if (mataUang == 'IDR') {
      return 'Rp ${amount.toStringAsFixed(0)}'; // Format IDR currency
    } else {
      return '${amount.toStringAsFixed(2)} $mataUang'; // Format other currencies
    }
  }

  @override
  void initState() {
    super.initState();
    components = List.from(widget.sections[0].components);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        data = prefs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (value) {
          if (value == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          } else if (value == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SaranKesanPage()));
          } else {
            AlertDialog alert = AlertDialog(
              title: Text("Logout"),
              content: Container(
                child: Text("Apakah yakin ingin Logout?"),
              ),
              actions: [
                TextButton(
                    child: Text("Ya"),
                    onPressed: () {
                      data.setBool('login', true);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }),
                TextButton(
                    child: Text("Tidak"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
            showDialog(context: context, builder: (context) => alert);
          }
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person_outline_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Saran & Kesan'),
            icon: Icon(Icons.textsms_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Logout'),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              ListResepCard(
                title: '',
                time: widget.totalTime,
                thumbnail: widget.thumbnail,
                videoUrl: widget.videoUrl,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Price',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            formatCurrency(
                              convertPriceToSelectedCurrency(
                                double.parse(widget.price),
                                mataUang,
                              ),
                              mataUang,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(width: 300),
                          DropdownButton<String>(
                            value:
                                mataUang, // Set the initial value of the dropdown
                            onChanged: (newValue) {
                              setState(() {
                                mataUang = newValue!;
                              });
                            },
                            items: exchangeRates.keys
                                .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ingredients',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: components.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              components[index].rawText,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Instructions',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: widget.instructions.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              widget.instructions[index].displayText,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
