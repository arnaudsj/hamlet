Nonterminals statements statement list ilist.

Terminals
semicolon dash idash element eol.

Rootsymbol statements.

statements -> statement eol statements: ['$1'|'$3']. 
statements -> statement : ['$1'].
statement -> element semicolon element : {list_to_atom(unwrap('$1')), unwrap('$3')}.
statement -> list : '$1'.
list -> dash element eol list: [unwrap('$2')|'$4'].
list -> dash eol ilist: ['$3'].
list -> dash eol ilist list: ['$3'|'$4'].
list -> dash element eol: [unwrap('$2')].
list -> dash element: [unwrap('$2')].

ilist -> idash element eol ilist: [unwrap('$2')|'$4'].
ilist -> idash element eol: [unwrap('$2')].
ilist -> idash element: [unwrap('$2')].

Erlang code.

unwrap({_,_,V}) -> V.