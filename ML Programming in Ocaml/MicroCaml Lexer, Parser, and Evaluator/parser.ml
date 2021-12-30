open MicroCamlTypes
open Utils
open TokenTypes

(* Provided functions - DO NOT MODIFY *)

(* Matches the next token in the list, throwing an error if it doesn't match the given token *)
let match_token (toks: token list) (tok: token) =
  match toks with
  | [] -> raise (InvalidInputException(string_of_token tok))
  | h::t when h = tok -> t  
  | h::_ -> raise (InvalidInputException(
      Printf.sprintf "Expected %s from input %s, got %s"
        (string_of_token tok)
        (string_of_list string_of_token toks)
        (string_of_token h)))

(* Matches a sequence of tokens given as the second list in the order in which they appear, throwing an error if they don't match *)
let match_many (toks: token list) (to_match: token list) =
  List.fold_left match_token toks to_match

(* Return the next token in the token list as an option *)
let lookahead (toks: token list) =
  match toks with
  | [] -> None
  | h::t -> Some h

(* Return the token at the nth index in the token list as an option*)
let rec lookahead_many (toks: token list) (n: int) =
  match toks, n with
  | h::_, 0 -> Some h
  | _::t, n when n > 0 -> lookahead_many t (n-1)
  | _ -> None

(* Part 2: Parsing expressions *)

let rec parse_expr_help toks =
	parse_or toks

and parse_or lst =
	let (lst2, e1) = (parse_and lst) in
	match lst2 with

	| Tok_Or::t -> let lst3 = (match_token lst2 Tok_Or) in
		let (lst4, e2) = (parse_or lst3) in (lst4, Binop(Or,e1,e2))

	| _ -> (lst2, e1)

and parse_and lst =
	let (lst2, e1) = (parse_equal lst) in
	match lst2 with
		| Tok_And::t -> let lst3 = (match_token lst2 Tok_And) in
			let (lst4, e2) = (parse_and lst3) in (lst4, Binop(And, e1,e2))

		| _ -> (lst2, e1)

and parse_equal lst =
	let (lst2, e1) = (parse_relational lst) in
	match lst2 with
		| Tok_Equal::t -> let lst3 = (match_token lst2 Tok_Equal) in
			let (lst4, e2) = (parse_equal lst3) in (lst4, Binop(Equal, e1,e2))

		| Tok_NotEqual::t -> let lst3 = (match_token lst2 Tok_NotEqual) in
			let (lst4, e2) = (parse_equal lst3) in (lst4, Binop(NotEqual, e1, e2))

		| _ -> (lst2, e1)

and parse_relational lst =
	let (lst2, e1) = (parse_add lst) in
	match lst2 with

		| Tok_Less::t -> let lst3 = (match_token lst2 Tok_Less) in
			let (lst4, e2) = (parse_relational lst3) in (lst4, Binop(Less,e1,e2))

		| Tok_Greater::t -> let lst3 = (match_token lst2 Tok_Greater) in
			let (lst4, e2) = (parse_relational lst3) in (lst4, Binop(Greater, e1,e2))

		| Tok_LessEqual::t -> let lst3 = (match_token lst2 Tok_LessEqual) in
			let (lst4, e2) = (parse_relational lst3) in (lst4, Binop(LessEqual,e1,e2))

		| Tok_GreaterEqual::t -> let lst3 = (match_token lst2 Tok_GreaterEqual) in
			let (lst4, e2) = (parse_relational lst3) in (lst4, Binop(GreaterEqual,e1,e2))
		
		| _ -> (lst2, e1)

and parse_add lst =
	let (lst2, e1) = (parse_mult lst) in
	match lst2 with

		| Tok_Add::t -> let lst3 = (match_token lst2 Tok_Add) in
			let (lst4, e2) = (parse_add lst3) in (lst4, Binop(Add, e1,e2))

		| Tok_Sub::t -> let lst3 = (match_token lst2 Tok_Sub) in
			let (lst4, e2) = (parse_add lst3) in (lst4, Binop(Sub, e1,e2))

		| _ -> (lst2, e1)

and parse_mult lst =
	let (lst2, e1) = (parse_concat lst) in
	match lst2 with
		| Tok_Mult::t -> let lst3 = (match_token lst2 Tok_Mult) in
			let (lst4, e2) = (parse_mult lst3) in (lst4, Binop(Mult,e1,e2))

		| Tok_Div::t -> let lst3 = (match_token lst2 Tok_Div) in
			let (lst4, e2) = (parse_mult lst3) in (lst4, Binop(Div,e1,e2))

		| _ -> (lst2, e1)

and parse_concat lst =
	let (lst2, e1) = (parse_unary lst) in
	match lst2 with

	|Tok_Concat::t -> let lst3 = (match_token lst2 Tok_Concat) in
		let (lst4, e2) = (parse_concat lst3) in (lst4, Binop(Concat, e1, e2))
|_ -> (lst2, e1)

and parse_unary lst =
match lst with
| Tok_Not::t -> let lst2 = (match_token lst Tok_Not) in
let (lst3, e2) = (parse_unary lst2) in (lst3, Not(e2))
| _ -> (parse_func_call_expr lst)


and parse_func_call_expr lst =
	let (lst2, e1) = (parse_primary lst) in
	let token = lookahead(lst2) in
	match token with
		| Some Tok_Int(x) ->
			let (lst3, e2) = (parse_primary lst2) in
			(lst3, FunctionCall(e1, e2))

		| Some Tok_Bool(x) ->
			let (lst3, e2) = (parse_primary lst2) in
			(lst3, FunctionCall(e1, e2))

		| Some Tok_String(x) ->
			let (lst3, e2) = (parse_primary lst2) in
			(lst3, FunctionCall(e1, e2))

		| Some Tok_ID(x) ->
			let (lst3, e2) = (parse_primary lst2) in
			(lst3, FunctionCall(e1, e2))

		| Some Tok_LParen ->
			let (lst3, e2) = (parse_primary lst2) in
			(lst3, FunctionCall(e1, e2))

		| __ -> (lst2, e1)



and parse_primary lst =
match lst with

| (Tok_Int(x))::t -> let lst2 = (match_token lst (Tok_Int(x))) in
(lst2, Value(Int(x)))

| (Tok_Bool(x))::t -> let lst2 = (match_token lst (Tok_Bool(x))) in
(lst2, Value(Bool x))

| (Tok_ID(x))::t -> let lst2 = (match_token lst (Tok_ID(x))) in
(lst2, ID(x))

| (Tok_String(x))::t -> let lst2 = (match_token lst (Tok_String(x))) in
(lst2, Value(String x))

| Tok_LParen::t -> let lst2 = (match_token lst Tok_LParen) in
(let (lst3, e2) = (parse_expr_help lst2) in
match lst3 with
| Tok_RParen::t -> (t, e2)
| _ -> raise (InvalidInputException("right paren not found")))
| _ ->
raise (InvalidInputException("error here"))
;;



let rec parse_statement toks =
match toks with

(* Let Parse *)
|Tok_Let::t ->
let (lst, let_statement) = (letStatement toks) in
(lst, let_statement)

(* Fun Parse *)
|Tok_Fun::t ->
let (lst, fun_statement) = (funStatement toks) in
(lst, fun_statement)

(* If Parse *)
|Tok_If::t ->
let (lst, if_statement) = (ifStatement toks) in
(lst, if_statement)

| _ -> parse_expr_help (toks)

and letStatement lst =

match lst with



| Tok_Let::Tok_ID(x)::t ->

(* Let Expression *)
let lst2 = (match_token lst Tok_Let) in
let lst3 = (match_token lst2 (Tok_ID x)) in

(* Equal Expression *)
let lst4 = (match_token lst3 Tok_Equal) in

let (lst5, eql_expr) = (parse_statement lst4) in

(* In Expression *)
let lst6 = (match_token lst5 Tok_In) in
let (lst7, in_exp) = (parse_statement lst6) in

(* Return *)
(lst7, Let(x, false, eql_expr, in_exp))

| Tok_Let::Tok_Rec::Tok_ID(x)::t ->

(* Let Expression *)
let lst2 = (match_token lst Tok_Let) in
let lst3 = (match_token lst2 Tok_Rec) in
let lst8 = (match_token lst3 (Tok_ID x)) in

(* Equal Expression *)
let lst4 = (match_token lst8 Tok_Equal) in
let (lst5, eql_expr) = (parse_statement lst4) in

(* In Expression *)
let lst6 = (match_token lst5 Tok_In) in
let (lst7, in_exp) = (parse_statement lst6) in

(* Return *)
(lst7, Let(x, true, eql_expr, in_exp))

| _ -> raise (InvalidInputException("Let error"))



and funStatement lst =
match lst with

| Tok_Fun::Tok_ID(x)::t ->

(* Fun Expr *)
let lst2 = (match_token lst Tok_Fun) in
let lst3 = (match_token lst2 (Tok_ID x)) in

(* Arrow Expr *)
let lst4 = (match_token lst3 Tok_Arrow) in
let (lst5, fun_expr) = (parse_statement lst4) in

(lst5, Fun(x, fun_expr))

| _ -> raise (InvalidInputException("Fun error"))



and ifStatement lst = match lst with

| Tok_If::t -> let lst2 = (match_token lst Tok_If) in
(* if expression *)

let (lst3, if_exp) = (parse_statement lst2) in
let lst4 = (match_token lst3 Tok_Then) in

(* then *)

let (lst5, if_stmt) = (parse_statement lst4) in

(* else *)
(match lst5 with
| Tok_Else::t -> let lst6 = (match_token lst5 Tok_Else) in

let (lst7, else_stmt) = (parse_statement lst6) in

(lst7, If(if_exp, if_stmt, else_stmt))  
| _ -> (lst5, If(if_exp, if_stmt, if_exp)))

| _ -> raise (InvalidInputException("if error"))




let rec parse_expr tokens =
parse_statement tokens


(* Part 3: Parsing mutop *)

let rec parse_mutop toks = failwith "unimplemented"
