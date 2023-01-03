import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/common/providers/common_provider.dart';
import 'package:share_picture/common/screens/user_screen.dart';
import 'package:share_picture/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Container(
          alignment: Alignment.center,
          height: 50,
          width: double.infinity * 0.95,
          child: TextField(
            autofocus: false,
            controller: searchController,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 20),
                border: OutlineInputBorder(),
                hintText: 'search',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                )),
            onChanged: (value) {
              Provider.of<CommonProvider>(context, listen: false)
                  .search(searchKey: value);
            },
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            Provider.of<CommonProvider>(context, listen: false).searchStream(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text('No Search'),
            );
          } else {
            if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? const Center(
                      child: Text('No user found'),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ProfileScreen.profileScreen,
                                arguments: snapshot.data![index].uid);
                          },
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data![index].profilePhoto),
                              radius: 16),
                          title: Text(snapshot.data![index].username,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      }));
            } else {
              return const Text('no user found');
            }
          }
        }),
      ),
    );
  }
}
