<?php /* Smarty version 2.6.26, created on 2012-03-04 21:04:37
         compiled from ./core/main.tpl */ ?>
﻿<?php echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><html><head><title>TypeChefWebInt: '; ?><?php echo $this->_tpl_vars['title']; ?><?php echo '</title><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><meta http-equiv="expires" content="0"><meta name="language" content="de"><meta name="author" content="'; ?><?php echo $this->_tpl_vars['_website_autor']; ?><?php echo '"><meta name="generator" content="Notepad++"><meta name="description" content="TypeChef WebInterface"><meta name="keywords" content="TypeChef WebInterface,TypeChef,WebInterface,TypeChefWebInt"><meta name="robots" content="all"><link rel="stylesheet" type="text/css" href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/stylesheets/main.css"><link rel="stylesheet" type="text/css" href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/stylesheets/form.css"><link rel="stylesheet" type="text/css" href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/stylesheets/table.css"><link rel="stylesheet" type="text/css" href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/stylesheets/links.css"><link rel="shortcut icon" type="image/ico" href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/icons/favicon.ico"/>'; ?><?php echo '<SCRIPT src="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/javascripts/treeview/ua.js"></SCRIPT><SCRIPT src="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/javascripts/treeview/ftiens4.js"></SCRIPT>'; ?><?php echo '<SCRIPT src="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/generics/treeview/busybox.js"></SCRIPT><SCRIPT>function check_boxes()'; ?><?php echo '{
				var outStr = ""
				for(var i = 0; i<MAX_LENGTH; i++){
					if(getElById(\'chkbox\'+i).checked){
						outStr = outStr + \'chkbox\'+ i + "_"
					}
				}'; ?><?php echo 'location.href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/execute?chkStr="+outStr}</SCRIPT><!--[if lt IE 7.]><script defer type="text/javascript" src="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/include/javascripts/pngfix/pngfix.js"></script><![endif]--></head><body class="body"><table align="center" border="1" cellpadding="0" cellspacing="0" class="table"><colgroup><col width="400"><col width="600"></colgroup><tr><td align="center" colspan="2">TypeChef - WebInterface</td></tr><tr valign="top"><th rowspan="2">'; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "./core/tree.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo '</th><td height="25"><a href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/" class="link">Startseite</a> - <a href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/reload_tree" class="link">Baum aktualisieren</a> - <a href="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/501_not_implemented" class="link">Einstellungen</a></td></tr><tr><td valign="top">'; ?><?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => $this->_tpl_vars['template'], 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?><?php echo '</td></tr><tr><td align="center" colspan="2"><br><div style="font-family:verdana; font-size:12px; color:black; padding-top:5px;">(c) '; ?><?php echo $this->_tpl_vars['_website_year']; ?><?php echo ' by '; ?><?php echo $this->_tpl_vars['_website_autor']; ?><?php echo '<br><br>Version '; ?><?php echo $this->_tpl_vars['_website_version']; ?><?php echo '</div></td></tr></table></body></html>'; ?>
