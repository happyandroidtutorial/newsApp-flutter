import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Models/categories_news_model.dart';
import 'package:news_app/Screens/news_detail_screen.dart';
import 'package:news_app/view_model/news_viewmodel.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  NewsViewmodel newsViewmodel = NewsViewmodel();
  String category = 'General';
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    print('Build called  ${newsViewmodel.fetchNewsCategoriesApi(category)}');
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      category = categoriesList[index].toString();
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Chip(
                          label: Text(
                        categoriesList[index].toString(),
                        style: GoogleFonts.poppins(
                            color: category == categoriesList[index].toString()
                                ? Colors.blueAccent
                                : Colors.grey),
                      )),
                    ),
                  );
                }),
          ),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewmodel.fetchNewsCategoriesApi(category),
                builder: (context, snapshot) {
                  print('futureBuilder called  ${snapshot.data}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitChasingDots(
                        color: Colors.grey,
                        size: 30,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          // get date time String
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: (){
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewsDetailScreen(articles: snapshot
                              .data!.articles![index])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      height: height * .22,
                                      width: width * .3,
                                      placeholder: (context, url) => Container(
                                        child: SpinKitFadingCircle(
                                          color: Colors.amber,
                                          size: 50,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: height * .22,
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data!.articles![index]
                                                      .source!.name
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.blue),
                                                ),
                                                Text(getDateTime(dateTime),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}

String getDateTime(DateTime timeStamp) {
  String formattedDate = DateFormat('dd MMMM yyyy').format(timeStamp);
  return formattedDate;
}
