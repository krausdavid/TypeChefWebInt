{if $error_nicknameAlreadySet eq true}
	<div class="info_message">
		<b>{$langINF_information}</b><br/><br/>
		Der Projekt-Nickname ist bereits vergeben!
	</div>
	<br/><br/>
{/if}
<form action="{$_wud}/project?choice=new&lang={$smarty.get.lang}" method="post">
	{$langTXTNEWPROJECT_topic}:<br/><br/>
	<table align="left" border="0" cellpadding="0" cellspacing="0" class="table_noborders">
		<tr>
			<td>{$langTXT_name}:</td>
			<td>&nbsp;</td>
			<td><input type="text" name="txt_name" /></td>
		</tr>
		<tr>
			<td>{$langTXT_nickname}:</td>
			<td>&nbsp;</td>
			<td><input type="text" name="txt_nickname" /></td>
		</tr>
		<tr>
			<td>{$langTXT_version}:</td>
			<td>&nbsp;</td>
			<td><input type="text" name="txt_version" /></td>
		</tr>
		<tr>
			<td>{$langTXT_path}:</td>
			<td>&nbsp;</td>
			<td><input type="text" name="txt_path" /></td>
		</tr>
		<tr>
			<td colspan="3"><br/><input type="submit" name="cmd_send" value="{$langTXT_newProjectCreate}" /></td>
		</tr>
	</table>
</form>
