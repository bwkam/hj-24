package;

import echo.Body;
import echo.World;
import echo.data.Options.BodyOptions;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Display;
import peote.view.Program;
import sprites.Fish;

class Fishes {
	public var buffer:Buffer<Sprite>;
	public var fishes:Array<Fish> = [];
	public var program:Program;
	public var display:Display;
	public var world:World;
	public var bodies:Array<Body> = [];
	public var speed(default, set):Int = -100;

	public function new(display:Display, world:World, buffer:Buffer<Sprite>, program:Program) {
		this.display = display;
		this.world = world;
		this.buffer = buffer; 
		this.program = program;
	}

	function set_speed(newSpeed:Int) {
		trace("changing speed");
		for (b in this.bodies) {
			b.velocity.x = this.speed;
		}

		return this.speed = -newSpeed;
	}

	public function addFish(c:Color, opts:BodyOptions) {
		var fish = new Fish(this.buffer, this.world, c, opts);
		bodies.push(fish.body);
		fishes.push(fish);
	}
	
	
	public function repeat(settings:{c:Color, w:Float, h:Float, level:Int, x:Void->Float, y:Void->Float}, n:Int) {
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

			addFish(settings.c, opts);
		}
	}
}
