{if $error_nicknameAlreadySet eq true}
	<div class="info_message">
		<b>{$langINF_information}</b><br/><br/>
		{$langINFTXT_nicknameAlreadySet}
	</div>
	<br/><br/>
{/if}
{if $error_nicknameContainsBadCharacter eq true}
	<div class="info_message">
		<b>{$langINF_information}</b><br/><br/>
		{$langINFTXT_nicknameContainsBadCharacter}
	</div>
	<br/><br/>
{/if}
{if $error_emptyFields eq true}
	<div class="info_message">
		<b>{$langINF_information}</b><br/><br/>
		{$langINFTXT_emptyFields}
	</div>
	<br/><br/>
{/if}
{if $java_output eq ""}
	<form action="{$_wud}/project?choice=new" method="post">
		{$langTXTNEWPROJECT_topic}:<br/><br/>
		<table align="left" border="0" cellpadding=2" cellspacing="2" class="table_noborders">
			<tr>
				<td>{$langTXT_name}:</td>
				<td>&nbsp;</td>
				<td><input type="text" name="txt_name" value="{$project_name_new}" class="text_small"/></td>
			</tr>
			<tr>
				<td>{$langTXT_nickname}:</td>
				<td>&nbsp;</td>
				<td><input type="text" name="txt_nickname" value="{$project_nickname_new}" {if $error_nicknameAlreadySet eq true}class="text_small_red"{else}class="text_small"{/if}/></td>
			</tr>
			<tr>
				<td>{$langTXT_version}:</td>
				<td>&nbsp;</td>
				<td><input type="text" name="txt_version" value="{$project_version_new}" class="text_small"/></td>
			</tr>
			<tr>
				<td>{$langTXT_path}:</td>
				<td>&nbsp;</td>
				<td><input type="text" name="txt_path" value="{$project_path_new}" class="text_small" class="text_small"/></td>
			</tr>
			<tr>
				<td colspan="3"><br/><input type="submit" name="cmd_send" value="{$langTXT_newProjectCreate}" class="button"/></td>
			</tr>
		</table>
	</form>
{else}
	{if $java_output neq ""}
		{$java_output}
		<br/>
		{$langTXTNEWPROJECT_loadSuccessfull}
	{else}
		{$langTXTNEWPROJECT_loadError}
	{/if}
{/if}