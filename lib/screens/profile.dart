import 'package:flutter/material.dart';
import 'package:mod3_kel9/widget/navigation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MyAnimeList',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
            )
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              _buildTabBar(),
              const SizedBox(height: 20),
              _buildInfoList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/seputipy.appspot.com/o/covers%2Fanimek.jpg?alt=media'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kelompok 9',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                  ),
              ),
              const Text(
                '@praktikumppb',
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey
                  ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8
                    ),
                ),
                child: const Text('Edit profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Center(child: Text('General', style: TextStyle(fontWeight: FontWeight.bold))),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Center(child: Text('List Anime', style: TextStyle(color: Colors.grey))),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoList() {
    return Column(
      children: [
        _buildInfoTile('Anggota 1', 'Fadli Shidqi Firdaus', Icons.person),
        _buildInfoTile('Anggota 2', 'Mutiara Sabrina R', Icons.person),
        _buildInfoTile('Anggota 3', 'Aditiya Putra A', Icons.person),
        _buildInfoTile('Anggota 4', 'Rizky Ananta', Icons.person),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon, {bool showDropdown = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          if (showDropdown) const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }
}