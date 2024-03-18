import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webscokets_pusker_issue/text_widgets.dart';
import 'package:webscokets_pusker_issue/user_provider.dart';
import 'colors.dart';
import 'messging_screen.dart';

class ChatScreenAllUsers extends StatefulWidget {
  @override
  State<ChatScreenAllUsers> createState() => _ChatScreenAllUsersState();
}

class _ChatScreenAllUsersState extends State<ChatScreenAllUsers> {
  late Future<void> _refreshFuture;

  @override
  void initState() {
    super.initState();
    _refreshFuture = _fetchuserInfo();
  }

  Future<void> _fetchuserInfo() async {
    try {
      print('Fetching User Information Screen...');
      await Provider.of<UserInformationProvider>(context, listen: false)
          .getUsersInformation();
      print('User Information  fetched successfully.');
      setState(() {});
    } catch (error) {
      print('Error fetching user informations exercises: $error');
    }
  }

  Future<void> _onRefresh() async {
    await _fetchuserInfo();
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserInformationProvider>(context);

    // Call the function to fetch user information
    // userProvider.getUsersInformation();

    // Now you can access the user information from the provider
    final List<UserModel> usersInformation = userProvider.usersInformation;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: largeText(title: 'Chats'),
      ),
      body: Consumer<UserInformationProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: provider.usersInformation.isEmpty
                        ? Container(
                      child: Center(
                        child: Container(height: 50,width: 50,),
                      ),
                    )
                        : SizedBox.shrink(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index){
                        final UserModel user = usersInformation[index];
                        if (usersInformation.isNotEmpty) {
                          return Container(
                            margin: const EdgeInsets.only(top: 10,left: 8,right: 8),
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, CupertinoPageRoute(builder: (context)=> MessagingScreen(
                                  userId: user.userId.toString(),
                                  userName: user.name,
                                )));
                              },
                              contentPadding:const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: listTileColor,
                              leading:const Icon(Icons.person,color: buttonColors,),
                              title: normalText(title: user.name.toUpperCase(),),
                              trailing: smallText(title: user.userId.toString()),
                            ),
                          );
                        } else {
                          return Center(
                            child: largeText(title: 'Please check internet'),
                          );
                        }
                      },
                      childCount: usersInformation.length,
                    ),

                  ),
                ],
              ));
        },
      ),
    );
  }
}
