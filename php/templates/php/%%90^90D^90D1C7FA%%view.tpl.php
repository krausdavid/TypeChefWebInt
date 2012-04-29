<?php /* Smarty version 2.6.26, created on 2012-04-29 19:51:53
         compiled from ./project/view.tpl */ ?>
﻿	Files:<br>
	<?php $_from = $this->_tpl_vars['files']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['act_file']):
?>
		<a href="<?php echo $this->_tpl_vars['_wud']; ?>
/project?choice=view&files=<?php echo $this->_tpl_vars['files_get']; ?>
&project=<?php echo $this->_tpl_vars['project']; ?>
&choosen_file=<?php echo $this->_tpl_vars['act_file']; ?>
"><?php echo $this->_tpl_vars['act_file']; ?>
</a> 
	<?php endforeach; endif; unset($_from); ?>
	<hr>
<?php echo ''; ?><?php if ($_GET['choosen_file'] != ""): ?><?php echo 'File: '; ?><?php echo $_GET['choosen_file']; ?><?php echo '<br><pre>'; ?><?php $_from = $this->_tpl_vars['file_output']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['file_output_name'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['file_output_name']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['file_output']):
        $this->_foreach['file_output_name']['iteration']++;
?><?php echo ''; ?><?php echo $this->_tpl_vars['file_output']['nr']; ?><?php echo ''; ?><?php echo $this->_tpl_vars['file_output']['line']; ?><?php echo '<br/>'; ?><?php endforeach; endif; unset($_from); ?><?php echo '</pre>'; ?><?php endif; ?><?php echo ''; ?>