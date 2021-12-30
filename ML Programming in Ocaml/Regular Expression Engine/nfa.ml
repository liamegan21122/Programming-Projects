open List
open Sets

(*********)
(* Types *)
(*********)

type ('q, 's) transition = 'q * 's option * 'q

type ('q, 's) nfa_t = {
  sigma: 's list;
  qs: 'q list;
  q0: 'q;
  fs: 'q list;
  delta: ('q, 's) transition list;
}

(***********)
(* Utility *)
(***********)

(* explode converts a string to a character list *)
let explode (s: string) : char list =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l)
  in
exp (String.length s - 1) []

let rec fold_right f xs a =
match xs with
|[] -> a
|x :: xt -> f x (fold_right f xt a)

let rec fold f a xs = match xs with
|[] -> a
| x :: xt -> fold f (f a x) xt

let rec srl x a = match a with
| [] -> false
|s :: t -> if s = x then true else srl x t

(****************)
(* Part 1: NFAs *)
(****************)

let rec move_helper target op trans_list reachable =
match trans_list with
| [] -> reachable 
| h :: t -> let ecl = (match h with
			      |(t, o, e) when t = target && o = op -> if elem e reachable == true then reachable else e::reachable
| (_,_,_) -> reachable)
in move_helper target op t ecl


let rec move (nfa: ('q,'s) nfa_t) (qs: 'q list) (s: 's option) : 'q list =
match qs with
|[] -> []
|h::t -> (move_helper h s (nfa.delta) [])@(move nfa t s)


let rec e_closure_helper trans_list e_closures work_list =
match work_list with
|[] -> e_closures
|h::t ->
let e_closures' =
union
e_closures (fold (fun acc (t, o, e) -> if ( t= h && o = None) then e::acc else acc) [] trans_list) in
e_closure_helper trans_list e_closures' (fold (fun acc (t, o, e) -> if (t = h && o = None) then e::acc else acc) [] trans_list)

let e_closure (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list =
e_closure_helper nfa.delta qs qs

let rec accept_helper nfa curr_states final_state str =
match str with
| [] -> fold (fun acc x -> acc || (subset [x] final_state)) false curr_states
| h :: t -> accept_helper nfa (e_closure nfa (move nfa (e_closure nfa curr_states) (Some h))) final_state t

let accept (nfa: ('q,char) nfa_t) (s: string) : bool =
if (s  = "") then fold (fun acc x -> acc || (subset [x] nfa.fs)) false (e_closure nfa [nfa.q0])
else accept_helper nfa [nfa.q0] nfa.fs (explode s)

(*******************************)
(* Part 2: Subset Construction *)
(*******************************)

let new_states (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
fold_left (fun acc x -> (union (move nfa qs (Some x)) (e_closure nfa (move nfa qs (Some x))))::acc) [] nfa.sigma

let rec remdup lst a =
match lst with
| []-> a
| h::t -> if srl h a = true then remdup t a
else remdup t (h::a)


let new_trans (nfa: ('q,'s) nfa_t) (qs: 'q list) : ('q list, 's) transition list =
fold_left (fun acc x -> let asc = (move nfa qs (Some x)) in (qs, Some x, union asc (e_closure nfa (move nfa qs (Some x))))::acc) [] nfa.sigma


let rec new_finals (nfa: ('q,'s) nfa_t) (qs: 'q list) : 'q list list =
match qs with
| [] -> []
| h :: t -> if elem h nfa.fs == true then [qs] else new_finals nfa t


let rec finals nfa_final dfa_states =
match nfa_final with
|[] -> []
|h::t -> hd (filter (fun x ->(subset [h] x)) dfa_states)::((finals t dfa_states))


let update_finals_trans dfa nfa =
{sigma = dfa.sigma; qs = dfa.qs; q0 = dfa.q0; fs = finals nfa.fs dfa.qs; delta = dfa.delta}

let rec nfa_to_dfa_step (nfa: ('q,'s) nfa_t) (dfa: ('q list, 's) nfa_t)
(work: 'q list list) : ('q list, 's) nfa_t =
match work with
| []-> dfa
| x::t ->
let new_dfa = {sigma = dfa.sigma; qs = remove [] (union dfa.qs (new_states nfa x));
q0 = dfa.q0; fs = union (new_finals nfa x) dfa.fs;
delta = union dfa.delta (new_trans nfa (hd work))}
in nfa_to_dfa_step nfa new_dfa (remove [] (union t (remove x (new_states nfa x))))


let nfa_to_dfa (nfa: ('q,'s) nfa_t) : ('q list, 's) nfa_t =
let dfa_start = e_closure nfa [nfa.q0] in
let dfa = {sigma = nfa.sigma; qs = [dfa_start]; q0 = dfa_start; fs = []; delta = []} in
update_finals_trans (nfa_to_dfa_step nfa dfa [dfa_start]) nfa
