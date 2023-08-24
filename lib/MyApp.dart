import 'package:flutter/material.dart';
import './meal_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var controller = TextEditingController();
  bool enabled = false;
  List<Score> score = [];
  double rate = 0;
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();
  dynamic listView = const Text("");

  void showReview({required String evalDate}) async {
    var api = MealApi();
    var result = api.getReview(evalDate: evalDate);
    setState(() {
      listView = FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text("${data[index]['rating']}"),
                    title: Text("${data[index]['comment']}"),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: data.length);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
        },
        future: result,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Color.fromARGB(255, 60, 0, 255),
              ),
              onRatingUpdate: (value) {
                setState(() {
                  rate = value;
                  enabled = true;
                });
              },
            ),
            TextFormField(
              validator: (value) {
                if (value.toString().trim().isEmpty) {
                  return 'space';
                }
                return null;
              },
              controller: controller,
              enabled: enabled,
              decoration: const InputDecoration(
                hintText: '한마디 해주세요',
                label: Text('여긴뭘까?'),
                border: OutlineInputBorder(),
              ),
              maxLength: 30,
            ),
            ElevatedButton(
              onPressed: enabled
                  ? () async {
                      var api = MealApi();
                      //2023-08-16 16:55:45
                      var evalDate = DateTime.now().toString().split(' ')[0];
                      var res =
                          await api.insert(evalDate, rate, controller.text);
                      print(res);

                      //----------------------------
                      score.add(
                        Score(
                          rate: rate,
                          comment: controller.text,
                        ),
                      );
                      setState(() {
                        listView;
                        enabled = false;
                      });
                      print(score.length);
                    }
                  : null,
              child: const Text('저장하기'),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: focusedDay,
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) async {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;

                showReview(evalDate: selectedDay.toString().split(" ")[0]);
              },
              selectedDayPredicate: (DateTime day) {
                // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                return isSameDay(selectedDay, day);
              },
            ),
            Expanded(child: listView),
          ],
        ),
      ),
    );
  }
}

class Score {
  double rate;
  String comment;
  Score({required this.rate, required this.comment});
}
