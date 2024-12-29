package sprites;

import echo.Body;
import echo.World;
import echo.data.Options.BodyOptions;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Element;
import peote.view.Program;


typedef FishConfig = {
	tile:Int,
	level:Int,
	gain:Int,
	damage:Int,
	follow:Bool,
}

enum FishState {
	AGGRESSIVE;
	IDLE;
	ESCAPE;
}


class Fish implements Element {
	@posX @varying @set("Position") public var x:Float = 0.0;
	@posY @varying @formula("y+1.0") @set("Position") public var y:Float = 0.0;

	@sizeX public var w(default, set):Float = 0.0;
	@sizeY public var h:Float;

	public var withBody:Bool = true;

	@color public var color:Color = 0x000000ff;

	@pivotX @const @formula("w * 0.5") public var pivotX:Float = 0.0;
	@pivotY @const @formula("h * 0.5") public var pivotY:Float = 0.0;

	@texPosY @const var texPosY:Int = -1;

	@rotation public var angle:Float = 0.0;

	@texTile() public var tile:Int = 0;

	public var level:Int = 1;
	public var tileNumber:Int;
	public var gain:Int;
	public var check:Bool = true;
	public var isSecret:Bool = false;
	public var damage:Int;
	public var state:FishState = IDLE;
	public var follow:Bool = false;
	public var flight:Float = 0.0;


	public static var program:Program;

	public var body:Body;
	public var buffer:Buffer<Fish>;

	public function new(buffer:Buffer<Fish>, world:World, color:Color, config:FishConfig, _options:BodyOptions, ?secret:Bool = false) {
		var options = _options;

		this.h = options.shape.height;
		this.w = options.shape.width;
		this.color = color;

		this.buffer = buffer;

		options.x = _options.x + (this.w * 0.5);
		options.y = _options.y + (this.h * 0.5);

		this.x = options.x;
		this.y = options.y;

		if (withBody) {
			body = world.make(options);
			body.on_move = onMove.bind(buffer, _);
		}

		buffer.addElement(this);

		this.buffer = buffer;
		this.level = config.level;
		this.tileNumber = config.tile;
		this.gain = config.gain;
		this.tile = config.tile;
		this.color = color;
		this.damage = config.damage;
		this.follow = config.follow;
		this.w = this.w * -1;
		if (secret != null) {
			isSecret = secret;
		}
	}

	function set_w(new_w) {
		if (this.body != null && this.withBody)
			this.body.scale_x = -new_w;
		return this.w = new_w;
	}

	public function kill() {
		this.buffer.removeElement(this);
		if (this.withBody) 
			this.body.remove();
	}

	public function onMove(buffer:Buffer<Fish>, x:Float, y:Float) {
		setPosition(x, y);
		buffer.updateElement(this);
	}

	public function update(dt:Float) {
		if (this.y <= 275) {
			flight += dt;
		}

		buffer.update();
	}
}
