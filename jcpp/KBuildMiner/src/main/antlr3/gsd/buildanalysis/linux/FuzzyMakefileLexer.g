/*
 * Copyright (c) 2010 Thorsten Berger <berger@informatik.uni-leipzig.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
lexer grammar FuzzyMakefileLexer;
options { filter=true; }
@header{
  package gsd.buildanalysis.linux;
  import java.util.HashMap;
  import java.util.LinkedList;
  import java.util.List;
  import java.util.Map;
  import gsd.buildanalysis.linux.model.*;
}
  
@members{

  // temporary lists
  public List<String> elements_objects = new LinkedList<String>();
  public List<String> elements_folders = new LinkedList<String>();
  public List<String> elements_variables = new LinkedList<String>();
  
  // for variable substitutions (occurs rather seldom)
  Map<String,String> vars = new HashMap<String,String>();
  
  ModelFactory modelFactory = null;
  
  public void setModelFactory( ModelFactory mf ){
    this.modelFactory = mf;
  };
  
  public String currentListName, currentSelection, currentVariable;
  
  public enum Pass{
    BUILDLISTS, PARSE;
  }
  
  // unfortunately, we have to pass the makefiles two times
  public Pass p = Pass.BUILDLISTS;
  
}

fragment
IFEQVALUE
  : 'y'|'m';

  // TODO: track ifeq and ifdef with a stack in order to reconstruct conditions
IFEQ
  : 'ifeq' WS '(' WS? '$(' name=CONFIGVAR ')' WS? ',' WS? selec=IFEQVALUE? WS? ')' CR
     {
     String value = $selec.text != null ? $selec.text : "";
     modelFactory.pushIf( new Eq( new Identifier( $name.text ), new StringLiteral( value ) ) );
     System.out.println("found ifeq "+$name.text + " = " + value );}
   ;
IFNEQ
  : 'ifneq' WS '(' WS? '$(' name=CONFIGVAR ')' WS? ',' WS? selec=IFEQVALUE? WS? ')' CR
     {
     String value = $selec.text != null ? $selec.text : "";
     modelFactory.pushIf( new NEq( new Identifier( $name.text ), new StringLiteral( value ) ) );
     System.out.println("found nifeq "+$name.text + " = " + $selec.text );}
   ;
IFDEF
  : 'ifdef' WS name=CONFIGVAR CR
     {
     modelFactory.pushIf( new Defined( new Identifier( $name.text ) ) );
     System.out.println("found ifdef "+$name.text );}
  ;
UnsupportedRegocnizedIFEQ
  : 'ifeq' WS '(' WS? '$(' name=NA ')' WS? ',' WS? v=VA WS? ')' CR
     {
     modelFactory.pushIf( new Eq( new Identifier( $name.text ), new StringLiteral( $v.text ) ) );
     System.out.println("found unsupported, but recognized and irrelevant ifeq: " + $name.text + "=" + $v.text );
     }
  ;
  
// some heuristics...
ComplicatedIFNEQ1
  : 'ifneq ($(lib-y),)'
     {
     modelFactory.pushIf( new UnknownExpression( new Not( new Eq( new Identifier( "lib-y" ), new StringLiteral( "" ) ) ) ) );
     }
   ;

  
UnsupportedIFEQ
  : 'ifeq'
     {
     modelFactory.pushIf( new InvalidExpression() );
     System.out.println( "found unsupported ifeq!" );
     //throw new RuntimeException("found unsupported ifeq!" );
     }
   ;
UnsupportedIFNEQ
  : 'ifneq'
     {
     modelFactory.pushIf( new InvalidExpression() );
     System.out.println( "found unsupported ifneq! Maybe we can resolve it later with some heuristics" );
     //throw new RuntimeException("found unsupported ifeq!" );
     }
   ;
   
UnsupportedRegocnizedIFDEF
  : 'ifdef' WS name=NA CR
     {
     modelFactory.pushIf( new Defined( new Identifier( $name.text ) ) );
     System.out.println("found unsupported, but recognized and irrelevant ifdef: " + $name.text );
      }
  ;
UnsupportedIFDEF
  : 'ifdef'
     {
     modelFactory.pushIf( new InvalidExpression() );
     System.out.println( "found unsupported ifdef!" );
     //throw new RuntimeException("found unsupported ifeq!" );
     }
   ;
   
ELSE
  : 'else' CR
     {
	modelFactory.pushElse();
        System.out.println("found else");
     }
  ;
  
ENDIF
  : 'endif' CR
     {
     modelFactory.popEndIf();
     System.out.println("found endif");
     }
  ;   


LISTROW
  : WS? listname=LISTE LISTASSIGNMENT name=ListOfObjectsOrDirs CR
  {
     
    System.out.println( "==List: " + currentListName + ", Var: " + currentSelection + " | $(" + currentVariable + "): " + elements_objects + elements_folders + elements_variables );
     
    Expression exp = null;
     
    if( currentListName.equals( "obj" ) || currentListName.equals( "core" ) || currentListName.equals( "drivers" ) ||
      currentListName.equals( "mcore" ) || currentListName.equals( "extra" ) || currentListName.equals( "lib" ) ||
      currentListName.equals( "libs" ) ){
      
      if( currentVariable != null )
        exp = new Or( new Eq( new Identifier( currentVariable ), new StringLiteral( "y" ) ), new Eq( new Identifier( currentVariable ), new StringLiteral( "m" ) ) );
      else
        exp = new True();
      
      for( String object : elements_objects ){
        boolean generated = object.startsWith( "<generated>" );
	String objectFile = object.substring( generated ? 11 : 0, object.length()-2 );
	if( currentSelection != null )
          modelFactory.addObject( objectFile, currentSelection, "o", generated, currentListName, exp );
        else
          modelFactory.addObject( objectFile, "o", generated, currentListName, exp );
      }
      for( String folder : elements_folders )
        modelFactory.addMakefile( folder, exp );
	  
      // now, that is tricky: composite objects can be inserted as a list variable or an object, e.g.
      // nfsd-$(CONFIG_NFSD)   := nfsctl.o
      // obj-y       += $(nfsd-y) $(nfsd-m)
      // or
      // obj-y := main.o version.o mounts.o
      // mounts-y     := do_mounts.o
      // mounts-$(CONFIG_BLK_DEV_RAM)  += do_mounts_rd.o
      // we deal with the first case here:
      for( String var : elements_variables ){
//        if( !var.endsWith( "-y" ) && !var.endsWith( "-m" ) )
//          throw new RuntimeException( "Invalid reference: " + var );
	if( var.endsWith("-y") || var.endsWith("-m") ){
	        String variable = var.substring( 0, var.length() - 2 );
	        String selectionSuffix = var.substring( var.length() - 1, var.length() );
	        modelFactory.addTempReference( variable, selectionSuffix, exp );
        }else{ // arbitrary variable
        	modelFactory.addVariableReference( var, exp );
        }
      }
      
    }else{  // composite list
      
      if( currentSelection != null )
        modelFactory.addTempCompositeList( currentListName, currentSelection );
      else
        modelFactory.addTempCompositeList( currentListName );
      
      if( currentVariable != null )
        exp = new Eq( new Identifier( currentVariable ), new StringLiteral( "y" ) );
      else
        exp = new True();
      
      for( String object : elements_objects ){
        boolean generated = object.startsWith( "<generated>" );
        String objectFile = object.substring( generated ? 11 : 0, object.length()-2 );
        modelFactory.addObject( objectFile, "o", generated, currentListName, exp );
        // extension enforced by lexer rule OBJECTFILENAME
        //
        // the actual object files of composite objects are always built into the composite object, i.e. they don't determine if they're built as
        // modules, so setting the "built_as" attribute for the actual object files doesn't make sense here
        // (Makefile.build just recognizes list-y and list-objs) 
      }
      
      for( String folder : elements_folders )
        modelFactory.addMakefile( folder, exp );
        
      // for variable problematice, see above
      for( String var : elements_variables ){
//        if( !var.endsWith( "-y" ) && !var.endsWith( "-m" ) )
//          throw new RuntimeException( "Invalid reference: " + var );
	if( var.endsWith("-y") || var.endsWith("-m") ){
	        String variable = var.substring( 0, var.length() - 2 );
	        String selectionSuffix = var.substring( var.length() - 1, var.length() );
	        modelFactory.addTempReference( variable, selectionSuffix, exp );
        }else{ // arbitrary variable
        	modelFactory.addVariableReference( var, exp );
        }
      }
      
      modelFactory.popTempCompositeList();
    }

    elements_objects = new LinkedList<String>();
    elements_folders = new LinkedList<String>();
    elements_variables = new LinkedList<String>();
  };

LISTE
@init{
  currentListName = null;
  currentSelection = null;
  currentVariable = null;
}
  : ('A'..'Z'|'a'..'z'|'0'..'9'|'-'|'_'|'0'..'9')+ '-' ( s=SELECTION | VARIABLE )
  { 
    System.out.println("!!!" + getText() + "!!!" );
    currentListName = getText().trim().substring ( 0, getText().trim().lastIndexOf('-') );
    currentSelection = $s.text;
  };


ARBITRARYVARASSIGNMENT
  :
    WS? n=NA la=LISTASSIGNMENT v=VA2 CR
    { vars.put( $n.text, $v.text );
    modelFactory.addVariableAssignment( $n.text, $la.text, $v.text );
    System.out.println ("Found var assignment: " + $n.text + $la.text + $v.text ); }
  ;

/*
Handles the case where a variable is created that contains a list of files in order
to be referenced somewhere else, e.g.:
COMMON_FILES:= \
\
	data_skip.o \
	data_extract_all.o \
	data_extract_to_stdout.o
*/
ARBITRARYVARASSIGNMENT_AS_LIST 
	:	WS? n=NA { modelFactory.pushListVariable( $n.text ); } la=LISTASSIGNMENT WS? wholeValue=AVA_HELPER1
	{
	modelFactory.popListVariable();
	modelFactory.addVariableAssignment( $n.text, $la.text, $wholeValue.text );
	System.out.println("Found another variable that contains a list"); }
	;

