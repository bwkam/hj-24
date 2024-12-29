package;

import echo.Body;
import echo.World;
import echo.data.Options.BodyOptions;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Display;
import peote.view.Program;
import sprites.Fish;

using Lambda;

class Fishes {
	public var buffer:Buffer<Fish>;
	public var fishes:Array<Fish> = [];
	public var program:Program;
	public var display:Display;
	public var world:World;
	public var bodies:Array<Body> = [];
	public var speed(default, set):Int = -800;
	public var activeFishes:Array<FishConfig> = [];

	public function new(display:Display, world:World, buffer:Buffer<Fish>, program:Program) {
		this.display = display;
		this.world = world;
		this.buffer = buffer; 
		this.program = program;
	}

	function set_speed(newSpeed:Int) {
		for (b in this.bodies) {
			b.velocity.x = this.speed;
		}

		return this.speed = -newSpeed;
	}

	public function addFish(c:Color, config:FishConfig, opts:BodyOptions, ?secret:Bool = false) {
		var fish = new Fish(this.buffer, this.world, c, config, opts, secret);
		bodies.push(fish.body);
		fishes.push(fish);
	}
	public function unlockFish(config:FishConfig) {
		activeFishes.push(config);
	}

	public function repeat(settings:{
		c:Color,
		w:Float,
		h:Float,
		x:Void->Float,
		y:Void->Float
	}, config:FishConfig, n:Int) {
		var _opts = null;
		for (_ in 0...n) {
            var opts:BodyOptions = {
                x: settings.x(), 
                y: settings.y(),
                kinematic: true,
				velocity_x: this.speed,
				mass: 10,
				shape: {
					type: RECT,
					width: settings.w,
					height: settings.h,
				},
            };

			_opts = opts;
			addFish(settings.c, config, opts);
		}
		// addFish(Color.RED, config, _opts, true);
	}
}
