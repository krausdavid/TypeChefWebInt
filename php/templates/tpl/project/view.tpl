	Files:<br>
	{foreach from=$files item=act_file}
		<a href="{$_wud}/project?choice=view&files={$files_get}&project={$project}&choosen_file={$act_file}">{$act_file}</a> 
	{/foreach}
	<hr>
{strip}
	{if $smarty.get.choosen_file neq ""}
		File: {$smarty.get.choosen_file}<br>
		{if $isSyntaxable eq true}
			<pre class="brush: {$syntax_lang} ; toolbar: false;">
		{else}
			<pre>
		{/if}
			{foreach from=$file_output item=file_output name=file_output_name}
				{if $isSyntaxable eq false}{$file_output.nr}{/if}{$file_output.line}{if $isSyntaxable eq false}<br/>{/if}
			{/foreach}
		</pre>
	{/if}
{/strip}