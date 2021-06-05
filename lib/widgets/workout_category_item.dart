import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interactive_workout_app/models/workout_category.dart';
import 'package:interactive_workout_app/screens/workout_screen.dart';
import 'package:interactive_workout_app/state_management_helpers/workout_screen_arguments.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WorkoutCategoryItem extends StatefulWidget {
  // TODO consider changing this to be an id instead and change description
  final String title;
  String description;

  WorkoutCategoryItem({
    @required this.title,
    @required this.description,
  });

  @override
  _WorkoutCategoryItemState createState() => _WorkoutCategoryItemState();
}

// TODO make the pictures more responsive (for tablets)
class _WorkoutCategoryItemState extends State<WorkoutCategoryItem> {
  // TODO configure the difficulty level adjustment and also allow for custom difficulty
  void showAdaptiveDialog() {
    var isiOS = (Theme.of(context).platform == TargetPlatform.iOS);
    if (isiOS) {
      showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text("Difficulty"),
          content: Text("Choose the difficulty of the workout"),
          actions: [
            CupertinoDialogAction(
              child: Text("Easy"),
              onPressed: () {
                print("easy");
              },
            ),
            CupertinoDialogAction(
              child: Text("Medium"),
              onPressed: () {
                print("Medium");
              },
            ),
            CupertinoDialogAction(
              child: Text("Hard"),
              onPressed: () {
                print("hard");
              },
            ),
            CupertinoDialogAction(
              child: Text("Impossible"),
              onPressed: () {
                print("Impossible");
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(context: context, builder: (_) => AlertDialog());
    }
  }

  Future<void> selectWorkout(BuildContext context) {
    // showAdaptiveDialog();
    Navigator.of(context).pushNamed(WorkoutScreen.routeName,
        arguments: WorkoutScreenArguments(
            currentWorkoutCategoryTitle: widget.title,
            upcomingWorkoutIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory =
        Provider.of<WorkoutCategory>(context).findCategory(widget.title);
    if (currentCategory.description == null) {
      // TODO find another design rather than this
      widget.description = "Enter description";
    }
    Size size = MediaQuery.of(context).size;
    return Card(
      color: currentCategory.color,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => selectWorkout(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(5),
            ),
            Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            currentCategory.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: (Image.asset(
                      currentCategory.image,
                      height: size.height * 0.25,
                      width: size.width * 0.38,
                      fit: BoxFit.contain,
                    )),
                  )
                : Text("no image"),
          ],
        ),
      ),
    );
  }
}