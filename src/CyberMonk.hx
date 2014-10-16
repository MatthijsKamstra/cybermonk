package ;

import sys.FileSystem;
import sys.io.File;
import haxe.Template;
import haxe.Timer;
import haxe.io.Path;
import Sys.println;
import Sys.print;
import Sys.stdin;

import cybermonk.Markmedown;

#if macro
import haxe.macro.Context;
#end

using StringTools;

private typedef Config = {
	var url : String;
	var src : String;
	var dst : String;
	@:optional var title : String;
	@:optional var description : String;
	@:optional var keywords : Array<String>;
	// @:optional var keywords : String;
	@:optional var num_index_posts : Int; // num posts shown on index site
	@:optional var author : String;
	@:optional var img : String;
}

private typedef DateTime = {
	var year : Int;
	var month : Int;
	var day : Int;
	var utc : String;
	var datestring : String;
	//var pub : String;
}

private typedef Site = { 
	var title : String;
	var date : DateTime;
	var content : String; 		// markdown
	var html : String; 			// markdown converted to html
	var layout : String;		// post is the only option?
	var css : Array<String>;
	var tags : Array<String>;
	var description : String;
	var author : String;
	@:optional var url : String;
	@:optional var src : String;
	@:optional var dst : String;
	@:optional var img : String;
}

private typedef Post = { > Site,
	var id : String;
	var path : String;
	var keywords : String;
}

/**
 * @author Matthijs Kamstra
 * MIT
 * http://www.matthijskamstra.nl
 */
class CyberMonk
{

	public static inline var VERSION = "0.4.0";
	public static var HELP(default,null) = buildHelp();
	public static inline var BUILD_INFO_FILE = '.cybermonk';

	// [mck] default config
	public static var cfg : Config = {
		url : "http://www.cybermonk.com/",
		src : "src/",
		dst : "out/",
		title : "CyberMonk blog generator",
		description : "Short description of the blog",
		keywords : ["blog, cybermonk, [mck]"],
		num_index_posts : 10,
		author : "Monk",
		img : "/img/"
	};

	static var lastBuildDate : Float = -1;
	static var siteTemplate : Template;
	static var posts : Array < Post>;
	static var markdown : Markmedown;

	static var e_site = ~/ *---(.+) *--- *(.+)/ms;
	static var e_header_line = ~/^ *([a-zA-Z0-9_\/\.\-]+) *: *([a-zA-Z0-9!_,\/\[\]\.\-\?\(\)\s]+) *$/;
	static var e_post_filename = ~/^([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])-([a-zA-Z0-9_,!\.\-\?\(\)\+]+)$/;

	/**
	 * CyberMonk
	 */
	public function new():Void
	{
		Console.start();
	
		var timestamp = Timer.stamp();

		// Read/Parse config
		var path_cfg = cfg.src + '_config.json';
		if( FileSystem.exists( path_cfg ) ) 
		{
			var content = File.getContent( path_cfg );
			cfg = haxe.Json.parse ( content );
		} else {
			Console.warn( 'no config file found' );
		}

		// [mck] when is the last time there was a build
		if( FileSystem.exists( BUILD_INFO_FILE ) ) {
			lastBuildDate = Date.fromString( File.getContent( BUILD_INFO_FILE ) ).getTime();
		}

		var args = Sys.args();
		var cmd = args[0];
		if( cmd == null ) cmd = 'help';
		switch cmd {
			case "help", 'h'					: exit( HELP );
			case "version", "v"					: exit( VERSION );
			case 'start', 'generate', 'init' 	: cmdGenerate();
			case 'config' 						: cmdConfig();
			case 'clean' 						: cmdClean();
			case 'build' 						: cmdBuild();
			case 'update' 						: cmdUpdate();
			case 'post' 						: cmdPost();
		}

		// [mck] establish bragging rights
		println( '$cmd is DONE in : ${Std.int((Timer.stamp()-timestamp)*1000)}ms' );
	}

	// ____________________________________ cmd functions ____________________________________

