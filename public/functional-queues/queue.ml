module type QUEUE = sig
  type 'a t
  val empty    : 'a t
  val is_empty : 'a t -> bool
  val enqueue  : 'a -> 'a t -> 'a t
  val dequeue  : 'a t -> ('a option * 'a t)
end

module Queue : QUEUE = struct
  type 'a t = ('a list * 'a list)

  let empty = ([], [])

  let is_empty = function
    | ([], []) -> true
    | (_, _)   -> false

  let enqueue x (pop, push) =
    (pop, x :: push)

  let rec dequeue = function
    | ([], [])      -> (None, empty)
    | (x::xs, push) -> (Some x, (xs, push))
    | ([], push)    -> dequeue (List.rev push, [])
end
