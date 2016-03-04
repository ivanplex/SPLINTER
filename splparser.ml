type token =
  | SEMICOLON
  | COMMA
  | ASSIGN
  | INTDEC
  | BOOLDEC
  | VOIDDEC
  | LISTDEC
  | FUNCID of (string)
  | VARID of (string)
  | OPENPAREN
  | CLOSEPAREN
  | OPENBRACE
  | CLOSEBRACE
  | ENDOFPROGRAM
  | RETURN
  | INTLIT of (int32)
  | BOOLLIT of (bool)

open Parsing;;
let _ = parse_error;;
# 4 "splparser.mly"
	open Spl
# 25 "splparser.ml"
let yytransl_const = [|
  257 (* SEMICOLON *);
  258 (* COMMA *);
  259 (* ASSIGN *);
  260 (* INTDEC *);
  261 (* BOOLDEC *);
  262 (* VOIDDEC *);
  263 (* LISTDEC *);
  266 (* OPENPAREN *);
  267 (* CLOSEPAREN *);
  268 (* OPENBRACE *);
  269 (* CLOSEBRACE *);
  270 (* ENDOFPROGRAM *);
  271 (* RETURN *);
    0|]

let yytransl_block = [|
  264 (* FUNCID *);
  265 (* VARID *);
  272 (* INTLIT *);
  273 (* BOOLLIT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\003\000\003\000\003\000\004\000\007\000\
\007\000\008\000\008\000\009\000\009\000\011\000\010\000\010\000\
\010\000\013\000\013\000\013\000\013\000\013\000\013\000\014\000\
\014\000\006\000\006\000\006\000\006\000\005\000\015\000\012\000\
\000\000"

let yylen = "\002\000\
\002\000\002\000\001\000\002\000\001\000\002\000\004\000\003\000\
\002\000\003\000\002\000\003\000\001\000\002\000\003\000\001\000\
\002\000\001\000\002\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\001\000\002\000\004\000\003\000\001\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\026\000\027\000\028\000\033\000\000\000\000\000\
\000\000\000\000\000\000\001\000\002\000\004\000\006\000\029\000\
\000\000\032\000\000\000\000\000\000\000\000\000\009\000\000\000\
\000\000\000\000\000\000\007\000\000\000\024\000\025\000\021\000\
\000\000\000\000\030\000\020\000\023\000\014\000\008\000\000\000\
\011\000\000\000\000\000\019\000\000\000\012\000\010\000\000\000\
\031\000\015\000"

let yydgoto = "\002\000\
\006\000\007\000\008\000\009\000\032\000\033\000\021\000\028\000\
\025\000\042\000\026\000\034\000\043\000\036\000\037\000"

let yysindex = "\011\000\
\045\255\000\000\000\000\000\000\000\000\000\000\009\255\045\255\
\027\255\032\255\047\255\000\000\000\000\000\000\000\000\000\000\
\016\255\000\000\029\255\042\255\026\255\025\255\000\000\251\254\
\033\255\041\255\005\255\000\000\025\255\000\000\000\000\000\000\
\251\254\049\255\000\000\000\000\000\000\000\000\000\000\045\255\
\000\000\044\255\057\255\000\000\025\255\000\000\000\000\025\255\
\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\046\255\
\031\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\048\255\000\000\000\000\004\255\000\000\000\000\000\000\
\000\000\014\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\050\255\000\000\000\000\000\000\000\000\051\255\
\000\000\000\000"

let yygindex = "\000\000\
\000\000\053\000\000\000\000\000\005\000\255\255\000\000\000\000\
\022\000\017\000\000\000\248\255\235\255\000\000\000\000"

let yytablesize = 65
let yytable = "\011\000\
\035\000\016\000\019\000\018\000\018\000\010\000\011\000\044\000\
\003\000\004\000\005\000\001\000\010\000\018\000\022\000\038\000\
\018\000\041\000\024\000\029\000\030\000\031\000\012\000\049\000\
\019\000\020\000\022\000\014\000\003\000\004\000\005\000\022\000\
\015\000\018\000\005\000\005\000\005\000\027\000\024\000\029\000\
\030\000\031\000\040\000\039\000\005\000\003\000\004\000\005\000\
\003\000\004\000\005\000\045\000\023\000\016\000\017\000\018\000\
\047\000\048\000\013\000\003\000\013\000\046\000\016\000\017\000\
\050\000"

let yycheck = "\001\000\
\022\000\007\001\011\000\009\001\001\001\001\000\008\000\029\000\
\004\001\005\001\006\001\001\000\008\000\009\001\001\001\024\000\
\013\001\013\001\020\000\015\001\016\001\017\001\014\001\045\000\
\033\000\010\001\013\001\001\001\004\001\005\001\006\001\003\001\
\001\001\009\001\004\001\005\001\006\001\012\001\040\000\015\001\
\016\001\017\001\002\001\011\001\014\001\004\001\005\001\006\001\
\004\001\005\001\006\001\003\001\011\001\007\001\008\001\009\001\
\013\001\001\001\011\001\014\001\008\000\040\000\013\001\013\001\
\048\000"

let yynames_const = "\
  SEMICOLON\000\
  COMMA\000\
  ASSIGN\000\
  INTDEC\000\
  BOOLDEC\000\
  VOIDDEC\000\
  LISTDEC\000\
  OPENPAREN\000\
  CLOSEPAREN\000\
  OPENBRACE\000\
  CLOSEBRACE\000\
  ENDOFPROGRAM\000\
  RETURN\000\
  "

let yynames_block = "\
  FUNCID\000\
  VARID\000\
  INTLIT\000\
  BOOLLIT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'topLevelList) in
    Obj.repr(
# 28 "splparser.mly"
                           ( _1 )
# 151 "splparser.ml"
               : Spl.ast))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'topLevelOperation) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'topLevelList) in
    Obj.repr(
# 31 "splparser.mly"
                                  ( Seq( _1, _2 ) )
# 159 "splparser.ml"
               : 'topLevelList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'topLevelOperation) in
    Obj.repr(
# 32 "splparser.mly"
                     ( _1 )
# 166 "splparser.ml"
               : 'topLevelList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'funcDef) in
    Obj.repr(
# 35 "splparser.mly"
                     ( _1 )
# 173 "splparser.ml"
               : 'topLevelOperation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'funcDef) in
    Obj.repr(
# 36 "splparser.mly"
           ( _1 )
# 180 "splparser.ml"
               : 'topLevelOperation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'varInit) in
    Obj.repr(
# 37 "splparser.mly"
                     ( _1 )
# 187 "splparser.ml"
               : 'topLevelOperation))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'typeDec) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'funcDefParams) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'funcDefBody) in
    Obj.repr(
# 40 "splparser.mly"
                                            (
		FuncDef( FuncIdentifier( _2 ), TypeDec( _1 ), _3, _4 )
	)
# 199 "splparser.ml"
               : 'funcDef))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'paramList) in
    Obj.repr(
# 45 "splparser.mly"
                                  ( _2 )
# 206 "splparser.ml"
               : 'funcDefParams))
; (fun __caml_parser_env ->
    Obj.repr(
# 46 "splparser.mly"
                        ( Null )
# 212 "splparser.ml"
               : 'funcDefParams))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'exprList) in
    Obj.repr(
# 49 "splparser.mly"
                                 ( _2 )
# 219 "splparser.ml"
               : 'funcDefBody))
; (fun __caml_parser_env ->
    Obj.repr(
# 50 "splparser.mly"
                        ( Null )
# 225 "splparser.ml"
               : 'funcDefBody))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'funcParam) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'paramList) in
    Obj.repr(
# 53 "splparser.mly"
                             ( FuncParams( _1, _3 ) )
# 233 "splparser.ml"
               : 'paramList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'funcParam) in
    Obj.repr(
# 54 "splparser.mly"
             ( _1 )
# 240 "splparser.ml"
               : 'paramList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'typeDec) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'varName) in
    Obj.repr(
# 57 "splparser.mly"
                   ( ParamDec( TypeDec( _1 ), _2 ) )
# 248 "splparser.ml"
               : 'funcParam))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'exprList) in
    Obj.repr(
# 60 "splparser.mly"
                           ( Seq( _1, _3 ) )
# 256 "splparser.ml"
               : 'exprList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 61 "splparser.mly"
        ( _1 )
# 263 "splparser.ml"
               : 'exprList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 62 "splparser.mly"
                  ( _1 )
# 270 "splparser.ml"
               : 'exprList))
; (fun __caml_parser_env ->
    Obj.repr(
# 66 "splparser.mly"
          ( ReturnStmt( Null ) )
# 276 "splparser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 67 "splparser.mly"
               ( ReturnStmt( _2 ) )
# 283 "splparser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'literal) in
    Obj.repr(
# 68 "splparser.mly"
           ( _1 )
# 290 "splparser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'varInit) in
    Obj.repr(
# 69 "splparser.mly"
           ( _1 )
# 297 "splparser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'varName) in
    Obj.repr(
# 70 "splparser.mly"
           ( _1 )
# 304 "splparser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'varAssign) in
    Obj.repr(
# 71 "splparser.mly"
             ( _1 )
# 311 "splparser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int32) in
    Obj.repr(
# 74 "splparser.mly"
          ( IntLit _1 )
# 318 "splparser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : bool) in
    Obj.repr(
# 75 "splparser.mly"
           ( BoolLit _1 )
# 325 "splparser.ml"
               : 'literal))
; (fun __caml_parser_env ->
    Obj.repr(
# 78 "splparser.mly"
          ( Int )
# 331 "splparser.ml"
               : 'typeDec))
; (fun __caml_parser_env ->
    Obj.repr(
# 79 "splparser.mly"
           ( Bool )
# 337 "splparser.ml"
               : 'typeDec))
; (fun __caml_parser_env ->
    Obj.repr(
# 80 "splparser.mly"
           ( Void )
# 343 "splparser.ml"
               : 'typeDec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'typeDec) in
    Obj.repr(
# 81 "splparser.mly"
                   ( List( _1 ) )
# 350 "splparser.ml"
               : 'typeDec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'typeDec) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'varName) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 84 "splparser.mly"
                               ( VarInitialisation( TypeDec( _1 ), _2, _4 ) )
# 359 "splparser.ml"
               : 'varInit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'varName) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 87 "splparser.mly"
                       ( Assignment( _1, _3 ) )
# 367 "splparser.ml"
               : 'varAssign))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 90 "splparser.mly"
       ( VarIdentifier _1 )
# 374 "splparser.ml"
               : 'varName))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Spl.ast)
