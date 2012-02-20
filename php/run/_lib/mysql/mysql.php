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
 */

class mysql
{
	var $cid;
	
	function connect()
	{
		$this->cid = mysql_connect($this->host, $this->user, $this->password, true);
		if (!$this->cid) {
			return $this->error();
		}
		if (!mysql_select_db($this->name, $this->cid)) {
			return $this->error();
		}
		$this->query("SET NAMES UTF8");
	}
		
	function query($query)
	{
		//echo $query."<br>";
		return mysql_query($query, $this->cid);
	}

	function fetch_array($fetch_array)
	{
		return mysql_fetch_array($fetch_array);
	}
	
	function num_rows($num_rows)
	{
		return mysql_num_rows($num_rows);
	}

	function insert($table, $values)
	{
		$qcols = "";
		$qvals = "";
		$i = 0;
		foreach ($values as $key => $val) {
			if ($i > 0) {
				$qcols .= ", ";
				$qvals .= ", ";
			}
			$qcols .= "`".$key."`";
			$qvals .= "'".$val."'";
			$i++;
		}
		$query = "INSERT INTO ".$table." (".$qcols.") VALUES (".$qvals.")";
		return $this->query($query);
	}
	
	function select_last_insert_id()
	{
		$dbreq = $this->query("SELECT LAST_INSERT_ID()");
		$dbres = $this->fetch_array($dbreq);
		return $dbres['LAST_INSERT_ID()'];
	}
	
	function update($table, $new_values, $col, $value)
	{
		$query = "UPDATE ".$table." SET ";
		$i = 0;
		foreach ($new_values as $key => $val) {
			if ($i > 0) {
				$query .= ", ";
			}
			$query .= "`".$key."`='".$val."'";
			$i++;
		}
		$query .= " WHERE ".$col."='".$value."'";
		return $this->query($query);
	}
	
	function select($table, $col, $value, $scol, $smode, $limit1, $limit2)
	{
		$q = "SELECT * FROM ".$table;
		if (!is_null($col) && !is_null($value)) {
			$q .= " WHERE ".$col."='".$value."'";
		}
		if (!is_null($scol) && !is_null($smode)) {
			$q .= " ORDER BY ".$scol." ".$smode;
		}
		if (!is_null($limit1) && !is_null($limit2)) {
			$q .= " LIMIT ".$limit1.", ".$limit2;
		}
		$dbreq = $this->query($q);
		$i = 0;
		while ($dbres = $this->fetch_array($dbreq)) {
			foreach (array_keys($dbres) as $col) {
				$result[$i][$col] = $dbres[$col];
			}
			$i++;
		}
		return $result;
	}
	
	function select_like($table, $col, $value, $scol, $smode, $limit1, $limit2)
	{
		$q = "SELECT * FROM ".$table." WHERE ".$col." LIKE '%".$value."%'";
		if (!is_null($scol) && !is_null($smode)) {
			$q .= " ORDER BY ".$scol." ".$smode;
		}
		if (!is_null($limit1) && !is_null($limit2)) {
			$q .= " LIMIT ".$limit1.", ".$limit2;
		}
		$dbreq = $this->query($q);
		$i = 0;
		while ($dbres = $this->fetch_array($dbreq)) {
			foreach (array_keys($dbres) as $col) {
				$result[$i][$col] = $dbres[$col];
			}
			$i++;
		}
		return $result;
	}
	
	function select_once($table, $col, $value)
	{
		$dbreq = $this->query("SELECT * FROM ".$table." WHERE ".$col."='".$value."'");
		$dbres = $this->fetch_array($dbreq);
		return $dbres;
	}
		
	function select_count($table, $col, $value)
	{
		$q = "SELECT COUNT(*) FROM ".$table;
		if ($col != null && $value != null) {
			$q .= " WHERE ".$col."='".$value."'";
		}
		$dbreq = $this->query($q);
		$dbres = $this->fetch_array($dbreq);
		return $dbres['COUNT(*)'];
	}
	
	function select_min($table, $col, $value, $mcol)
	{
		$q = "SELECT MIN(".$mcol.") FROM ".$table;
		if ($col != null && $value != null) {
			$q .= " WHERE ".$col."='".$value."'";
		}
		$dbreq = $this->query($q);
		$dbres = $this->fetch_array($dbreq);
		return $dbres['MIN('.$mcol.')'];
	}
	
	function select_max($table, $col, $value, $mcol)
	{
		$q = "SELECT MAX(".$mcol.") FROM ".$table;
		if ($col != null && $value != null) {
			$q .= " WHERE ".$col."='".$value."'";
		}
		$dbreq = $this->query($q);
		$dbres = $this->fetch_array($dbreq);
		return $dbres['MAX('.$mcol.')'];
	}
		
	function delete($table, $col, $value)
	{
		$query = "DELETE FROM ".$table." WHERE ".$col."='".$value."'";
		return $this->query($query);
	}
	
	function error()
	{
		if (mysql_errno() != 0) {
			die("<br />\n<b>MySQL error</b>:  ".mysql_errno().": ".mysql_error()."<br />\n");
		}
	}
	
	function disconnect()
	{
		return mysql_close($this->cid);
	}
}

?>