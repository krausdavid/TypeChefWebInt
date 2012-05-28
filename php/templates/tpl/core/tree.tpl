{strip}
	{$langTXT_actualProject}:&nbsp;
	<form method="post" action="{$_wud}/?lang={$smarty.get.lang}" style="display:inline">
		<select name="project" size="1">
			<optgroup label="{$langTXT_projects}">
				{foreach from=$projects_list item=projects_list name=projects_list_name}
					<option value="_{$projects_list.name}" {if $projects_list.selected eq true}selected{/if} onclick="this.form.submit();">{$projects_list.name}</option>
				{foreachelse}
					<option value="_" selected>{$langTXT_noProjectsExist}</option>
				{/foreach}
			</optgroup>
				<optgroup label="{$langTXT_options}">
				<option value="new" onclick="form.action='{$_wud}/project?choice=new&lang={$smarty.get.lang}';this.form.submit();">{$langTXT_newProject}</option>
				<option value="match" onclick="form.action='{$_wud}/project?choice=match&lang={$smarty.get.lang}';this.form.submit();">{$langTXT_compareTwoProjects}</option>
			</optgroup>
		</select>
	</form>
	
	{if $project_name neq "emptytree/empty"}
	<form method="post" action="{$_wud}/?lang={$smarty.get.lang}" style="display:inline">
		&nbsp;<input type="submit" value="{$langTXT_deleteProject}" name="cmd_delete_project" class="button" />
	</form>
	{/if}
	
	<div style="position:absolute; top:0; left:0;"><table border=0><tr><td><font size=-2><a style="font-size:6pt;text-decoration:none;color:black" href="http://www.treemenu.net/" target=_blank>with Javascript Tree Menu</a></font></td></tr></table></div>
	<div class="treeview">
		<script>initializeDocument()</script>
		<noscript>
			{$langTXT_pleaseActivateJavaScript}
		</noscript>
	</div>
	{if $project_name neq "emptytree/empty"}
		<input type="button" onClick="check_boxes();" value="{$langTXT_evaluation}" class="button" />
	{/if}
{/strip}