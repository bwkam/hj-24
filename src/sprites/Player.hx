package sprites;

import echo.World;
import echo.data.Options.BodyOptions;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import peote.view.Buffer;
import peote.view.Color;

class Player extends Sprite {
	public var isMovingUp:Bool = false;
	public var isMovingDown:Bool = false;
	public var vy:Float = 0.0;
	public var vx:Float = 0.0;
	public var acc:Float = 0.0;
	public var entered:Bool;
	public var level:Int = 2;
	public var score:Int = 0;
	public var health:Int = 100; 
	public var boost:Int = 0; 


	override public function new(buffer:Buffer<Sprite>, world:World, c:Color, _options:BodyOptions) {
		super(buffer, world, c, _options);
		this.buffer = buffer;
	}


	public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier) {
		if (keyCode == KeyCode.W || keyCode == KeyCode.UP) {
			this.body.velocity.y = -vy;
			isMovingUp = true;
		} else if (keyCode == KeyCode.S || keyCode == KeyCode.DOWN) {
			this.body.velocity.y = vy;
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
			this.body.velocity.y = 0;
			isMovingUp = false;
		} else if (keyCode == KeyCode.S || keyCode == KeyCode.DOWN) {
			this.body.velocity.y = 0;
			isMovingDown = false;
		}


		if (keyCode == KeyCode.D || keyCode == KeyCode.RIGHT || keyCode == KeyCode.A || keyCode == KeyCode.LEFT) {
			this.body.velocity.x = 0;
		}
	}
}
