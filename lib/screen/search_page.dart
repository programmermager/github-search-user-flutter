import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:github_user_search/data/domain/api_domain.dart';
import 'package:github_user_search/data/repository/api_repository.dart';
import 'package:github_user_search/model/object/user_model.dart';
import 'package:github_user_search/screen/bloc/search_page_bloc.dart';
import 'package:github_user_search/screen/bloc/search_page_event.dart';
import 'package:github_user_search/util/screen_util.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/search_page_state.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchPageBloc _bloc;
  ApiDomain _domain;
  String q;
  var searchCtrl = TextEditingController();
  List<UserModel> users= List();
  bool isNeedLoadMore = false;
  int currentPage = 1;
  // ScrollController controller;

  bool isLoading = false;
  bool isValid = true;

  @override
  void initState() {
    _domain = new ApiDomain(ApiRepository());
    _bloc = new SearchPageBloc(domain: _domain);

    // controller = new ScrollController()..addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 360, height: 640, allowFontScaling: true)
          ..init(context);

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) {
                  return _bloc;
                },
              )
            ],
            child: BlocListener<SearchPageBloc, SearchPageState>(
              bloc: _bloc,
              listener: (context, state) {
                if(state is ReqSearchSuccess){
                  isLoading = false;
                  isValid = true;
                  if(state.response.items.length > 0){
                    for(var item in state.response.items){
                      users.add(item);
                    }
                    isNeedLoadMore = true;
                  }else{
                    isNeedLoadMore = false;
                  }
                }else if(state is ReqSearchError){
                  isValid = false;
                  isLoading= false;
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        title: Text("Failed", style: GoogleFonts.muli().copyWith(fontSize: ScreenUtil().setSp(12)),),
                        content: Text("${state.error}", style: GoogleFonts.muli().copyWith(fontSize: ScreenUtil().setSp(12)),),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Try Again', style: GoogleFonts.muli().copyWith(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold),),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                isValid = true;
                              });
                              _reqSearch();
                            },
                          ),
                          FlatButton(
                            child: Text('Close', style: GoogleFonts.muli().copyWith(fontSize: ScreenUtil().setSp(12), color: Colors.red),),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
                }

              },
              child: BlocBuilder<SearchPageBloc, SearchPageState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(ScreenUtil().setWidth(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/img/ic_github.svg"),
                            SizedBox(width: ScreenUtil().setWidth(10),),
                            Text("Github Search", style: GoogleFonts.poppins().copyWith(color: Colors.black, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w900))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(15), left: ScreenUtil().setWidth(15),bottom: ScreenUtil().setHeight(15)),
                        child: Card(
                          color: Color(0xFFF4F4F4),
                          child: Container(
                            padding: EdgeInsets.only(left: ScreenUtil().setSp(15), right: ScreenUtil().setSp(15)),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              controller: searchCtrl,
                              textInputAction: TextInputAction.search,
                              onFieldSubmitted: (value) {
                                if(searchCtrl.text.isEmpty) return;
                                _reqSearch();
                              },
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins().copyWith(fontSize: ScreenUtil().setSp(12)),
                              decoration: new InputDecoration(
                                  hintStyle: TextStyle(color: Color(0xffD1D1D1)),
                                  border: InputBorder.none,
                                  hintText: "Search user Github",
                                  fillColor: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Stack(
                        children: [
                          Column(
                            children: [
                              showList(state),
                              loading(state),
                            ],
                          ),
                        ],
                      ))
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showEmptyState(){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/img/img_empty_data.svg"),
          SizedBox(height: ScreenUtil().setHeight(10),),
          Text("No Data Found", style: GoogleFonts.muli().copyWith(fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w900),)
        ],
      ),
    );
  }

  Widget showList(SearchPageState state){
    return Expanded(
        child:NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              if(isValid) {
                currentPage += 1;
                _reqSearch();
                setState(() {
                  isLoading = true;
                });
              }
            }
          },
          child: (users.length <=0 && currentPage == 1) ? showEmptyState() : ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: users.length,
            itemBuilder: (context, position) {
              return InkWell(
                onTap: () {

                },
                child: itemUser(users[position]),
              );
            },
          ),
        ));
  }

  itemUser(UserModel item){
    return InkWell(
      onTap: () {
        _launchURL(item.url);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(15), left: ScreenUtil().setWidth(15), right: ScreenUtil().setWidth(15) ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "${item.avatar_url}")
                      )),
                  width: ScreenUtil().setWidth(50),
                  height: ScreenUtil().setWidth(50),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item.login}", style: GoogleFonts.muli().copyWith(fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                    SizedBox(
                      height: ScreenUtil().setHeight(5),
                    ),
                    Text("Score : ${item.score}", style: GoogleFonts.muli().copyWith(fontSize: ScreenUtil().setSp(12), )),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(15),
          ),
        ],
      ),
    );
  }

  Widget loading(SearchPageState state) {
    return (isValid) ? Container(
      height: (state is ReqLoading) ? 50:0,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    ) : MaterialButton(onPressed: (){
      setState(() {
        isValid = true;
      });
      _reqSearch();
    }, child: Text("Try Again"),);
  }

  _reqSearch() {
    if(!isLoading) _bloc.add(ReqSearchUser(q: searchCtrl.text, page: currentPage));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

