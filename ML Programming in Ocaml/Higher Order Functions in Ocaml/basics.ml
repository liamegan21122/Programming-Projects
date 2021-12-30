(***********************************)
(* Part 1: Non-Recursive Functions *)
(***********************************)

let rev_tup tup = match tup with(a, b, c) -> (c, b, a);;

let is_odd x =
if x mod 2 = 0 then
false
else
true
;;

let area x y = match(x, y) with ((x1, y1), (x2, y2)) -> (abs((x1-x2) * (y1-y2)));;

let volume x y = match(x, y) with ((x1, y1, z1), (x2, y2, z2)) ->
(abs((x1-x2) * (y1-y2) * (z1-z2)));;

(*******************************)
(* Part 2: Recursive Functions *)
(*******************************)

let rec fibonacci n =
if n = 0 then
0
else
if n < 3 then
1
else
fibonacci(n -1) + fibonacci(n-2);;

let rec pow x y =
if y = 0 then
1
else
x * pow x (y-1);;

let rec log x y =
if y < x then 0
else 1 + (log x (y/x));;

let rec gcf x y =
if y = 0 then
x
else
gcf y (x mod y);;

let rec is_prime x =
let rec noDivisors y =
y * y > x || (x mod y != 0 && noDivisors (y + 1)) in
x >= 2 && noDivisors 2

(*****************)
(* Part 3: Lists *)
(*****************)

let rec get idx lst =
match lst with
| [] -> failwith "Out of bounds"
| h :: t ->
if idx = 0 then
h
else
get (idx - 1) t;;

let rec length lst =
match lst with
|[] -> 0
|_::t->1 + length t;;

let larger lst1 lst2 =

if (length lst1) > (length lst2) then
lst1
else
if (length lst1) < (length lst2) then
lst2
else
[];;

let rec rev lst = match lst with
|[] -> []
|h :: t -> rev t @ [h]

let reverse lst = rev lst

let rec combine lst1 lst2 =
match lst1 with
|h :: t -> h :: combine t lst2
|[]->lst2
;;

let rec merge lst1 lst2 =
match lst1, lst2 with
|[], _ -> lst2
|_, [] -> lst1
|hx :: tx, hy :: ty ->
if hx < hy then 
hx :: merge tx lst2
else
hy :: merge lst1 ty
;;

let rotatehelp lst = 
match lst with
|[]->[]
|[ele]->[ele]
|first::rest->(rest @ (first::[]))
;;

let rec rotate shift lst = 
match shift with
|0->lst
|_->rotate(shift-1)(rotatehelp lst)

let rec is_palindrome lst =
if (rev lst) = lst then
true
else
false
;;
