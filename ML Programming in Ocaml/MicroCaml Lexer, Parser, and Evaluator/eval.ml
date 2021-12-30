open MicroCamlTypes
open Utils

exception TypeError of string
exception DeclareError of string
exception DivByZeroError 

(* Provided functions - DO NOT MODIFY *)

(* Adds mapping [x:v] to environment [env] *)
let extend env x v = (x, ref v)::env

(* Returns [v] if [x:v] is a mapping in [env]; uses the
   most recent if multiple mappings for [x] are present *)
let rec lookup env x =
  match env with
  | [] -> raise (DeclareError ("Unbound variable " ^ x))
  | (var, value)::t -> if x = var then !value else lookup t x

(* Creates a placeholder mapping for [x] in [env]; needed
   for handling recursive definitions *)
let extend_tmp env x = (x, ref (Int 0))::env

(* Updates the (most recent) mapping in [env] for [x] to [v] *)
let rec update env x v =
  match env with
  | [] -> raise (DeclareError ("Unbound variable " ^ x))
  | (var, value)::t -> if x = var then (value := v) else update t x v
        
(* Part 1: Evaluating expressions *)

(* Helper functions*)
let rec search env x = match env with 
	|[] -> false
	|(y, z)::t -> if x = y then true else (search t x)


(* Evaluates MicroCaml expression [e] in environment [env],
   returning a value, or throwing an exception on error *)
