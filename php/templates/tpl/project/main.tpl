Files:<br>
{foreach from=$files item=act_file}
	<a href="{$_wud}/project?files={$files_get}&project={$project}&choosen_file={$act_file}">{$act_file}</a>
{/foreach}
<hr>
{if $smarty.get.choosen_file neq ""}
	File: {$smarty.get.choosen_file}<br>
	<pre>{$filecontent}</pre>
{/if}