fragment AVA_HELPER1 : (v=VA {
		if( $v.text.endsWith(".o") )
			modelFactory.addObjectToList( $v.text.substring( 0, $v.text.length()-2 ) );
	} WS*)+;


fragment NA : ('A'..'Z'|'a'..'z'|'_'|'-'|'0'..'9'|'.')+ ;
fragment VA : ('a'..'z'|'A'..'Z'|'_'|'-'|'.'|'0'..'9'|'/')+ ;
fragment VA2 : ('a'..'z'|'A'..'Z'|'_'|'-'|'.'|'0'..'9'|'/'|'$'|'('|')'|'='|','|' '|'"'|'\'')+ ;
fragment VA3 : ('a'..'z'|'A'..'Z'|'_'|'-'|'.'|'0'..'9'|'/'|'='|','|' ')+ ;



fragment
LISTASSIGNMENT
  : WS? ( '+=' | ':=' | '=' ) WS?
  ;


fragment
ListOfObjectsOrDirs
  : ( WS | LISTELEMENT )+
  ;

fragment
LISTELEMENT
  : obj=OBJECTFILENAME { elements_objects.add( $obj.text ); } |
    sub=SUBDIR { elements_folders.add( $sub.text ); } |
    '$(' v=NA ')' { elements_variables.add( $v.text ); }
  ;


