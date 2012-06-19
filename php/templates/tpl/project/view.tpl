{strip}
	<div class="content_bigger">
		{if $parseerrorCount eq 0 && $typeerrorCount eq 0}
			{$langTXTVIEWPROJECT_noerror}
		{else}
			{$langTXTVIEWPROJECT_error}
		{/if}
	</div>
	<br/>
	Permalink: <a href="{$_wud}/file?p={$smarty.get.project}/{$smarty.get.files}" class="link">{$_wud}/file?p={$smarty.get.project}/{$smarty.get.files}</a>
	
	{if $parseerrorCount neq 0}
		<table align="left" border="0" cellpadding="0" cellspacing="0" class="content">
			{foreach from=$parsererror item=parsererror name=parsererror_name}
				<tr>
					<td>ParserError Nr.</td>
					<td>{$parsererror.id}</td>
				</tr>
				<tr>
					<td>Feature String</td>
					<td>{$parsererror.featurestr}</td>
				</tr>
				<tr>
					<td>Message</td>
					<td>{$parsererror.msg}</td>
				</tr>
				<tr>
					<td>Position</td>
					<td>File: {$parsererror.file} &nbsp;&nbsp;&nbsp; Line: {$parsererror.line} &nbsp;&nbsp;&nbsp; Col: {$parsererror.col}</td>
				</tr>
				<tr>
					<td colspan="2"><hr/></td>
				</tr>
			{/foreach}
		</table>
	{/if}
	<br/><br/>
	{if $typeerrorCount neq 0}
		<table align="left" border="0" cellpadding="0" cellspacing="0" class="content">
			{foreach from=$typeerror item=typeerror name=typeerror_name}
				<tr>
					<td>typeError Nr.</td>
					<td>{$typeerror.id}</td>
				</tr>
				<tr>
					<td>Feature String</td>
					<td>{$typeerror.featurestr}</td>
				</tr>
				<tr>
					<td>Severity</td>
					<td>{$typeerror.severity}</td>
				</tr>
				<tr>
					<td>Message</td>
					<td>{$typeerror.msg}</td>
				</tr>
				<tr>
					<td>Position</td>
					<td>File: {$typeerror.file} &nbsp;&nbsp;&nbsp; Line: {$typeerror.line} &nbsp;&nbsp;&nbsp; Col: {$typeerror.col}</td>
				</tr>
				<tr>
					<td colspan="2"><hr/></td>
				</tr>
			{/foreach}
		</table>
	{/if}
{/strip}
