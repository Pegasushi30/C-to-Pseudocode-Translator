%{
#include <string.h>
#include <algorithm>
#include <stdio.h>
#include <iostream>
#include <string>
using namespace std;
extern FILE *yyin;
extern int yylex();
void yyerror(const char* s);

static inline void ReplaceAll(string &str, const string& from, const string& to) {
				size_t start_pos = 0;
				while((start_pos = str.find(from, start_pos)) != string::npos) {
					str.replace(start_pos, from.length(), to);
					start_pos += to.length(); 
				}
			}
//I used the algorithm from the following link:https://stackoverflow.com/questions/2896600/how-to-replace-all-occurrences-of-a-character-in-string
%}
%token <number> INTEGER
%token <str> IDENT CHARVAL VOID SF PF IF ELSE GREATER EQEQ LESSEQ GREATEREQ LESS INCREMENT DECREMENT INCL MULTIPLICATION DIVIDE RETURN
%token <doubflt> FLOATVAL
%token PLUS EQ MINUS SEMICOLON COMMA OPPARENTH OPENCURL SCANF DEN CELIM 
%token INTRESERVE DOUBLERESERVE FLOATRESERVE CHARRESERVE DOT QUOTE  CLPARENTH CLOSECURL  PERCENT AND FOR

%union
{
	int number;
	char* str;
	double doubflt;
}
%type <str> decl_body parameter assgns assgn sf pf b_for_fun b_for_funs ifelse comparetype forLoop incordec identOrInt call callBody
%start program
%%
program:INCL fncns|fncns|{cout<<"Enter a valid input"<<endl;}
		;
fncns:fncns fncn|fncn;
fncn: typ_f IDENT OPPARENTH parameter CLPARENTH OPENCURL  CLOSECURL
		{cout<<"FUNCTION "<<$2<<" "<<$4<<"\nEND FUNCTION "<<$2<<"\n"<<endl;}|
	  typ_f IDENT OPPARENTH parameter CLPARENTH OPENCURL b_for_funs CLOSECURL{	
		string s= "FUNCTION "+ string($2) + " " + string($4) + "\n" + string($7);
		ReplaceAll(s,string("\n"),string("\n\t"));
		cout<<s;
		cout<<"\nEND FUNCTION "<<$2<<"\n";
		}
		|
	  typ_f IDENT OPPARENTH parameter CLPARENTH OPENCURL b_for_funs RETURN IDENT SEMICOLON CLOSECURL{	
		string s= "FUNCTION "+ string($2) + " " + string($4) + "\n" + string($7)+"\n"+string($2)+"="+string($9);
		ReplaceAll(s,string("\n"),string("\n\t"));
		cout<<s;
		cout<<"\nEND FUNCTION "<<$2<<"\n";}
		;
b_for_funs:b_for_fun b_for_funs {$$ = strdup((string($1)+"\n"+ string($2)).c_str());}|b_for_fun {$$=$1;};
b_for_fun:assgns {$$=$1;}|sf {$$=$1;}|pf {$$=$1;}|
	ifelse {
		string s=string($1);
		ReplaceAll(s,string("\n"),string("\n\t"));
		ReplaceAll(s,string("\n\tELSEIF"),string("\nELSEIF"));
		ReplaceAll(s,string("\n\tELSE"),string("\nELSE"));
		if(s[0]=='I'){
			string a = "\nENDIF";
			$$ = strdup((s+a).c_str());
		}
		else{
			$$ = strdup(s.c_str());
			}
	}|
	forLoop {$$ = $1;}
	;
typ_f:VOID|DOUBLERESERVE|FLOATRESERVE|CHARRESERVE|INTRESERVE;
parameter:VOID {$$=strdup("");}|assgns;
assgns:assgns assgn{$$ = strdup((string($1) + "\n"+string($2)).c_str());}|
	assgn { $$=$1;};
