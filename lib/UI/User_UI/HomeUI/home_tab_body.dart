import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/utils/colors.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../RentalpropertyUI/room_detail_page.dart';

class HomeTabBody extends StatefulWidget {
  final CupertinoTabController tabController;

  HomeTabBody({Key? key, required this.tabController}) : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomeTabBody> {
  List<RentalProperty> listRental = [];

  //cuon trang, kích thước hiển thị của màn hình
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = 220;
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    super.initState();
    _getTopRental();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  void _getTopRental() async {
    final rentalcontroller = context.read<Rentalpropertycontroller>();
    listRental = await rentalcontroller.getTopRental();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Container(
                height: 220,
                child: PageView.builder(
                    controller: pageController,
                    itemCount: listRental.length > 3 ? 3 : listRental.length,
                    //begin 0->4
                    itemBuilder: (context, position) {
                      return _buildPageItem(position);
                    }),
              ),
              new DotsIndicator(
                dotsCount: listRental.length > 3 ? 3 : listRental.length,
                position: _currPageValue,
                decorator: DotsDecorator(
                  activeColor: AppColors.mainColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, bottom: 20),
                children: [
                  // Each button can be a Column containing an Icon and Text
                  buildIconButton('Phòng trọ\nsinh viên', Icons.school),
                  buildIconButton('Phòng trọ\ncó gác', Icons.stairs),
                  buildIconButton('Phòng trọ\ngiá rẻ', Icons.attach_money),
                  buildIconButton('Nuôi\nthú cưng', Icons.pets),
                  buildIconButton('Có\nban công', Icons.balcony),
                  buildIconButton('Phòng trọ\nmáy lạnh', Icons.severe_cold),
                ],
              )
            ],
          );
  }

  Widget buildIconButton(String text, IconData icon) {
    return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Màu nền khung
              borderRadius: BorderRadius.circular(10), // Bo góc
              border: Border.all(color: Colors.grey), // Màu viền
            ),
            // margin: EdgeInsets.all(5), // Khoảng cách giữa các khung
            padding: EdgeInsets.all(10), // Khoảng cách bên trong khung
            child: Icon(icon,
                size: 25, color: AppColors.mainColor), // Kích thước icon
          ),
          SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12), // Kích thước chữ
          ),
        ],
      ),
      onTap: () {
        widget.tabController.index = 2;
      },
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RoomDetailPage(rentalProperty: listRental[index],)));
            },
            child: Container(
              height: 220,
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.cover, //anh day box
                      image: listRental[index].images[0] != null
                          ? NetworkImage("${listRental[index].images[0]}")
                          : AssetImage("assets/images/anh1.png"))),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }
}
