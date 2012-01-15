// $ANTLR 3.1.3 Mar 17, 2009 19:23:44 gsd/buildanalysis/linux/FuzzyMakefileLexer.g 2012-01-09 15:44:50

  package gsd.buildanalysis.linux;
  import java.util.HashMap;
  import java.util.LinkedList;
  import java.util.List;
  import java.util.Map;
  import gsd.buildanalysis.linux.model.*;


import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
public class FuzzyMakefileLexer extends Lexer {
    public static final int VA3=31;
    public static final int UnsupportedRegocnizedIFDEF=17;
    public static final int CONFIGVAR=6;
    public static final int VA2=27;
    public static final int LISTE=21;
    public static final int ListOfObjectsOrDirs=23;
    public static final int ELSE=19;
    public static final int IFNEQ=9;
    public static final int VA=12;
    public static final int OBJECTFILENAME=33;
    public static final int IFDEF=10;
    public static final int UnsupportedIFEQ=15;
    public static final int EOF=-1;
    public static final int LISTASSIGNMENT=22;
    public static final int IFEQ=8;
    public static final int SELECTION=25;
    public static final int UnsupportedIFDEF=18;
    public static final int WS=5;
    public static final int VARIABLE=26;
    public static final int FILENAME=36;
    public static final int ARBITRARYVARASSIGNMENT_AS_LIST=30;
    public static final int IFEQVALUE=4;
    public static final int SL_COMMENT=35;
    public static final int ENDIF=20;
    public static final int LISTELEMENT=32;
    public static final int LISTROW=24;
    public static final int SUBDIR=34;
    public static final int AVA_HELPER1=29;
    public static final int CR=7;
    public static final int UnsupportedRegocnizedIFEQ=13;
    public static final int NA=11;
    public static final int UnsupportedIFNEQ=16;
    public static final int ComplicatedIFNEQ1=14;
    public static final int ARBITRARYVARASSIGNMENT=28;


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
      


    // delegates
    // delegators

    public FuzzyMakefileLexer() {;} 
    public FuzzyMakefileLexer(CharStream input) {
        this(input, new RecognizerSharedState());
    }
    public FuzzyMakefileLexer(CharStream input, RecognizerSharedState state) {
        super(input,state);

    }
    public String getGrammarFileName() { return "gsd/buildanalysis/linux/FuzzyMakefileLexer.g"; }

    public Token nextToken() {
        while (true) {
            if ( input.LA(1)==CharStream.EOF ) {
                return Token.EOF_TOKEN;
            }
            state.token = null;
    	state.channel = Token.DEFAULT_CHANNEL;
            state.tokenStartCharIndex = input.index();
            state.tokenStartCharPositionInLine = input.getCharPositionInLine();
            state.tokenStartLine = input.getLine();
    	state.text = null;
            try {
                int m = input.mark();
                state.backtracking=1; 
                state.failed=false;
                mTokens();
                state.backtracking=0;

                if ( state.failed ) {
                    input.rewind(m);
                    input.consume(); 
                }
                else {
                    emit();
                    return state.token;
                }
            }
            catch (RecognitionException re) {
                // shouldn't happen in backtracking mode, but...
                reportError(re);
                recover(re);
            }
        }
    }

    public void memoize(IntStream input,
    		int ruleIndex,
    		int ruleStartIndex)
    {
    if ( state.backtracking>1 ) super.memoize(input, ruleIndex, ruleStartIndex);
    }