	function cmdGenerate():Void
	{
		// [mck] generate the default folders
		if( !FileSystem.exists( cfg.src ) ) FileSystem.createDirectory (cfg.src);
		if( !FileSystem.exists( cfg.dst ) ) FileSystem.createDirectory (cfg.dst);	
		if( !FileSystem.exists( cfg.src + cfg.img ) ) FileSystem.createDirectory (cfg.src + cfg.img);	
		
		// generate templates
		if( !FileSystem.exists( cfg.src + '_drafts' ) ) FileSystem.createDirectory (cfg.src + '_drafts');
		if( !FileSystem.exists( cfg.src + '_layout' ) ) FileSystem.createDirectory (cfg.src + '_layout');
		if( !FileSystem.exists( cfg.src + '_posts' ) ) FileSystem.createDirectory (cfg.src + '_posts');
		if( !FileSystem.exists( cfg.src + 'css' ) ) FileSystem.createDirectory (cfg.src + 'css');

		// use embedded .html
		var indexStr = haxe.Resource.getString("index");
		var postStr = haxe.Resource.getString("post");
		// var t = new Template(str);
		// var output = t.execute(cfg);

		// Console.debug (cfg);


		var info = "---\n"+
		"title : Post CyberMonk\n" + 
		"tags : first, cybermonk, site\n" +
		"description : I should do something with this desc \n" +
		"author : [mck]\n" +
		"---\n";

		// writeFile (cfg.src + 'index.html' , output);
		writeFile (cfg.src + 'index.html' , info + indexStr);
		writeFile (cfg.src + '_layout/site.html' , indexStr);
		writeFile (cfg.src + '_layout/post.html' , info + postStr);

		// use embedded .css
		var cssStr = haxe.Resource.getString("css");
		writeFile (cfg.src + '/css/base.min.css' , cssStr);
		writeFile ( cfg.src + '/css/custom.css' , haxe.Resource.getString ('customcss') );

		// feeds
		var atomStr = haxe.Resource.getString("atom");
		var rssStr = haxe.Resource.getString("rss");

		// writeFile (cfg.src + 'feed.rss' , rssStr);
		writeFile (cfg.src + 'atom.xml' , atomStr);
		writeFile (cfg.src + 'htaccess' , "");

		var svgStr = haxe.Resource.getString("feather");
		writeFile (cfg.src + 'img/feather14.svg' , svgStr);
		writeFile (cfg.src + 'img/monkfeather.svg' , haxe.Resource.getString('monkfeather') );
		

		var favicon = haxe.Resource.getBytes('favicon');
		sys.io.File.saveBytes(cfg.src + 'favicon.ico' , favicon);

		writeFile (cfg.src + '_config.json' ,  haxe.Json.stringify(cfg, null, '\t'));

		buildPost('Welcome-CyberMonk');
		buildPost('Test-CyberMonk', -1);

		writeFile(cfg.src + '_drafts/test me.md', '*test*');

		Console.log( 'Generate' );
	}

	/**
	 * create a post, in the way CyberMonk want it
	 * @param  name      	this post needs a name
	 * @param  minusYear 	testing purposes, so we can generate a couple dummy posts
	 */
	function buildPost(name:String, minusYear:Int = 0):Void
	{
		// generate first post
		var _now:DateTime = getCurrentDate();
		_now.year = _now.year + minusYear;

		// var n = Date.now();
		// var dy = n.getFullYear() + minusYear;
		// var dm = n.getMonth()+1;
		// var dd = n.getDate();
		// var datestring = formatTimePart(dy)+"-"+formatTimePart(dm)+"-"+formatTimePart(dd);
		// var now : DateTime = {
		// 	year : dy,
		// 	month : dm,
		// 	day : dd,
		// 	datestring : formatTimePart(dy)+"-"+formatTimePart(dm)+"-"+formatTimePart(dd),
		// 	utc : formatUTC( dy, dm, dd )
		// }
		
		var info:String = "---\n" +
			"title : " + name.replace("-", " ").replace("_", " " ) + "\n" +
			"tags : first, cybermonk, post\n" +
			"description : what is this\n" +
			"author : " + cfg.author + "\n" +
			"---\n";

		var str = haxe.Resource.getString("markdown");

		writeFile (cfg.src + '_posts/' + _now.datestring + '-' + name + '.md' , info + str);
	}