assgn:assgn_type decl_body SEMICOLON { $$=$2;}|
	assgn_type IDENT { $$ =$2;}|
	assgn_type IDENT COMMA assgn  {$$ = strdup((string($2)+" "+string($4)).c_str());}|
	assgn_type IDENT COMMA decl_body SEMICOLON  {$$ = strdup((string($4)).c_str());}|
	IDENT EQ INTEGER SEMICOLON { $$ = strdup((string($1) + "=" + to_string($3)).c_str()); }|
	IDENT EQ FLOATVAL SEMICOLON { $$ = strdup((string($1) + "=" + to_string($3)).c_str()); }|
	IDENT EQ CHARVAL SEMICOLON { $$ = strdup((string($1) + "=" + string($3)).c_str()); }|
	IDENT EQ IDENT PLUS IDENT SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"+"+string($5)).c_str());}|
	IDENT EQ IDENT PLUS INTEGER SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"+"+to_string($5)).c_str());}|
	IDENT EQ IDENT MULTIPLICATION  IDENT SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"*"+string($5)).c_str());}|
	IDENT EQ IDENT MULTIPLICATION  INTEGER SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"*"+to_string($5)).c_str());}|
	IDENT EQ IDENT MINUS  IDENT SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"*"+string($5)).c_str());}|
	IDENT EQ IDENT MINUS  INTEGER SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"*"+to_string($5)).c_str());}|
	IDENT EQ IDENT DIVIDE IDENT SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"/"+string($5)).c_str());}|
	IDENT EQ IDENT DIVIDE INTEGER SEMICOLON  { $$ = strdup((string($1) + "=" + string($3)+"/"+to_string($5)).c_str());}|
	IDENT EQ call SEMICOLON {$$=strdup((string($1)+"="+string($3)).c_str());}
	;
assgn_type:DOUBLERESERVE|FLOATRESERVE|CHARRESERVE|INTRESERVE;
decl_body:IDENT EQ INTEGER { $$ = strdup((string($1) + "=" + to_string($3)).c_str()); }|
	IDENT EQ FLOATVAL { $$ = strdup((string($1) + "=" + to_string($3)).c_str()); }|
	IDENT EQ CHARVAL { $$ = strdup((string($1) + "=" + string($3)).c_str()); }|
	IDENT EQ INTEGER COMMA decl_body { $$ = strdup((string($1) + "=" + to_string($3) + "\n" + string($5)).c_str());  }|
	IDENT EQ FLOATVAL COMMA decl_body { $$ = strdup((string($1) + "=" + to_string($3) + "\n" + string($5)).c_str());  }|
	IDENT EQ CHARVAL COMMA decl_body { $$ = strdup((string($1) + "=" + string($3) + "\n" + string($5)).c_str());  }|
	IDENT EQ IDENT COMMA decl_body { $$ = strdup((string($1) + "=" + string($3) + "\n" + string($5)).c_str());  }|
	IDENT EQ IDENT { $$ = strdup((string($1) + "=" + string($3)).c_str());  }|
	IDENT { $$=strdup(""); }
	;
//IF ELSE
ifelse:
	IF OPPARENTH IDENT	comparetype identOrInt	CLPARENTH OPENCURL b_for_funs CLOSECURL{	
			string s= string("IF")+" "+string($3)+" "+string($4)+" "+string($5)+" THEN"+"\n"+string($8);
			$$ = strdup(s.c_str());}|
	IF OPPARENTH IDENT comparetype identOrInt CLPARENTH OPENCURL CLOSECURL{
			$$ = strdup((string("IF ")+string($3)+" "+string($4)+" "+string($5)+string(" THEN")).c_str());
		}|
	ELSE IF OPPARENTH IDENT	comparetype identOrInt	CLPARENTH OPENCURL b_for_funs CLOSECURL{
			$$ = strdup((string("ELSEIF")+" "+string($4)+" "+string($5)+" "+string($6)+" THEN"+"\n"+string($9)).c_str());
		}|
	ELSE IF OPPARENTH IDENT comparetype identOrInt CLPARENTH OPENCURL CLOSECURL{
			$$ = strdup((string("ELSEIF ")+string($4)+" "+string($5)+" "+string($6)+string(" THEN")).c_str());
		}|
	ELSE OPENCURL b_for_funs CLOSECURL{
			$$ = strdup((string("ELSE ")+string($3)).c_str());
		}|
	ELSE OPENCURL CLOSECURL{
			$$ = strdup((string("ELSE ")+string("THEN")).c_str());
		}|
	IF OPPARENTH IDENT	comparetype identOrInt	CLPARENTH OPENCURL b_for_funs CLOSECURL ifelse{	
			string s= string("IF")+" "+string($3)+" "+string($4)+" "+string($5)+" THEN"+"\n"+string($8)+"\n"+string($10);
			$$ = strdup(s.c_str());
		}|
	ELSE IF OPPARENTH IDENT	comparetype identOrInt	CLPARENTH OPENCURL b_for_funs CLOSECURL ifelse{
			$$ = strdup((string("ELSEIF")+" "+string($4)+" "+string($5)+" "+string($6)+" THEN"+"\n"+string($9)+"\n"+string($11)).c_str());
		}
	;
