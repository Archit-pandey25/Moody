import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/widgets.dart';
import 'package:star_book/models/user.dart';
import '../controllers/global_setting.dart';
import '../styles/style.dart';
import '../utils/string.dart';

/// UserName Add Sheet Screen Widget
///
/// Input form to store Username of user in [User] table.
class UsernameAddSheet extends StatefulWidget {
  @override
  _UsernameAddSheetState createState() => _UsernameAddSheetState();
}

class _UsernameAddSheetState extends State<UsernameAddSheet> {
  late final TextEditingController textController;
  late User user;
  final int maxLength = 20;
  late int remainingChar;

  @override
  void initState() {
    super.initState();
    remainingChar = maxLength;
    textController = TextEditingController();
    textController.addListener(onTextChanged);
    user = GlobalSettingController.getuser();
    textController.text = user.name;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void onTextChanged() {
    setState(() {
      remainingChar = maxLength - textController.text.length;
      user = user.copyWith(name: textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return c.CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: c.CupertinoDynamicColor.resolve(
        c.Color(0xFF80C0DB),
        context,
      ),
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Spacer(flex: 24),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Hello there!',
                style: Style.largeTitle(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'So nice to meet you! What do your friends call you?',
              style: Style.title(context),
            ),
            const Spacer(flex: 22),
            c.CupertinoTextField(
              maxLength: maxLength,
              controller: textController,
              placeholder: 'Your Name',
              cursorColor: c.Color(0xFFFFFFFF),
              keyboardType: TextInputType.text,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: c.Color(0xFF8FD0EC),
              ),
            ),
            c.Container(
              padding: const EdgeInsets.only(top: 5),
              alignment: Alignment.centerRight,
              child: Text(
                '${textController.text.length} / $maxLength',
                style: c.TextStyle(
                  color: c.Color(0xFFFFFFFF),
                ),
              ),
            ),
            const Spacer(flex: 46),
            c.CupertinoButton(
              onPressed: isNullOrEmpty(textController.text) ? null : () => onContinuePressed(context),
              color: c.Color(0xFF8FD0EC),
              child: Text(
                'Continue',
                style: Style.buttonText(context),
              ),
            ),
            const Spacer(flex: 8),
          ],
        ),
      ),
    );
  }

  void onContinuePressed(c.BuildContext context) async {
    GlobalSettingController.setUser(user);
    await Navigator.of(context).pushReplacementNamed('home');
  }
}
