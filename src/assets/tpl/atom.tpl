<?xml version="1.0" encoding="utf-8"?>
 
<feed xmlns="http://www.w3.org/2005/Atom">
 
	<title>::title::</title>
	<subtitle>::description::</subtitle>
	<link rel="self" href="::url::atom.xml" />
	<link href="::url::atom.xml" />
	<link rel="alternate" type="text/html" hreflang="en" href="::url::"/>
	<updated>::now.utc::</updated>
	<id>::url::</id>
	<generator version="::cyberMonk_version::">cybermonk</generator>
	<author>
		<name>::author::</name>
		<uri>::url::</uri>
	</author>
	<id>::url::</id>
 	
	::foreach posts::
	<entry>
		<title>::title::</title>
		<link href="::url::::path::" />
		<id>::url::::path::</id>
		<updated>::date.utc::</updated>
		<content type="xhtml">
			<div xmlns="http://www.w3.org/1999/xhtml">
				<p>::html::</p>
			</div>
		</content>
		<author>
			<name>::author::</name>
		</author>
	</entry>
	::end::
 
</feed>