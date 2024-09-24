import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailPage extends StatefulWidget {
  final int item;
  final String title;

  const DetailPage({super.key, required this.item, required this.title});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<AnimeDetail> animeDetail;

  @override
  void initState() {
    super.initState();
    animeDetail = fetchAnimeDetail(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<AnimeDetail>(
        future: animeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          AnimeDetail detail = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(detail.imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detail.title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('Score: ${detail.score}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Broadcast: ${detail.broadcast}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Text(detail.synopsis, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AnimeDetail {
  final String title;
  final String imageUrl;
  final double score;
  final String broadcast;
  final String synopsis;

  AnimeDetail({
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.broadcast,
    required this.synopsis,
  });

  factory AnimeDetail.fromJson(Map<String, dynamic> json) {
    return AnimeDetail(
      title: json['title'],
      imageUrl: json['images']['jpg']['large_image_url'],
      score: json['score'] != null ? json['score'].toDouble() : 0.0,
      broadcast: json['broadcast']['string'] ?? 'Unknown',
      synopsis: json['synopsis'] ?? 'No synopsis available.',
    );
  }
}

Future<AnimeDetail> fetchAnimeDetail(int id) async {
  final response = await http.get(Uri.parse('https://api.jikan.moe/v4/anime/$id'));

  if (response.statusCode == 200) {
    return AnimeDetail.fromJson(json.decode(response.body)['data']);
  } else {
    throw Exception('Failed to load anime details');
  }
}