	/**
	 * get the current date in a DateTime format
	 * var _now:DateTime = getCurrentDate();
	 * @return 		DateTime
	 */
	function getCurrentDate():DateTime
	{
		var n = Date.now();
		var dy = n.getFullYear();
		var dm = n.getMonth()+1;
		var dd = n.getDate();
		var datestring = formatTimePart(dy)+"-"+formatTimePart(dm)+"-"+formatTimePart(dd);
		var now : DateTime = {
			year : dy,
			month : dm,
			day : dd,
			datestring : formatTimePart(dy)+"-"+formatTimePart(dm)+"-"+formatTimePart(dd),
			utc : formatUTC( dy, dm, dd )
		}
		return now;
	}

	function cmdClean():Void
	{
		if( FileSystem.exists( cfg.dst ) ) {
			clearDirectory( cfg.dst );
			FileSystem.deleteDirectory( cfg.dst );
			println( 'Cleaned' );
		}
	}

	function cmdConfig():Void
	{
		if( lastBuildDate != -1 )
			println( 'Last build : ' + Date.fromTime( lastBuildDate ) );
		else
			println( 'Project not built' );
		for( f in Reflect.fields( cfg ) ) println( '$f : ' + Reflect.field( cfg, f ) );
		exit();
	}

	function cmdBuild():Void
	{

		// build info
		if( FileSystem.exists( BUILD_INFO_FILE ) ) {
			lastBuildDate = Date.fromString( File.getContent( BUILD_INFO_FILE ) ).getTime();
		}

		println( 'BUILD cyberMonk > ' + cfg.url );

		posts = new Array();
		markdown = new cybermonk.Markmedown( {
			imagePath : cfg.img,
			createLink : function(s){return s;}
		} );
		siteTemplate = new Template( File.getContent( cfg.src + '_layout/site.html' ) );

		FileSystem.exists( cfg.dst ) ? clearDirectory( cfg.dst ) : FileSystem.createDirectory( cfg.dst );	

		printPosts( cfg.src + "_posts" ); // write posts
		processDirectory( cfg.src ); // Write everything else

		var fo = File.write( BUILD_INFO_FILE );
		fo.writeString( Date.now().toString() );
		fo.close();

	}

	function cmdUpdate():Void
	{
		// [mck] check for most important file
		var path_cfg = cfg.src + '_config.json';
		if( !FileSystem.exists( path_cfg ) ) 
			println ( 'are you sure you don\'t mean "generate"?' );
		else 
			println( 'you choose "update", but that doesn\'t work yet' );	
		
	}

	function cmdPost():Void
	{
		buildPost('Post_CyberMonk');
		println ('post-template is done');
	}

	// ____________________________________ parse / print ____________________________________

	/**
	 * Parse file at given path into a 'Site' object
	 * 
	 * @param  path : String [description]
	 * @param  name : String [description]
	 * @return	: Site
	 */
	function parseSite( path : String, name : String ) : Site 
	{
		var fp = '$path/$name';
		var ft = File.getContent( fp );
		
		if( !e_site.match( ft ) ){
			Console.warn( 'Invalid html template [$fp]' );
		}

		var s : Site = cast {
			css : new Array<String>()
		};

		// Console.debug (e_site.matched(2));

		for( l in e_site.matched(1).trim().split("\n") ) {
			if( ( l = l.trim() ) == "" )
				continue;
			if( !e_header_line.match( l ) )
				Console.error( "Invalid template header ("+l+")" );
			var id 	= e_header_line.matched(1);
			var v 	= e_header_line.matched(2);
			switch( id ) {
				case "title": 			s.title = v;
				case "layout": 			s.layout = v;
				case "css": 			s.css.push(v);
				case "tags":
					s.tags = new Array();
					var tags = v.split( "," );
					for( t in tags ) 	s.tags.push( t.trim() );
				case "description": 	s.description = v;
				case "author": 			s.author = v;
				default : Console.log( 'Unknown header key ($id)' );
			}
		}
		s.content = e_site.matched(2);
		return s;
	}

