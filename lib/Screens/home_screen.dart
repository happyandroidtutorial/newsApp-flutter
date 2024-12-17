import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Models/categories_news_model.dart';
import 'package:news_app/Models/news_headlines_model.dart';
import 'package:news_app/Screens/category_screen.dart';
import 'package:news_app/Screens/news_detail_screen.dart';
import 'package:news_app/view_model/news_viewmodel.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewmodel newsViewmodel = NewsViewmodel();

  String? selectedMenu;
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 20,
            width: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton(
              initialValue: selectedMenu,
              onSelected: (item) {
                if ('bbcNews' == item) {
                  name = 'bbc-news';
                } else if ('aryNews' == item) {
                  name = 'ary-news';
                } else if ('cnn' == item) {
                  name = 'cnn';
                } else if ('aljazeera' == item) {
                  name = 'al-jazeera-english';
                } else if ('news24' == item) {
                  name = 'news24';
                }

                setState(() {
                  selectedMenu = name;
                });
              },
              itemBuilder: (context) => <PopupMenuEntry>[
                    PopupMenuItem(value: 'bbcNews', child: Text('BBC News')),
                    PopupMenuItem(value: 'aryNews', child: Text('ARY News')),
                    PopupMenuItem(value: 'cnn', child: Text('CNN News')),
                    PopupMenuItem(
                        value: 'aljazeera', child: Text('Al-Jazzeera')),
                    PopupMenuItem(value: 'news24', child: Text('news24')),
                  ])
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsHeadlinesModel>(
                future: newsViewmodel.fetchNewseadlinesApi(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitChasingDots(
                        color: Colors.grey,
                        size: 30,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          // get date time String
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewsDetailScreen(articles: snapshot
                              .data!.articles![index])));
                            },
                            child: Container(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: width * .9,
                                    height: height * .55,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: height * .02),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            child: SpinKitFadingCircle(
                                              color: Colors.amber,
                                              size: 50,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        height: height * .2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: width * .7,
                                                child: Text(
                                                  snapshot.data!
                                                      .articles![index].title
                                                      .toString(),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                width: width * .7,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source!
                                                          .name
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                    Text(getDateTime(dateTime),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewmodel.fetchNewsCategoriesApi('general'),
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
                        shrinkWrap: true,
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
