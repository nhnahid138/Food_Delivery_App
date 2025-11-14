import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SalesGraphWidget extends StatefulWidget {
  const SalesGraphWidget({super.key});

  @override
  State<SalesGraphWidget> createState() => _SalesGraphWidgetState();
}

class _SalesGraphWidgetState extends State<SalesGraphWidget> {
  // bar graph array
  final List<String> days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List<double> salesToday = [0, 0, 0, 0, 0, 0,0];
  List<double> ordersDelivered = [0, 0, 0, 0, 0, 0,0];

  // array for line graph
  List<double> processingOrders = [500, 200, 150, 300, 650, 400, 350];
  List<double> shippingOrders = [80, 180, 120, 280, 220, 380, 320];
  List<double> deliveredOrders = [60, 160, 110, 260, 210, 360, 310];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
              .collection('admin')
               .doc('order')
               .collection('userOrder')
               .snapshots(),
      builder: (context, asyncSnapshot) {
        if(!asyncSnapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }
        final sales =asyncSnapshot.data!.docs;
        DateTime today = DateTime.now();
        //DateTime ago = today.subtract(Duration(days: 1));
        //String todayformattedDate = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: 1)));
        //print(sevenDaysAgo);
        // Reset before new calculation
        salesToday = List.filled(7, 0);
        ordersDelivered = List.filled(7, 0);

        for (int i=0;i<sales.length;i++){
          var sale=sales[i];
          var date=sale['date'];
          DateTime dateTime=date.toDate();
          String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
          String weekend = DateFormat('EEE').format(dateTime);
          int day = dateTime.weekday;
          for(int j=0;j<7;j++){
            String todayDate = DateFormat('yyyy-MM-dd').format(today.subtract(Duration(days: j)));
            String week = DateFormat('EEE').format(today.subtract(Duration(days: j)));
            days[6-j]=week;


            if(formattedDate==todayDate && sale['status']=='processing') {
              salesToday[6-j]=salesToday[6-j]+sale['total'];



            }
            if(formattedDate==todayDate && sale['status']=='Delivered') {
              ordersDelivered[6-j]=ordersDelivered[6-j]+sale['total'];



            }

          }






        }
        return Column(
          children: [
            const Text(
              'Weekly Sales (Bar: Today/Delivered)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Bar graph code

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(color: Colors.green, label: 'Sales'),
                SizedBox(width: 16),
                _LegendItem(color: Colors.blue, label: 'Delivered'),
              ],
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.7,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: 1,
                ),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return BarChart(
                    _barChartDataAnimated(value),
                  );
                },
              ),
            ),




            // code for line graph



            const SizedBox(height: 32),
            const Text(
              'Order Status Trend (Line)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Legend for line colors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(color: Colors.red, label: 'Processing'),
                SizedBox(width: 16),
                _LegendItem(color: Colors.blue, label: 'Shipping'),
                SizedBox(width: 16),
                _LegendItem(color: Colors.amber, label: 'Delivered'),
              ],
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(_lineChartData()),
            ),
          ],
        );
      }
    );
  }

  BarChartData _barChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: (salesToday.asMap().entries.map((e) => e.value + ordersDelivered[e.key])
          .reduce((a, b) => a > b ? a : b)) +
          10,
      barGroups: List.generate(days.length, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: salesToday[i] + ordersDelivered[i],
              width: 18,
              rodStackItems: [
                BarChartRodStackItem(0, salesToday[i], Colors.green),
                BarChartRodStackItem(salesToday[i],
                    salesToday[i] + ordersDelivered[i], Colors.blue),
              ],
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int idx = value.toInt();
              return idx >= 0 && idx < days.length
                  ? Text(days[idx],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12))
                  : const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48, // Increased reserved size for large numbers
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11, // Smaller font size for better fit
                ),
                textAlign: TextAlign.right,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${days[groupIndex]}\nSales: ${salesToday[groupIndex].toInt()}\nDelivered: ${ordersDelivered[groupIndex].toInt()}',
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }

  BarChartData _barChartDataAnimated(double t) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: (salesToday.asMap().entries.map((e) => e.value + ordersDelivered[e.key])
          .reduce((a, b) => a > b ? a : b)) +
          100,
      barGroups: List.generate(days.length, (i) {
        final animatedSales = salesToday[i] * t;
        final animatedDelivered = ordersDelivered[i] * t;
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: animatedSales + animatedDelivered,
              width: 18,
              rodStackItems: [
                BarChartRodStackItem(0, animatedSales, Colors.green),
                BarChartRodStackItem(animatedSales,
                    animatedSales + animatedDelivered, Colors.blue),
              ],
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int idx = value.toInt();
              return idx >= 0 && idx < days.length
                  ? Text(days[idx],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12))
                  : const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                textAlign: TextAlign.right,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${days[groupIndex]}\nSales: ${salesToday[groupIndex].toInt()}\nDelivered: ${ordersDelivered[groupIndex].toInt()}',
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }

  LineChartData _lineChartData() {
    double maxY = [
      //...salesToday,
      ...processingOrders,
      ...shippingOrders,
      ...deliveredOrders
    ].reduce((a, b) => a > b ? a : b) + 100;

    return LineChartData(
      minX: 0,
      maxX: days.length - 1,
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        // Processing Orders (Red)
        LineChartBarData(
          spots: List.generate(processingOrders.length, (i) => FlSpot(i.toDouble(), processingOrders[i])),
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
        // Shipping Orders (Blue)
        LineChartBarData(
          spots: List.generate(shippingOrders.length, (i) => FlSpot(i.toDouble(), shippingOrders[i])),
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
        // Delivered Orders (Amber)
        LineChartBarData(
          spots: List.generate(deliveredOrders.length, (i) => FlSpot(i.toDouble(), deliveredOrders[i])),
          isCurved: true,
          color: Colors.amber,
          barWidth: 3,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int idx = value.toInt();
              return idx >= 0 && idx < days.length
                  ? Text(days[idx],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12))
                  : const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                textAlign: TextAlign.right,
              );
            },
          ),
        ),
      ),
      lineTouchData: const LineTouchData(enabled: true),
    );
  }
}

// Legend widget
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