	/**
	 * Process/Print posts
	 * @param  path 		The path to the post source
	 */
	function printPosts( path : String ) {

		// Console.log ( path );

		for( f in FileSystem.readDirectory( path ) ) {
			if( f.startsWith(".") )
				continue;
			
			// Console.debug (f);

			if( !e_post_filename.match( f.replace('.md' , '' ) ) ) 
			{	


				// print a message on the screen
		        // Sys.println("Do you want to update [$f]? [y/n]");
		        // // read user input
		        // var input = Sys.stdin().readLine();
		        // // print the result
		        // Sys.println("Hello " + input);


				var _now:DateTime = getCurrentDate();
				var newName:String = _now.datestring + "-" +f.replace(' ', '-');
				
				var ft = File.getContent(path + "/" + f );
		
				if( !e_site.match( ft ) ){
					Console.warn( 'Invalid html template [$ft]' );

					var info:String = "---\n" +
						"title : " + newName.replace("-", " ").replace("_", " " ) + "\n" +
						"tags : first, cybermonk, post\n" +
						"description : what is this\n" +
						"author : " + cfg.author + "\n" +
						"---\n";


					writeFile (path + "/" + f  , info + ft);

					println ('Added info to post [$f]');

				}

				Console.warn( 'Invalid filename for post [$f]' );

				FileSystem.rename(path + "/" + f, path + "/" + newName);

				println ('Changed name of post [$f] to ['+newName+']');


				continue;
			}





			// Console.debug (e_post_filename.match( f.replace('.md' , '' ) ));

			// Create site object
			var site : Site = parseSite( path, f );
			if( site.layout == null ) site.layout = "post";
			if( site.author == null ) site.author = cfg.author;

			// site.html = markup.format( site.content );
			// [mck] cyberchrist uses markup and 
			// I prefer markdown (http://daringfireball.net/projects/markdown/) 
			// which is also used on github for example
			
			site.html = markdown.format (site.content);

			
			// Console.debug (site.html);

			var d_year = Std.parseInt( e_post_filename.matched(1) );
			var d_month = Std.parseInt( e_post_filename.matched(2) );
			var d_day = Std.parseInt( e_post_filename.matched(3) );
			var utc = formatUTC( d_year, d_month, d_day );
			var date : DateTime = {
				year : d_year,
				month : d_month,
				day : d_day,
				datestring : formatTimePart( d_year )+"-"+formatTimePart( d_month )+"-"+formatTimePart( d_day ),
				utc : utc,
			}
			var post : Post = {
				id : e_post_filename.matched(4),
				title : site.title,
				content : site.content,
				html : site.html,
				layout : null,
				date : date,
				description : site.description,
				author : (site.author == null) ? cfg.author : site.author,
				tags : site.tags, //["disktree","panzerkunst","art"],
				keywords : ( site.tags != null ) ? site.tags.join(",") : null,
				css : new Array<String>(),
				path : null,
				url : cfg.url
			};
			var path = cfg.dst + formatTimePart( d_year );
			if( !FileSystem.exists( path ) ) FileSystem.createDirectory( path );
			path = path+"/" + formatTimePart( d_month );
			if( !FileSystem.exists( path ) ) FileSystem.createDirectory( path );
			path = path+"/" + formatTimePart( d_day );
			if( !FileSystem.exists( path ) ) FileSystem.createDirectory( path );
			post.path =
				formatTimePart( d_year )+"/"+
				formatTimePart( d_month )+"/"+
				formatTimePart( d_day )+'/${post.id}.html';
			posts.push( post );
		}
		
		// Sort posts
		posts.sort( function(a,b){
			if( a.date.year > b.date.year ) return -1;
			else if( a.date.year < b.date.year ) return 1;
			else {
				if( a.date.month > b.date.month ) return -1;
				else if( a.date.month < b.date.month ) return 1;
				else {
					if( a.date.day > b.date.day ) return -1;
					else if( a.date.month < b.date.day ) return 1;
				}
			}
			return 0;
		});
		
		// Write post html files
		var tpl = parseSite( cfg.src + "_layout", "post.html" );
		Console.log( 'Generating ${posts.length} posts : ' );
		for( p in posts ) {

			// Console.debug (p);

			var ctx = mergeObjects( {}, p );


			// Console.debug(tpl.content);

			ctx.content = new Template( tpl.content ).execute( p );

			// [mck] correct the image path...
			// this doesn't feel like the best place... but I don't want to use an absolut path like ::url::::path::
			var _depth = ctx.path.split('/');
			// Console.log (_depth.length);

			var _str = '';
			for (i in 0..._depth.length-1) {
				_str += "../";
			
			}



			// Console.log ([cfg.img, _str]);
			// Console.debug ('<img src="' );
			// ctx.content.split('<img src="' + cfg.img).join(_str);
			ctx.content = ctx.content.split('<img src="' ).join('<img src="' + _str);
			ctx.content = ctx.content.split('<link rel="stylesheet" href="css/' ).join('<link rel="stylesheet" href="'+_str+'css/');
			ctx.content = ctx.content.split('<a href="http://www.cybermonk.com/">' ).join('<a href="'+_str+'">');
			// Console.debug (ctx.content);

			// writeHTMLSite( cfg.dst + p.path, ctx );

			writeFile(cfg.dst + p.path, ctx.content);

			Console.log( "+ " + p.path);
		}
	}

