import 'package:news_app/Models/categories_news_model.dart';
import 'package:news_app/Models/news_headlines_model.dart';
import 'package:news_app/Repository/news_repository.dart';

class NewsViewmodel {
  final _rep = NewsRepository();

  Future<NewsHeadlinesModel> fetchNewseadlinesApi(String sourse) async {
    final response = await _rep.fetchNewseadlinesApi(sourse);
    return response;
  }
  // fetcch category
   Future<CategoriesNewsModel> fetchNewsCategoriesApi(String category) async {
    final response = await _rep.fetchNewsCategoriesApi(category);
    return response;
  }
}
