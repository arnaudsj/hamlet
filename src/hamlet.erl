-module(hamlet).

-include("hamlet.hrl").

-define(LEXER,hamlet_lexer).
-define(PARSER,hamlet_parser).

-export([parse/1,parse/2]).

parse(String) ->
    {ok,Tokens,EndLine} = ?LEXER:string(String),
	?LOG("Tokens",Tokens),
    {ok, ParseTree} = ?PARSER:parse(Tokens),ParseTree,
	?LOG("ParseTree",ParseTree).
	

parse(file, FileName) ->
    {ok, InFile} = file:open(FileName, [read]),
    Acc = loop(InFile,[]),
    	  file:close(InFile),
    	  parse(Acc).

loop(InFile,Acc) ->
    case io:request(InFile, {get_until,prompt,?LEXER,token,[1]}) of
        {ok,Toks,EndLine} ->
            loop(InFile,Acc ++ [Toks]);
        {error,token} ->
            exit("Scanning error");    
        {eof,_} ->
            Acc
    end.