forLoop:
    FOR OPPARENTH IDENT EQ INTEGER SEMICOLON IDENT comparetype INTEGER SEMICOLON IDENT incordec CLPARENTH OPENCURL b_for_funs CLOSECURL
        {
			string a= string($3)+ "=" + to_string($5) + "\n";
			string b= "WHILE " + string($7) + string($8) + to_string($9)+"\n" + $15+"\n"+string($11)+"="+string($11)+string($12)+"1";
			string c = "\nEND WHILE";
			ReplaceAll(b,string("\n"),string("\n\t"));
			$$ = strdup((a+b+c).c_str());
        }|
	FOR OPPARENTH IDENT EQ INTEGER SEMICOLON IDENT comparetype IDENT SEMICOLON IDENT incordec CLPARENTH OPENCURL b_for_funs CLOSECURL
        {
			string a= string($3)+ "=" + to_string($5) + "\n";
			string b= "WHILE " + string($7) + string($8) + string($9)+"\n" + $15+"\n"+string($11)+"="+string($11)+string($12)+"1";
			string c = "\nEND WHILE";
			ReplaceAll(b,string("\n"),string("\n\t"));
			$$ = strdup((a+b+c).c_str());
        }|
    FOR OPPARENTH IDENT EQ INTEGER SEMICOLON IDENT comparetype INTEGER SEMICOLON IDENT incordec CLPARENTH OPENCURL CLOSECURL
        {
            $$ = strdup((string($3) + "=" + to_string($5) + "\n" + "WHILE " + string($7) + string($8) + to_string($9) + "\n").c_str());
        }|
	FOR OPPARENTH IDENT EQ INTEGER SEMICOLON IDENT comparetype IDENT SEMICOLON IDENT incordec CLPARENTH OPENCURL CLOSECURL
        {
            $$ = strdup((string($3) + "=" + to_string($5) + "\n" + "WHILE " + string($7) + string($8) + string($9) + "\n").c_str());
        }
    ;
incordec:
    INCREMENT    {$$ =strdup("+");}|
    DECREMENT    {$$ =strdup("-");}
    ;
comparetype:
	GREATER  {$$ =strdup((string($1)).c_str());}|
	EQEQ     {$$ =strdup((string($1)).c_str());}|
	LESS      {$$ =strdup((string($1)).c_str());}|
	GREATEREQ  {$$ =strdup((string($1)).c_str());}|
	LESSEQ    {$$ =strdup((string($1)).c_str());}
	;
	
identOrInt:
	IDENT {$$ =strdup((string($1)).c_str());}|
	INTEGER		{$$ =strdup(to_string($1).c_str());}
	;
call:
	IDENT OPPARENTH callBody CLPARENTH { $$ = strdup((string($1)+" "+string($3)).c_str());}|
	IDENT OPPARENTH  CLPARENTH {$$=$1;}
	;
	
callBody:
	IDENT	{ $$ = strdup((string($1)).c_str()); }|
	IDENT COMMA callBody {$$ = strdup((string($1)+" "+string($3)).c_str());}
	;
//PRINTF
pf:
	PF OPPARENTH CELIM COMMA	IDENT CLPARENTH SEMICOLON{$$=strdup(("PRINT "+string($5)).c_str());}
	;
//SCANF
sf:SF OPPARENTH CELIM COMMA AND IDENT CLPARENTH SEMICOLON{$$ =strdup(("READ "+string($6)).c_str());}
	;
%%

void yyerror(const char* s){
	cout<<"error: "<<s<<endl;
}

int yywrap(){
	return 1;
}

int main(int argc, char *argv[])
{
	yyin=fopen(argv[1],"r");
	yyparse();
	fclose(yyin);
	return 0;
}
