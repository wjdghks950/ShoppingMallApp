import 'package:flutter/material.dart';
import 'favoritemodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'model/products_repository.dart';
import 'model/product.dart';

class RankingPage extends StatefulWidget{

  _RankingPageState createState() => _RankingPageState();

}
class Section{
  final String domainName;
  final int number;

  Section(this.domainName, this.number);
}

class _RankingPageState extends State<RankingPage>{
  List<charts.Series<Section, String>> seriesList;

  @override
  Widget build(BuildContext context){
    List<Product> products = ProductsRepository.loadProducts(Category.all);
    final data = [
      Section('Favorite Hotels', ScopedModel.of<FavoriteList>(context).saved.length),
      Section('Total Hotels', products.length),
    ];

    seriesList = [
      charts.Series<Section, String>(
        id: 'Hotel Statistics',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Section hotels, _) => hotels.domainName,
        measureFn: (Section hotels, _) => hotels.number,
        data: data,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Page',
                  style: TextStyle(color: Colors.white)),
                centerTitle: true,
      ),
      body: Center(
        child:charts.BarChart(
        seriesList
      ),
      ),
    );
  }
}
