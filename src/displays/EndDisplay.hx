package displays;

import lime.graphics.Image;
import lime.ui.Window;
import peote.text.Font;
import peote.ui.PeoteUIDisplay;
import peote.ui.interactive.Interactive;
import peote.ui.interactive.UIElement;
import peote.ui.interactive.UITextLine;
import peote.ui.style.RoundBorderStyle;
import peote.ui.style.interfaces.FontStyle;
import peote.ui.style.interfaces.StyleID;
import peote.view.Buffer;
import peote.view.Color;
import peote.view.Element;
import peote.view.PeoteView;
import peote.view.Program;
import peote.view.Texture;
import peote.view.element.Elem;
import peote.view.text.Text;
import peote.view.text.TextProgram;
import sprites.Fish;
import utils.Loader;

using tweenxcore.Tools;


class EndDisplay extends PeoteUIDisplay  {

    override public function new(end:Bool, window:Window, x:Int, y:Int, width:Int, height:Int, color:Color=0x00000000, maxTouchpoints:Int = 3, availableStyles:Array<StyleID> = null, autoAddStyles:Null<Bool> = null) {
        super(x, y, width, height, color, maxTouchpoints, availableStyles, autoAddStyles);
        var scoreScale = 40;

        var textProgram = new TextProgram();
        
		var text1 = null; 
		var text2 = null; 
        
        
        if (end) {
            text1 = new Text(0, 10, 'u lost :sob:', {letterWidth: scoreScale, letterHeight: scoreScale});
            text2 = new Text(0, 10, 'go play smth else', {letterWidth: scoreScale, letterHeight: scoreScale});
        } else {
            text1 = new Text(0, 10, 'thanks for playing', {letterWidth: scoreScale, letterHeight: scoreScale});
            text2 = new Text(0, 10, ':)', {letterWidth: scoreScale, letterHeight: scoreScale});
        }
		
        text1.x = Std.int((this.width - (scoreScale * text1.text.length)) / 2); 
        text1.y = Std.int((this.height - scoreScale) / 2) - 20; 
        
        text2.x = Std.int((this.width - (scoreScale * text2.text.length)) / 2); 
        text2.y = Std.int((this.height - scoreScale) / 2) + 20; 
        

        text1.fgColor = Color.WHITE;
        text2.fgColor = Color.WHITE;
        
        textProgram.add(text1);
        textProgram.add(text2);


		PeoteUIDisplay.registerEvents(window);

        this.addProgram(textProgram);
    }

}


