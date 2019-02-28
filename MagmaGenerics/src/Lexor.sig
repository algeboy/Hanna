174,0
T,ListToken,-,0
T,NillListToken,-,1,ListToken
T,ConsToken,-,1,ListToken
A,ConsToken,4,head,tail,stream,lineCount
S,Tokenize,Turn string stream into token stream,0,1,0,0,0,0,0,0,0,298,,ListToken,-38,-38,-38,-38,-38
S,Head,Return first token,0,1,0,0,0,0,0,0,0,ConsToken,,Tkn,-38,-38,-38,-38,-38
S,Tail,Tail of token list,0,1,0,0,0,0,0,0,0,ConsToken,,ListToken,-38,-38,-38,-38,-38
S,Sprint,,0,1,0,0,0,0,0,0,0,ConsToken,,298,-38,-38,-38,-38,-38
S,Print,Print token list,0,1,0,0,1,0,0,0,0,ConsToken,,-38,-38,-38,-38,-38,-38
