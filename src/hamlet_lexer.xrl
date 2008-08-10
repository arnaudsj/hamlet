% Lexes a HAML template

Definitions.

T   = [A-Za-z0-9_]
SEMIC = [':']
DASH = [\-]
WS  = ([\000-\s]|%.*)
NL = ['\n']

Rules.

{T}+ 		:   {token,{element,TokenLine,TokenChars}}.
{SEMIC}		:	{token,{semicolon, TokenLine, TokenChars}}.
{DASH}		:	{token,{dash, TokenLine, TokenChars}}.
{NL}		:	{token,{eol, TokenLine, TokenChars}}.
{WS}+       :   skip_token.

Erlang code.

% strip(TokenChars,TokenLen) -> lists:sublist(TokenChars, 1, TokenLen - 1).