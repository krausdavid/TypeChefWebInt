{strip}
	<div class="content_bigger">
		{if $errorCount eq 0}
			<img src="{$_wud}/include/images/style/fileok32x32.png" border="0" alt="NoError" style="position:relative; top:10px;"/>&nbsp;{$langTXTVIEWPROJECT_noerror}
		{else}
			<img src="{$_wud}/include/images/style/fileerr32x32.png" border="0" alt="Error" style="position:relative; top:10px;"/>&nbsp;{$langTXTVIEWPROJECT_error}
		{/if}
	</div>
	<br/>
	Permalink: <a href="{$_wud}/file?p={$smarty.get.project}/{$smarty.get.files}" class="link">{$_wud}/file?p={$smarty.get.project}/{$smarty.get.files}</a>
	<br/><br/>
	
	{if $parsererrorCount neq "0" || $typeerrorCount neq "0"}
		{$langTXTVIEWPROJECT_result}:
	{/if}
	
	{if $parsererrorCount neq "0"}
		<div class="teletype">
			Parser-Errors:<br/><br/>
			{foreach from=$parsererror item=parsererror name=parsererror_name}
				Error Nr. {$parsererror.id}:<br/>
				You've got an error with the following configuration: {$parsererror.featurestr}<br/>{$parsererror.msg}<br/>
				Error in line {$parsererror.line}:{$parsererror.col} in the PI-file.<br/><br/>
			{/foreach}
		</div>
	{/if}
	<br/><br/>
	{if $typeerrorCount neq "0"}
		<div class="teletype">
			Type-Errors:<br/><br/>
			{foreach from=$typeerror item=typeerror name=typeerror_name}
				Error Nr. {$typeerror.id}:<br/>
				You've got an <b>{$typeerror.severity}</b> with the following configuration: {$typeerror.featurestr}<br/>{$typeerror.msg}<br/>
				Error in line {$typeerror.line}:{$typeerror.col} in the PI-file.<br/><br/>
			{/foreach}
		</div>
	{/if}
{/strip}
