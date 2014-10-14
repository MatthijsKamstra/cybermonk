<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
	<channel>
		<title>::title::</title>
		<description>::description::</description>
		<link>::url::</link>
		<pubDate>Thu, 27 Apr 2006</pubDate>
		<pubDate>::now.utc::</pubDate>
		<generator>CyberMonk</generator>

		::foreach posts::
		<item>
			<title>::title::</title>
			<description>::description::</description>
			<link>::url::::path::</link>
			<pubDate>::date.utc::</pubDate>
		</item>
		::end::
	

		::now::
	</channel>
</rss>