let rec eval_expr (env:environment) (e:expr) : value = match e with 
	
	(* Value Types *)
	
	(* Evaluate Int *)
	| Value(Int x) -> Int(x)
	
	(* Evaluate Boolean *)
	| Value(Bool x) -> Bool(x)

	(* Evaluate String *)
	| Value(String x) -> String(x)

	(* Evaluate ID *)
	| ID x -> lookup env x
		
	(* Evaluate Not *)
	| Not exp -> let bool = (eval_expr env exp) in 
		(match bool with 
		| Bool x -> (Bool (not x))
		| Int x -> raise (TypeError("Expected type bool"))
		| _ -> raise (TypeError("Expected type bool")))

	(* Binary Operations *)
	
	(* Evaluate Add *)
	| Binop(Add,e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with 
		| Int x -> (match num2 with
			| Int y -> (Int (x+y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Evaluate Sub *)
	| Binop(Sub,e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with 
		| Int x -> (match num2 with
			| Int y -> (Int (x-y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Evaluate Mult *)
	| Binop(Mult,e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with 
		| Int x -> (match num2 with
			| Int y -> (Int (x*y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Evaluate Div *)
	| Binop(Div,e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with 
		| Int x -> (match num2 with
			| Int y -> if y = 0 then raise (DivByZeroError) else (Int(x/y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Relational Operators *)
	
	(* Evaluate Greater *)
	| Binop(Greater, e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with
		| Int x -> (match num2 with
			| Int y -> (Bool (x>y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Evaluate Less *)
	| Binop(Less, e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with
		| Int x -> (match num2 with
			| Int y -> (Bool (x<y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Evaluate Greater Equal *)
	| Binop(GreaterEqual, e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with
		| Int x -> (match num2 with
			| Int y -> (Bool (x>=y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Evaluate Less Equal *)
	| Binop(LessEqual, e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with
		| Int x -> (match num2 with
			| Int y -> (Bool (x<=y))
			| _ -> raise (TypeError("Expected type int")))
		| _ -> raise (TypeError("Expected type int")))

	(* Evaluate Concat *)
	| Binop(Concat, e1,e2) -> let num1 = (eval_expr env e1) in
		let num2 = (eval_expr env e2) in
		(match num1 with
		| String x -> (match num2 with
			| String y -> (String (x^y))
			| _ -> raise (TypeError("Expected type string")))
		| _ -> raise (TypeError("Expected type string")))

	(* Equality Operators *)

	(* Evaluate Equal *)
	| Binop(Equal, e1,e2) -> let exp1 = (eval_expr env e1) in
		let exp2 = (eval_expr env e2) in
		(match exp1 with
		
		| Int x -> (match exp2 with
			| Int y -> (Bool (x=y))
			| _-> raise (TypeError("Cannot compare types")))
				
		| Bool x ->	(match exp2 with
			| Bool y -> (Bool (x=y))
			| _ -> raise (TypeError("Cannot compare types")))

		| String x -> (match exp2 with 
			| String y -> (Bool (x=y))
			|_ -> raise (TypeError("Cannot compare types")))

		| _ -> raise (TypeError("Cannot compare types")))

	(* Evaluate Not Equal *)
	| Binop(NotEqual, e1,e2) -> let exp1 = (eval_expr env e1) in
		let exp2 = (eval_expr env e2) in
		(match exp1 with
		
		| Int x -> (match exp2 with
			| Int y -> (Bool (x!=y))
			| _-> raise (TypeError("Cannot compare types")))
				
		| Bool x ->	(match exp2 with
			| Bool y -> (Bool (x!=y))
			| _ -> raise (TypeError("Cannot compare types")))

		| String x -> (match exp2 with 
			| String y -> (Bool (if x = y then false else true))
			|_ -> raise (TypeError("Cannot compare types")))

		| _ -> raise (TypeError("equal2 invalid exp found")))

	(* Logical Operators *)
	
	(* Evaluate Or *)
	| Binop(Or,e1,e2) -> let bool1 = (eval_expr env e1) in
		let bool2 = (eval_expr env e2) in
		(match bool1 with
		| Bool x -> (match bool2 with
			| Bool y -> (Bool (x || y))
			| _ -> raise (TypeError("Expected type bool")))
		| _ -> raise (TypeError("Expected type bool")))

	(* Evaluate And *)
	| Binop(And,e1,e2) -> let bool1 = (eval_expr env e1) in
		let bool2 = (eval_expr env e2) in
		(match bool1 with
		| Bool x -> (match bool2 with
			| Bool y -> (Bool (x && y))
			| _ -> raise (TypeError("Expected type bool")))
		| _ -> raise (TypeError("Expected type bool")))
	
	(* Evaluate If *) 
	| If (exp,s1,s2) -> let e2 = (eval_expr env exp) in
		(match e2 with
			| Bool x -> let e3 = (if x=true 
				then (eval_expr env s1)
				else (eval_expr env s2)) in e3 	
			| _ -> raise (TypeError("Guard does not evaluate to type bool")))

	(* Key Words *)

	(* Evaluate Let *) 
	| Let (tag,false,e1,e2) -> let e3 = (eval_expr env e1) in
				   eval_expr (extend env tag e3) e2

	| Let (tag,true,e1,e2) -> let env3 = extend_tmp env tag in
					let e3 = (eval_expr env3 e1) in
					let _ = update env3 tag e3 in
					eval_expr env3 e2

	(* Evaluate Fun *)
	| Fun (tag, expr) -> Closure(env, tag, expr)

	(* Evaluate FuncationCall *)
	| FunctionCall(e1,e2) -> let e3 = (eval_expr env e1) in
		(match e3 with 
			| Closure(env1, tag, expr) -> 
			let v = (eval_expr env e2) in
			eval_expr (extend env1 tag v) expr 
	
			|_ -> raise (TypeError("Not a function")))
	

	| _ -> raise (DeclareError("Invalid input expression"))

(* Part 2: Evaluating mutop directive *)

(* Evaluates MicroCaml mutop directive [m] in environment [env],
   returning a possibly updated environment paired with
   a value option; throws an exception on error *)
let eval_mutop env m = 
	match m with

	| Def (tag, exp1) -> let env3 = extend_tmp env tag in
				let e3 = (eval_expr env3 exp1) in
				let _ = update env3 tag e3 in
				(env3, Some(e3))

	|Expr(x) -> (env, Some(eval_expr env x))
 
	| NoOp -> (env, None)