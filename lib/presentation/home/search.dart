import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echonest/presentation/colors/contantColors.dart';
import 'package:echonest/presentation/login/widgets/search_tile.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late String searchName;
  late Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream;

  @override
  void initState() {
    super.initState();
    searchName = "";
    _updateUsersStream();
  }

  void _updateUsersStream() {
    _usersStream = FirebaseFirestore.instance
        .collection('Users-collection')
        .orderBy("email")
        .startAt([searchName]).endAt(["$searchName\uf8ff"])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: loginPagetextcolor,
        title: 
          const Text(
            "Contacts",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
       
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: SizedBox(
              height: 40,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchName = value;
                    _updateUsersStream();
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _usersStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No data"));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SearchPageTile(
                          imageUrl: post["profilepic"] == ""
                              ? "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg&ga=GA1.1.508103245.1699588812&semt=ais"
                              : post["profilepic"],
                          user: post["username"],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
