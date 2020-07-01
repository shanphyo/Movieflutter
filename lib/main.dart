import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/Moviedata.dart';

void main() {
  runApp(MyApp());
}

class MovieResult {
  final String title;
  final String description;
  final String posterPath;
  final String overview;

  MovieResult(this.title, this.description, this.posterPath,this.overview);


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
  
    return HomePageState();
  }

}
class HomePageState extends State<HomePage>{
  var url="https://api.themoviedb.org/3/movie/top_rated?api_key=96249906fe854e8efc7a5a9627346497";
  var murl="https://image.tmdb.org/t/p/w200";
  MovieData md;

  @override
  void initState(){
    super.initState();
    fetchData();
    
  }

  fetchData() async{
    var data=await http.get(url);
    var jsonData= jsonDecode(data.body);
    md = MovieData.fromJson(jsonData);

  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(appBar: AppBar(title: Text('Movie'),backgroundColor: Colors.cyan,
    ),
    body: md==null ? Center(child: CircularProgressIndicator(),)
    :GridView.count(
      crossAxisCount: 2,
      
      children:
      
      md.results.map((movie) => 
      
    
      
       Padding(
         padding: EdgeInsets.all(2.0),
        
      
        
        child:InkWell(
          onTap: (){
            MovieResult rs=new MovieResult(
              movie.title,
              movie.overview,
              movie.posterPath,
              movie.overview
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => new NewDetail(res: rs,)));
          },
          child: Hero(
            tag: movie.posterPath,
            child: Card(
              child: Column(
                children:[
                  Container(

                    child: Image.network(""+murl+movie.posterPath,cacheHeight: 130,cacheWidth: 200,)
                  ),
                  Text(
                    movie.originalTitle,
                    style:TextStyle(
                      fontSize:20.0,
                      fontWeight: FontWeight.bold

                    )
                  )
                ]
                
              ),
            ),
          ),
        )
      )
      
      ).toList()
      )
    ,);
  }

}

class NewDetail extends StatelessWidget {
 final MovieResult res;
  var murl="https://image.tmdb.org/t/p/w200";
 NewDetail({this.res});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Description'),
      ),
      body: Column(
      children:[
         Image.network(murl+res.posterPath,height: 300.0,),
          SizedBox(height: 20.0,),
          Text(res.title,textAlign: TextAlign.start,style:Theme.of(context).textTheme.headline5,),
          SizedBox(height: 20.0,),
          Text(res.overview),
      ]
      ),
      
    );
  }
}