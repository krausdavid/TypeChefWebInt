{strip}
	{if $loginFailed eq true}
		<div class="error_message">
			<b>{$langINF_information}</b><br/><br/>
			{$langERRTXT_wrongLogin}
		</div>
		<br/><br/>
	{/if}
	<form action="{$_wud}/login?lang={$smarty.get.lang}" method="post">
		{$langTXT_name}:<br/>
		<input type="text" name="txt_name" class="text_small" /><br/><br/>
		{$langTXT_password}:<br/>
		<input type="password" name="txt_password" class="text_small" /><br/><br/>
		<input type="submit" name="cmd_submit" value="{$langTXT_login}" class="button" />
	</form>
{/strip}