{strip}
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>{$_website_name}: {$title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="expires" content="0">
		<meta name="language" content="de">
		<meta name="author" content="{$_website_autor}">
		<meta name="generator" content="Notepad++">
		<meta name="description" content="TypeChef WebInterface">
		<meta name="keywords" content="TypeChef WebInterface,TypeChef,WebInterface,TypeChefWebInt">
		<meta name="robots" content="all">
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/main.css">
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/form.css">
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/table.css">
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/links.css">
		<link rel="shortcut icon" type="image/ico" href="{$_wud}/include/icons/favicon.ico"/>
		{* Skripte für TreeView *}
		<SCRIPT src="{$_wud}/include/javascripts/treeview/ua.js"></SCRIPT>
		<SCRIPT src="{$_wud}/include/javascripts/treeview/ftiens4.js"></SCRIPT>

		{* TODO: Muss generisch werden!!! *}
		<SCRIPT src="{$_wud}/generics/treeview/busybox.js"></SCRIPT>
		<SCRIPT>
			function check_boxes(){literal}{
				var outStr = ""
				for(var i = 0; i<MAX_LENGTH; i++){
					if(getElById('chkbox'+i).checked){
						outStr = outStr + 'chkbox'+ i + "_"
					}
				}{/literal}
				location.href="{$_wud}/execute?chkStr="+outStr
			}
		</SCRIPT>
		<!--[if lt IE 7.]>
			<script defer type="text/javascript" src="{$_wud}/include/javascripts/pngfix/pngfix.js"></script>
		<![endif]-->
	</head>

	<body class="body">
		<table align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table align="center" border="1" cellpadding="0" cellspacing="0" class="table">
						<colgroup>
							<col width="400">
							<col width="600">
						</colgroup>
						<tr>
							<td align="center" colspan="2">
								TypeChef - WebInterface
							</td>
						</tr>
						<tr valign="top">
							<th rowspan="2">{include file="./core/tree.tpl"}</th>
							<td height="25">
								<a href="{$_wud}/" class="link">Startseite</a> {* - <a href="{$_wud}/reload_tree" class="link">Baum aktualisieren</a>*} - {if $login neq true}<a href="{$_wud}/login" class="link">Login</a>{else}Hallo {$login_username} <a href="{$_wud}/logout" class="link">Logout</a>{/if}
							</td>
						</tr>
						<tr>
							<td valign="top">{include file=$template}</td>
						</tr>
						<tr>
							<td align="center" colspan="2"><br>
								<div style="font-family:verdana; font-size:12px; color:black; padding-top:5px;">(c) {$_website_year} by {$_website_autor}<br><br>Version {$_website_version}</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
</html>
{/strip}
