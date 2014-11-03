package cybermonk;

#if sys
import sys.io.File;
#end

import Markdown;

using StringTools;

typedef WikiConfig = {

	/** Path to the image directory */
	var imagePath : String;

	/** Callback for creating links */
	var createLink : String->String;
}

class Markmedown 
{


	// strike out 
	static var E_strikeout = ~/~~([^<>]*?)~~/g;

	// markdown image
	static var E_image = ~/\[(.*?)\]\((.*?)\)/;



	public var config : WikiConfig;

	public function new( config : WikiConfig ) {
		this.config = config;
	}

	public function format( t : String ) : String 
	{

		// // Console.log(t);
		// Console.log("///////////// - " + t);

		// if (E_image.match(t)){
		// 	Console.debug (E_image.matched(1));
		// 	Console.debug (E_image.matched(2));
		// }

		/*
		var _arr = t.split('\n');
		Console.log (_arr.length);
		var _store = '';
		for (i in 0..._arr.length) 
		{

			if (E_image.match(_arr[i])){
				Console.debug (E_image.matched(1));
				Console.debug (E_image.matched(2));
				if(E_image.matched(2).indexOf("http") == -1)
				{
					Console.debug(config.imagePath);
					Console.debug('http is not : ' + _arr[i]);
					_store += "!["+E_image.matched(1)+"](../../.." + config.imagePath + _arr[i].split(config.imagePath)[1] + "\n";
				}
			} else {
				_store += _arr[i] + "\n";

			}

		}

		t = _store;
		*/

		// [mck] for some reason the strikeout doesn't work in Markdown, but it did in Markup
		t = E_strikeout.replace( t, '<span style="text-decoration:line-through;">$1</span>' );

		t = Markdown.markdownToHtml( t );

		// [mck] perhaps need to reset the comment in markdown, they are fine to hide content
		t = t.split ("&lt;!--").join("<!--");

		return t;
	}

}