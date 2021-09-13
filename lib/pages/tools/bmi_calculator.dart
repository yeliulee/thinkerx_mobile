import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thinkerx/generated/l10n.dart';

enum Gender { male, female }

const kBottomContainerHeight = 80.0;
const kBottomContainerColour = Color(0xFFEB1555);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.white,
);

const kNumberTextStyle = TextStyle(
  fontSize: 50.0,
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

/// [PageToolBmiCalculator] 输入页面
class PageToolBmiCalculator extends StatefulWidget {
  @override
  _PageToolBmiCalculatorState createState() => _PageToolBmiCalculatorState();
}

/// [_PageToolBmiCalculatorState] 输入页面 状态
class _PageToolBmiCalculatorState extends State<PageToolBmiCalculator> {
  Gender selectedGender;
  int height;
  int weight;
  int age;

  @override
  void initState() {
    height = 180;
    weight = 60;
    age = 20;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([...DeviceOrientation.values]);
    super.dispose();
  }

  void handleCalc(BuildContext context) {
    BMICalculator calculator = BMICalculator(height: height, weight: weight);
    List<Widget> dialogActions = <Widget>[
      FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text("关闭")),
    ];
    var resultDialog = Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text("计算结果"),
            content: Text("指数：${calculator.calcBMI()}\n状态：${calculator.getResult()}\n详解：${calculator.getResultDetail()}"),
            actions: dialogActions,
          )
        : AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0),
            title: Text("计算结果"),
            content: Text("指数：${calculator.calcBMI()}\n状态：${calculator.getResult()}\n详解：${calculator.getResultDetail()}"),
            actions: dialogActions,
          );

    showDialog(
      context: context,
      builder: (BuildContext context) => resultDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = Theme.of(context).primaryColor;
    Color genderCardColor(Gender gender) => selectedGender == gender ? Theme.of(context).primaryColorDark : cardColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.current.toolNameBmiCalculator),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    color: genderCardColor(Gender.male),
                    child: CardIconContent(
                      icon: FontAwesomeIcons.mars,
                      label: "男 性",
                    ),
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: genderCardColor(Gender.female),
                    child: CardIconContent(
                      icon: FontAwesomeIcons.venus,
                      label: "女 性",
                    ),
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              color: cardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "身 高",
                    style: kLabelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        height.toString(),
                        style: kNumberTextStyle,
                      ),
                      Text(
                        'cm',
                        style: kLabelTextStyle,
                      )
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: Theme.of(context).primaryColorLight,
                      activeTrackColor: Colors.white,
                      thumbColor: Colors.white,
                      overlayColor: Colors.white,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
                    ),
                    child: Slider(
                      min: 120,
                      max: 220,
                      value: height.toDouble(),
                      onChanged: (double value) {
                        setState(() {
                          height = value.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    color: cardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '体 重',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          weight.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                                icon: FontAwesomeIcons.minus,
                                onPressed: () {
                                  setState(() {
                                    weight--;
                                  });
                                }),
                            SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  weight++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: cardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '年 龄',
                          style: kLabelTextStyle,
                        ),
                        Text(
                          age.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () {
                                setState(
                                  () {
                                    age--;
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () {
                                setState(() {
                                  age++;
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          PageBottomButton(
            buttonTitle: "计算 BMI",
            onTap: () => handleCalc(context),
          )
        ],
      ),
    );
  }
}

/// [ReusableCard] start
class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.color, this.child, this.onPress});

  final Color color;
  final Widget child;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: child,
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

/// [CardIconContent] start
class CardIconContent extends StatelessWidget {
  CardIconContent({this.icon, this.label, this.textStyle});

  final IconData icon;
  final String label;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
          size: 80.0,
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        )
      ],
    );
  }
}

/// [RoundIconButton] start
class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      shape: CircleBorder(),
      fillColor: Theme.of(context).primaryColorLight,
    );
  }
}

/// [BottomButton]
class PageBottomButton extends StatelessWidget {
  PageBottomButton({@required this.onTap, @required this.buttonTitle});

  final Function onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(top: 12.0),
        padding: EdgeInsets.only(bottom: 16.0),
        width: double.infinity,
        height: kBottomContainerHeight,
        child: Center(
          child: Text(
            buttonTitle,
            style: kLargeButtonTextStyle,
          ),
        ),
      ),
    );
  }
}

class BMICalculator {
  final int height;
  final int weight;

  double _bmi;

  BMICalculator({this.height, this.weight});

  String calcBMI() {
    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi >= 25) {
      return "体重过重";
    } else if (_bmi >= 18.5) {
      return "体重正常";
    } else {
      return "体重过轻";
    }
  }

  String getResultDetail() {
    if (_bmi >= 25) {
      return "您的体重高于正常体重，可以尝试增强锻炼。";
    } else if (_bmi >= 18.5) {
      return "您的体重在正常水平，继续保持哦！";
    } else {
      return "您的体重低于正常体重，记得增加饮食和适度锻炼。";
    }
  }
}
