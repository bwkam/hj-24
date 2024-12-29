package lib;

import lime.ui.Window;

class Math {
    public static function roundToPrecision(number:Float, precision:Int = 0):Float {
		var decimalPlaces = std.Math.pow(10, precision);
		return std.Math.fround(decimalPlaces * number) / decimalPlaces;
	}

	public static function roundToNearest(number:Float, nearest:Float = 1.0):Float {
		if (nearest == 0) {
			return number;
		}
		return std.Math.fround(roundToPrecision(number / nearest, 10)) * nearest;
	}

	public static function getTargetOffset(window:Window, zoom:Float, target:Float) {
		var zoom = 1.0; 
		var view_center_x = (window.width / 2) / zoom;

		var x_scroll_min = view_center_x;
		if (target < x_scroll_min) {
			view_center_x = x_scroll_min; 
		} else {
			var x_scroll_max = window.width - view_center_x;
			if (target > x_scroll_max) {
				view_center_x = x_scroll_max; 
			}
		}

		var offset_x = -Std.int((target - view_center_x) * zoom);
	
		return offset_x;
	}

	public static function lerp(a:Float, b:Float, t:Float):Float {
        return a + (b - a) * t;
    }
	// public static function distribute(levels:Int, base:Int, decay:Int) {
	// 	var weights:Map<Int, Float> = new Map();
	// 	for (level in 0...levels) {
	// 		var weight = base * std.Math.pow(1 - (decay / 100), level);
	// 		weights.set(level + 1, (weight / base) * 100);
	// 	}
	// 	return weights;
	// }

	public static function distribute(value:Float, levels:Int, decay:Float):Map<Int, Float> {
		var weights:Map<Int, Float> = new Map();
		var totalWeight:Float = 0;

		// Calculate the total weight based on decay
		for (level in 0...levels) {
			totalWeight += std.Math.pow(1 - decay, level);
		}

		// Distribute the value among levels proportionally
		for (level in 0...levels) {
			var weight = std.Math.pow(1 - decay, level) / totalWeight;
			weights.set(level + 1, value * weight);
		}

		return weights;
	}

	public static function hexToRgb(hex:String):{r:Int, g:Int, b:Int} {
		var hexStr = hex.substr(1); // Remove the '#' character
		var r = Std.parseInt('0x' + hexStr.substr(0, 2));
		var g = Std.parseInt('0x' + hexStr.substr(2, 2));
		var b = Std.parseInt('0x' + hexStr.substr(4, 2));

		return {r: r, g: g, b: b};
	}

	public static function deltaDx(vi:Float, t:Float, acc:Float) {
		return (-vi * (t / 2)) + (0.5 * acc * std.Math.pow(t / 2, 2));
	}
	inline public static function randomRange(min:Int, max:Int):Int {
		return min + Std.random(max - min);
	}
}