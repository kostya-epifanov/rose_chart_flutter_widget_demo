# Rose Chart Widget Demo

A Flutter demo project showcasing advanced custom widget architecture for multi-component charts with manual canvas rendering. This project demonstrates how to build complex, interactive charts by organizing rendering logic into modular, reusable components.

## 🎯 Project Overview

This demo implements a rose chart (radar chart) widget that displays data sectors in a circular layout. The project serves as an educational example of how to structure complex custom Flutter widgets that require manual canvas drawing, particularly when dealing with:

- Multiple visual components (axes, sectors, labels, effects)
- Interactive animations and transitions
- Gesture handling
- Modular rendering architecture

https://github.com/user-attachments/assets/f553c812-f71e-4e52-8b1c-08200ce7ae37

## 🏗️ Architecture & Design Patterns

### Component-Based Rendering

The chart is built using a modular component system where each visual element is a separate `ExtendedCustomPainter` subclass:

```
lib/components/rendering/
├── axes/
│   ├── circular_axes_component.dart    # Concentric circles
│   └── radial_axes_component.dart      # Radial lines
├── sectors/
│   └── sectors_group_component.dart    # Data sectors
├── labels/
│   ├── labels_component.dart           # Sector labels
│   └── summary_labels_component.dart   # Central labels
└── effects/
    ├── bottom_fade_gradient_component.dart
    └── plus_icons_component.dart
```

### Key Architectural Principles

1. **Separation of Concerns**: Each component handles only its specific rendering logic
2. **Composition over Inheritance**: Components are composed in the main painter
3. **Dependency Injection**: Components receive their configuration through constructors
4. **Immutability**: Models use `equatable` for proper state comparison

### Custom Painter Architecture

```dart
class RoseChartPainter extends CustomPainter {
  final List<ExtendedCustomPainter> components;
  final ChartTransition transition;
  final double transitionValue;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate transformations
    // Apply transitions
    // Render each component
    for (final component in components) {
      component.extendedPaint(canvas, size, scaledSize, position);
    }
  }
}
```

## 🚀 Features Demonstrated

### Chart States & Transitions
- **Base State**: Full circular chart with all sectors visible
- **Summary State**: Scaled-down view for overview
- **Detailed State**: Zoomed-in view with navigation controls

### Interactive Features
- **Sector Selection**: Tap sectors to highlight them
- **Smooth Animations**: Transition between chart states
- **Rotation Animation**: Smooth sector rotation when changing focus
- **Gesture Handling**: Custom gesture detector for chart interactions

### Rendering Features
- **Manual Canvas Drawing**: All rendering done with low-level Canvas API
- **Gradient Effects**: Visual enhancements like fade gradients
- **Dynamic Coloring**: Color-coded sectors and labels
- **Responsive Layout**: Adapts to different screen sizes

## 📁 Project Structure

```
lib/
├── components/
│   ├── chart/
│   │   ├── rose_chart_widget.dart      # Main widget
│   │   └── core_chart_widget.dart
│   ├── gestures/
│   │   ├── chart_gesture_detector.dart  # Touch handling
│   │   └── measure_size_widget.dart
│   └── rendering/                      # All rendering logic
│       ├── axes/                       # Grid lines
│       ├── sectors/                    # Data visualization
│       ├── labels/                     # Text labels
│       ├── effects/                    # Visual effects
│       └── painter/
│           ├── rose_chart_painter.dart # Main painter
│           └── extended_custom_painter.dart
├── models/
│   ├── chart_sector.dart               # Data model
│   └── category.dart                   # Category model
├── transitions/
│   ├── chart_state.dart                # State definitions
│   ├── chart_transition.dart           # Transition logic
│   └── rotate_transition.dart          # Rotation animations
├── extensions/
│   └── string_extension.dart           # String utilities
├── main.dart                           # Demo app
└── utils.dart                          # Test data generation
```

## 🔧 Getting Started

### Prerequisites
- Flutter SDK (>=3.1.2)
- Dart SDK (>=3.1.2)

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the demo

### Usage Example

```dart
// Create chart data
final sectors = [
  ChartSectorModelImpl(
    strength: 5,
    category: Category(name: 'Category A'),
    isEmpty: false,
  ),
  // ... more sectors
];

// Create the widget
RoseChartWidget(
  maxStrength: 10,
  storyPartViewModels: sectors,
  sectorOnTop: sectors.first,
  centralSectorsActiveCount: 3,
  transition: const ChartTransition(
    fromState: ChartState.base(),
    toState: ChartState.summary(),
  ),
  transitionAnimationValue: 0.5,
  onTapSelectorLeft: () => print('Left tapped'),
  onTapSelectorRight: () => print('Right tapped'),
  onTapSector: (sector) => print('Sector tapped: ${sector.category.name}'),
  onTapBasic: () => print('Center tapped'),
)
```

## 🎨 Customization

### Adding New Components

1. Create a new class extending `ExtendedCustomPainter`
2. Implement the `extendedPaint` method
3. Add the component to the painter's component list

```dart
class MyCustomComponent extends ExtendedCustomPainter {
  @override
  void extendedPaint(Canvas canvas, Size originalSize, Size scaledSize, Offset position) {
    // Your custom rendering logic here
  }
}
```

### Chart States

Add new chart states by extending the `ChartState` class:

```dart
const ChartState.myCustomState()
  : this._(
      testTitle: 'custom',
      widgetHeight: 300,
      scaleMod: 1.2,
      posXMod: 0.1,
      posYMod: 0.1,
      haveBottomFade: true,
      isGesturesEnabled: false,
      chartXoffset: 50,
      chartYoffset: 20,
    );
```

## 🧪 Demo Features

The demo app includes:

- **Random Data Generation**: Generate random chart data
- **Fixed Data**: Use predefined test data
- **State Transitions**: Interactive controls to switch between chart states
- **Animation Slider**: Manually control transition animations
- **Sector Navigation**: Navigate through sectors in detailed view

## 🔍 Key Implementation Details

### Coordinate System
The chart uses a polar coordinate system converted to Cartesian coordinates for canvas rendering.

### Animation System
- State transitions use `AnimationController` with custom curves
- Rotation animations provide smooth sector transitions
- Gesture-based interactions trigger appropriate animations

### Performance Optimizations
- Components only repaint when their data changes
- Canvas operations are batched efficiently
- Memory-efficient data structures using `equatable`

## 📚 Learning Resources

This project demonstrates several advanced Flutter concepts:

- **Custom Painting**: Manual canvas rendering techniques
- **Component Architecture**: Modular widget composition
- **Animation Controllers**: Complex animation sequences
- **Gesture Recognition**: Custom touch handling
- **State Management**: Efficient state updates and transitions

## 🤝 Contributing

This is a demo project for educational purposes. Feel free to:
- Experiment with the code
- Add new components
- Modify rendering logic
- Extend the animation system

## 📄 License

This project is for educational purposes only.
