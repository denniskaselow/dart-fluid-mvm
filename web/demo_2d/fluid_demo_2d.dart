import 'dart:html';
import 'package:fluid_mvm/fluid_mvm.dart';
import 'package:fluid_mvm/fluid_mvm_renderer2d.dart';

FluidSimulator simulator;
CanvasRenderingContext2D context;

const _deltaCount = 20;
const _dividend = _deltaCount * 1000;
List<double> deltas = new List.generate(_deltaCount, (_) => 0.0, growable: false);
int frame = 0;
double lastTime = 0.0;

void main() {
  CanvasElement canvas = querySelector("#fluid_canvas");
  context = canvas.context2D;
  context.textBaseline = 'top';

  // Create the fluid simulator
  simulator = new FluidSimulator();
  simulator.initializeGrid(canvas.width, canvas.height);

  // Add some initial particles
  for (int i = 0; i < 50; i++) {
    for (int j = 0; j < 50; j++) {
      simulator.addParticle(i * 2 + 10, j * 2 + 10, 0.5, 0);
    }
  }

  // Create a 2d renderer to draw the fluid
  simulator.renderer = new FluidRenderer2D(context);

  window.animationFrame.then(draw);
}

void draw(num elapsedTime) {
  // Clear out the background
  context.strokeStyle = "black";
  context.fillStyle = "white";
  context.fillRect(0, 0, context.canvas.width, context.canvas.height);

  // Update the simulation
  simulator.update();

  // Draw the fluid particles
  simulator.draw();

  deltas[frame++ % _deltaCount] = elapsedTime - lastTime;
  lastTime = elapsedTime;

  var fps = _dividend / deltas.reduce((combined, current) => combined + current);

  context.fillStyle = 'black';
  context.fillText('FPS: ${fps.toStringAsFixed(2)}', 5, 5);

  window.animationFrame.then(draw);
}
