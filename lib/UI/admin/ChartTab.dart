import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:intl/intl.dart';

import '../../Controller/RentalPropertyController.dart';


class ChartTab extends StatefulWidget {
  @override
  _ChartTabState createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {

  @override
  void initState() {
    super.initState();

    // Gọi setRental() khi khởi tạo widget
    final listRental = context.read<Rentalpropertycontroller>();

    listRental.setRental();
    final userController = context.read<Usercontroller>();
    userController.users;
  }
  @override
  Widget build(BuildContext context) {
    final rentalpropertycontroller = context.watch<Rentalpropertycontroller>();

    // Lấy dữ liệu từ rentalController
    final rentalProperties = rentalpropertycontroller.listRental;
    final userController = context.watch<Usercontroller>();
    // Tính toán dữ liệu thống kê từ rentalProperties
    final totalRooms = rentalProperties.length;
    final averageRent = rentalProperties.isNotEmpty
        ? rentalProperties.map((e) => e.getNumericRentPrice()).reduce((a, b) => a + b) / totalRooms
        : 0.0;
    final int currentYear = DateTime.now().year;
    final totalUsers = userController.users.length; // Get the number of users


    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                _buildOverviewSection(totalRooms, averageRent, totalUsers),
                SizedBox(height: 24),

                // Monthly Trend Chart
                _buildChartSection(currentYear),
                SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildOverviewSection(int totalRooms, double averageRent, int totalUsers) {
    // double averageRentInMillion = rentalController.averageRent / 1000000;
    // String formattedValue = NumberFormat("#,##0.0", "vi_VN").format(averageRentInMillion);
    final formatter = NumberFormat("#,##0.0", "vi_VN");

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Tổng phòng trọ', '$totalRooms', Icons.home,
            //FindTab()
      ),
        _buildStatCard(
          'Giá trung bình',
          '${formatter.format(averageRent / 1000000)} Tr',
          Icons.money_sharp,
        ),
        _buildStatCard(
          'Tổng số người dùng',
          '$totalUsers',
          Icons.person,
        ),
        // _buildStatCard(
        //   'Tỷ lệ đặt phòng',
        //   '32.5%',
        //   '+2.5%',
        //   Icons.visibility,
        // ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.mainColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

    );
  }

  // Widget _buildStatCard(String title, String value, IconData icon, Widget destination) {
  //   return GestureDetector(
  //     onTap: () {
  //       // Navigate to the destination widget (e.g., FindTab)
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => destination),
  //       );
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.1),
  //             spreadRadius: 1,
  //             blurRadius: 6,
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Icon(icon, color: AppColors.mainColor),
  //           const SizedBox(height: 8),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: Colors.grey[600],
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             value,
  //             style: const TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }



  Future<List<double>> fetchMonthlyListings(int year) async {
    try {
      // Access the controller from the context
      final rentalpropertycontroller = context.read<Rentalpropertycontroller>();
      final Map<int, int> rentalCount = await rentalpropertycontroller.getRentalCountForYear(year);

      // Generate a list for 12 months, defaulting to 0 if no data is available
      return List.generate(12, (index) {
        int month = index + 1;
        return rentalCount[month]?.toDouble() ?? 0.0;
      });
    } catch (e) {
      print('Error fetching monthly listings: $e');
      return List.filled(12, 0.0); // Return a fallback list of zeros
    }
  }

  Widget _buildChartSection(int year) {
    return FutureBuilder<List<double>>(
      future: fetchMonthlyListings(year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorIndicator(snapshot.error);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoDataIndicator();
        }
        return _buildLineChart(snapshot.data!);
      },
    );
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  Widget _buildErrorIndicator(Object? error) => Center(child: Text('Error: $error'));

  Widget _buildNoDataIndicator() => Center(child: Text('No data available'));

  Widget _buildLineChart(List<double> monthlyListings) {
    final double maxY = monthlyListings.isNotEmpty ? monthlyListings.reduce((a, b) => a > b ? a : b) : 0.0;
    final double minY = monthlyListings.isNotEmpty ? monthlyListings.reduce((a, b) => a < b ? a : b) : 0.0;

    // Calculate an appropriate step for the Y-axis labels
    final double yInterval = (maxY - minY) / 5; // Divide the range into 5 steps for flexibility

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Xu hướng theo tháng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: _buildAxisTitles(yInterval), // Pass the dynamic interval
                borderData: FlBorderData(show: true),
                minY: 0, // Ensure Y-axis starts from 0
                maxY: maxY + yInterval, // Ensure maxY is adjusted
                lineBarsData: [_buildLineBarData(monthlyListings)],
              ),
            ),
          ),
          _buildChartLegend(),
        ],
      ),
    );
  }

  FlTitlesData _buildAxisTitles(double yInterval) => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: true, getTitlesWidget: _buildMonthLabels, interval: 1),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (double value, TitleMeta meta) => _buildNumericLabels(value, meta, yInterval),
        interval: yInterval, // Adjust based on dynamic interval
      ),
    ),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );

  Widget _buildNumericLabels(double value, TitleMeta meta, double yInterval) {
    // Format numeric labels for the Y-axis with dynamic intervals
    if (value % yInterval == 0) {
      return Text(
        value.toStringAsFixed(0),
        style: const TextStyle(color: Colors.black, fontSize: 12),
      );
    }
    return Container(); // Do not show labels for values that don't align with the interval
  }

  Widget _buildMonthLabels(double value, TitleMeta meta) {
    final months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
    return Text(months[value.toInt()], style: const TextStyle(color: Colors.black, fontSize: 12));
  }


  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 6,
      ),
    ],
  );
  LineChartBarData _buildLineBarData(List<double> monthlyListings) => LineChartBarData(
    spots: monthlyListings.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
    isCurved: true,
    color: AppColors.mainColor,
    dotData: FlDotData(show: true),
    belowBarData: BarAreaData(show: true, color: AppColors.mainColor.withOpacity(0.1)),
  );

  Widget _buildChartLegend() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [_buildLegendItem('Số phòng', AppColors.mainColor)],
  );



  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

