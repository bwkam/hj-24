package sprites;

import echo.Body;
import echo.World;
import echo.data.Options.BodyOptions;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Element;
import peote.view.Program;

class Sea implements Element {
	@posX @varying @set("Position") public var x:Float = 0.0;
	@posY @varying @set("Position") public var y:Float = 0.0;

	@sizeX public var w(default, set):Float = 0.0;
	@sizeY public var h:Float;

	@color public var color:Color = 0x000000ff;

	@pivotX @const @formula("w * 0.5") public var pivotX:Float = 0.0;
	@pivotY @const @formula("h * 0.5") public var pivotY:Float = 0.0;

	@texTile() public var tile:Int = 89;
    @texSlot public var slot:Int = 0;

    @texSizeX @const @formula("64.0/(w/16.0)") public var twOffset:Int;
    @texSizeY @const @formula("64.0/(h/16.0)") public var thOffset:Int;

    var OPTIONS = { texRepeatX:true, texRepeatY:true, blend:true };


	public static var program:Program;

	public var body:Body;
	public var buffer:Buffer<Sea>;

	public function new(buffer:Buffer<Sea>, world:World, c:Color, _options:BodyOptions) {
		var options = _options;

		this.h = options.shape.height;
		this.w = options.shape.width;
		this.color = c;

		options.x = _options.x + (this.w * 0.5);
		options.y = _options.y + (this.h * 0.5);

		this.x = options.x;
		this.y = options.y;

		body = world.make(options);
		body.on_move = onMove.bind(buffer, _);

		buffer.addElement(this);
	}

	function set_w(new_w) {
		if (this.body != null) this.body.scale_x = -new_w;
		return this.w = new_w;
	}

	public function kill() {
		this.buffer.removeElement(this);
		this.body.remove();
	}

	public function onMove(buffer:Buffer<Sea>, x:Float, y:Float) {
		setPosition(x, y);
		buffer.updateElement(this);
	}
}
