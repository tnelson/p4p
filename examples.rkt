#lang s-exp "p4p.rkt"

defvar: this-better-be-6 = +(1, 2, 3)
defvar: this-better-be-0 = +()
;; This will produce a run-time error: /()

deffun: five() = 5
deffun: six(x) = 6
deffun: iden(x) = x
deffun: dbl(x) = +(x, x)
deffun: trpl(x) = +(x, x, x)

deffun: f (x) = 
  +(dbl(dbl(x)), 
    dbl(x))

defvar: id =
  fun: (x) in: x

deffun: fact (n) =
  if: zero?(n)
        1
  else:
        *(n, fact(-(n, 1)))

defvar: v = id(fact(10))

defstruct: memo (key, ans)

deffun: memoize (f) =
  defvar: memo-table = box(empty)
  fun: args in:
    defvar: lookup =
      filter(fun: (v) in:
                equal?(args, memo-key(v)),
             unbox(memo-table))
    if: empty?(lookup)
        do: {
            set-box!(memo-table,
                     cons (make-memo (args, apply(f, args)), unbox(memo-table)))
            apply(f, args)
        }
    else:
          memo-ans(first(lookup))

deffun: fib(n) =
  if: =(n, 0) 
    1
  elif: =(n, 1)
        1
  else:
        +(fib(sub1(n)), fib(-(n, 2)))

defvar: mfib =
  memoize(
    fun: (n) in:
      if: =(n, 0)
           1
      elif: =(n, 1)
           1
      else:
           +(fib(sub1(n)), fib(-(n, 2))))

;; If the function position is a non-identifier expression, wrap it in parens.
defvar: this-better-be-9 = {fun: (n) in: *(n, n)}(3)

deffun: andalso (a, b) = if: a b else: false

defvar: levenshtein =
  memoize (
    fun: (s, t) in:
      if: andalso(empty?(s), empty?(t))
        0
      elif: empty?(s)
        length(t)
      elif: empty?(t)
        length(s)
      else:
        if: equal?(first(s), first(t))
          levenshtein(rest(s), rest(t))
        else:
          min(add1(levenshtein(rest(s), t)),
              add1(levenshtein(s, rest(t))),
              add1(levenshtein(rest(s), rest(t)))
           )
   )
    
=(levenshtein(string->list("kitten"), string->list("sitting")), 3)
=(levenshtein(string->list("gumbo"), string->list("gambol")), 2)
=(levenshtein(string->list("acgtacgtacgt"), string->list("acatacttgtact")), 4)

deffun: g(a, b, c) = +(a, b, c)
=(g(1,2,3), 6)

deffun: h args = args
defvar: k =
  fun: args in: args
defvar: p =
  fun: (a, b) in: +(a, b)
equal?(k(), empty)
equal?(k(1, 2), list(1, 2))
=(p(1, 2), 3)

levenshtein
k
k()

;; d/dx : (R -> R) -> (R -> R)
deffun: d/dx(f) =
  defvar: delta = 0.001
  fun: (x) in:
    /(-(f(+(x, delta)),
        f(x)),
      delta)

defvar: d/dx-of-square = d/dx(fun: (x) in: *(x,x))
=(round(d/dx-of-square(10)), 20.0)
=(round(d/dx-of-square(25)), 50.0)

+(1,
    -(2,
      3,
      5),
  +(4,5))

defstruct: frob (a, 
  b)

fun: (x) in:
  if: false
    1
  else: 2
  
+(1, 2,
  dbl(4),
  dbl(dbl(8)))

first(list("a", "b"))

deffun: len(l) =
  if: empty?(l)
    0
  else:
    add1(len(rest(l)))
    
length(list(1,2,3))

defstruct: pt 
 (x,
  y)
make-pt(1, 2)

deffun: mymap(f, l) =
  if: empty?(l)
    empty
  else:
    cons(f(first(l)), mymap(f, rest(l)))

mymap(add1, list(1, 2, 3))

defvar: l = list(1,2,3)

let:
  x = 3,
  y = 2
 in:
  +(x, y)
  
let*: x = 3, y = x in: +(x, y)

letrec: even = ;; perversely written as a one-liner
               fun: (n) in: if: zero?(n) true else: odd?(sub1(n)),
        odd = fun: (n) in:
                if: zero?(n)
                  false
                else:
                  odd?(sub1(n))
 in: list(odd?(10), even?(10))