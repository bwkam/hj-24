package displays;

import peote.ui.PeoteUIDisplay;
import peote.ui.style.interfaces.StyleID;
import peote.view.Color;
import peote.view.text.Text;
import peote.view.text.TextProgram;

class UI extends PeoteUIDisplay {
    var scoreScale:Int = 30;
    var text:Text;
    var textProgram:TextProgram;

    override public function new(x:Int, y:Int, width:Int, height:Int, color:Color=0x00000000, maxTouchpoints:Int = 3, availableStyles:Array<StyleID> = null, autoAddStyles:Null<Bool> = null) {
        super(x, y, width, height, color, maxTouchpoints, availableStyles, autoAddStyles);
        
        textProgram = new TextProgram();
        
        text = new Text(0, 10, lib.Utils.formatScore(0, 9), {letterWidth: scoreScale, letterHeight: scoreScale});
        text.x = this.width - (text.text.length * scoreScale) - 10; 
        text.fgColor = Color.BLACK;
        
        textProgram.add(text);

        this.addProgram(textProgram);
    }

    public function updateScore(x:Int) {
        text.text = lib.Utils.formatScore(x, 9);      
        text.x = this.width - (text.text.length * text.letterWidth);
        textProgram.update(text, true);
    }

} 