	/**
	 * Run cyberMonk on given source directory
	 * 
	 * @param  path :             String [description]
	 * @return      [description]
	 */
	function processDirectory( path : String ) {

		Console.log ('$path');

		for( f in FileSystem.readDirectory( path ) ) {
			if( f.startsWith(".") )
				continue;
			var fp = path+f;
			if( FileSystem.isDirectory( fp ) ) {
				if( f.startsWith( "_" ) ) {
					// 
				} else {
					var d = cfg.dst+f;
					if( !FileSystem.exists(d) ) FileSystem.createDirectory( d );
					//TODO not just copy file but process
					copyDirectory( f );
					//processDirectory(f);
				}
			} else {
				if( f.startsWith( "_" ) ) {
					// --- ignore files starting with an underscore
				} else if( f == "htaccess" ) {
					File.copy( fp, cfg.dst + '.htaccess' );
				} else {
					var ext = Path.extension( f );
					//Console.log(ext);
					if( ext == null )
						continue;
					var ctx : Dynamic = createBaseContext();
					switch ext {
					case "xml","rss" :

						// Console.debug( cfg );

						var tpl = new Template( File.getContent(fp) );
						var _posts : Array<Post> = ctx.posts;
						//for( p in _posts ) p.content = StringTools.htmlEscape( p.content );
						
						// Console.debug( ctx );

						// Console.debug (tpl.execute( ctx ));

						writeFile( cfg.dst+f, tpl.execute( ctx ) );
					case "html" :
						var site = parseSite( path, f );
						var tpl = new Template( site.content );
						var content = tpl.execute( ctx );
						
						// [mck] not sure this does something clever.. ctx seems to be fine
						ctx = createBaseContext();
						ctx.content = content;
						ctx.html = content;

						// Console.debug(content); // klopt


						//trace(site.title);
						if( site.title != null ) ctx.title = site.title;
						if( site.description != null ) ctx.description = site.description;
						if( site.tags != null ) ctx.keywords = site.tags.join(",");

						ctx.title = cfg.title;
						ctx.description = cfg.description;

						Console.debug('ctx.title: ' + ctx.title + ' // ctx.description : ' + ctx.description );

						// [mck] okay... this needs some love...
						/**
						 * first the folder is being read, and so the index.html needs to have the correct header
						 * but for the generator it uses _layout/site.html, so there it doesn't need correct header
						 * it seems that the post.html and site.html are the same...
						 */
						writeHTMLSite( cfg.dst+f, ctx );
					default:
						File.copy( fp, cfg.dst+f );
					}
				}
			}
		}
	}

