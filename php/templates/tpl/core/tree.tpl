{strip}
	Aktuelles Projekt:&nbsp;
	<select name="project" size="1">
		{foreach from=$projects_list item=projects_list name=projects_list_name}
			<option value="{$projects_list.id}" {if $projects_list.selected eq true}selected{/if}>{$projects_list.name}</option>
		{/foreach}
		<option value="-">---</option>
		<option value="new">Neues Projekt...</option>
		<option value="match">Zwei Projekte vergleichen</option>
	</select>
	{* Laut Copyright sollte dieser Text angezeigt werden. Schriftgröße ist auf 0pt für Design und Testzwecke,
	   vielleicht sollte man beim Entwickler nachfragen, ob er für die Uni Marburg was springen lässt ;) *}
	<DIV style="position:absolute; top:20; left:0;"><TABLE border=0><TR><TD><FONT size=-2><A style="font-size:0pt;text-decoration:none;color:white" href="http://www.treemenu.net/" target=_blank>Javascript Tree Menu</A></FONT></TD></TR></TABLE></DIV>
	<div class="treeview">
		<SCRIPT>initializeDocument()</SCRIPT>
		<NOSCRIPT>
		Bitte aktivieren Sie JavaScript!
		</NOSCRIPT>
	</div>
	<INPUT type="button" onClick="check_boxes()" value="Evaluation">
{/strip}