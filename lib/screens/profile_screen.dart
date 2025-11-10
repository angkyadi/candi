import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    //TODO:1 deklarasi variabel yang dibutuhkan
    bool isSignedIn = true;
    String fullName = "";
    String userName = "";
    int favoriteCandiCount =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [
                Container(
                    height: 200, width: double.infinity,color: Colors.deepPurple,
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    children: [
                        //TODO : 2. Buat bagian Profile Header
                    
                        Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                               Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.deepPurple, width: 2),
                                    shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage('images/placeholder_image.png'),
                                ),
                               ),
                               if(isSignedIn)
                                IconButton(onPressed: (){},
                                 icon: Icon(Icons.camera_alt, color: Colors.deepPurple[50],),),
                            ],
                        )
                        //TODO : 3 buat bagian Profile Info
                            
                        //TODO : 4 buat Profile Action
                    ],
                )
                ,)
            ],
        ),
    );
  }
}