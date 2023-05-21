import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhirtpm_123200129/model/list_resep.dart';
import 'package:tugasakhirtpm_123200129/service/base_network.dart';
import 'package:tugasakhirtpm_123200129/view/profile_page.dart';
import 'package:tugasakhirtpm_123200129/view/resep_detail.dart';
import 'package:tugasakhirtpm_123200129/view/saran_kesan_page.dart';
import 'list_resep.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<ListResep> list_resep;
  bool _isLoading = true;

  late SharedPreferences data;
  late String username;

  @override
  void initState() {
    super.initState();
    getResep();
    initial();
  }

  void initial() async {
    data = await SharedPreferences.getInstance();
    setState(() {
      username = data.getString("username")!;
    });
  }

  Future<void> getResep() async {
    list_resep = await BaseNetwork.getResep();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Resep Masakan"),
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
          } else if (value == 2) {
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
                      Navigator.push(context,
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list_resep.length,
              itemBuilder: (context, index) {
                final Price price = PriceList[index];
                return GestureDetector(
                  child: ListResepCard(
                      title: list_resep[index].name,
                      time: list_resep[index].totalTime,
                      thumbnail: list_resep[index].thumbnail,
                      videoUrl: list_resep[index].videoUrl),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailResep(
                          name: list_resep[index].name,
                          totalTime: list_resep[index].totalTime.toString(),
                          thumbnail: list_resep[index].thumbnail,
                          description: list_resep[index].description,
                          videoUrl: list_resep[index].videoUrl,
                          instructions: list_resep[index].instructions,
                          sections: list_resep[index].sections,
                          price: price.harga.toString(),
                        ),
                      ),
                    )
                  },
                );
              },
            ),
    );
  }
}