fragment
VARIABLE
  : '$(' ( var = CONFIGVAR { currentVariable = $var.text; } | 'call sequencer,' WS? '$(' v=CONFIGVAR ')' { currentVariable = "SequencerCall[CONFIG_SND_SEQUENCER," + $v.text + "]"; System.out.println( "Found call in list construction! Diasambiguate manually!" ); } ) ')'
  
  ;
  
SL_COMMENT
    :   '#' (options {greedy=false;} : . )* '\n'
    ;
  

WS  :   (' '|'\t' | '\\\n')+
    ;
    
CR  : WS? ( '\n' | SL_COMMENT | EOF )
    ;


fragment
OBJECTFILENAME  : ('<generated>')? (('a'..'z'|'A'..'Z'|'_'|'-'|'0'..'9'|'/')+ '/')? FILENAME '.o'
    // we add <generated> manually to object files that aren't associated to any .c file, but get generated somehow
  ;
fragment
SUBDIR  : ('a'..'z'|'A'..'Z'|'_'|'-'|'0'..'9'|'/')+ '/'
  ;


fragment
SELECTION
  : 'y'|'m'|'objs'  // 'objs' just used for composite lists
  ;
  
fragment
FILENAME  :   ('a'..'z'|'A'..'Z'|'_'|'-'|'0'..'9'|'$'|'('|')')+
    ;


fragment
CONFIGVAR  :   'CONFIG_' ('A'..'Z'|'a'..'z'|'_'|'-'|'0'..'9')+ | 'ACPI_FUTURE_USAGE'
    ;
