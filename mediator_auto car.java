interface CarMediator {
	void notify(Component sender);
}

class ControlUnit implements CarMediator {
	private Navigation navigation;
	private Sensor sensor;
	private DriveSystem drive;
	private BrakeSystem brake;

	public ControlUnit(Navigation navigation, Sensor sensor, DriveSystem drive, BrakeSystem brake) {
		this.navigation = navigation;
		this.sensor = sensor;
		this.drive = drive;
		this.brake = brake;

		this.navigation.setMediator(this);
		this.sensor.setMediator(this);
		this.drive.setMediator(this);
		this.brake.setMediator(this);
	}

	@Override
	public void notify(Component sender) {
		System.out.println("===[Mediator] notify from: " + sender.getClass().getSimpleName() + "===");

		if(sender instanceof Navigation) {
			handleNavigation();
		} else if (sender instanceof Sensor) {
			handleSensorDetaction();
		} else if (sender instanceof DriveSystem) {
			handleDriveSystem();
		} else if (sender instanceof BrakeSystem) {
			handleBrakeSystem();
		}
	}

	private void handleNavigation() {
		this.sensor.scan();
		String direction = this.navigation.getDirection();

		switch (direction) {
		case "forward":
			if (this.brake.isBraking()) this.brake.updateBrake(false);
			if (this.drive.getSpeed() != 60) this.drive.updateSpeed(60);
			break;
		case "stop":
			if (!this.brake.isBraking()) this.brake.updateBrake(true);
			if (this.drive.getSpeed() != 0) this.drive.updateSpeed(0);
			break;
		case "backward":
			if (this.brake.isBraking()) this.brake.updateBrake(false);
			if (this.drive.getSpeed() != 20) this.drive.updateSpeed(20);
			break;
		case "left":
		case "right":
			if (!this.brake.isBraking()) this.brake.updateBrake(true);
			if (this.drive.getSpeed() != 10) this.drive.updateSpeed(10);
			break;
		default:
			System.out.println("Unknown direction.");
			break;
		}
	}

	private void handleSensorDetaction() {
		if (this.sensor.getObjectDistance() < 10) {
			if (!this.brake.isBraking()) this.brake.updateBrake(true);
			if (this.drive.getSpeed() != 0) this.drive.updateSpeed(0);
			if (!navigation.getDirection().equals("stop")) {
				this.navigation.navigate("stop");
			}
		} else {
			if (this.brake.isBraking()) this.brake.updateBrake(false);
			if (this.drive.getSpeed() == 0) this.drive.updateSpeed(60);
			this.sensor.scan();
		}
	}

	private void handleDriveSystem() {
		if (this.drive.getSpeed() > 0) {
			if (this.brake.isBraking()) this.brake.updateBrake(false);
			if (this.navigation.getDirection().equals("stop")) {
				this.navigation.navigate("forward");
			}
		} else {
			if (!this.brake.isBraking()) this.brake.updateBrake(true);
			if (!this.navigation.getDirection().equals("stop")) {
				this.navigation.navigate("stop");
			}
		}
		this.sensor.scan();
	}

	private void handleBrakeSystem() {
		if (this.brake.isBraking() && drive.getSpeed() > 0) {
			this.drive.updateSpeed(0);
			if (!navigation.getDirection().equals("stop")) {
				this.navigation.navigate("stop");
			}
		} else if (!this.brake.isBraking() && this.drive.getSpeed() == 0) {
			this.drive.updateSpeed(60);
			if (!navigation.getDirection().equals("forward")) {
				this.navigation.navigate("forward");
			}
		}
		this.sensor.scan();
	}
}

abstract class Component {
	protected CarMediator mediator;

	public Component() {
		this.mediator = null;
	}

	public void setMediator(CarMediator mediator) {
		this.mediator = mediator;
	}
}

class Navigation extends Component {
	private String direction;

	public Navigation() {
		super();
		this.direction = null;
	}

	public void navigate(String direction) {
		this.direction = direction;
		System.out.println("[Navigation] changing direction to " + this.direction);
		this.mediator.notify(this);
	}

	public String getDirection() {
		return this.direction;
	}
}

class Sensor extends Component {
	private int objectDistance;

	public Sensor() {
		super();
		this.objectDistance = 0;
	}

	public void scan() {
		System.out.println("[Sensor] scanning...");
	}

	public void detected(int distance) {
		this.objectDistance = distance;
		System.out.println("[Sensor] detected object distance " + this.objectDistance + "meters");
		this.mediator.notify(this);
	}

	public int getObjectDistance() {
		return this.objectDistance;
	}
}

class DriveSystem extends Component {
	private int speed;

	public DriveSystem() {
		super();
		this.speed = 0;
	}

	public void updateSpeed(int speed) {
		this.speed = speed;
		System.out.println("[DriveSystem] speed update to " + this.speed + "km/h");
		this.mediator.notify(this);
	}

	public int getSpeed() {
		return this.speed;
	}
}

class BrakeSystem extends Component {
	private boolean braking;

	public BrakeSystem() {
		super();
		this.braking = false;
	}

	public void updateBrake(boolean braking) {
		this.braking = braking;
		if(this.braking) {
			System.out.println("[BrakeSystem] braking...");
		} else {
			System.out.println("[BrakeSystem] no braking...");
		}
		this.mediator.notify(this);
	}

	public boolean isBraking() {
		return this.braking;
	}
}

public class Main {
	public static void main(String[] args) {
		Navigation navigation = new Navigation();
		Sensor sensor = new Sensor();
		DriveSystem driveSystem = new DriveSystem();
		BrakeSystem brakeSystem = new BrakeSystem();

		ControlUnit controUnit = new ControlUnit(navigation, sensor, driveSystem, brakeSystem);

		navigation.navigate("forward");
		System.out.println("\n");
		navigation.navigate("backward");
		System.out.println("\n");
		navigation.navigate("left");
		System.out.println("\n");
		navigation.navigate("stop");
		
		System.out.println("\n");
		sensor.detected(15);
		System.out.println("\n");
		sensor.detected(5);
	}
}

