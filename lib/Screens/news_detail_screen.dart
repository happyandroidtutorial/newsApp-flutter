import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Models/news_headlines_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final articles;

  const NewsDetailScreen({super.key, required this.articles});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Container(
              height: height * .45,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: CachedNetworkImage(
                  imageUrl: widget.articles.urlToImage.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height * .46),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(),
              height: height * .6,
              child: ListView(
                children: [
                  Text(
                    widget.articles.title.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Text(
                    widget.articles.source.name.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(
                          Uri.parse(widget.articles.url.toString()))) {
                        await launchUrl(
                            Uri.parse(widget.articles.url.toString()));
                      } else {
                        throw 'Could not launch this url';
                      }
                    },
                    child: Text(
                      widget.articles.url.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Text(
                    widget.articles.description.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
