
import 'dart:math';

import 'package:flutter/material.dart';

class RotatingCubeWithSnakeMovement extends StatefulWidget {
  const RotatingCubeWithSnakeMovement({super.key});

  @override
  _RotatingCubeWithSnakeMovementState createState() =>
      _RotatingCubeWithSnakeMovementState();
}

class _RotatingCubeWithSnakeMovementState
    extends State<RotatingCubeWithSnakeMovement> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _snakeController;
  late List<Offset> snakePositions;

  @override
  void initState() {
    super.initState();

    // Animation controller for rotating the larger cube
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // Loop the rotation

    // Animation controller for the snake movement (small cubes inside the large cube)
    _snakeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Repeat snake-like movement

    // Initialize positions for the small cubes (snake body)
    snakePositions = [
      const Offset(0, 0),
      const Offset(0, 0),
      const Offset(0, 0),
      const Offset(0, 0),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _snakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Rotation angle for the large cube
            double angle = _controller.value * 2 * pi;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(angle)
                ..rotateY(angle)
                ..rotateZ(angle),
              child: Stack(
                children: List.generate(4, (index) {
                  // Calculate the position for each small cube (snake-like movement)
                  double movementFactor = _snakeController.value * 100;

                  // Make the snake move in an oscillating pattern
                  double offsetX = snakePositions[index].dx + movementFactor;
                  double offsetY = snakePositions[index].dy + movementFactor;

                  return Transform.translate(
                    offset: Offset(offsetX, offsetY),
                    child: Positioned(
                      top: 50 + index * 20,
                      left: 50 + index * 20,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}