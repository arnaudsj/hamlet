-module(hamlet).


-include("hamlet.hrl").

-define(LEXER,hamlet_lexer).
-define(PARSER,hamlet_parser).

-export([parse/1,parse/2]).
-include_lib("eunit/include/eunit.hrl").

parse(String) ->
    {ok,Tokens,EndLine} = ?LEXER:string(String),
	?LOG("Tokens",Tokens),
    {ok, ParseTree} = ?PARSER:parse(Tokens),ParseTree,
	?LOG("ParseTree",ParseTree),
	ParseTree.

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

%% Using specs from http://yaml.org/spec/current.html#id2438200

parse_test_() ->
	[
	%% Basic
	%?_assert(parse("key:val") == {key,"val"} ),
	%?_assert(parse("key1:val1\nkey2:val2") == [{key1,"val1"}, {key2, "val2"}] ),
	%?_assert(parse("-apple\n-pear\n-peach") == ["apple", "pear", "peach"]),

	%% Example 2.1.  Sequence of Scalars
	?_assert(parse("- Mark McGwire\n- Sammy Sosa\n- Ken Griffey\n") == [["Mark McGwire", "Sammy Sosa", "Ken Griffey"]]),
	%% Example 2.2.  Mapping Scalars to Scalars
	?_assert(parse("hr: 65\navg: 0.278\nrbi: 147") == [{hr,"65"}, {avg, "0.278"}, {rbi, "147"}])
	
	].