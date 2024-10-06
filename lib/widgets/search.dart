// import 'package:flutter/material.dart';
// import 'package:timtro/utils/colors.dart';
// // import 'package:http/http.dart' as http;
//
// class FindTab extends StatefulWidget {
//   @override
//   _FindTab createState() => _FindTab();
//   FindTab({Key? key}): super(key: key);
// }
//
//
//
// class _FindTab extends State<FindTab> {
//   Color _iconColor = Colors.grey; // Màu mặc định
//   Color _focusedIconColor = AppColors.mainColor; // Màu khi focus
//   final TextEditingController _searchController = TextEditingController();
//
//   List<SearchResult> _searchResults = [];
//
//   Future<void> _search(String query) async {
//     // Gọi API tìm kiếm ở đây, ví dụ:
//     var url = Uri.parse('https://api.example.com/search?query=$query');
//     // var response = await http.get(url);
//     // Parse kết quả và cập nhật _searchResults
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//
//               width: 300,
//               child: Container(
//                 margin: EdgeInsets.only(top: 20),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: (value) {
//                     _search(value);
//                     setState(() {
//                       // Cập nhật màu sắc icon khi giá trị trong TextField thay đổi
//                       _iconColor = _focusedIconColor;
//                     });
//                   },
//                   decoration: InputDecoration(
//
//                     prefixIcon: Icon(Icons.search, color: _iconColor,),
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(
//                         color: Colors.grey.shade300,
//                         width: 1.0,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(
//                         color: Colors.grey.shade300,
//                         width: 1.0,
//
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(
//                         color: AppColors.mainColor, width: 1.5,
//
//                       ),
//
//                     ),
//
//                     hintText: 'Tìm kiếm...',
//                     hintStyle: TextStyle(color: Colors.grey.shade400),
//                   ),
//                 ),
//               )
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _searchResults.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(_searchResults[index].title),
//
//                   subtitle: Text(_searchResults[index].description),
//
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SearchResult {
//   final String title;
//   final String description;
//   final String url;
//
//   SearchResult({required this.title, required this.description, required this.url});
// }



import 'package:flutter/material.dart';
import 'package:timtro/utils/colors.dart';
// import 'package:http/http.dart' as http;

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch; // Hàm callback để gọi khi có sự kiện tìm kiếm

  SearchWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Color _iconColor = Colors.grey;
  Color _focusedIconColor = AppColors.mainColor;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            widget.onSearch(value); // Gọi hàm tìm kiếm được truyền vào từ widget cha
            setState(() {
              _iconColor = _focusedIconColor; // Thay đổi màu icon khi người dùng nhập
            });
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: _iconColor),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColors.mainColor,
                width: 1.5,
              ),
            ),
            hintText: 'Tìm kiếm...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }
}
