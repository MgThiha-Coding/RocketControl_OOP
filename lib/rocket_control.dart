// Main control function that initiates the rocket launch sequence
void falcon9() {
  // Create an instance of ThrustControl to manage main thrusters and Vernier thrusters
  ThrustControl thrustControl = ThrustControl(
    engine1: 0.0,
    engine2: 0.0,
    engine3: 0.0,
    engine4: 0.0,
    engine5: 0.0,
    engine6: 0.0,
  );

  // Call methods to accelerate the rocket and activate Vernier thrusters
  thrustControl.accelerate(); // Abstraction: Simplifies thrust management
  thrustControl
      .controlVerniers(); // Polymorphism: Same interface, different behaviors

  // Create instances of fuel types (Liquid Hydrogen and Oxygen)
  LiquidHydrogenFuel fuel = LiquidHydrogenFuel(1000.0);
  LiquidOxygenFuel ofuel = LiquidOxygenFuel(500.0, 1000.0);

  // Create the empannage section and check if it should eject at the right altitude
  EmpannageSection empannageSection =
      EmpannageSection(500.0, 1000.0, false, 400000);

  // Open hydrogen and oxygen fuel systems
  fuel.liquidHydrogen(); // Encapsulation: Keeps fuel management logic hidden
  ofuel
      .liquidOxygen(); // Inheritance: Shares functionality, but customized for oxygen

  // Eject empannage section if conditions are met
  empannageSection
      .ejectEmpannage(); // Polymorphism: Empannage section behaves differently based on altitude
}

// Abstract class representing a general thruster with six engines
abstract class Thruster {
  double engine1;
  double engine2;
  double engine3;
  double engine4;
  double engine5;
  double engine6;

  // Constructor initializes the engines
  Thruster({
    required this.engine1,
    required this.engine2,
    required this.engine3,
    required this.engine4,
    required this.engine5,
    required this.engine6,
  });

  // Method to calculate total thrust and lift
  void accelerate() {
    double totalThrust =
        engine1 + engine2 + engine3 + engine4 + engine5 + engine6;
    double lift = totalThrust + 1; // Calculate lift as thrust plus 1
    print('Rocket Launching with totalLift(Thrust) : $lift');
  }
}

// Mixin for Vernier thrusters, providing fine control for the rocket's direction
mixin VernierThruster {
  double thrust = 0;

  // Method to activate a Vernier thruster
  void activateVernier(int thrusterNumber) {
    thrust += 1; // Polymorphism: Increases thrust with each activation
    print('Vernier Thruster $thrusterNumber activated. Thrust: $thrust');
  }
}

// Class to control both main thrusters and Vernier thrusters using ThrustControl
class ThrustControl extends Thruster with VernierThruster {
  ThrustControl({
    required super.engine1,
    required super.engine2,
    required super.engine3,
    required super.engine4,
    required super.engine5,
    required super.engine6,
  });

  @override
  void accelerate() {
    super.accelerate(); // Abstraction: Simplifies main engine acceleration
    print('Main engines accelerating');
  }

  // Method to control Vernier thrusters (fine adjustments)
  void controlVerniers() {
    activateVernier(
        1); // Composition: Uses the VernierThruster mixin for secondary control
    activateVernier(2);
    activateVernier(3);
    activateVernier(4);
  }
}

// Class for managing liquid hydrogen fuel
class LiquidHydrogenFuel {
  double hydrogenFuel;

  LiquidHydrogenFuel(this.hydrogenFuel);

  // Method to open liquid hydrogen fuel
  void liquidHydrogen() {
    print('Open liquidHydrogen $hydrogenFuel');
  }
}

// Class for managing liquid oxygen fuel, inheriting from LiquidHydrogenFuel
class LiquidOxygenFuel extends LiquidHydrogenFuel {
  double oxygenFuel;

  LiquidOxygenFuel(
    this.oxygenFuel,
    super.hydrogenFuel,
  );

  // Method to open liquid oxygen fuel
  void liquidOxygen() {
    print('Open LiquidOxygenfuel when hydrogen runs out: $oxygenFuel');
  }

  // Override liquidHydrogen to customize behavior for oxygen
  @override
  void liquidHydrogen() {
    super.liquidHydrogen();
    print(
        'Stop and close tank $hydrogenFuel'); // Inheritance: Reuses functionality but customizes it
  }
}

// Class to manage the empannage section, including ejection logic based on altitude
class EmpannageSection extends LiquidOxygenFuel {
  double altitude;
  bool eject;

  EmpannageSection(
    super.oxygenFuel,
    super.hydrogenFuel,
    this.eject,
    this.altitude,
  );

  @override
  void liquidHydrogen() {
    super.liquidHydrogen();
    print('Closing hydrogen tanks...');
  }

  @override
  void liquidOxygen() {
    super.liquidOxygen();
    print('Closing oxygen tanks...');
  }

  // Method to eject the empannage section when altitude is high enough
  void ejectEmpannage() {
    if (altitude >= 400000) {
      eject = true;
      print('Ejecting Empannage Section at altitude: $altitude');
    } else {
      print('Altitude too low for empannage ejection.');
    }
  }
}
