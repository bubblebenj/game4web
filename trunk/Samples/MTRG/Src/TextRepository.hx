/**
 * ...
 * @author de
 */

package ;

class AllTexts extends haxe.xml.Proxy < "../WWW/SWF/Data/Texts.xml", String > 
{
}

class TextRepository 
{
    public static var all = new Hash<String>();
    public static var list = new AllTexts(all.get);
}