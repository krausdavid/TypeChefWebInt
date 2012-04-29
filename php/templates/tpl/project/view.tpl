	Files:<br>
	{foreach from=$files item=act_file}
		<a href="{$_wud}/project?choice=view&files={$files_get}&project={$project}&choosen_file={$act_file}">{$act_file}</a> 
	{/foreach}
	<hr>
{strip}
	{if $smarty.get.choosen_file neq ""}
		File: {$smarty.get.choosen_file}<br>
		<pre>
			{foreach from=$file_output item=file_output name=file_output_name}
				{$file_output.nr}{$file_output.line}<br/>
			{/foreach}
		</pre>
	{/if}
{/strip}