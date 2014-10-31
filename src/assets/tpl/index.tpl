<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>::title::</title>
	<meta name="author" content="::author::">
	<meta name="description" content="::description::">
	<meta name="keywords" content="::keywords::">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="generator" content="CyberMonk ::cyberMonk_version::" />
	<link rel="stylesheet" href="css/base.min.css">
	<link rel="stylesheet" href="css/custom.css">
	<link rel="alternate" type="application/atom+xml" title="::title:: - feed" href="atom.xml" />
	<link rel="icon" href="favicon.ico">  
	<!--   
	<link rel="apple-touch-icon-precomposed" href="/docs/apple-touch-icon.png">
	-->
	<link href='http://fonts.googleapis.com/css?family=Dosis' rel='stylesheet' type='text/css'>
</head>

<body>
<!--
	title > ::title::
	author > ::author::
	description > ::description::
	keywords > ::keywords::
	url > ::url::
	id > ::id:: 
	layout > ::layout:: 
	date > ::date:: 
	tags > ::tags:: 
	css > ::css:: 
	path > ::path:: 
	version <em>::cyberMonk_version::</em> :
-->

	<header class="p2 white bg-dark-gray">
		<div class="container">
			<div class="table">
			<div class="table-cell p0"><a href="::url::"><img src="img/monkfeather.svg" width="200px" height="200px" title="Monk" alt="Monk"/></a></div>
			<div class="table-cell ">
				<h1 class="m0">::title::</h1>
				<h2 class="m0">::description::</h2>
			</div>
			</div>
		</div>	
	</header>

	<main class="container px2 overflow-hidden">

		::foreach posts::
		<section class="py3">
			<h1 class="md-h1 mb2 center"><a href="::path::" title="::title::">::title::</a></h1>
			<h5 class="pb1 center">::date.datestring::</h5>
			<hr class="bg-dark-gray">
			<p class="md-col-9 bg-lighter-gray">::html::</p>
		</section>

		<hr class="ml0 col-5 sm-col-3 hr-block bg-blue">
		::end::

	</main>

	<div class="container px2">
		<footer class="py4 center">
		Made with
		<svg class="icon red" xmlns="http://www.w3.org/2000/svg" viewbox="0 0 32 32">
			<path d=" M0 10 C0 6, 3 2, 8 2 C12 2, 15 5, 16 6 C17 5, 20 2, 24 2 C30 2, 32 6, 32 10 C32 18, 18 29, 16 30 C14 29, 0 18, 0 10 ">
		</svg>
		<!-- Made with love by <a href="::url::">::author::</a> -->
		by <b>::author::</b>
		</footer>
	</div>

	<!-- This blog is generated CyberMonk version ::cyberMonk_version:: -->

</body>
</html>
