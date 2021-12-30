open TokenTypes
open MicroCamlTypes

(* Part 1: Lexer - IMPLEMENT YOUR CODE BELOW *)

let tokenize input = 
	
	(* Tokens with simple rules *)
	let regexp_lparen = Str.regexp "(" in
	let regexp_rparen = Str.regexp ")" in
	let regexp_equal = Str.regexp "=" in
	let regexp_notequal = Str.regexp "<>" in 
	let regexp_greater = Str.regexp ">" in 
	let regexp_less = Str.regexp "<" in 
	let regexp_greaterequal = Str.regexp ">=" in 
	let regexp_lessequal = Str.regexp "<=" in  
	let regexp_or = Str.regexp "||" in 
	let regexp_and = Str.regexp "&&" in
	let regexp_not = Str.regexp "not" in
	let regexp_if = Str.regexp "if" in 
	let regexp_then = Str.regexp "then" in 
	let regexp_else = Str.regexp "else" in 
	let regexp_add = Str.regexp "+" in 
	let regexp_sub = Str.regexp "-" in 
	let regexp_mult = Str.regexp "*" in
	let regexp_div = Str.regexp "/" in
	let regexp_concat = Str.regexp "\\^" in
	
	(* Some Keyword tokens *)
	let regexp_let = Str.regexp "let" in
	let regexp_def = Str.regexp "def" in
	let regexp_in = Str.regexp "in" in
	let regexp_rec = Str.regexp "rec" in
	let regexp_fun = Str.regexp "fun" in
	let regexp_arrow = Str.regexp "->" in
	let regexp_doublesemi = Str.regexp "\\;;" in 

	(* Tokens with some more complex rules *)
	let regexp_bool = Str.regexp "true\\|false" in
	let regexp_int_paren = Str.regexp "(-[0-9]+)" in
	let regexp_int_noparen = Str.regexp "[0-9]+" in
	let regexp_string = Str.regexp "\"[^\"]*\"" in
	let regexp_id = Str.regexp "[a-zA-Z][a-zA-Z0-9]*" in

	(* Formatting*)
	let regexp_skip = Str.regexp "[ \t\n]*" in
	let regexp_extra = Str.regexp "[a-zA-Z0-9]+" in

	(* Let's start Tokenizing *)
	let rec next_token str pos = 

	if pos >= (String.length str) then []

	(* Tok_Bool *)
	else if (Str.string_match regexp_bool str pos)
		then let token = Str.matched_string str in
		(Tok_Bool (bool_of_string token))::(next_token str (Str.match_end()))


	(* Tok_Int_Pos *)
	else if (Str.string_match regexp_int_noparen str pos) then 
		let token = Str.matched_string str in 
		(Tok_Int (int_of_string token))::(next_token str (Str.match_end()))

	(* Tok_Int_Neg *)
	else if (Str.string_match regexp_int_paren str pos) then 
		let token = Str.matched_string str in
		(Tok_Int (int_of_string (String.sub token 1 ((String.length token) - 2)))):: (next_token str ( Str.match_end()))
	
	(* Tok_LParen *)
	else if (Str.string_match regexp_lparen str pos)
		then (Tok_LParen)::(next_token str (pos+1))
	
	(* Tok_RParen *)
	else if (Str.string_match regexp_rparen str pos)
		then (Tok_RParen)::(next_token str (pos+1))

	(* Tok_Equal *)
	else if (Str.string_match regexp_equal str pos)
		then (Tok_Equal)::(next_token str (pos+1))

	(* Tok_NotEqual *)
	else if (Str.string_match regexp_notequal str pos)
		then (Tok_NotEqual)::(next_token str (pos+2))

	(* Tok_GreaterEqual *)
	else if (Str.string_match regexp_greaterequal str pos)
		then (Tok_GreaterEqual)::(next_token str (pos+2))

	(* Tok_LessEqual *)
	else if (Str.string_match regexp_lessequal str pos)
		then (Tok_LessEqual)::(next_token str (pos+2))

	(* Tok_Greater *)
	else if (Str.string_match regexp_greater str pos)
		then (Tok_Greater)::(next_token str (pos+1))

	(* Tok_Less *)
	else if (Str.string_match regexp_less str pos)
		then (Tok_Less)::(next_token str (pos+1))

	(* Tok_Or *)
	else if (Str.string_match regexp_or str pos)
		then (Tok_Or)::(next_token str (pos+2))

	(* Tok_And *)
	else if (Str.string_match regexp_and str pos)
		then (Tok_And)::(next_token str (pos+2))

	(* Tok_Arrow *)
	else if (Str.string_match regexp_arrow str pos)
		then (Tok_Arrow)::(next_token str (pos+2))

	(* Tok_Add *)
	else if (Str.string_match regexp_add str pos)
		then (Tok_Add)::(next_token str (pos+1))

	(* Tok_Sub *)
	else if (Str.string_match regexp_sub str pos)
		then (Tok_Sub)::(next_token str (pos+1))

	(* Tok_Mult *)
	else if (Str.string_match regexp_mult str pos)
		then (Tok_Mult)::(next_token str (pos+1))

	(* Tok_Div *)
	else if (Str.string_match regexp_div str pos)
		then (Tok_Div)::(next_token str (pos+1))

	(* Tok_Concat *)
	else if (Str.string_match regexp_concat str pos)
		then (Tok_Concat)::(next_token str (pos+1))

	(* Tok_Let*)
	else if (Str.string_match regexp_let str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_Let)::(next_token str new_pos)

	(* Tok_Def *)
	else if (Str.string_match regexp_def str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_Def)::(next_token str new_pos)

	(* Tok_In *)
	else if (Str.string_match regexp_in str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_In)::(next_token str new_pos)
	
	(* Tok_Rec *)
	else if (Str.string_match regexp_rec str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
		(Tok_Rec)::(next_token str new_pos)

	(* Tok_Fun *)
	else if (Str.string_match regexp_fun str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_Fun)::(next_token str new_pos)

	(* Tok_Not *)
	else if (Str.string_match regexp_not str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_Not)::(next_token str new_pos)

	(* Tok_If *)
	else if (Str.string_match regexp_if str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_If)::(next_token str new_pos)

	(* Tok_Then *)
	else if (Str.string_match regexp_then str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_Then)::(next_token str new_pos)

	(* Tok_Else *)
	else if (Str.string_match regexp_else str pos) then 
		let token_key = Str.matched_string str in
		let new_pos = Str.match_end() in
		if (Str.string_match regexp_extra str new_pos)then 
			let token_id = Str.matched_string str in
			(Tok_ID (token_key^token_id))::(next_token str (Str.match_end()))
		else 
			(Tok_Else)::(next_token str new_pos)

	(* Tok_String *)
	else if (Str.string_match regexp_string str pos) then 
		let token = Str.matched_string str in 
		(Tok_String (String.sub token 1 ((String.length token) - 2)))::(next_token str (Str.match_end()))
	
	(* Tok_Id *)
	else if (Str.string_match regexp_id str pos) then 
		let token = Str.matched_string str in 
		(Tok_ID token)::(next_token str (Str.match_end()))
	
	(* Tok_DoubleSemi *)
	else if (Str.string_match regexp_doublesemi str pos)
		then (Tok_DoubleSemi)::(next_token str (pos+2))

	(* Skip Whitespace *)
	else if (Str.string_match regexp_skip str pos)
			then (next_token str (Str.match_end()))

	else 
		raise (InvalidInputException "Lexing Error")
	in 

	next_token input 0
	
	