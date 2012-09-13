{strip}
	<div style="position:absolute; top:0; left:0;"><table border=0><tr><td><font size=-2><a style="font-size:6pt;text-decoration:none;color:black" href="http://www.treemenu.net/" target=_blank>with Javascript Tree Menu</a></font></td></tr></table></div>
	<div class="treeview">
	<script>initializeDocument()</script>
	<noscript>
		{$langTXT_pleaseActivateJavaScript}
	</noscript>
	</div>
	{if $project_name neq "emptytree/empty" && $rights eq true}
		<input type="button" onClick="check_boxes();" value="{$langTXT_evaluation}" class="button" />
	{/if}
{/strip}