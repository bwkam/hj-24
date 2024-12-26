package lib;

class Utils {
    public static function formatScore(number:Int, width:Int):String {
        var str = Std.string(number);
        
        while (str.length < width) {
            str = "0" + str;
        }
        
        return str;
    }
}