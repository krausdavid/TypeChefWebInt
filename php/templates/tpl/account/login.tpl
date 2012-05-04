{strip}
	{if $loginFailed eq true}
		<div class="error_message">
			<b>Hinweis</b><br/><br/>
			Login fehlgeschlagen! Benutzername / Passwort stimmen nicht überein.
		</div>
		<br/><br/>
	{/if}
	<form action="{$_wud}/login" method="post">
		Name:<br/>
		<input type="text" name="txt_name" class="text_small" /><br/><br/>
		Passwort:<br/>
		<input type="password" name="txt_password" class="text_small" /><br/><br/>
		<input type="submit" name="cmd_submit" value="Login" class="button" />
	</form>
{/strip}