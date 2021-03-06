﻿{strip}
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
       "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>{$_website_name}: {$title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta http-equiv="expires" content="0"/>
		<meta name="language" content="de"/>
		<meta name="author" content="{$_website_autor}"/>
		<meta name="generator" content="Notepad++"/>
		<meta name="description" content="TypeChef WebInterface"/>
		<meta name="keywords" content="TypeChef WebInterface,TypeChef,WebInterface,TypeChefWebInt"/>
		<meta name="robots" content="all"/>
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/main.css"/>
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/form.css"/>
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/table.css"/>
		<link rel="stylesheet" type="text/css" href="{$_wud}/include/stylesheets/links.css"/>
		<link rel="shortcut icon" type="image/ico" href="{$_wud}/include/icons/favicon.ico"/>

		{* Scripts for TreeView *}
		<script src="{$_wud}/include/javascripts/treeview/ua.js"></script>
		<script src="{$_wud}/include/javascripts/treeview/ftiens4.js"></script>
		{if $project_name neq "emptytree/empty"}
			<script src="{$_wud}/generics/treeview/{$project_name}{if $showOnlyErrors eq true}.err{/if}{if $rights neq true}.nochk{/if}.js"></script>
		{else}
			<script src="{$_wud}/generics/treeview/emptytree/empty.js"></script>
		{/if}
		{* Scripts for SyntaxHighlighter *}
		<script type="text/javascript" src="{$_wud}/include/javascripts/syntaxhighlighter/shCore.js"></script>
		<script type="text/javascript" src="{$_wud}/include/javascripts/syntaxhighlighter/shBrushCpp.js"></script>
		<script type="text/javascript" src="{$_wud}/include/javascripts/syntaxhighlighter/shBrushXml.js"></script>
		<link type="text/css" rel="stylesheet" href="{$_wud}/include/stylesheets/syntaxhighlighter/shCoreDefault.css"/>
		<script type="text/javascript">SyntaxHighlighter.all();</script>
			<script>
				function check_boxes(){literal}{
					var outStr = "";
					for(var i = 0; i<MAX_LENGTH; i++){
						if(document.getElementById('chkbox'+i)!=null && document.getElementById('chkbox'+i).checked){
							outStr = outStr + 'chkbox'+ i + "_";
						}
					}{/literal}
					location.href="{$_wud}/execute?chkStr="+outStr;
				}
			</script>
		<!--[if lt IE 7.]>
			<script defer type="text/javascript" src="{$_wud}/include/javascripts/pngfix/pngfix.js"></script>
		<![endif]-->
	</head>

	<body class="body">
		<table align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="right">
					<a href="{$_wud}/?lang=DE-DE&redirect={$redirectURL}"><img src="{$_wud}/include/images/lang/DE-DE.png" border="0" alt="DE-DE" /></a> <a href="{$_wud}/?lang=EN-US&redirect={$redirectURL}"><img src="{$_wud}/include/images/lang/EN-US.png" border="0" alt="EN-US" /></a>
					<table align="center" border="0" cellpadding="0" cellspacing="0" class="table">
						<colgroup>
							<col width="400">
							<col width="600">
						</colgroup>
						<tr>
							<td align="center" colspan="2" class="body_header">
								TypeChef - WebInterface
							</td>
						</tr>
						<tr valign="top" class="body_main">
							<td>
								<table valign="top" align="left" border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<td class="body_tree" align="left">{include file="./core/navigation_pane.tpl"}</td>
									</tr>
									<tr>
										<td class="body_tree_nobottomborder" align="left">
											{include file="./core/tree.tpl"}
										</td>
									</tr>
								</table>
							</td>
							<td>
								<table align="left" valign="top" border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr class="body_main">
										<td height="25" class="body_menu">
											&nbsp;<a href="{$_wud}/" class="menu_link">{$langTXT_homepage}</a> - {$langTXT_hello} {$login_username} - {if $rights neq true}<a href="{$_wud}/login" class="menu_link">{$langTXT_login}</a>{else}{$langTXT_settings} - <a href="{$_wud}/logout" class="menu_link">{$langTXT_logout}</a>{/if}
										</td>
									</tr>
									<tr>
										<td class="content">
											{if $error_projectDeleted eq true && $rights eq true && $error_projectDeleted_project_new neq ""}
												<div class="info_message">
													<b>{$langINF_information}</b><br/><br/>
													{$langINFTXT_deletedProject_PART1} {$error_projectDeleted_project_old} {$langINFTXT_deletedProject_PART2} {$error_projectDeleted_project_new} {$langINFTXT_deletedProject_PART3}
												</div>
												<br/><br/>
											{/if}
											{include file=$template}
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td align="center" colspan="2" class="body_footer"><br>
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