    public boolean alreadyParsedRule(IntStream input, int ruleIndex) {
    if ( state.backtracking>1 ) return super.alreadyParsedRule(input, ruleIndex);
    return false;
    }// $ANTLR start "IFEQVALUE"
    public final void mIFEQVALUE() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:57:3: ( 'y' | 'm' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            {
            if ( input.LA(1)=='m'||input.LA(1)=='y' ) {
                input.consume();
            state.failed=false;
            }
            else {
                if (state.backtracking>0) {state.failed=true; return ;}
                MismatchedSetException mse = new MismatchedSetException(null,input);
                recover(mse);
                throw mse;}


            }

        }
        finally {
        }
    }
    // $ANTLR end "IFEQVALUE"

    // $ANTLR start "IFEQ"
    public final void mIFEQ() throws RecognitionException {
        try {
            int _type = IFEQ;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token name=null;
            Token selec=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:3: ( 'ifeq' WS '(' ( WS )? '$(' name= CONFIGVAR ')' ( WS )? ',' ( WS )? (selec= IFEQVALUE )? ( WS )? ')' CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:5: 'ifeq' WS '(' ( WS )? '$(' name= CONFIGVAR ')' ( WS )? ',' ( WS )? (selec= IFEQVALUE )? ( WS )? ')' CR
            {
            match("ifeq"); if (state.failed) return ;

            mWS(); if (state.failed) return ;
            match('('); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:19: ( WS )?
            int alt1=2;
            int LA1_0 = input.LA(1);

            if ( (LA1_0=='\t'||LA1_0==' '||LA1_0=='\\') ) {
                alt1=1;
            }
            switch (alt1) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:19: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match("$("); if (state.failed) return ;

            int nameStart66 = getCharIndex();
            mCONFIGVAR(); if (state.failed) return ;
            name = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nameStart66, getCharIndex()-1);
            match(')'); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:47: ( WS )?
            int alt2=2;
            int LA2_0 = input.LA(1);

            if ( (LA2_0=='\t'||LA2_0==' '||LA2_0=='\\') ) {
                alt2=1;
            }
            switch (alt2) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:47: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match(','); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:55: ( WS )?
            int alt3=2;
            switch ( input.LA(1) ) {
                case ' ':
                    {
                    alt3=1;
                    }
                    break;
                case '\t':
                    {
                    alt3=1;
                    }
                    break;
                case '\\':
                    {
                    int LA3_3 = input.LA(2);

                    if ( (LA3_3=='\n') ) {
                        alt3=1;
                    }
                    }
                    break;
            }

            switch (alt3) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:55: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:64: (selec= IFEQVALUE )?
            int alt4=2;
            int LA4_0 = input.LA(1);

            if ( (LA4_0=='m'||LA4_0=='y') ) {
                alt4=1;
            }
            switch (alt4) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:64: selec= IFEQVALUE
                    {
                    int selecStart80 = getCharIndex();
                    mIFEQVALUE(); if (state.failed) return ;
                    selec = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, selecStart80, getCharIndex()-1);

                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:76: ( WS )?
            int alt5=2;
            int LA5_0 = input.LA(1);

            if ( (LA5_0=='\t'||LA5_0==' '||LA5_0=='\\') ) {
                alt5=1;
            }
            switch (alt5) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:61:76: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match(')'); if (state.failed) return ;
            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

                   String value = (selec!=null?selec.getText():null) != null ? (selec!=null?selec.getText():null) : "";
                   modelFactory.pushIf( new Eq( new Identifier( (name!=null?name.getText():null) ), new StringLiteral( value ) ) );
                   System.out.println("found ifeq "+(name!=null?name.getText():null) + " = " + value );
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "IFEQ"

    // $ANTLR start "IFNEQ"
    public final void mIFNEQ() throws RecognitionException {
        try {
            int _type = IFNEQ;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token name=null;
            Token selec=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:3: ( 'ifneq' WS '(' ( WS )? '$(' name= CONFIGVAR ')' ( WS )? ',' ( WS )? (selec= IFEQVALUE )? ( WS )? ')' CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:5: 'ifneq' WS '(' ( WS )? '$(' name= CONFIGVAR ')' ( WS )? ',' ( WS )? (selec= IFEQVALUE )? ( WS )? ')' CR
            {
            match("ifneq"); if (state.failed) return ;

            mWS(); if (state.failed) return ;
            match('('); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:20: ( WS )?
            int alt6=2;
            int LA6_0 = input.LA(1);

            if ( (LA6_0=='\t'||LA6_0==' '||LA6_0=='\\') ) {
                alt6=1;
            }
            switch (alt6) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:20: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match("$("); if (state.failed) return ;

            int nameStart121 = getCharIndex();
            mCONFIGVAR(); if (state.failed) return ;
            name = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nameStart121, getCharIndex()-1);
            match(')'); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:48: ( WS )?
            int alt7=2;
            int LA7_0 = input.LA(1);

            if ( (LA7_0=='\t'||LA7_0==' '||LA7_0=='\\') ) {
                alt7=1;
            }
            switch (alt7) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:48: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match(','); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:56: ( WS )?
            int alt8=2;
            switch ( input.LA(1) ) {
                case ' ':
                    {
                    alt8=1;
                    }
                    break;
                case '\t':
                    {
                    alt8=1;
                    }
                    break;
                case '\\':
                    {
                    int LA8_3 = input.LA(2);

                    if ( (LA8_3=='\n') ) {
                        alt8=1;
                    }
                    }
                    break;
            }

            switch (alt8) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:56: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:65: (selec= IFEQVALUE )?
            int alt9=2;
            int LA9_0 = input.LA(1);

            if ( (LA9_0=='m'||LA9_0=='y') ) {
                alt9=1;
            }
            switch (alt9) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:65: selec= IFEQVALUE
                    {
                    int selecStart135 = getCharIndex();
                    mIFEQVALUE(); if (state.failed) return ;
                    selec = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, selecStart135, getCharIndex()-1);

                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:77: ( WS )?
            int alt10=2;
            int LA10_0 = input.LA(1);

            if ( (LA10_0=='\t'||LA10_0==' '||LA10_0=='\\') ) {
                alt10=1;
            }
            switch (alt10) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:68:77: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match(')'); if (state.failed) return ;
            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

                   String value = (selec!=null?selec.getText():null) != null ? (selec!=null?selec.getText():null) : "";
                   modelFactory.pushIf( new NEq( new Identifier( (name!=null?name.getText():null) ), new StringLiteral( value ) ) );
                   System.out.println("found nifeq "+(name!=null?name.getText():null) + " = " + (selec!=null?selec.getText():null) );
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "IFNEQ"

    // $ANTLR start "IFDEF"
    public final void mIFDEF() throws RecognitionException {
        try {
            int _type = IFDEF;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token name=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:75:3: ( 'ifdef' WS name= CONFIGVAR CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:75:5: 'ifdef' WS name= CONFIGVAR CR
            {
            match("ifdef"); if (state.failed) return ;

            mWS(); if (state.failed) return ;
            int nameStart169 = getCharIndex();
            mCONFIGVAR(); if (state.failed) return ;
            name = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nameStart169, getCharIndex()-1);
            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

                   modelFactory.pushIf( new Defined( new Identifier( (name!=null?name.getText():null) ) ) );
                   System.out.println("found ifdef "+(name!=null?name.getText():null) );
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "IFDEF"

    // $ANTLR start "UnsupportedRegocnizedIFEQ"
    public final void mUnsupportedRegocnizedIFEQ() throws RecognitionException {
        try {
            int _type = UnsupportedRegocnizedIFEQ;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token name=null;
            Token v=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:3: ( 'ifeq' WS '(' ( WS )? '$(' name= NA ')' ( WS )? ',' ( WS )? v= VA ( WS )? ')' CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:5: 'ifeq' WS '(' ( WS )? '$(' name= NA ')' ( WS )? ',' ( WS )? v= VA ( WS )? ')' CR
            {
            match("ifeq"); if (state.failed) return ;

            mWS(); if (state.failed) return ;
            match('('); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:19: ( WS )?
            int alt11=2;
            int LA11_0 = input.LA(1);

            if ( (LA11_0=='\t'||LA11_0==' '||LA11_0=='\\') ) {
                alt11=1;
            }
            switch (alt11) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:19: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match("$("); if (state.failed) return ;

            int nameStart203 = getCharIndex();
            mNA(); if (state.failed) return ;
            name = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nameStart203, getCharIndex()-1);
            match(')'); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:40: ( WS )?
            int alt12=2;
            int LA12_0 = input.LA(1);

            if ( (LA12_0=='\t'||LA12_0==' '||LA12_0=='\\') ) {
                alt12=1;
            }
            switch (alt12) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:40: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match(','); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:48: ( WS )?
            int alt13=2;
            int LA13_0 = input.LA(1);

            if ( (LA13_0=='\t'||LA13_0==' '||LA13_0=='\\') ) {
                alt13=1;
            }
            switch (alt13) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:48: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            int vStart217 = getCharIndex();
            mVA(); if (state.failed) return ;
            v = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, vStart217, getCharIndex()-1);
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:57: ( WS )?
            int alt14=2;
            int LA14_0 = input.LA(1);

            if ( (LA14_0=='\t'||LA14_0==' '||LA14_0=='\\') ) {
                alt14=1;
            }
            switch (alt14) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:81:57: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            match(')'); if (state.failed) return ;
            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

                   modelFactory.pushIf( new Eq( new Identifier( (name!=null?name.getText():null) ), new StringLiteral( (v!=null?v.getText():null) ) ) );
                   System.out.println("found unsupported, but recognized and irrelevant ifeq: " + (name!=null?name.getText():null) + "=" + (v!=null?v.getText():null) );
                   
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "UnsupportedRegocnizedIFEQ"

    // $ANTLR start "ComplicatedIFNEQ1"
    public final void mComplicatedIFNEQ1() throws RecognitionException {
        try {
            int _type = ComplicatedIFNEQ1;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:90:3: ( 'ifneq ($(lib-y),)' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:90:5: 'ifneq ($(lib-y),)'
            {
            match("ifneq ($(lib-y),)"); if (state.failed) return ;

            if ( state.backtracking==1 ) {

                   modelFactory.pushIf( new UnknownExpression( new Not( new Eq( new Identifier( "lib-y" ), new StringLiteral( "" ) ) ) ) );
                   
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "ComplicatedIFNEQ1"

    // $ANTLR start "UnsupportedIFEQ"
    public final void mUnsupportedIFEQ() throws RecognitionException {
        try {
            int _type = UnsupportedIFEQ;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:98:3: ( 'ifeq' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:98:5: 'ifeq'
            {
            match("ifeq"); if (state.failed) return ;

            if ( state.backtracking==1 ) {

                   modelFactory.pushIf( new InvalidExpression() );
                   System.out.println( "found unsupported ifeq!" );
                   //throw new RuntimeException("found unsupported ifeq!" );
                   
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "UnsupportedIFEQ"

    // $ANTLR start "UnsupportedIFNEQ"
    public final void mUnsupportedIFNEQ() throws RecognitionException {
        try {
            int _type = UnsupportedIFNEQ;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:106:3: ( 'ifneq' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:106:5: 'ifneq'
            {
            match("ifneq"); if (state.failed) return ;

            if ( state.backtracking==1 ) {

                   modelFactory.pushIf( new InvalidExpression() );
                   System.out.println( "found unsupported ifneq! Maybe we can resolve it later with some heuristics" );
                   //throw new RuntimeException("found unsupported ifeq!" );
                   
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "UnsupportedIFNEQ"

    // $ANTLR start "UnsupportedRegocnizedIFDEF"
    public final void mUnsupportedRegocnizedIFDEF() throws RecognitionException {
        try {
            int _type = UnsupportedRegocnizedIFDEF;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token name=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:115:3: ( 'ifdef' WS name= NA CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:115:5: 'ifdef' WS name= NA CR
            {
            match("ifdef"); if (state.failed) return ;

            mWS(); if (state.failed) return ;
            int nameStart321 = getCharIndex();
            mNA(); if (state.failed) return ;
            name = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nameStart321, getCharIndex()-1);
            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

                   modelFactory.pushIf( new Defined( new Identifier( (name!=null?name.getText():null) ) ) );
                   System.out.println("found unsupported, but recognized and irrelevant ifdef: " + (name!=null?name.getText():null) );
                    
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "UnsupportedRegocnizedIFDEF"

    // $ANTLR start "UnsupportedIFDEF"
    public final void mUnsupportedIFDEF() throws RecognitionException {
        try {
            int _type = UnsupportedIFDEF;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:122:3: ( 'ifdef' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:122:5: 'ifdef'
            {
            match("ifdef"); if (state.failed) return ;

            if ( state.backtracking==1 ) {

                   modelFactory.pushIf( new InvalidExpression() );
                   System.out.println( "found unsupported ifdef!" );
                   //throw new RuntimeException("found unsupported ifeq!" );
                   
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "UnsupportedIFDEF"

    // $ANTLR start "ELSE"
    public final void mELSE() throws RecognitionException {
        try {
            int _type = ELSE;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:131:3: ( 'else' CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:131:5: 'else' CR
            {
            match("else"); if (state.failed) return ;

            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

              	modelFactory.pushElse();
                      System.out.println("found else");
                   
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "ELSE"

    // $ANTLR start "ENDIF"
    public final void mENDIF() throws RecognitionException {
        try {
            int _type = ENDIF;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:139:3: ( 'endif' CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:139:5: 'endif' CR
            {
            match("endif"); if (state.failed) return ;

            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

                   modelFactory.popEndIf();
                   System.out.println("found endif");
                   
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "ENDIF"

    // $ANTLR start "LISTROW"
    public final void mLISTROW() throws RecognitionException {
        try {
            int _type = LISTROW;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token listname=null;
            Token name=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:148:3: ( ( WS )? listname= LISTE LISTASSIGNMENT name= ListOfObjectsOrDirs CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:148:5: ( WS )? listname= LISTE LISTASSIGNMENT name= ListOfObjectsOrDirs CR
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:148:5: ( WS )?
            int alt15=2;
            int LA15_0 = input.LA(1);

            if ( (LA15_0=='\t'||LA15_0==' '||LA15_0=='\\') ) {
                alt15=1;
            }
            switch (alt15) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:148:5: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            int listnameStart421 = getCharIndex();
            mLISTE(); if (state.failed) return ;
            listname = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, listnameStart421, getCharIndex()-1);
            mLISTASSIGNMENT(); if (state.failed) return ;
            int nameStart427 = getCharIndex();
            mListOfObjectsOrDirs(); if (state.failed) return ;
            name = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nameStart427, getCharIndex()-1);
            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {

                   
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
                
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "LISTROW"

    // $ANTLR start "LISTE"
    public final void mLISTE() throws RecognitionException {
        try {
            int _type = LISTE;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token s=null;


              currentListName = null;
              currentSelection = null;
              currentVariable = null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:248:3: ( ( 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '-' | '_' | '0' .. '9' )+ '-' (s= SELECTION | VARIABLE ) )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:248:5: ( 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '-' | '_' | '0' .. '9' )+ '-' (s= SELECTION | VARIABLE )
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:248:5: ( 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '-' | '_' | '0' .. '9' )+
            int cnt16=0;
            loop16:
            do {
                int alt16=2;
                alt16 = dfa16.predict(input);
                switch (alt16) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            	    {
            	    if ( input.LA(1)=='-'||(input.LA(1)>='0' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();
            	    state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return ;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt16 >= 1 ) break loop16;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(16, input);
                        throw eee;
                }
                cnt16++;
            } while (true);

            match('-'); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:248:56: (s= SELECTION | VARIABLE )
            int alt17=2;
            int LA17_0 = input.LA(1);

            if ( (LA17_0=='m'||LA17_0=='o'||LA17_0=='y') ) {
                alt17=1;
            }
            else if ( (LA17_0=='$') ) {
                alt17=2;
            }
            else {
                if (state.backtracking>0) {state.failed=true; return ;}
                NoViableAltException nvae =
                    new NoViableAltException("", 17, 0, input);

                throw nvae;
            }
            switch (alt17) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:248:58: s= SELECTION
                    {
                    int sStart476 = getCharIndex();
                    mSELECTION(); if (state.failed) return ;
                    s = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, sStart476, getCharIndex()-1);

                    }
                    break;
                case 2 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:248:72: VARIABLE
                    {
                    mVARIABLE(); if (state.failed) return ;

                    }
                    break;

            }

            if ( state.backtracking==1 ) {
               
                  System.out.println("!!!" + getText() + "!!!" );
                  currentListName = getText().trim().substring ( 0, getText().trim().lastIndexOf('-') );
                  currentSelection = (s!=null?s.getText():null);
                
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "LISTE"

    // $ANTLR start "ARBITRARYVARASSIGNMENT"
    public final void mARBITRARYVARASSIGNMENT() throws RecognitionException {
        try {
            int _type = ARBITRARYVARASSIGNMENT;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token n=null;
            Token la=null;
            Token v=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:257:3: ( ( WS )? n= NA la= LISTASSIGNMENT v= VA2 CR )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:258:5: ( WS )? n= NA la= LISTASSIGNMENT v= VA2 CR
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:258:5: ( WS )?
            int alt18=2;
            int LA18_0 = input.LA(1);

            if ( (LA18_0=='\t'||LA18_0==' '||LA18_0=='\\') ) {
                alt18=1;
            }
            switch (alt18) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:258:5: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            int nStart506 = getCharIndex();
            mNA(); if (state.failed) return ;
            n = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nStart506, getCharIndex()-1);
            int laStart510 = getCharIndex();
            mLISTASSIGNMENT(); if (state.failed) return ;
            la = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, laStart510, getCharIndex()-1);
            int vStart514 = getCharIndex();
            mVA2(); if (state.failed) return ;
            v = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, vStart514, getCharIndex()-1);
            mCR(); if (state.failed) return ;
            if ( state.backtracking==1 ) {
               vars.put( (n!=null?n.getText():null), (v!=null?v.getText():null) );
                  modelFactory.addVariableAssignment( (n!=null?n.getText():null), (la!=null?la.getText():null), (v!=null?v.getText():null) );
                  System.out.println ("Found var assignment: " + (n!=null?n.getText():null) + (la!=null?la.getText():null) + (v!=null?v.getText():null) ); 
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "ARBITRARYVARASSIGNMENT"

    // $ANTLR start "ARBITRARYVARASSIGNMENT_AS_LIST"
    public final void mARBITRARYVARASSIGNMENT_AS_LIST() throws RecognitionException {
        try {
            int _type = ARBITRARYVARASSIGNMENT_AS_LIST;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            Token n=null;
            Token la=null;
            Token wholeValue=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:274:2: ( ( WS )? n= NA la= LISTASSIGNMENT ( WS )? wholeValue= AVA_HELPER1 )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:274:4: ( WS )? n= NA la= LISTASSIGNMENT ( WS )? wholeValue= AVA_HELPER1
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:274:4: ( WS )?
            int alt19=2;
            int LA19_0 = input.LA(1);

            if ( (LA19_0=='\t'||LA19_0==' '||LA19_0=='\\') ) {
                alt19=1;
            }
            switch (alt19) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:274:4: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            int nStart542 = getCharIndex();
            mNA(); if (state.failed) return ;
            n = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, nStart542, getCharIndex()-1);
            if ( state.backtracking==1 ) {
               modelFactory.pushListVariable( (n!=null?n.getText():null) ); 
            }
            int laStart548 = getCharIndex();
            mLISTASSIGNMENT(); if (state.failed) return ;
            la = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, laStart548, getCharIndex()-1);
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:274:77: ( WS )?
            int alt20=2;
            int LA20_0 = input.LA(1);

            if ( (LA20_0=='\t'||LA20_0==' '||LA20_0=='\\') ) {
                alt20=1;
            }
            switch (alt20) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:274:77: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            int wholeValueStart555 = getCharIndex();
            mAVA_HELPER1(); if (state.failed) return ;
            wholeValue = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, wholeValueStart555, getCharIndex()-1);
            if ( state.backtracking==1 ) {

              	modelFactory.popListVariable();
              	modelFactory.addVariableAssignment( (n!=null?n.getText():null), (la!=null?la.getText():null), (wholeValue!=null?wholeValue.getText():null) );
              	System.out.println("Found another variable that contains a list"); 
            }

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "ARBITRARYVARASSIGNMENT_AS_LIST"

    // $ANTLR start "AVA_HELPER1"
    public final void mAVA_HELPER1() throws RecognitionException {
        try {
            Token v=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:281:22: ( (v= VA ( WS )* )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:281:24: (v= VA ( WS )* )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:281:24: (v= VA ( WS )* )+
            int cnt22=0;
            loop22:
            do {
                int alt22=2;
                int LA22_0 = input.LA(1);

                if ( ((LA22_0>='-' && LA22_0<='9')||(LA22_0>='A' && LA22_0<='Z')||LA22_0=='_'||(LA22_0>='a' && LA22_0<='z')) ) {
                    alt22=1;
                }


                switch (alt22) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:281:25: v= VA ( WS )*
            	    {
            	    int vStart573 = getCharIndex();
            	    mVA(); if (state.failed) return ;
            	    v = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, vStart573, getCharIndex()-1);
            	    if ( state.backtracking==1 ) {

            	      		if( (v!=null?v.getText():null).endsWith(".o") )
            	      			modelFactory.addObjectToList( (v!=null?v.getText():null).substring( 0, (v!=null?v.getText():null).length()-2 ) );
            	      	
            	    }
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:284:4: ( WS )*
            	    loop21:
            	    do {
            	        int alt21=2;
            	        int LA21_0 = input.LA(1);

            	        if ( (LA21_0=='\t'||LA21_0==' '||LA21_0=='\\') ) {
            	            alt21=1;
            	        }


            	        switch (alt21) {
            	    	case 1 :
            	    	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:284:4: WS
            	    	    {
            	    	    mWS(); if (state.failed) return ;

            	    	    }
            	    	    break;

            	    	default :
            	    	    break loop21;
            	        }
            	    } while (true);


            	    }
            	    break;

            	default :
            	    if ( cnt22 >= 1 ) break loop22;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(22, input);
                        throw eee;
                }
                cnt22++;
            } while (true);


            }

        }
        finally {
        }
    }
    // $ANTLR end "AVA_HELPER1"

    // $ANTLR start "NA"
    public final void mNA() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:287:13: ( ( 'A' .. 'Z' | 'a' .. 'z' | '_' | '-' | '0' .. '9' | '.' )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:287:15: ( 'A' .. 'Z' | 'a' .. 'z' | '_' | '-' | '0' .. '9' | '.' )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:287:15: ( 'A' .. 'Z' | 'a' .. 'z' | '_' | '-' | '0' .. '9' | '.' )+
            int cnt23=0;
            loop23:
            do {
                int alt23=2;
                int LA23_0 = input.LA(1);

                if ( ((LA23_0>='-' && LA23_0<='.')||(LA23_0>='0' && LA23_0<='9')||(LA23_0>='A' && LA23_0<='Z')||LA23_0=='_'||(LA23_0>='a' && LA23_0<='z')) ) {
                    alt23=1;
                }


                switch (alt23) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            	    {
            	    if ( (input.LA(1)>='-' && input.LA(1)<='.')||(input.LA(1)>='0' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();
            	    state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return ;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt23 >= 1 ) break loop23;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(23, input);
                        throw eee;
                }
                cnt23++;
            } while (true);


            }

        }
        finally {
        }
    }
    // $ANTLR end "NA"

    // $ANTLR start "VA"
    public final void mVA() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:288:13: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:288:15: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:288:15: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' )+
            int cnt24=0;
            loop24:
            do {
                int alt24=2;
                int LA24_0 = input.LA(1);

                if ( ((LA24_0>='-' && LA24_0<='9')||(LA24_0>='A' && LA24_0<='Z')||LA24_0=='_'||(LA24_0>='a' && LA24_0<='z')) ) {
                    alt24=1;
                }


                switch (alt24) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            	    {
            	    if ( (input.LA(1)>='-' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();
            	    state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return ;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt24 >= 1 ) break loop24;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(24, input);
                        throw eee;
                }
                cnt24++;
            } while (true);


            }

        }
        finally {
        }
    }
    // $ANTLR end "VA"

    // $ANTLR start "VA2"
    public final void mVA2() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:289:14: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' | '$' | '(' | ')' | '=' | ',' | ' ' | '\"' | '\\'' )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:289:16: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' | '$' | '(' | ')' | '=' | ',' | ' ' | '\"' | '\\'' )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:289:16: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' | '$' | '(' | ')' | '=' | ',' | ' ' | '\"' | '\\'' )+
            int cnt25=0;
            loop25:
            do {
                int alt25=2;
                int LA25_0 = input.LA(1);

                if ( (LA25_0==' '||LA25_0=='\"'||LA25_0=='$'||(LA25_0>='\'' && LA25_0<=')')||(LA25_0>=',' && LA25_0<='9')||LA25_0=='='||(LA25_0>='A' && LA25_0<='Z')||LA25_0=='_'||(LA25_0>='a' && LA25_0<='z')) ) {
                    alt25=1;
                }


                switch (alt25) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            	    {
            	    if ( input.LA(1)==' '||input.LA(1)=='\"'||input.LA(1)=='$'||(input.LA(1)>='\'' && input.LA(1)<=')')||(input.LA(1)>=',' && input.LA(1)<='9')||input.LA(1)=='='||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();
            	    state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return ;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt25 >= 1 ) break loop25;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(25, input);
                        throw eee;
                }
                cnt25++;
            } while (true);


            }

        }
        finally {
        }
    }
    // $ANTLR end "VA2"

    // $ANTLR start "VA3"
    public final void mVA3() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:290:14: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' | '=' | ',' | ' ' )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:290:16: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' | '=' | ',' | ' ' )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:290:16: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '.' | '0' .. '9' | '/' | '=' | ',' | ' ' )+
            int cnt26=0;
            loop26:
            do {
                int alt26=2;
                int LA26_0 = input.LA(1);

                if ( (LA26_0==' '||(LA26_0>=',' && LA26_0<='9')||LA26_0=='='||(LA26_0>='A' && LA26_0<='Z')||LA26_0=='_'||(LA26_0>='a' && LA26_0<='z')) ) {
                    alt26=1;
                }


                switch (alt26) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            	    {
            	    if ( input.LA(1)==' '||(input.LA(1)>=',' && input.LA(1)<='9')||input.LA(1)=='='||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();
            	    state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return ;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt26 >= 1 ) break loop26;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(26, input);
                        throw eee;
                }
                cnt26++;
            } while (true);


            }

        }
        finally {
        }
    }
    // $ANTLR end "VA3"

    // $ANTLR start "LISTASSIGNMENT"
    public final void mLISTASSIGNMENT() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:3: ( ( WS )? ( '+=' | ':=' | '=' ) ( WS )? )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:5: ( WS )? ( '+=' | ':=' | '=' ) ( WS )?
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:5: ( WS )?
            int alt27=2;
            int LA27_0 = input.LA(1);

            if ( (LA27_0=='\t'||LA27_0==' '||LA27_0=='\\') ) {
                alt27=1;
            }
            switch (alt27) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:5: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:9: ( '+=' | ':=' | '=' )
            int alt28=3;
            switch ( input.LA(1) ) {
            case '+':
                {
                alt28=1;
                }
                break;
            case ':':
                {
                alt28=2;
                }
                break;
            case '=':
                {
                alt28=3;
                }
                break;
            default:
                if (state.backtracking>0) {state.failed=true; return ;}
                NoViableAltException nvae =
                    new NoViableAltException("", 28, 0, input);

                throw nvae;
            }

            switch (alt28) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:11: '+='
                    {
                    match("+="); if (state.failed) return ;


                    }
                    break;
                case 2 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:18: ':='
                    {
                    match(":="); if (state.failed) return ;


                    }
                    break;
                case 3 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:25: '='
                    {
                    match('='); if (state.failed) return ;

                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:31: ( WS )?
            int alt29=2;
            int LA29_0 = input.LA(1);

            if ( (LA29_0=='\t'||LA29_0==' '||LA29_0=='\\') ) {
                alt29=1;
            }
            switch (alt29) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:296:31: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }


            }

        }
        finally {
        }
    }
    // $ANTLR end "LISTASSIGNMENT"

    // $ANTLR start "ListOfObjectsOrDirs"
    public final void mListOfObjectsOrDirs() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:302:3: ( ( WS | LISTELEMENT )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:302:5: ( WS | LISTELEMENT )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:302:5: ( WS | LISTELEMENT )+
            int cnt30=0;
            loop30:
            do {
                int alt30=3;
                int LA30_0 = input.LA(1);

                if ( (LA30_0=='\t'||LA30_0==' '||LA30_0=='\\') ) {
                    alt30=1;
                }
                else if ( (LA30_0=='$'||(LA30_0>='(' && LA30_0<=')')||LA30_0=='-'||(LA30_0>='/' && LA30_0<='9')||LA30_0=='<'||(LA30_0>='A' && LA30_0<='Z')||LA30_0=='_'||(LA30_0>='a' && LA30_0<='z')) ) {
                    alt30=2;
                }


                switch (alt30) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:302:7: WS
            	    {
            	    mWS(); if (state.failed) return ;

            	    }
            	    break;
            	case 2 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:302:12: LISTELEMENT
            	    {
            	    mLISTELEMENT(); if (state.failed) return ;

            	    }
            	    break;

            	default :
            	    if ( cnt30 >= 1 ) break loop30;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(30, input);
                        throw eee;
                }
                cnt30++;
            } while (true);


            }

        }
        finally {
        }
    }
    // $ANTLR end "ListOfObjectsOrDirs"

    // $ANTLR start "LISTELEMENT"
    public final void mLISTELEMENT() throws RecognitionException {
        try {
            Token obj=null;
            Token sub=null;
            Token v=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:307:3: (obj= OBJECTFILENAME | sub= SUBDIR | '$(' v= NA ')' )
            int alt31=3;
            alt31 = dfa31.predict(input);
            switch (alt31) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:307:5: obj= OBJECTFILENAME
                    {
                    int objStart800 = getCharIndex();
                    mOBJECTFILENAME(); if (state.failed) return ;
                    obj = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, objStart800, getCharIndex()-1);
                    if ( state.backtracking==1 ) {
                       elements_objects.add( (obj!=null?obj.getText():null) ); 
                    }

                    }
                    break;
                case 2 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:308:5: sub= SUBDIR
                    {
                    int subStart812 = getCharIndex();
                    mSUBDIR(); if (state.failed) return ;
                    sub = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, subStart812, getCharIndex()-1);
                    if ( state.backtracking==1 ) {
                       elements_folders.add( (sub!=null?sub.getText():null) ); 
                    }

                    }
                    break;
                case 3 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:309:5: '$(' v= NA ')'
                    {
                    match("$("); if (state.failed) return ;

                    int vStart826 = getCharIndex();
                    mNA(); if (state.failed) return ;
                    v = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, vStart826, getCharIndex()-1);
                    match(')'); if (state.failed) return ;
                    if ( state.backtracking==1 ) {
                       elements_variables.add( (v!=null?v.getText():null) ); 
                    }

                    }
                    break;

            }
        }
        finally {
        }
    }
    // $ANTLR end "LISTELEMENT"

    // $ANTLR start "VARIABLE"
    public final void mVARIABLE() throws RecognitionException {
        try {
            Token var=null;
            Token v=null;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:315:3: ( '$(' (var= CONFIGVAR | 'call sequencer,' ( WS )? '$(' v= CONFIGVAR ')' ) ')' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:315:5: '$(' (var= CONFIGVAR | 'call sequencer,' ( WS )? '$(' v= CONFIGVAR ')' ) ')'
            {
            match("$("); if (state.failed) return ;

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:315:10: (var= CONFIGVAR | 'call sequencer,' ( WS )? '$(' v= CONFIGVAR ')' )
            int alt33=2;
            int LA33_0 = input.LA(1);

            if ( (LA33_0=='A'||LA33_0=='C') ) {
                alt33=1;
            }
            else if ( (LA33_0=='c') ) {
                alt33=2;
            }
            else {
                if (state.backtracking>0) {state.failed=true; return ;}
                NoViableAltException nvae =
                    new NoViableAltException("", 33, 0, input);

                throw nvae;
            }
            switch (alt33) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:315:12: var= CONFIGVAR
                    {
                    int varStart854 = getCharIndex();
                    mCONFIGVAR(); if (state.failed) return ;
                    var = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, varStart854, getCharIndex()-1);
                    if ( state.backtracking==1 ) {
                       currentVariable = (var!=null?var.getText():null); 
                    }

                    }
                    break;
                case 2 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:315:63: 'call sequencer,' ( WS )? '$(' v= CONFIGVAR ')'
                    {
                    match("call sequencer,"); if (state.failed) return ;

                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:315:81: ( WS )?
                    int alt32=2;
                    int LA32_0 = input.LA(1);

                    if ( (LA32_0=='\t'||LA32_0==' '||LA32_0=='\\') ) {
                        alt32=1;
                    }
                    switch (alt32) {
                        case 1 :
                            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:315:81: WS
                            {
                            mWS(); if (state.failed) return ;

                            }
                            break;

                    }

                    match("$("); if (state.failed) return ;

                    int vStart869 = getCharIndex();
                    mCONFIGVAR(); if (state.failed) return ;
                    v = new CommonToken(input, Token.INVALID_TOKEN_TYPE, Token.DEFAULT_CHANNEL, vStart869, getCharIndex()-1);
                    match(')'); if (state.failed) return ;
                    if ( state.backtracking==1 ) {
                       currentVariable = "SequencerCall[CONFIG_SND_SEQUENCER," + (v!=null?v.getText():null) + "]"; System.out.println( "Found call in list construction! Diasambiguate manually!" ); 
                    }

                    }
                    break;

            }

            match(')'); if (state.failed) return ;

            }

        }
        finally {
        }
    }
    // $ANTLR end "VARIABLE"

    // $ANTLR start "SL_COMMENT"
    public final void mSL_COMMENT() throws RecognitionException {
        try {
            int _type = SL_COMMENT;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:320:5: ( '#' ( options {greedy=false; } : . )* '\\n' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:320:9: '#' ( options {greedy=false; } : . )* '\\n'
            {
            match('#'); if (state.failed) return ;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:320:13: ( options {greedy=false; } : . )*
            loop34:
            do {
                int alt34=2;
                int LA34_0 = input.LA(1);

                if ( (LA34_0=='\n') ) {
                    alt34=2;
                }
                else if ( ((LA34_0>='\u0000' && LA34_0<='\t')||(LA34_0>='\u000B' && LA34_0<='\uFFFF')) ) {
                    alt34=1;
                }


                switch (alt34) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:320:40: .
            	    {
            	    matchAny(); if (state.failed) return ;

            	    }
            	    break;

            	default :
            	    break loop34;
                }
            } while (true);

            match('\n'); if (state.failed) return ;

            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "SL_COMMENT"

    // $ANTLR start "WS"
    public final void mWS() throws RecognitionException {
        try {
            int _type = WS;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:324:5: ( ( ' ' | '\\t' | '\\\\\\n' )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:324:9: ( ' ' | '\\t' | '\\\\\\n' )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:324:9: ( ' ' | '\\t' | '\\\\\\n' )+
            int cnt35=0;
            loop35:
            do {
                int alt35=4;
                switch ( input.LA(1) ) {
                case ' ':
                    {
                    alt35=1;
                    }
                    break;
                case '\t':
                    {
                    alt35=2;
                    }
                    break;
                case '\\':
                    {
                    alt35=3;
                    }
                    break;

                }

                switch (alt35) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:324:10: ' '
            	    {
            	    match(' '); if (state.failed) return ;

            	    }
            	    break;
            	case 2 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:324:14: '\\t'
            	    {
            	    match('\t'); if (state.failed) return ;

            	    }
            	    break;
            	case 3 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:324:21: '\\\\\\n'
            	    {
            	    match("\\\n"); if (state.failed) return ;


            	    }
            	    break;

            	default :
            	    if ( cnt35 >= 1 ) break loop35;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(35, input);
                        throw eee;
                }
                cnt35++;
            } while (true);


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "WS"

    // $ANTLR start "CR"
    public final void mCR() throws RecognitionException {
        try {
            int _type = CR;
            int _channel = DEFAULT_TOKEN_CHANNEL;
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:5: ( ( WS )? ( '\\n' | SL_COMMENT | EOF ) )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:7: ( WS )? ( '\\n' | SL_COMMENT | EOF )
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:7: ( WS )?
            int alt36=2;
            int LA36_0 = input.LA(1);

            if ( (LA36_0=='\t'||LA36_0==' '||LA36_0=='\\') ) {
                alt36=1;
            }
            switch (alt36) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:7: WS
                    {
                    mWS(); if (state.failed) return ;

                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:11: ( '\\n' | SL_COMMENT | EOF )
            int alt37=3;
            switch ( input.LA(1) ) {
            case '\n':
                {
                alt37=1;
                }
                break;
            case '#':
                {
                alt37=2;
                }
                break;
            default:
                alt37=3;}

            switch (alt37) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:13: '\\n'
                    {
                    match('\n'); if (state.failed) return ;

                    }
                    break;
                case 2 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:20: SL_COMMENT
                    {
                    mSL_COMMENT(); if (state.failed) return ;

                    }
                    break;
                case 3 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:327:33: EOF
                    {
                    match(EOF); if (state.failed) return ;

                    }
                    break;

            }


            }

            state.type = _type;
            state.channel = _channel;
        }
        finally {
        }
    }
    // $ANTLR end "CR"

    // $ANTLR start "OBJECTFILENAME"
    public final void mOBJECTFILENAME() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:332:17: ( ( '<generated>' )? ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+ '/' )? FILENAME '.o' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:332:19: ( '<generated>' )? ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+ '/' )? FILENAME '.o'
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:332:19: ( '<generated>' )?
            int alt38=2;
            int LA38_0 = input.LA(1);

            if ( (LA38_0=='<') ) {
                alt38=1;
            }
            switch (alt38) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:332:20: '<generated>'
                    {
                    match("<generated>"); if (state.failed) return ;


                    }
                    break;

            }

            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:332:36: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+ '/' )?
            int alt40=2;
            alt40 = dfa40.predict(input);
            switch (alt40) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:332:37: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+ '/'
                    {
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:332:37: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+
                    int cnt39=0;
                    loop39:
                    do {
                        int alt39=2;
                        alt39 = dfa39.predict(input);
                        switch (alt39) {
                    	case 1 :
                    	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
                    	    {
                    	    if ( input.LA(1)=='-'||(input.LA(1)>='/' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
                    	        input.consume();
                    	    state.failed=false;
                    	    }
                    	    else {
                    	        if (state.backtracking>0) {state.failed=true; return ;}
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;}


                    	    }
                    	    break;

                    	default :
                    	    if ( cnt39 >= 1 ) break loop39;
                    	    if (state.backtracking>0) {state.failed=true; return ;}
                                EarlyExitException eee =
                                    new EarlyExitException(39, input);
                                throw eee;
                        }
                        cnt39++;
                    } while (true);

                    match('/'); if (state.failed) return ;

                    }
                    break;

            }

            mFILENAME(); if (state.failed) return ;
            match(".o"); if (state.failed) return ;


            }

        }
        finally {
        }
    }
    // $ANTLR end "OBJECTFILENAME"

    // $ANTLR start "SUBDIR"
    public final void mSUBDIR() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:336:9: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+ '/' )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:336:11: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+ '/'
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:336:11: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+
            int cnt41=0;
            loop41:
            do {
                int alt41=2;
                int LA41_0 = input.LA(1);

                if ( (LA41_0=='/') ) {
                    int LA41_1 = input.LA(2);

                    if ( (LA41_1=='-'||(LA41_1>='/' && LA41_1<='9')||(LA41_1>='A' && LA41_1<='Z')||LA41_1=='_'||(LA41_1>='a' && LA41_1<='z')) ) {
                        alt41=1;
                    }


                }
                else if ( (LA41_0=='-'||(LA41_0>='0' && LA41_0<='9')||(LA41_0>='A' && LA41_0<='Z')||LA41_0=='_'||(LA41_0>='a' && LA41_0<='z')) ) {
                    alt41=1;
                }


                switch (alt41) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            	    {
            	    if ( input.LA(1)=='-'||(input.LA(1)>='/' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();
            	    state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return ;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt41 >= 1 ) break loop41;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(41, input);
                        throw eee;
                }
                cnt41++;
            } while (true);

            match('/'); if (state.failed) return ;

            }

        }
        finally {
        }
    }
    // $ANTLR end "SUBDIR"

    // $ANTLR start "SELECTION"
    public final void mSELECTION() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:342:3: ( 'y' | 'm' | 'objs' )
            int alt42=3;
            switch ( input.LA(1) ) {
            case 'y':
                {
                alt42=1;
                }
                break;
            case 'm':
                {
                alt42=2;
                }
                break;
            case 'o':
                {
                alt42=3;
                }
                break;
            default:
                if (state.backtracking>0) {state.failed=true; return ;}
                NoViableAltException nvae =
                    new NoViableAltException("", 42, 0, input);

                throw nvae;
            }

            switch (alt42) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:342:5: 'y'
                    {
                    match('y'); if (state.failed) return ;

                    }
                    break;
                case 2 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:342:9: 'm'
                    {
                    match('m'); if (state.failed) return ;

                    }
                    break;
                case 3 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:342:13: 'objs'
                    {
                    match("objs"); if (state.failed) return ;


                    }
                    break;

            }
        }
        finally {
        }
    }
    // $ANTLR end "SELECTION"

    // $ANTLR start "FILENAME"
    public final void mFILENAME() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:346:11: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '$' | '(' | ')' )+ )
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:346:15: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '$' | '(' | ')' )+
            {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:346:15: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '$' | '(' | ')' )+
            int cnt43=0;
            loop43:
            do {
                int alt43=2;
                int LA43_0 = input.LA(1);

                if ( (LA43_0=='$'||(LA43_0>='(' && LA43_0<=')')||LA43_0=='-'||(LA43_0>='0' && LA43_0<='9')||(LA43_0>='A' && LA43_0<='Z')||LA43_0=='_'||(LA43_0>='a' && LA43_0<='z')) ) {
                    alt43=1;
                }


                switch (alt43) {
            	case 1 :
            	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
            	    {
            	    if ( input.LA(1)=='$'||(input.LA(1)>='(' && input.LA(1)<=')')||input.LA(1)=='-'||(input.LA(1)>='0' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
            	        input.consume();
            	    state.failed=false;
            	    }
            	    else {
            	        if (state.backtracking>0) {state.failed=true; return ;}
            	        MismatchedSetException mse = new MismatchedSetException(null,input);
            	        recover(mse);
            	        throw mse;}


            	    }
            	    break;

            	default :
            	    if ( cnt43 >= 1 ) break loop43;
            	    if (state.backtracking>0) {state.failed=true; return ;}
                        EarlyExitException eee =
                            new EarlyExitException(43, input);
                        throw eee;
                }
                cnt43++;
            } while (true);


            }

        }
        finally {
        }
    }
    // $ANTLR end "FILENAME"

    // $ANTLR start "CONFIGVAR"
    public final void mCONFIGVAR() throws RecognitionException {
        try {
            // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:351:12: ( 'CONFIG_' ( 'A' .. 'Z' | 'a' .. 'z' | '_' | '-' | '0' .. '9' )+ | 'ACPI_FUTURE_USAGE' )
            int alt45=2;
            int LA45_0 = input.LA(1);

            if ( (LA45_0=='C') ) {
                alt45=1;
            }
            else if ( (LA45_0=='A') ) {
                alt45=2;
            }
            else {
                if (state.backtracking>0) {state.failed=true; return ;}
                NoViableAltException nvae =
                    new NoViableAltException("", 45, 0, input);

                throw nvae;
            }
            switch (alt45) {
                case 1 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:351:16: 'CONFIG_' ( 'A' .. 'Z' | 'a' .. 'z' | '_' | '-' | '0' .. '9' )+
                    {
                    match("CONFIG_"); if (state.failed) return ;

                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:351:26: ( 'A' .. 'Z' | 'a' .. 'z' | '_' | '-' | '0' .. '9' )+
                    int cnt44=0;
                    loop44:
                    do {
                        int alt44=2;
                        int LA44_0 = input.LA(1);

                        if ( (LA44_0=='-'||(LA44_0>='0' && LA44_0<='9')||(LA44_0>='A' && LA44_0<='Z')||LA44_0=='_'||(LA44_0>='a' && LA44_0<='z')) ) {
                            alt44=1;
                        }


                        switch (alt44) {
                    	case 1 :
                    	    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:
                    	    {
                    	    if ( input.LA(1)=='-'||(input.LA(1)>='0' && input.LA(1)<='9')||(input.LA(1)>='A' && input.LA(1)<='Z')||input.LA(1)=='_'||(input.LA(1)>='a' && input.LA(1)<='z') ) {
                    	        input.consume();
                    	    state.failed=false;
                    	    }
                    	    else {
                    	        if (state.backtracking>0) {state.failed=true; return ;}
                    	        MismatchedSetException mse = new MismatchedSetException(null,input);
                    	        recover(mse);
                    	        throw mse;}


                    	    }
                    	    break;

                    	default :
                    	    if ( cnt44 >= 1 ) break loop44;
                    	    if (state.backtracking>0) {state.failed=true; return ;}
                                EarlyExitException eee =
                                    new EarlyExitException(44, input);
                                throw eee;
                        }
                        cnt44++;
                    } while (true);


                    }
                    break;
                case 2 :
                    // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:351:66: 'ACPI_FUTURE_USAGE'
                    {
                    match("ACPI_FUTURE_USAGE"); if (state.failed) return ;


                    }
                    break;

            }
        }
        finally {
        }
    }
    // $ANTLR end "CONFIGVAR"

    public void mTokens() throws RecognitionException {
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:39: ( IFEQ | IFNEQ | IFDEF | UnsupportedRegocnizedIFEQ | ComplicatedIFNEQ1 | UnsupportedIFEQ | UnsupportedIFNEQ | UnsupportedRegocnizedIFDEF | UnsupportedIFDEF | ELSE | ENDIF | LISTROW | LISTE | ARBITRARYVARASSIGNMENT | ARBITRARYVARASSIGNMENT_AS_LIST | SL_COMMENT | WS | CR )
        int alt46=18;
        alt46 = dfa46.predict(input);
        switch (alt46) {
            case 1 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:41: IFEQ
                {
                mIFEQ(); if (state.failed) return ;

                }
                break;
            case 2 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:46: IFNEQ
                {
                mIFNEQ(); if (state.failed) return ;

                }
                break;
            case 3 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:52: IFDEF
                {
                mIFDEF(); if (state.failed) return ;

                }
                break;
            case 4 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:58: UnsupportedRegocnizedIFEQ
                {
                mUnsupportedRegocnizedIFEQ(); if (state.failed) return ;

                }
                break;
            case 5 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:84: ComplicatedIFNEQ1
                {
                mComplicatedIFNEQ1(); if (state.failed) return ;

                }
                break;
            case 6 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:102: UnsupportedIFEQ
                {
                mUnsupportedIFEQ(); if (state.failed) return ;

                }
                break;
            case 7 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:118: UnsupportedIFNEQ
                {
                mUnsupportedIFNEQ(); if (state.failed) return ;

                }
                break;
            case 8 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:135: UnsupportedRegocnizedIFDEF
                {
                mUnsupportedRegocnizedIFDEF(); if (state.failed) return ;

                }
                break;
            case 9 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:162: UnsupportedIFDEF
                {
                mUnsupportedIFDEF(); if (state.failed) return ;

                }
                break;
            case 10 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:179: ELSE
                {
                mELSE(); if (state.failed) return ;

                }
                break;
            case 11 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:184: ENDIF
                {
                mENDIF(); if (state.failed) return ;

                }
                break;
            case 12 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:190: LISTROW
                {
                mLISTROW(); if (state.failed) return ;

                }
                break;
            case 13 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:198: LISTE
                {
                mLISTE(); if (state.failed) return ;

                }
                break;
            case 14 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:204: ARBITRARYVARASSIGNMENT
                {
                mARBITRARYVARASSIGNMENT(); if (state.failed) return ;

                }
                break;
            case 15 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:227: ARBITRARYVARASSIGNMENT_AS_LIST
                {
                mARBITRARYVARASSIGNMENT_AS_LIST(); if (state.failed) return ;

                }
                break;
            case 16 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:258: SL_COMMENT
                {
                mSL_COMMENT(); if (state.failed) return ;

                }
                break;
            case 17 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:269: WS
                {
                mWS(); if (state.failed) return ;

                }
                break;
            case 18 :
                // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:272: CR
                {
                mCR(); if (state.failed) return ;

                }
                break;

        }

    }

    // $ANTLR start synpred1_FuzzyMakefileLexer
    public final void synpred1_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:41: ( IFEQ )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:41: IFEQ
        {
        mIFEQ(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred1_FuzzyMakefileLexer

    // $ANTLR start synpred2_FuzzyMakefileLexer
    public final void synpred2_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:46: ( IFNEQ )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:46: IFNEQ
        {
        mIFNEQ(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred2_FuzzyMakefileLexer

    // $ANTLR start synpred3_FuzzyMakefileLexer
    public final void synpred3_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:52: ( IFDEF )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:52: IFDEF
        {
        mIFDEF(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred3_FuzzyMakefileLexer

    // $ANTLR start synpred4_FuzzyMakefileLexer
    public final void synpred4_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:58: ( UnsupportedRegocnizedIFEQ )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:58: UnsupportedRegocnizedIFEQ
        {
        mUnsupportedRegocnizedIFEQ(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred4_FuzzyMakefileLexer

    // $ANTLR start synpred5_FuzzyMakefileLexer
    public final void synpred5_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:84: ( ComplicatedIFNEQ1 )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:84: ComplicatedIFNEQ1
        {
        mComplicatedIFNEQ1(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred5_FuzzyMakefileLexer

    // $ANTLR start synpred6_FuzzyMakefileLexer
    public final void synpred6_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:102: ( UnsupportedIFEQ )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:102: UnsupportedIFEQ
        {
        mUnsupportedIFEQ(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred6_FuzzyMakefileLexer

    // $ANTLR start synpred7_FuzzyMakefileLexer
    public final void synpred7_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:118: ( UnsupportedIFNEQ )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:118: UnsupportedIFNEQ
        {
        mUnsupportedIFNEQ(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred7_FuzzyMakefileLexer

    // $ANTLR start synpred8_FuzzyMakefileLexer
    public final void synpred8_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:135: ( UnsupportedRegocnizedIFDEF )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:135: UnsupportedRegocnizedIFDEF
        {
        mUnsupportedRegocnizedIFDEF(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred8_FuzzyMakefileLexer

    // $ANTLR start synpred9_FuzzyMakefileLexer
    public final void synpred9_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:162: ( UnsupportedIFDEF )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:162: UnsupportedIFDEF
        {
        mUnsupportedIFDEF(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred9_FuzzyMakefileLexer

    // $ANTLR start synpred10_FuzzyMakefileLexer
    public final void synpred10_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:179: ( ELSE )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:179: ELSE
        {
        mELSE(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred10_FuzzyMakefileLexer

    // $ANTLR start synpred11_FuzzyMakefileLexer
    public final void synpred11_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:184: ( ENDIF )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:184: ENDIF
        {
        mENDIF(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred11_FuzzyMakefileLexer

    // $ANTLR start synpred12_FuzzyMakefileLexer
    public final void synpred12_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:190: ( LISTROW )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:190: LISTROW
        {
        mLISTROW(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred12_FuzzyMakefileLexer

    // $ANTLR start synpred13_FuzzyMakefileLexer
    public final void synpred13_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:198: ( LISTE )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:198: LISTE
        {
        mLISTE(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred13_FuzzyMakefileLexer

    // $ANTLR start synpred14_FuzzyMakefileLexer
    public final void synpred14_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:204: ( ARBITRARYVARASSIGNMENT )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:204: ARBITRARYVARASSIGNMENT
        {
        mARBITRARYVARASSIGNMENT(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred14_FuzzyMakefileLexer

    // $ANTLR start synpred15_FuzzyMakefileLexer
    public final void synpred15_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:227: ( ARBITRARYVARASSIGNMENT_AS_LIST )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:227: ARBITRARYVARASSIGNMENT_AS_LIST
        {
        mARBITRARYVARASSIGNMENT_AS_LIST(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred15_FuzzyMakefileLexer

    // $ANTLR start synpred16_FuzzyMakefileLexer
    public final void synpred16_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:258: ( SL_COMMENT )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:258: SL_COMMENT
        {
        mSL_COMMENT(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred16_FuzzyMakefileLexer

    // $ANTLR start synpred17_FuzzyMakefileLexer
    public final void synpred17_FuzzyMakefileLexer_fragment() throws RecognitionException {   
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:269: ( WS )
        // gsd/buildanalysis/linux/FuzzyMakefileLexer.g:1:269: WS
        {
        mWS(); if (state.failed) return ;

        }
    }
    // $ANTLR end synpred17_FuzzyMakefileLexer

    public final boolean synpred2_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred2_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred8_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred8_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred12_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred12_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred17_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred17_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred15_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred15_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred3_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred3_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred5_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred5_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred7_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred7_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred11_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred11_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred16_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred16_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred10_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred10_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred9_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred9_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred6_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred6_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred14_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred14_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred4_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred4_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred1_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred1_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }
    public final boolean synpred13_FuzzyMakefileLexer() {
        state.backtracking++;
        int start = input.mark();
        try {
            synpred13_FuzzyMakefileLexer_fragment(); // can never throw exception
        } catch (RecognitionException re) {
            System.err.println("impossible: "+re);
        }
        boolean success = !state.failed;
        input.rewind(start);
        state.backtracking--;
        state.failed=false;
        return success;
    }


    protected DFA16 dfa16 = new DFA16(this);
    protected DFA31 dfa31 = new DFA31(this);
    protected DFA40 dfa40 = new DFA40(this);
    protected DFA39 dfa39 = new DFA39(this);
    protected DFA46 dfa46 = new DFA46(this);
    static final String DFA16_eotS =
        "\3\uffff\2\6\4\uffff\1\6";
    static final String DFA16_eofS =
        "\12\uffff";
    static final String DFA16_minS =
        "\1\55\1\44\1\uffff\3\55\1\uffff\3\55";
    static final String DFA16_maxS =
        "\2\172\1\uffff\3\172\1\uffff\3\172";
    static final String DFA16_acceptS =
        "\2\uffff\1\1\3\uffff\1\2\3\uffff";
    static final String DFA16_specialS =
        "\12\uffff}>";
    static final String[] DFA16_transitionS = {
            "\1\1\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\32\2",
            "\1\6\10\uffff\1\2\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff"+
            "\14\2\1\4\1\2\1\5\11\2\1\3\1\2",
            "",
            "\1\2\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\32\2",
            "\1\2\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\32\2",
            "\1\2\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\1\2\1\7"+
            "\30\2",
            "",
            "\1\2\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\11\2\1\10"+
            "\20\2",
            "\1\2\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\22\2\1\11"+
            "\7\2",
            "\1\2\2\uffff\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\32\2"
    };

    static final short[] DFA16_eot = DFA.unpackEncodedString(DFA16_eotS);
    static final short[] DFA16_eof = DFA.unpackEncodedString(DFA16_eofS);
    static final char[] DFA16_min = DFA.unpackEncodedStringToUnsignedChars(DFA16_minS);
    static final char[] DFA16_max = DFA.unpackEncodedStringToUnsignedChars(DFA16_maxS);
    static final short[] DFA16_accept = DFA.unpackEncodedString(DFA16_acceptS);
    static final short[] DFA16_special = DFA.unpackEncodedString(DFA16_specialS);
    static final short[][] DFA16_transition;

    static {
        int numStates = DFA16_transitionS.length;
        DFA16_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA16_transition[i] = DFA.unpackEncodedString(DFA16_transitionS[i]);
        }
    }

    class DFA16 extends DFA {

        public DFA16(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 16;
            this.eot = DFA16_eot;
            this.eof = DFA16_eof;
            this.min = DFA16_min;
            this.max = DFA16_max;
            this.accept = DFA16_accept;
            this.special = DFA16_special;
            this.transition = DFA16_transition;
        }
        public String getDescription() {
            return "()+ loopback of 248:5: ( 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '-' | '_' | '0' .. '9' )+";
        }
    }
    static final String DFA31_eotS =
        "\5\uffff\1\7\4\uffff\1\1\1\uffff\1\13";
    static final String DFA31_eofS =
        "\15\uffff";
    static final String DFA31_minS =
        "\1\44\1\uffff\1\44\1\55\3\44\1\uffff\1\51\1\44\1\51\1\uffff\1\44";
    static final String DFA31_maxS =
        "\1\172\1\uffff\5\172\1\uffff\3\172\1\uffff\1\172";
    static final String DFA31_acceptS =
        "\1\uffff\1\1\5\uffff\1\2\3\uffff\1\3\1\uffff";
    static final String DFA31_specialS =
        "\15\uffff}>";
    static final String[] DFA31_transitionS = {
            "\1\4\3\uffff\2\1\3\uffff\1\2\1\uffff\1\3\12\2\2\uffff\1\1\4"+
            "\uffff\32\2\4\uffff\1\2\1\uffff\32\2",
            "",
            "\1\1\3\uffff\2\1\3\uffff\1\2\1\1\1\5\12\2\7\uffff\32\2\4\uffff"+
            "\1\2\1\uffff\32\2",
            "\1\3\1\uffff\1\5\12\3\7\uffff\32\3\4\uffff\1\3\1\uffff\32\3",
            "\1\1\3\uffff\1\6\1\1\3\uffff\2\1\1\uffff\12\1\7\uffff\32\1"+
            "\4\uffff\1\1\1\uffff\32\1",
            "\1\1\3\uffff\2\1\3\uffff\1\2\1\uffff\1\5\12\2\7\uffff\32\2"+
            "\4\uffff\1\2\1\uffff\32\2",
            "\1\1\3\uffff\2\1\3\uffff\1\11\1\10\1\uffff\12\11\7\uffff\32"+
            "\11\4\uffff\1\11\1\uffff\32\11",
            "",
            "\1\13\3\uffff\2\13\1\uffff\12\13\7\uffff\32\13\4\uffff\1\13"+
            "\1\uffff\16\13\1\12\13\13",
            "\1\1\3\uffff\1\1\1\14\3\uffff\1\11\1\10\1\uffff\12\11\7\uffff"+
            "\32\11\4\uffff\1\11\1\uffff\32\11",
            "\1\13\3\uffff\2\13\1\uffff\12\13\7\uffff\32\13\4\uffff\1\13"+
            "\1\uffff\32\13",
            "",
            "\1\1\3\uffff\2\1\3\uffff\2\1\1\uffff\12\1\7\uffff\32\1\4\uffff"+
            "\1\1\1\uffff\32\1"
    };

    static final short[] DFA31_eot = DFA.unpackEncodedString(DFA31_eotS);
    static final short[] DFA31_eof = DFA.unpackEncodedString(DFA31_eofS);
    static final char[] DFA31_min = DFA.unpackEncodedStringToUnsignedChars(DFA31_minS);
    static final char[] DFA31_max = DFA.unpackEncodedStringToUnsignedChars(DFA31_maxS);
    static final short[] DFA31_accept = DFA.unpackEncodedString(DFA31_acceptS);
    static final short[] DFA31_special = DFA.unpackEncodedString(DFA31_specialS);
    static final short[][] DFA31_transition;

    static {
        int numStates = DFA31_transitionS.length;
        DFA31_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA31_transition[i] = DFA.unpackEncodedString(DFA31_transitionS[i]);
        }
    }

    class DFA31 extends DFA {

        public DFA31(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 31;
            this.eot = DFA31_eot;
            this.eof = DFA31_eof;
            this.min = DFA31_min;
            this.max = DFA31_max;
            this.accept = DFA31_accept;
            this.special = DFA31_special;
            this.transition = DFA31_transition;
        }
        public String getDescription() {
            return "305:1: fragment LISTELEMENT : (obj= OBJECTFILENAME | sub= SUBDIR | '$(' v= NA ')' );";
        }
    }
    static final String DFA40_eotS =
        "\4\uffff";
    static final String DFA40_eofS =
        "\4\uffff";
    static final String DFA40_minS =
        "\2\44\2\uffff";
    static final String DFA40_maxS =
        "\2\172\2\uffff";
    static final String DFA40_acceptS =
        "\2\uffff\1\1\1\2";
    static final String DFA40_specialS =
        "\4\uffff}>";
    static final String[] DFA40_transitionS = {
            "\1\3\3\uffff\2\3\3\uffff\1\1\1\uffff\1\2\12\1\7\uffff\32\1\4"+
            "\uffff\1\1\1\uffff\32\1",
            "\1\3\3\uffff\2\3\3\uffff\1\1\1\3\1\2\12\1\7\uffff\32\1\4\uffff"+
            "\1\1\1\uffff\32\1",
            "",
            ""
    };

    static final short[] DFA40_eot = DFA.unpackEncodedString(DFA40_eotS);
    static final short[] DFA40_eof = DFA.unpackEncodedString(DFA40_eofS);
    static final char[] DFA40_min = DFA.unpackEncodedStringToUnsignedChars(DFA40_minS);
    static final char[] DFA40_max = DFA.unpackEncodedStringToUnsignedChars(DFA40_maxS);
    static final short[] DFA40_accept = DFA.unpackEncodedString(DFA40_acceptS);
    static final short[] DFA40_special = DFA.unpackEncodedString(DFA40_specialS);
    static final short[][] DFA40_transition;

    static {
        int numStates = DFA40_transitionS.length;
        DFA40_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA40_transition[i] = DFA.unpackEncodedString(DFA40_transitionS[i]);
        }
    }

    class DFA40 extends DFA {

        public DFA40(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 40;
            this.eot = DFA40_eot;
            this.eof = DFA40_eof;
            this.min = DFA40_min;
            this.max = DFA40_max;
            this.accept = DFA40_accept;
            this.special = DFA40_special;
            this.transition = DFA40_transition;
        }
        public String getDescription() {
            return "332:36: ( ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+ '/' )?";
        }
    }
    static final String DFA39_eotS =
        "\5\uffff";
    static final String DFA39_eofS =
        "\5\uffff";
    static final String DFA39_minS =
        "\1\55\1\44\1\uffff\1\44\1\uffff";
    static final String DFA39_maxS =
        "\2\172\1\uffff\1\172\1\uffff";
    static final String DFA39_acceptS =
        "\2\uffff\1\1\1\uffff\1\2";
    static final String DFA39_specialS =
        "\5\uffff}>";
    static final String[] DFA39_transitionS = {
            "\1\2\1\uffff\1\1\12\2\7\uffff\32\2\4\uffff\1\2\1\uffff\32\2",
            "\1\4\3\uffff\2\4\3\uffff\1\3\1\uffff\1\2\12\3\7\uffff\32\3"+
            "\4\uffff\1\3\1\uffff\32\3",
            "",
            "\1\4\3\uffff\2\4\3\uffff\1\3\1\4\1\2\12\3\7\uffff\32\3\4\uffff"+
            "\1\3\1\uffff\32\3",
            ""
    };

    static final short[] DFA39_eot = DFA.unpackEncodedString(DFA39_eotS);
    static final short[] DFA39_eof = DFA.unpackEncodedString(DFA39_eofS);
    static final char[] DFA39_min = DFA.unpackEncodedStringToUnsignedChars(DFA39_minS);
    static final char[] DFA39_max = DFA.unpackEncodedStringToUnsignedChars(DFA39_maxS);
    static final short[] DFA39_accept = DFA.unpackEncodedString(DFA39_acceptS);
    static final short[] DFA39_special = DFA.unpackEncodedString(DFA39_specialS);
    static final short[][] DFA39_transition;

    static {
        int numStates = DFA39_transitionS.length;
        DFA39_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA39_transition[i] = DFA.unpackEncodedString(DFA39_transitionS[i]);
        }
    }

    class DFA39 extends DFA {

        public DFA39(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 39;
            this.eot = DFA39_eot;
            this.eof = DFA39_eof;
            this.min = DFA39_min;
            this.max = DFA39_max;
            this.accept = DFA39_accept;
            this.special = DFA39_special;
            this.transition = DFA39_transition;
        }
        public String getDescription() {
            return "()+ loopback of 332:37: ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '-' | '0' .. '9' | '/' )+";
        }
    }
    static final String DFA46_eotS =
        "\32\uffff";
    static final String DFA46_eofS =
        "\32\uffff";
    static final String DFA46_minS =
        "\2\0\3\uffff\1\0\1\uffff\1\0\2\uffff\1\0\2\uffff\1\0\11\uffff\1"+
        "\0\2\uffff";
    static final String DFA46_maxS =
        "\1\uffff\1\0\3\uffff\1\0\1\uffff\1\0\2\uffff\1\0\2\uffff\1\0\11"+
        "\uffff\1\0\2\uffff";
    static final String DFA46_acceptS =
        "\2\uffff\1\16\1\17\1\22\1\uffff\1\20\1\uffff\1\14\1\21\1\uffff\1"+
        "\15\1\22\1\uffff\1\1\1\2\1\3\1\4\1\5\1\6\1\7\1\10\1\11\1\uffff\1"+
        "\12\1\13";
    static final String DFA46_specialS =
        "\1\0\1\1\3\uffff\1\2\1\uffff\1\3\2\uffff\1\4\2\uffff\1\5\11\uffff"+
        "\1\6\2\uffff}>";
    static final String[] DFA46_transitionS = {
            "\11\14\1\7\26\14\1\7\2\14\1\5\11\14\1\12\1\1\1\14\12\12\7\14"+
            "\32\12\1\14\1\7\2\14\1\12\1\14\4\12\1\27\3\12\1\15\21\12\uff85"+
            "\14",
            "\1\uffff",
            "",
            "",
            "",
            "\1\uffff",
            "",
            "\1\uffff",
            "",
            "",
            "\1\uffff",
            "",
            "",
            "\1\uffff",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "\1\uffff",
            "",
            ""
    };

    static final short[] DFA46_eot = DFA.unpackEncodedString(DFA46_eotS);
    static final short[] DFA46_eof = DFA.unpackEncodedString(DFA46_eofS);
    static final char[] DFA46_min = DFA.unpackEncodedStringToUnsignedChars(DFA46_minS);
    static final char[] DFA46_max = DFA.unpackEncodedStringToUnsignedChars(DFA46_maxS);
    static final short[] DFA46_accept = DFA.unpackEncodedString(DFA46_acceptS);
    static final short[] DFA46_special = DFA.unpackEncodedString(DFA46_specialS);
    static final short[][] DFA46_transition;

    static {
        int numStates = DFA46_transitionS.length;
        DFA46_transition = new short[numStates][];
        for (int i=0; i<numStates; i++) {
            DFA46_transition[i] = DFA.unpackEncodedString(DFA46_transitionS[i]);
        }
    }

    class DFA46 extends DFA {

        public DFA46(BaseRecognizer recognizer) {
            this.recognizer = recognizer;
            this.decisionNumber = 46;
            this.eot = DFA46_eot;
            this.eof = DFA46_eof;
            this.min = DFA46_min;
            this.max = DFA46_max;
            this.accept = DFA46_accept;
            this.special = DFA46_special;
            this.transition = DFA46_transition;
        }
        public String getDescription() {
            return "1:1: Tokens options {k=1; backtrack=true; } : ( IFEQ | IFNEQ | IFDEF | UnsupportedRegocnizedIFEQ | ComplicatedIFNEQ1 | UnsupportedIFEQ | UnsupportedIFNEQ | UnsupportedRegocnizedIFDEF | UnsupportedIFDEF | ELSE | ENDIF | LISTROW | LISTE | ARBITRARYVARASSIGNMENT | ARBITRARYVARASSIGNMENT_AS_LIST | SL_COMMENT | WS | CR );";
        }
        public int specialStateTransition(int s, IntStream _input) throws NoViableAltException {
            IntStream input = _input;
        	int _s = s;
            switch ( s ) {
                    case 0 : 
                        int LA46_0 = input.LA(1);

                        s = -1;
                        if ( (LA46_0=='.') ) {s = 1;}

                        else if ( (LA46_0=='#') ) {s = 5;}

                        else if ( (LA46_0=='\t'||LA46_0==' '||LA46_0=='\\') ) {s = 7;}

                        else if ( (LA46_0=='-'||(LA46_0>='0' && LA46_0<='9')||(LA46_0>='A' && LA46_0<='Z')||LA46_0=='_'||(LA46_0>='a' && LA46_0<='d')||(LA46_0>='f' && LA46_0<='h')||(LA46_0>='j' && LA46_0<='z')) ) {s = 10;}

                        else if ( ((LA46_0>='\u0000' && LA46_0<='\b')||(LA46_0>='\n' && LA46_0<='\u001F')||(LA46_0>='!' && LA46_0<='\"')||(LA46_0>='$' && LA46_0<=',')||LA46_0=='/'||(LA46_0>=':' && LA46_0<='@')||LA46_0=='['||(LA46_0>=']' && LA46_0<='^')||LA46_0=='`'||(LA46_0>='{' && LA46_0<='\uFFFF')) ) {s = 12;}

                        else if ( (LA46_0=='i') ) {s = 13;}

                        else if ( (LA46_0=='e') ) {s = 23;}

                        if ( s>=0 ) return s;
                        break;
                    case 1 : 
                        int LA46_1 = input.LA(1);

                         
                        int index46_1 = input.index();
                        input.rewind();
                        s = -1;
                        if ( (synpred14_FuzzyMakefileLexer()) ) {s = 2;}

                        else if ( (synpred15_FuzzyMakefileLexer()) ) {s = 3;}

                        else if ( (true) ) {s = 4;}

                         
                        input.seek(index46_1);
                        if ( s>=0 ) return s;
                        break;
                    case 2 : 
                        int LA46_5 = input.LA(1);

                         
                        int index46_5 = input.index();
                        input.rewind();
                        s = -1;
                        if ( (synpred16_FuzzyMakefileLexer()) ) {s = 6;}

                        else if ( (true) ) {s = 4;}

                         
                        input.seek(index46_5);
                        if ( s>=0 ) return s;
                        break;
                    case 3 : 
                        int LA46_7 = input.LA(1);

                         
                        int index46_7 = input.index();
                        input.rewind();
                        s = -1;
                        if ( (synpred12_FuzzyMakefileLexer()) ) {s = 8;}

                        else if ( (synpred14_FuzzyMakefileLexer()) ) {s = 2;}

                        else if ( (synpred15_FuzzyMakefileLexer()) ) {s = 3;}

                        else if ( (synpred17_FuzzyMakefileLexer()) ) {s = 9;}

                        else if ( (true) ) {s = 4;}

                         
                        input.seek(index46_7);
                        if ( s>=0 ) return s;
                        break;
                    case 4 : 
                        int LA46_10 = input.LA(1);

                         
                        int index46_10 = input.index();
                        input.rewind();
                        s = -1;
                        if ( (synpred12_FuzzyMakefileLexer()) ) {s = 8;}

                        else if ( (synpred13_FuzzyMakefileLexer()) ) {s = 11;}

                        else if ( (synpred14_FuzzyMakefileLexer()) ) {s = 2;}

                        else if ( (synpred15_FuzzyMakefileLexer()) ) {s = 3;}

                        else if ( (true) ) {s = 4;}

                         
                        input.seek(index46_10);
                        if ( s>=0 ) return s;
                        break;
                    case 5 : 
                        int LA46_13 = input.LA(1);

                         
                        int index46_13 = input.index();
                        input.rewind();
                        s = -1;
                        if ( (synpred1_FuzzyMakefileLexer()) ) {s = 14;}

                        else if ( (synpred2_FuzzyMakefileLexer()) ) {s = 15;}

                        else if ( (synpred3_FuzzyMakefileLexer()) ) {s = 16;}

                        else if ( (synpred4_FuzzyMakefileLexer()) ) {s = 17;}

                        else if ( (synpred5_FuzzyMakefileLexer()) ) {s = 18;}

                        else if ( (synpred6_FuzzyMakefileLexer()) ) {s = 19;}

                        else if ( (synpred7_FuzzyMakefileLexer()) ) {s = 20;}

                        else if ( (synpred8_FuzzyMakefileLexer()) ) {s = 21;}

                        else if ( (synpred9_FuzzyMakefileLexer()) ) {s = 22;}

                        else if ( (synpred12_FuzzyMakefileLexer()) ) {s = 8;}

                        else if ( (synpred13_FuzzyMakefileLexer()) ) {s = 11;}

                        else if ( (synpred14_FuzzyMakefileLexer()) ) {s = 2;}

                        else if ( (synpred15_FuzzyMakefileLexer()) ) {s = 3;}

                        else if ( (true) ) {s = 12;}

                         
                        input.seek(index46_13);
                        if ( s>=0 ) return s;
                        break;
                    case 6 : 
                        int LA46_23 = input.LA(1);

                         
                        int index46_23 = input.index();
                        input.rewind();
                        s = -1;
                        if ( (synpred10_FuzzyMakefileLexer()) ) {s = 24;}

                        else if ( (synpred11_FuzzyMakefileLexer()) ) {s = 25;}

                        else if ( (synpred12_FuzzyMakefileLexer()) ) {s = 8;}

                        else if ( (synpred13_FuzzyMakefileLexer()) ) {s = 11;}

                        else if ( (synpred14_FuzzyMakefileLexer()) ) {s = 2;}

                        else if ( (synpred15_FuzzyMakefileLexer()) ) {s = 3;}

                        else if ( (true) ) {s = 12;}

                         
                        input.seek(index46_23);
                        if ( s>=0 ) return s;
                        break;
            }
            if (state.backtracking>0) {state.failed=true; return -1;}
            NoViableAltException nvae =
                new NoViableAltException(getDescription(), 46, _s, input);
            error(nvae);
            throw nvae;
        }
    }
 

}