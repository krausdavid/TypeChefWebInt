<?php /* Smarty version 2.6.26, created on 2012-03-04 21:05:59
         compiled from ./project/main.tpl */ ?>
﻿Files:<br>
<?php $_from = $this->_tpl_vars['files']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['act_file']):
?>
	<a href="<?php echo $this->_tpl_vars['_wud']; ?>
/project?files=<?php echo $this->_tpl_vars['files_get']; ?>
&project=<?php echo $this->_tpl_vars['project']; ?>
&choosen_file=<?php echo $this->_tpl_vars['act_file']; ?>
"><?php echo $this->_tpl_vars['act_file']; ?>
</a>
<?php endforeach; endif; unset($_from); ?>
<hr>
<?php if ($_GET['choosen_file'] != ""): ?>
	File: <?php echo $_GET['choosen_file']; ?>
<br>
	<pre><?php echo $this->_tpl_vars['filecontent']; ?>
</pre>
<?php endif; ?>