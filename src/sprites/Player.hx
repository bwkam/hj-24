package sprites;

import echo.World;
import echo.data.Options.BodyOptions;
import echo.math.Vector2;
import haxe.Timer;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import peote.view.Buffer;
import peote.view.Color;

class Player extends Sprite {
	public var isMovingUp:Bool = false;
	public var isMovingDown:Bool = false;
	public var isMoving:Bool = false;
	public var vyi:Float = 300;
	public var vxi:Float = 50;
	public var vy:Float = 0.0;
	public var vx:Float = 0.0;
	public var acc:Float = 0.0;
	public var entered:Bool;
	public var level:Int = 2;
	public var score:Int = 0;
	public var health:Float = 100; 
	public var gold:Int = 0;
	public var boost:Int = 0; 
	public var inAir:Bool = false;
	public var reachedMax:Bool = false;
	public var last_x:Float = 0.0;
	public var last_y:Float = 0.0;
	public var last_vx:Float = 0.0;
	public var last_vy:Float = 0.0;
	public var onPlatform:Bool = false;

	var timeStopped:Float = 0.0;

	var angleOffset = 20;


	override public function new(buffer:Buffer<Sprite>, world:World, c:Color, _options:BodyOptions) {
		super(buffer, world, c, _options);
		this.buffer = buffer;
	}


	public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier, y:Float) {
		if ((keyCode == KeyCode.W || keyCode == KeyCode.UP)) {
			if (!reachedMax || onPlatform) {
				this.angle = -angleOffset;
				this.body.velocity.y = -vy;
				this.body.velocity.x = vx;
				isMoving = true;
				isMovingUp = true;
			} else
				return;

		} else if (keyCode == KeyCode.S || keyCode == KeyCode.DOWN) {
			this.angle = angleOffset;
			this.body.velocity.y = vy;
			this.body.velocity.x = vx;
			isMoving = true;
			isMovingDown = true;
		} 

		if (keyCode == KeyCode.D || keyCode == KeyCode.RIGHT) {
			this.body.velocity.x = vx;
		} else if (keyCode == KeyCode.A || keyCode == KeyCode.LEFT) {
			this.body.velocity.x = -vx;
		}
	}

	public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier) {
		if (keyCode == KeyCode.W || keyCode == KeyCode.UP) {
			last_x = this.x;
			last_y = this.y;
			last_vx = this.body.velocity.x;
			last_vy = this.body.velocity.y;
			this.angle = 0;
			this.body.velocity.y = 0;
			isMovingUp = false;
			isMoving = false;
			timeStopped = Timer.stamp();
		} else if (keyCode == KeyCode.S || keyCode == KeyCode.DOWN) {
			last_x = this.x;
			last_y = this.y;
			last_vx = this.body.velocity.x;
			last_vy = this.body.velocity.y;
			this.angle = 0;
			this.body.velocity.y = 0;
			isMoving = false;
			isMovingDown = false;
			timeStopped = Timer.stamp();
		}


		if (keyCode == KeyCode.D || keyCode == KeyCode.RIGHT || keyCode == KeyCode.A || keyCode == KeyCode.LEFT) {
			this.body.velocity.x = 0;
		}
	}
	public function update() {
		if (!isMoving && (Timer.stamp() - timeStopped) < 2 && !inAir) {
			// trace("setting to 0")
			this.body.velocity.x = lib.Math.lerp(this.body.velocity.x, 0, 1);
			this.body.x = lib.Math.lerp(this.body.x, 20, 0.05);
		}
	}
}
