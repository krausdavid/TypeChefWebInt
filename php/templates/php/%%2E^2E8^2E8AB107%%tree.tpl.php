<?php /* Smarty version 2.6.26, created on 2012-04-29 20:02:46
         compiled from ./core/tree.tpl */ ?>
﻿<?php echo 'Aktuelles Projekt:&nbsp;<form method="post" action="'; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/" style="display:inline"><select name="project" size="1"><optgroup label="Projeke">'; ?><?php $_from = $this->_tpl_vars['projects_list']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }$this->_foreach['projects_list_name'] = array('total' => count($_from), 'iteration' => 0);
if ($this->_foreach['projects_list_name']['total'] > 0):
    foreach ($_from as $this->_tpl_vars['projects_list']):
        $this->_foreach['projects_list_name']['iteration']++;
?><?php echo '<option value="_'; ?><?php echo $this->_tpl_vars['projects_list']['name']; ?><?php echo '" '; ?><?php if ($this->_tpl_vars['projects_list']['selected'] == true): ?><?php echo 'selected'; ?><?php endif; ?><?php echo ' onclick="this.form.submit();">'; ?><?php echo $this->_tpl_vars['projects_list']['name']; ?><?php echo '</option>'; ?><?php endforeach; endif; unset($_from); ?><?php echo '</optgroup><optgroup label="Optionen"><option value="new" onclick="form.action=\''; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/project?choice=new\';this.form.submit();">Neues Projekt...</option><option value="match" onclick="form.action=\''; ?><?php echo $this->_tpl_vars['_wud']; ?><?php echo '/project?choice=match\';this.form.submit();">Zwei Projekte vergleichen</option></optgroup></select></form><div style="position:absolute; top:0; left:0;"><table border=0><tr><td><font size=-2><a style="font-size:6pt;text-decoration:none;color:black" href="http://www.treemenu.net/" target=_blank>with Javascript Tree Menu</a></font></td></tr></table></div><div class="treeview"><script>initializeDocument()</script><noscript>Bitte aktivieren Sie JavaScript!</noscript></div><input type="button" onClick="check_boxes()" value="Evaluation" />'; ?>