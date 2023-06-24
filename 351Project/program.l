digit	[0-9]
letter	[A-Za-z]
%{
	#include <stdio.h>
	#include <string.h>
	#include "y.tab.h"
%}

%%

"int"	{return INTRESERVE;}
"double"	{return DOUBLERESERVE;}
"float"	{return FLOATRESERVE;}
"char"	{return CHARRESERVE;}
"void"  {yylval.str=strdup(yytext); return VOID;}
"scanf" {yylval.str=strdup(yytext); return SF;}
"printf" {yylval.str=strdup(yytext); return PF;}
"if"	{yylval.str=strdup(yytext);return IF;}
"else"	{yylval.str=strdup(yytext);return ELSE;}
"return" {yylval.str=strdup(yytext);return RETURN;}
"for"   {yylval.str=strdup(yytext);return FOR;}
(-)?[0-9]+ 	yylval.number=atoi(yytext);	return INTEGER;
"include <"{letter}+"."{letter}+">" {yylval.str=strdup(yytext);return INCL;} 
{digit}+"."{digit}+	{yylval.doubflt=atof(yytext); return FLOATVAL;}
"'"{letter}"'" {yylval.str=strdup(yytext); return CHARVAL;}
{letter}[\t]*({letter}|{digit})* {yylval.str=strdup(yytext); return IDENT;}
[\"](.*)[\"] return CELIM;
\<		{yylval.str=strdup(yytext);return LESS;}
\>		{yylval.str=strdup(yytext);return GREATER;}
\==		{yylval.str=strdup(yytext);return EQEQ;}
\>=		{yylval.str=strdup(yytext);return GREATEREQ;}
\<=		{yylval.str=strdup(yytext);return LESSEQ;}
\+		return PLUS;
\= 		return EQ;
\-		return MINUS;
\.      return DOT;
\'      return QUOTE;
\,      return COMMA;
\;		return SEMICOLON;
\(      return OPPARENTH;
\)      return CLPARENTH;
\{      return OPENCURL;
\}	    return CLOSECURL; 
\"		return DEN;
\%		return PERCENT;
\&		return AND;
\--  	return DECREMENT;
\++    	return INCREMENT;
\* 		return MULTIPLICATION;
\n
[ \t]+ 	
%%