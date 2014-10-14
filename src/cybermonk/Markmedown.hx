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


	static var E_img = ~/@([ A-Za-z0-9._-]+)@/g;
	static var E_img_withtitle = ~/@([ A-Za-z0-9._-]+)\|(.*?)@/g;

	static var E_strikeout = ~/~~([^<>]*?)~~/g;

	public var config : WikiConfig;

	public function new( config : WikiConfig ) {
		this.config = config;
	}

	public function format( t : String ) : String 
	{

		// [mck] for some reason the strikeout doesn't work in Markdown, but it did in Markup
		t = E_strikeout.replace( t, '<span style="text-decoration:line-through;">$1</span>' );

		t = Markdown.markdownToHtml( t );

		// [mck] perhaps need to reset the comment in markdown, they are fine to hide content

		return t;
	}

}