	/**
	 * Create the base context for printing templates
	 * @param  ?attach :             Dynamic [description]
	 * @return         [description]
	 */
	function createBaseContext( ?attach : Dynamic ) : Dynamic {
		var _posts = posts;
		var _archive = new Array<Post>();
		if( cfg.num_index_posts > 0 && posts.length > cfg.num_index_posts ) {
			_archive = _posts.slice( cfg.num_index_posts );
			_posts = _posts.slice( 0, cfg.num_index_posts );
		}
		var n = Date.now();
		var dy = n.getFullYear();
		var dm = n.getMonth()+1;
		var dd = n.getDate();
		var now : DateTime = {
			year : dy,
			month : dm,
			day : dd,
			datestring : formatTimePart(dy)+"-"+formatTimePart(dm)+"-"+formatTimePart(dd),
			utc : formatUTC( dy, dm, dd )
		}
		var ctx = {
			title : cfg.title,
			url : cfg.url,
			posts : _posts,
			archive : _archive,
			author : cfg.author,
			description: cfg.description,
			now : now,
			cyberMonk_version : VERSION
			//keywords : ["disktree","panzerkunst","art"]
			//mobile:
			//useragent
		};
		if( attach != null )
			mergeObjects( ctx, attach );
		return ctx;
	}

	// ____________________________________ time functions ____________________________________

	function formatUTC( year : Int, month : Int, day : Int ) : String {
		var s = new StringBuf();
		s.add( year );
		s.add( "-" );
		s.add( formatTimePart(month) );
		s.add( "-" );
		s.add( formatTimePart(day) );
		s.add( "T00:00:00Z" ); //TODO
		return s.toString();
	}

	function formatUTCDate( d : Date ) : String {
		return formatUTC( d.getFullYear(), d.getMonth()+1, d.getDate() );
	}

	function formatTimePart( i : Int ) : String {
		return if( i < 10 ) "0"+i else Std.string(i);
	}

	// ____________________________________ write / clear /  ____________________________________

	function writeFile( path : String, content : String ) {
		var f = File.write( path, false );
		f.writeString( content );
		f.close();
	}

	function writeHTMLSite( path : String, ctx : Dynamic ) {

		// Console.debug([path, ctx]);

		var t = siteTemplate.execute( ctx );
		var a   = new Array<String>();
		for( l in t.split( "\n" ) ) if( l.trim() != "" ) a.push(l);
		t = a.join( "\n" );
		writeFile( path, t );
	}

	function clearDirectory( path : String ) {
		for( f in FileSystem.readDirectory( path ) ) {
			var p = path+"/"+f;
			if( FileSystem.isDirectory( p ) ) {
				clearDirectory( p );
				FileSystem.deleteDirectory( p );
			} else {
				FileSystem.deleteFile( p );
			}
		}
	}

	function copyDirectory( path : String ) {
		var ps = cfg.src + path;
		for( f in FileSystem.readDirectory( ps ) ) {
			var s = '$ps/$f';
			var d = cfg.dst + '$path/$f';
			if( FileSystem.isDirectory( s ) ) {
				if( !FileSystem.exists(d) ) FileSystem.createDirectory( d );
				copyDirectory( '$path/$f' );
			} else {
				File.copy( s, d );
			}
		}
	}
	
	// ____________________________________ misc ____________________________________

	function exit( ?info : Dynamic ) {
		if( info != null ) Console.log( info );
		Sys.exit( 0 );
	}

	function mergeObjects<A,B,R>( a : A, b : B ) : R {
		for( f in Reflect.fields( b ) ) Reflect.setField( a, f, Reflect.field( b, f ) );
		return cast a;
	}

	// ____________________________________ help ____________________________________

	macro static function buildHelp() {
		var commands = [
		'start : Start new project (default files and templates)',
		'build : Build project',
		// 'release : Build project in release mode',
		'clean : Remove all generated files',
		'post : Create a post',
		'update : Update templates',
		'config : Print project config',
		'help : Print this help',
		'version : Print CyberMonk version'
		].map( function(v){ return '\t\t'+v; } ).join('\n');
  		return Context.makeExpr( 'CyberMonk $VERSION
\tUsage : cybermonk <command>
\tCommands :
${commands}', Context.currentPos() );
	}

    static public function main() { new CyberMonk(); }
}