import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_pbp/client/UserClient.dart';
import 'package:news_pbp/entity/user.dart';
import 'package:news_pbp/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MembershipPage extends StatefulWidget {
  const MembershipPage({super.key});

  @override
  State<MembershipPage> createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  final _formKey = GlobalKey<FormState>();
  var id = 0;
  bool isLoading = false;

  TextEditingController uangController = TextEditingController();

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    User user = await UserClient.find(prefs.getInt('userId'));
    setState(() {
      id = user.id!;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadUserData();
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informasi Pembayaran"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showBottomGold() {
    setState(() {
      uangController.text = '';
    });
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: 7.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(122, 149, 229, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 12.0,
                ),
                width: 400,
                height: 373.5,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(158, 180, 244, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 78,
                          height: 75,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/gold.png'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Gold\nMembership",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 3.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                              ),
                              padding: const EdgeInsets.only(top: 3),
                              width: 120,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(122, 149, 229, 1),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                "MEMBERSHIP 1 YEAR",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Rp. 250.000, 00",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 60),
                      child: const Text(
                        "Masukkan Uang Yang Pas",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                        left: 10.0,
                        bottom: 10.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: uangController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Uang Sesuai Nominal',
                            hintStyle: TextStyle(fontSize: 15),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () async {
                          String inputUang = uangController.text;
                          double nominalUang =
                              double.tryParse(inputUang) ?? 0.0;
                          double nominalExpectation = 250000.0;

                          if (nominalUang == nominalExpectation) {
                            await editUser(id, "Gold");
                            Navigator.pop(context);
                            Navigator.pop(context);
                            _showAlertDialog("Terimakasih telah membayar");
                          } else if (nominalUang < nominalExpectation) {
                            _showAlertDialog(
                                "Uang kurang. Mohon periksa kembali nominal pembayaran.");
                          } else {
                            _showAlertDialog(
                                "Uang kelebihan. Mohon periksa kembali nominal pembayaran.");
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(255, 198, 178, 1),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(
                                color: Color.fromRGBO(247, 111, 63, 1),
                              ),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 45.0),
                          ),
                        ),
                        child: const Text(
                          "Bayar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
      },
    );
  }

  void _showBottomPlat() {
    setState(() {
      uangController.text = '';
    });
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: 7.0,
                  width: 60.0,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(122, 149, 229, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 12.0,
                ),
                width: 400,
                height: 373.5,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(158, 180, 244, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 78,
                          height: 75,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/plat.png'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Plat\nMembership",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 3.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                              ),
                              padding: const EdgeInsets.only(top: 3),
                              width: 150,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(122, 149, 229, 1),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                "MEMBERSHIP 1 MONTH",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Rp. 150.000, 00",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 60),
                      child: const Text(
                        "Masukkan Uang Yang Pas",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                        left: 10.0,
                        bottom: 10.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: uangController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Uang Sesuai Nominal',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () async {
                          String inputUang = uangController.text;
                          double nominalUang =
                              double.tryParse(inputUang) ?? 0.0;
                          double nominalExpectation = 150000.0;

                          if (nominalUang == nominalExpectation) {
                            await editUser(id, "Platinum");
                            Navigator.pop(context);
                            Navigator.pop(context);
                            _showAlertDialog("Terimakasih telah membayar");
                          } else if (nominalUang < nominalExpectation) {
                            _showAlertDialog(
                                "Uang kurang. Mohon periksa kembali nominal pembayaran.");
                          } else {
                            _showAlertDialog(
                                "Uang kelebihan. Mohon periksa kembali nominal pembayaran.");
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(188, 188, 188, 1),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(
                                color: Color.fromRGBO(125, 125, 125, 1),
                              ),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 45.0),
                          ),
                        ),
                        child: const Text(
                          "Bayar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(122, 149, 229, 1),
      ),
      backgroundColor: const Color.fromRGBO(122, 149, 229, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                width: 500,
                child: Text(
                  "Pilihan Paket\nMembership",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const SizedBox(
                width: 500,
                child: Text(
                  "Select a Membership Option",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                width: 500,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21.0),
                  color: const Color.fromRGBO(158, 180, 244, 1),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 280,
                      child: Row(
                        children: [
                          Container(
                            width: 78,
                            height: 75,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/gold.png'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Column(
                            children: [
                              const Text(
                                "Gold\nMembership",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 3.0,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10,
                                ),
                                padding: const EdgeInsets.only(top: 3),
                                width: 120,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(122, 149, 229, 1),
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Text(
                                  "MEMBERSHIP 1 YEAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0),
                      width: 400,
                      child: const Text(
                        "Description & Price",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: const Text(
                        "Bergabunglah dengan membership Tria News, Benefit yang akan kalian dapatkan berupa pemberian berita ekslusif selama 1 tahun seputar mancanegara seperti Investigasi, dan konten yang premium. Ditunggu apalagi bergabunglah dengan kami Tria News tempatnya baca berita real no hoax.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      alignment: Alignment.center,
                      child: Container(
                        width: 280,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rp. 250.000,00",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 25,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showBottomGold();
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(255, 198, 178, 1),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(247, 111, 63, 1),
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Bayar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
              const SizedBox(
                height: 14.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                width: 500,
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.0),
                    color: const Color.fromRGBO(158, 180, 244, 1)),
                child: Column(
                  children: [
                    SizedBox(
                      width: 280,
                      child: Row(
                        children: [
                          Container(
                            width: 78,
                            height: 75,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/plat.png'),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Column(
                            children: [
                              const Text(
                                "Platinum\nMembership",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 3.0,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10,
                                ),
                                padding: const EdgeInsets.only(top: 3),
                                width: 150,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(122, 149, 229, 1),
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Text(
                                  "MEMBERSHIP 1 MONTH",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0),
                      width: 400,
                      child: const Text(
                        "Description & Price",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: const Text(
                        "Bergabunglah dengan membership Tria News, Benefit yang akan kalian dapatkan berupa pemberian berita ekslusif selama 1 bulan seputar mancanegara seperti Investigasi, dan konten yang premium. Ditunggu apalagi bergabunglah dengan kami Tria News tempatnya baca berita real no hoax.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      alignment: Alignment.center,
                      child: Container(
                        width: 280,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rp. 150.000,00",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 25,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                _showBottomPlat();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(188, 188, 188, 1),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(125, 125, 125, 1),
                                    ),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Bayar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editUser(int id, String membership) async {
    User user = await UserClient.find(id);
    setState(() {
      user.membership = membership;
    });

    await UserClient.update(user);
  }
}
