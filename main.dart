import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(Newsapp());

class News {
  final String title;
  final String urlToImage;

  News({
    required this.title,
    required this.urlToImage,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
    );
  }
}

class Newsapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: NewsHomePage(),
    );
  }
}

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  String apiKey = '3aa59ecf4f39418cac23c5b5403b31b0';
  List<News> articles = [];
  List<News> breakingNews = [];
  String selectedCategory = 'All';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBreakingNews();
    fetchNews(selectedCategory);
  }

  Future<void> fetchBreakingNews() async {
    String url = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey&pageSize=3';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            breakingNews = (data['articles'] as List)
                .map((article) => News.fromJson(article))
                .toList();
          });
        } else {
          throw Exception('Failed to load breaking news');
        }
      } else {
        throw Exception('Failed to load breaking news');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchNews(String category) async {
    String url = 'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          setState(() {
            articles = (data['articles'] as List)
                .map((article) => News.fromJson(article))
                .toList();
          });
        } else {
          throw Exception('Failed to load news');
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ANUTUN"),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w900, color: Colors.green),
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NewsSearchDelegate());
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Implement notification functionality
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: breakingNews.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetails(news: breakingNews[index]),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            breakingNews[index].urlToImage,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.6),
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              breakingNews[index].title,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          // Rest of your code remains unchanged
          // Add your Row with ElevatedButtons here
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
           
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'sports';
                  });
                  fetchNews(selectedCategory);
                },
                child: Text('Sports'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'general';
                  });
                  fetchNews(selectedCategory);
                },
                child: Text('General'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = 'politics';
                  });
                  fetchNews(selectedCategory);
                },
                child: Text('Politics'),
              ),

            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetails(news: articles[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          articles[index].urlToImage.isNotEmpty
                              ? Image.network(
                                  articles[index].urlToImage,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              articles[index].title,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 90,
        shape: CircularNotchedRectangle(
          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    // Navigate to home page
                  },
                ),
                Text(
                  'Home',
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    // Navigate to bookmark page
                  },
                ),
                Text(
                  'Bookmark',
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to settings page
                  },
                ),
                Text(
                  'Settings',
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.discord),
                  onPressed: () {
                    // Navigate to settings page
                  },
                ),
                Text(
                  'Discord',
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
  
      );
      // Add your BottomAppBar here
    
  }
}

class NewsDetails extends StatelessWidget {
  final News news;

  NewsDetails({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Details',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                news.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (news.urlToImage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  news.urlToImage,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
