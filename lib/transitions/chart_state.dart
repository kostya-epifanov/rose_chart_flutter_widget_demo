class ChartState {
  final String testTitle;
  final double widgetHeight;
  final double scaleMod;
  final double posXMod;
  final double posYMod;
  final bool haveBottomFade;
  final bool isGesturesEnabled;
  final double chartXoffset;
  final double chartYoffset;

  const ChartState._({
    required this.testTitle,
    required this.widgetHeight,
    required this.scaleMod,
    required this.posXMod,
    required this.posYMod,
    required this.haveBottomFade,
    required this.isGesturesEnabled,
    required this.chartXoffset,
    required this.chartYoffset,
  });

  static const types = [
    ChartState.base(),
    ChartState.summary(),
    ChartState.detailed(),
  ];

  const ChartState.base()
      : this._(
          testTitle: 'base',
          widgetHeight: 360,
          scaleMod: 1.0,
          posXMod: 0.0,
          posYMod: 0.0,
          haveBottomFade: false,
          isGesturesEnabled: true,
          chartXoffset: 0,
          chartYoffset: -15,
        );

  const ChartState.summary()
      : this._(
          testTitle: 'summary',
          widgetHeight: 264,
          scaleMod: 0.75,
          posXMod: 0.3,
          posYMod: -0.1,
          haveBottomFade: false,
          isGesturesEnabled: false,
          chartXoffset: 0,
          chartYoffset: 0,
        );

  const ChartState.detailed()
      : this._(
          testTitle: 'detailed',
          widgetHeight: 176,
          scaleMod: 2.0,
          posXMod: 0.0,
          posYMod: 0.25,
          haveBottomFade: true,
          isGesturesEnabled: false,
          chartXoffset: 90,
          chartYoffset: 0,
        );
}
