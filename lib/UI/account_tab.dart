// import 'package:flutter/material.dart';
//
// class AccountTab extends StatelessWidget {
//   const AccountTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("Account tab"),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //
      //   title: Text('Đăng ký/Đăng nhập'),
      //   actions: [
      //     Icon(Icons.person),
      //   ],
      // ),
      // body: ListView(
      //   children: [
      //     ListTile(
      //       leading: Icon(Icons.code),
      //       title: Text('Nhập mã giới thiệu'),
      //     ),
      //     ListTile(
      //       leading: Icon(Icons.warning),
      //       title: Text('Chính sách quy định'),
      //     ),
      //     ListTile(
      //       leading: Icon(Icons.info),
      //       title: Text('Về chúng tôi'),
      //     ),
      //   ],
      // ),

      body: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(right: 20),
                      child: Icon(Icons.person, color: Colors.white),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.mainColor,
                      ),
                    ),
                  ),

                  BigText(text: "Đăng ký/Đăng nhập")
                ],
              ),
            ),
          ),
          Container(
            height: 300,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.code, color: AppColors.mainColor,),
                  title: Text('Nhập mã giới thiệu'),
                ),
                ListTile(
                  leading: Icon(Icons.warning, color: AppColors.mainColor,),
                  title: Text('Chính sách quy định'),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: AppColors.mainColor,),
                  title: Text('Về chúng tôi'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
