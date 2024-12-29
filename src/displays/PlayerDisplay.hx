package displays;

import echo.World;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Display;
import peote.view.Program;
import sprites.Player;

typedef PlayerMembers = {
    player: Player,
}

class PlayerDisplay extends Display {
    var buffer:Buffer<Sprite>;
    var program:Program;
    public var members:PlayerMembers;

    override public function new(x:Int, y:Int, width:Int, height:Int, world:World, color:Color = 0x00000000) {
		super(x, y, width, height, color);
        
		this.buffer = new Buffer<Sprite>(1, 1, true);
        this.program = new Program(this.buffer);

		var player = new Player(this.buffer, world, Color.RED, {
			x: 20,
			y: 0,
			mass: 10,
			shape: {
				type: RECT,
				width: 20,
				height: 20,
			},
		});

		player.vy = 300;
		player.vx = 50;
		player.level = 2;

		this.addProgram(this.program);
		this.members = {
			player: player,
		}
    }

	public function update() {
		this.members.player.update();
        this.buffer.update();
    }
}