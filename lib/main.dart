import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/chart_state.dart';
import 'package:rose_chart_widget_demo/transitions/chart_transition.dart';
import 'package:rose_chart_widget_demo/utils.dart';
import 'package:rose_chart_widget_demo/widget/personality_chart_widget.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RoseChartDemoScreen(),
    ),
  );
}

class RoseChartDemoScreen extends StatefulWidget {
  const RoseChartDemoScreen({super.key});

  @override
  RoseChartDemoScreenState createState() => RoseChartDemoScreenState();
}

class RoseChartDemoScreenState extends State<RoseChartDemoScreen> {
  List<ChartSectorModelImpl>? _dataList;
  ChartSectorModelImpl? _dataUnitOnTop;
  int _centralSectorsActiveCount = 0;
  double _transitionAnimationValue = 0.0;

  ChartTransition _transition = const ChartTransition(
    fromState: ChartState.base(),
    toState: ChartState.summary(),
  );

  @override
  void initState() {
    super.initState();
    _dataList ??= generateRandomSizeTestList();
    _dataUnitOnTop ??= _dataList!.first;
  }

  int get _maxStrength {
    return _dataList!.map((e) => e.strength).toList().reduce(max);
  }

  void _onTapGenerateRandom() {
    _dataList = generateRandomSizeTestList();
    _dataUnitOnTop = _dataList!.first;
    _centralSectorsActiveCount = Random().nextInt(_dataList!.length + 1);
    setState(() {});
  }

  void _onTapGeneratePersonality() {
    _dataList = generateFixedTestList();
    _dataUnitOnTop = _dataList!.first;
    _centralSectorsActiveCount = Random().nextInt(_dataList!.length + 1);
    setState(() {});
  }

  void _onTapGenerateFixedDummy() {
    _dataList = generateFixedTestList();
    _dataUnitOnTop = _dataList!.first;
    _centralSectorsActiveCount = 6;
    setState(() {});
  }

  void _onTransitionAnimSliderChanged(double value) {
    _transitionAnimationValue = value;
    setState(() {});
  }

  void _onTapSelectorLeftRight(bool isLeft) {
    final indexOfCurrent = _dataList!.indexOf(_dataUnitOnTop!);
    if (isLeft) {
      if (indexOfCurrent == 0) {
        _dataUnitOnTop = _dataList!.last;
      } else {
        _dataUnitOnTop = _dataList![indexOfCurrent - 1];
      }
    } else {
      if (indexOfCurrent == _dataList!.length - 1) {
        _dataUnitOnTop = _dataList!.first;
      } else {
        _dataUnitOnTop = _dataList![indexOfCurrent + 1];
      }
    }
    setState(() {});
  }

  void _onTapChartSector(ChartSectorModel data) {
    //showCustomSnackbar(CustomSnackBarMessage(text: '\"${data.title}\" tap!'));
  }

  void _onTapChartBasic() {
    //showCustomSnackbar(CustomSnackBarMessage(text: '\"BASIC\" tap!'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 96),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 666),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  key: ValueKey(_dataList.toString()),
                  child: RoseChartWidget(
                    maxStrength: _maxStrength,
                    storyPartViewModels: _dataList!,
                    sectorOnTop: _dataUnitOnTop!,
                    transitionAnimationValue: _transitionAnimationValue,
                    transition: _transition,
                    centralSectorsActiveCount: _centralSectorsActiveCount,
                    onTapSelectorLeft: () => _onTapSelectorLeftRight(true),
                    onTapSelectorRight: () => _onTapSelectorLeftRight(false),
                    onTapBasic: () => _onTapChartBasic(),
                    onTapSector: (data) => _onTapChartSector(data),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _buildRadioGroup(
                        groupTitle: 'FROM',
                        selected: _transition.fromState,
                        list: ChartState.types,
                        onTap: (val) {
                          _transition = ChartTransition(
                            fromState: val,
                            toState: _transition.toState,
                          );
                          setState(() {});
                        },
                      ),
                      _buildRadioGroup(
                        groupTitle: 'TO',
                        selected: _transition.toState,
                        list: ChartState.types,
                        onTap: (val) {
                          _transition = ChartTransition(
                            fromState: _transition.fromState,
                            toState: val,
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Slider(
                    value: _transitionAnimationValue,
                    onChanged: (value) => _onTransitionAnimSliderChanged(value),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: RawMaterialButton(
                    child: const Text('GENERATE RANDOM'),
                    onPressed: () => _onTapGenerateRandom(),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: RawMaterialButton(
                    child: const Text('GENERATE FIXED'),
                    onPressed: () => _onTapGeneratePersonality(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup({
    required String groupTitle,
    required ChartState selected,
    required List<ChartState> list,
    required Function(ChartState) onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(groupTitle),
        ...list.map((data) {
          return SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 24,
            child: RadioListTile(
              title: Text(data.testTitle),
              value: data,
              groupValue: selected,
              onChanged: (val) => onTap.call(val as ChartState),
              contentPadding: const EdgeInsets.all(0),
            ),
          );
        }).toList()
      ],
    );
  }
}
