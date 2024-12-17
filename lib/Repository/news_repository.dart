import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/Models/categories_news_model.dart';
import 'package:news_app/Models/news_headlines_model.dart';

class NewsRepository {
  Future<NewsHeadlinesModel> fetchNewseadlinesApi(String source) async {
    // bbc-news
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$source&apiKey=c6f5e58664474adea61533b22829b273';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsHeadlinesModel.fromJson(body);
    }
    throw (e) {
      print(e.toString());
    };
  }

// category fetch
  Future<CategoriesNewsModel> fetchNewsCategoriesApi(String category) async {
    //
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=c6f5e58664474adea61533b22829b273';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw (e) {
      print(e.toString());
    };
  }
}
