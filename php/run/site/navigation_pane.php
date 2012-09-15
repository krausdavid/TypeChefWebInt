<?php

/*
 * #####################################################
 * #                                                   #
 * # TYPECHEF WEB INTERFACE                            #
 * #                                                   #
 * # Copyright (c) by EifX & KrausDavid                #
 * #                                                   #
 * #                    eifx@informatik.uni-marburg.de #
 * #              krausdavid@informatik.uni-marburg.de #
 * #                                                   #
 * #####################################################
 *
 * ===Notes=============================================
 * There are currently no notes.
 * =====================================================
 *
 * ./run/site/navigation_pane.php
 *
 * This whole methods are needed for the navigation-pane
 * in the left upper corner
 */

//Check, if user has switched between "Show Errors" and "Show no Errors"
if((isset($_POST['chk_showOnlyErrors']) && $_POST['chk_showOnlyErrors']=="checked") && (isset($_POST['showOnlyErrors_val']) && $_POST['showOnlyErrors_val']=="val")){
	$session->set("showOnlyErrors",true);
}
if(!isset($_POST['chk_showOnlyErrors']) && (isset($_POST['showOnlyErrors_val']) && $_POST['showOnlyErrors_val']=="val")){
	$session->set("showOnlyErrors",false);
}
$template->assign("showOnlyErrors", $session->get("showOnlyErrors"));



?>