{strip}
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>AdressBooX: {$title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="expires" content="0">
		<meta name="language" content="de">
		<meta name="author" content="{$_website_autor}">
		<meta name="generator" content="Notepad++">
		<meta name="description" content="Adressbuch">
		<meta name="keywords" content="Adressbuch, AdressbooX">
		<meta name="robots" content="all">
		<link rel="stylesheet" type="text/css" href="/include/stylesheets/main.css">
		<link rel="shortcut icon" type="image/ico" href="/include/icons/favicon.ico"/>
	</head>

	<body class="body">
	
	<table align="left" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<img src="/include/images/style/header.png" border="0"><br>
				<a href="/book" class="link">Adressbuch</a> - <a href="/person" class="link">Person</a> - <a href="/search" class="link">Suche</a> - <a href="/edit" class="link">Einstellungen</a>
			</td>
		</tr>
		<tr>
			<td>
				<div class="body">
					{include file=$template}
				</div>
			</td>
		</tr>
		<tr>
			<td align="center"><br>
				<div style="font-family:verdana; font-size:12px; color:black; padding-top:5px;">(c) {$_website_year} by {$_website_autor}<br><br>Version {$_website_version}</div>
			</td>
		</tr>
	</table>
	
	</body>
</html>
{/strip}