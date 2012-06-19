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
	{if $parseerrorCount neq "0"}
		<table align="left" border="0" cellpadding="0" cellspacing="0" class="content" width="100%">
			{foreach from=$parsererror item=parsererror name=parsererror_name}
				<tr>
					<td nowrap>ParserError Nr.</td>
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
					<td>Line: {$parsererror.line}, Col: {$parsererror.col}</td>
				</tr>
				<tr>
					<td colspan="2"><hr/></td>
				</tr>
			{/foreach}
		</table>
	{/if}
	<br/><br/>
	{if $typeerrorCount neq "0"}
		<table align="left" border="0" cellpadding="0" cellspacing="0" class="content" width="100%">
			{foreach from=$typeerror item=typeerror name=typeerror_name}
				<tr>
					<td nowrap>TypeError Nr.</td>
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
					<td>Line: {$typeerror.line}, Col: {$typeerror.col}</td>
				</tr>
				<tr>
					<td colspan="2"><hr/></td>
				</tr>
			{/foreach}
		</table>
	{/if}
{/strip}
