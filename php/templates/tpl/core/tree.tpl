{strip}
	<table align="left" border="0" cellpadding="0" cellspacing="0" class="content">
		<tr>
			<td><b>{$langTXT_actualProject}</b></td>
			<td><b>{$langTXT_deltas}</b></td>
			<td><b>{$langTXT_showOnlyErrors}</b></td>
		</tr>
		<tr>
			<td>
				<form method="post" action="{$_wud}/" style="display:inline">
					<select name="project" size="1">
						<optgroup label="{$langTXT_projects}">
							{foreach from=$projects_list item=projects_list name=projects_list_name}
								<option value="_{$projects_list.name}" {if $projects_list.selected eq true}selected{/if} onclick="this.form.submit();">{$projects_list.name}</option>
							{foreachelse}
								<option value="-" selected>{$langTXT_noProjectsExist}</option>
							{/foreach}
						</optgroup>
						{if $rights eq true}
							<optgroup label="{$langTXT_options}">
								<option value="new" onclick="form.action='{$_wud}/project?choice=new';this.form.submit();">{$langTXT_newProject}</option>
								<option value="match" onclick="form.action='{$_wud}/project?choice=match';this.form.submit();">{$langTXT_compareTwoProjects}</option>
							</optgroup>
						{/if}
					</select>
				</form>
			</td>
			<td>
				<form method="post" action="{$_wud}/" style="display:inline">
					<select name="deltas" size="1">
						<option value="_{$project_name_origin}" onclick="this.form.submit();">{$langTXT_mainproject}</option>
							{foreach from=$projects_deltas item=projects_deltas name=projects_deltas_name}
								<option value="_{$projects_deltas.name}" {if $projects_deltas.selected eq true}selected{/if} onclick="this.form.submit();">{$projects_deltas.name}</option>
							{/foreach}
					</select>
				</form>
			</td>
			<td>
				<form method="post" action="{$_wud}/?redirect={$redirectURL}" style="display:inline">
					<input type="checkbox" value="checked" name="chk_showOnlyErrors" onclick="this.form.submit();" {if $showOnlyErrors eq true}checked {/if}/>
					<input type="hidden" name="showOnlyErrors_val" value="val" />
				</form>
			</td>
		</tr>
	</table>
	<br/>
	{if $project_name neq "emptytree/empty" && $rights eq true}
		<form method="post" action="{$_wud}/" style="display:inline">
			&nbsp;<input type="submit" value="{$langTXT_deleteProject}" name="cmd_delete_project" class="button" />
		</form>
	{/if}
	<br/><br/>
	
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