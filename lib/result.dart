import 'package:flutter/material.dart';
import 'package:flutter_application_mel/meal_api.dart';

import 'my_chart.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  dynamic chartePage = const Text("차트 영억");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IconButton(
            onPressed: () async {
              var dt = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
              );

              if (dt != null) {
                print(dt);
                var api = MealApi();
                var result = await api.getList(evalDate: dt);
                print(result);
                List<double> ratings = [];
                List<String> days = [];

                for (var k in result) {
                  days.add(k["eval_date"]);
                  ratings.add(double.parse(k["rating"]));
                }
                print(ratings);
                print(days);
                setState(() {
                  chartePage = MyChart(days: days, ratings: ratings);
                });
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
          Expanded(child: chartePage),
        ],
      ),
    );
  }
}
