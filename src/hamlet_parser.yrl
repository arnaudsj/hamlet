Nonterminals statements statement.

Terminals
semicolon element eol.

Rootsymbol statements.

statements -> statement eol statements: ['$1', '$3']. 
statements -> statement : '$1'.
statement -> element semicolon element : {list_to_atom(unwrap('$1')), unwrap('$3')}.

Erlang code.

unwrap({_,_,V}) -> V.