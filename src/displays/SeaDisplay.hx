package displays;

import echo.World;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Display;
import peote.view.Program;

typedef SeaMembers = {
	sea: Sprite,
	fishes: Fishes,
}

class SeaDisplay extends Display {
    var buffer:Buffer<Sprite>;
    var program:Program;
	public var members:SeaMembers;
	var fishThreshold:Int = 100;


    override public function new(x:Int, y:Int, width:Int, height:Int, world:World, color:Color = 0x00000000) {
		super(x, y, width, height, color);
        
		this.buffer = new Buffer<Sprite>(1, 10, true);
        this.program = new Program(this.buffer);

        var sea = new Sprite(this.buffer, world, Color.BLUE2, {
			x: 0,
			y: world.height / 2,
			mass: 0,
			kinematic: true,
			shape: {
                type: RECT,
				width: world.width,
				height: world.height / 2,
			},
		});

        var fishes = new Fishes(this, world, this.buffer, this.program);


        this.addProgram(this.program);

		this.members = {
			sea: sea, 
			fishes: fishes, 
		}
    }

	public function updateElement(e:Sprite) {
		this.buffer.updateElement(e);
	}

    public function update() {
		var fishes = this.members.fishes;

		for (f in fishes.fishes) {
			if (!this.isPointInside(Std.int(f.x), Std.int(f.y))) {
				fishes.fishes.remove(f); 
				fishes.bodies.remove(f.body);
				f.kill();
			}
		}

		if (fishes.fishes.length < fishThreshold) {
			var fishCount = fishThreshold - fishes.fishes.length;
			fishes.repeat({
				c: Color.BLACK,
				w: 10,
				h: 10,
				level: 1,
				x: () -> Std.random(width) + width, 
				y: () -> Std.random(Std.int(height / 2)) + height / 2,
			}, fishCount);
		}


		this.buffer.update();
    }
}