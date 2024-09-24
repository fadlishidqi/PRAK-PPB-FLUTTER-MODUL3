import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mod3_kel9/widget/appbar.dart';
import 'dart:convert';

import '../widget/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Anime>> recommendedAnime;
  late Future<List<Anime>> topAnime;
  final int _itemsPerPage = 4;
  int _currentPage = 1;
  

  @override
  void initState() {
    super.initState();
    recommendedAnime = fetchRecommendedAnime();
    topAnime = fetchTopAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('MyAnimeList',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 20.0,
          )
        ),
        backgroundColor: Colors.white
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                'Recommended Anime',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(
              height: 220,
              child: FutureBuilder<List<Anime>>(
                future: recommendedAnime,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recommendations available'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                snapshot.data![index].imageUrl,
                                width: 120,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 120,
                              child: Text(
                                snapshot.data![index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _currentPage > 1 ? () => _changePage(-1) : null,
                  ),
                  const Text(
                    'Top Anime',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  FutureBuilder<List<Anime>>(
                    future: topAnime,
                    builder: (context, snapshot) {
                      bool hasNextPage = snapshot.hasData && 
                                        (_currentPage * _itemsPerPage) < snapshot.data!.length;
                      return IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: hasNextPage ? () => _changePage(1) : null,
                      );
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Anime>>(
              future: topAnime, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } 
                else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No top anime available'));
                }

                int startIndex = (_currentPage - 1) * _itemsPerPage;
                int endIndex = startIndex + _itemsPerPage;

                if (endIndex > snapshot.data!.length) {
                  endIndex = snapshot.data!.length;
                }

                if (startIndex >= snapshot.data!.length) {
                  return const Center(child: Text('No more items to display.'));
                }

                List<Anime> pageItems = snapshot.data!.sublist(startIndex, endIndex);

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(pageItems[index].imageUrl),
                          radius: 30,
                        ),
                        title: Text(pageItems[index].title),
                        subtitle: Text('Score: ${pageItems[index].score}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: {
                              'item': pageItems[index].id,
                              'title': pageItems[index].title,
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }

  void _changePage(int delta) {
    setState(() {
      _currentPage += delta;
      if (_currentPage < 1) _currentPage = 1;
    });
  }

}

class Anime {
  final int id;
  final String title;
  final String imageUrl;
  final double score;

  Anime({required this.id, required this.title, required this.imageUrl, required this.score});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'],
      imageUrl: json['images']['jpg']['image_url'],
      score: json['score'] != null ? json['score'].toDouble() : 0.0,
    );
  }
}

Future<List<Anime>> fetchRecommendedAnime() async {
  final response = await http.get(Uri.parse('https://api.jikan.moe/v4/recommendations/anime'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['data'];
    List<Anime> recommendations = [];
    for (var item in jsonResponse) {
      if (item['entry'] != null && item['entry'].isNotEmpty) {
        recommendations.add(Anime.fromJson(item['entry'][0]));
      }
    }
    return recommendations;
  } else {
    throw Exception('Failed to load recommended anime');
  }
}

Future<List<Anime>> fetchTopAnime() async {
  final response = await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['data'];
    return jsonResponse.map((item) => Anime.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load top anime');
  }
}

