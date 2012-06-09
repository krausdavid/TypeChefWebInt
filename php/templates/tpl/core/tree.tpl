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
	
	<div id="thetree" class="demo"></div>
	{literal}
		<script type="text/javascript" class="source">
		$(function () {
			$("#thetree").jstree({
				"plugins" : [ "themes", "json_data", "ui", "checkbox", "cookies", "types"],
				"types" : {
					"types" : {
						"folderfail" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/folderclosedfail.gif"
							},
							"icon_open" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/folderopenfail.gif"
							}
						},
						"folderok" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/folderclosedok.gif"
							},
							"icon_open" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/folderopenok.gif"
							}
						},
						"folderdifference" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/foldercloseddifference.gif"
							},
							"icon_open" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/folderopendifference.gif"
							}
						},
						"folderidentical" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/folderclosedidentical.gif"
							},
							"icon_open" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/folderopenidentical.gif"
							}
						},
						"filefail" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/filefail.gif"
							}
						},
						"fileok" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/fileok.gif"
							}
						},
						"fileempty" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/fileempty.gif"
							}
						},
						"filedifference" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/filedifference.gif"
							}
						},
						"fileidentical" : {
							"icon" : {
								"image" : "{/literal}{$_wud}{literal}/include/images/jsTree/fileidentical.gif"
							}
						}
					}
				},

				"themes" : {
					"theme" : "default",
					"dots" : true,
					"icons" : true
				},
				
				"core" : {
					"animation" : 0
				},
				
				"cookies" : {
					"save_selected" : false
				},
				"json_data" : {
				{/literal}
				"data" : {$JSONTree}
				{literal}
				}
		//	}).bind("select_node.jstree", function (e, data) { alert($('#test').jstree('get_checked')[0].id); });
			}).bind("select_node.jstree", function (e, data) { alert(data.rslt.obj.data("link")); });
		});
		</script>
	{/literal}
	
	{if $project_name neq "emptytree/empty"}
		<input type="button" onClick="check_boxes();" value="{$langTXT_evaluation}" class="button" />
	{/if}
{/strip}