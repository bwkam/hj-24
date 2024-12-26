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
}