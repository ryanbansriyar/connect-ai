import 'package:flutter/material.dart';
import 'objectivepage.dart';
import 'optioncard.dart';
import 'objectivepage.dart';

class OptionCardCreator extends StatelessWidget {

  late OptionCard optionChoose;
  OptionCardCreator({ required this.optionChoose });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObjectiveDetailPage(
              title: optionChoose.title,
              text: optionChoose.text,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(16.0,16.0,16.0,16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                optionChoose.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                optionChoose.text,
                style: TextStyle(fontSize: 14),
              ),

            ],
          ),
        ),
      ),
    );
  }
}