
	Aktuelles Projekt:&nbsp;
	<form method="post" action="{$_wud}/" style="display:inline">
		<select name="project" size="1">
			<optgroup label="Projeke">
				{foreach from=$projects_list item=projects_list name=projects_list_name}
					<option value="_{$projects_list.name}" {if $projects_list.selected eq true}selected{/if} onclick="this.form.submit();">{$projects_list.name}</option>
				{/foreach}
			</optgroup>
				<optgroup label="Optionen">
				<option value="new" onclick="form.action='{$_wud}/project?choice=new';this.form.submit();">Neues Projekt...</option>
				<option value="match" onclick="form.action='{$_wud}/project?choice=match';this.form.submit();">Zwei Projekte vergleichen</option>
			</optgroup>
		</select>
	</form>
	<div style="position:absolute; top:0; left:0;"><table border=0><tr><td><font size=-2><a style="font-size:6pt;text-decoration:none;color:black" href="http://www.treemenu.net/" target=_blank>with Javascript Tree Menu</a></font></td></tr></table></div>
	<div class="treeview">
		<script>initializeDocument()</script>
		<noscript>
			Bitte aktivieren Sie JavaScript!
		</noscript>
	</div>
	<input type="button" onClick="check_boxes();" value="Evaluation" />
