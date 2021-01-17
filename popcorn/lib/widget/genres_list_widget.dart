import 'package:flutter/material.dart';
import 'package:popcorn/bloc/get_movies_byGenre_bloc.dart';
import 'package:popcorn/model/genre.dart';
import 'package:popcorn/style/theme.dart' as style;
import 'package:popcorn/widget/movies_by_genre_widget.dart';

class GenresListWidget extends StatefulWidget {
  final List<Genre> genres;

  const GenresListWidget({Key key, @required this.genres}) : super(key: key);

  @override
  _GenresListWidgetState createState() => _GenresListWidgetState(genres);
}

class _GenresListWidgetState extends State<GenresListWidget> with SingleTickerProviderStateMixin {
  final List<Genre> genres;
  TabController _tabController;
  _GenresListWidgetState(this.genres);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: genres.length, vsync: this);
    _tabController.addListener(() {
      if(_tabController.indexIsChanging){
        moviesByGenreBloc..drainStream();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .37,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: style.Colors.primaryColor,
          appBar: PreferredSize(
            child: TabBar(
                controller: _tabController,
                indicatorColor: style.Colors.secondaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3.0,
                unselectedLabelColor: style.Colors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre) {
                  return Container(
                    padding: EdgeInsets.only(
                      bottom: 10.0,
                      top: 15.0,
                    ),
                    child: Text(
                      genre.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            preferredSize: Size.fromHeight(50),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: genres.map((Genre genre){
              return MoviesByGenreWidget(genreId: genre.id);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
