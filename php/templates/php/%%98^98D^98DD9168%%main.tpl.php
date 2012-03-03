<?php /* Smarty version 2.6.26, created on 2012-03-03 18:07:09
         compiled from ./project/main.tpl */ ?>
﻿<?php echo 'Files:<br>'; ?><?php $_from = $this->_tpl_vars['files']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['act_file']):
?><?php echo '<a href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/project?files='; ?><?php echo $this->_tpl_vars['files_get']; ?><?php echo '&project='; ?><?php echo $this->_tpl_vars['project']; ?><?php echo '&choosen_file='; ?><?php echo $this->_tpl_vars['act_file']; ?><?php echo '">'; ?><?php echo $this->_tpl_vars['act_file']; ?><?php echo '</a>&nbsp;'; ?><?php endforeach; endif; unset($_from); ?><?php echo '<hr>'; ?><?php if ($_GET['choosen_file'] != ""): ?><?php echo 'File: '; ?><?php echo $_GET['choosen_file']; ?><?php echo '<br><pre>'; ?><?php echo $this->_tpl_vars['filecontent']; ?><?php echo '</pre>'; ?><?php endif; ?><?php echo ''; ?>
