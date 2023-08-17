import 'package:flutter/material.dart';
import './meal_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      itemCount: score.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => ListTile(
        leading: Text('${score[index].rate}'),
        title: Text(score[index].comment),
      ),
    );
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
