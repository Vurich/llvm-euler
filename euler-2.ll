@print.uint = private unnamed_addr constant [4 x i8] c"%u\0A\00"

declare i32 @printf(i8*, ...)
declare i64 @atol(i8*)

define i64 @sum-fibs-not-greater-than(i64 %not-greater-than) #0 {
  %cur = alloca i64
  store i64 1, i64* %cur

  %last = alloca i64
  store i64 1, i64* %last

  ; Start with the sum of %cur and %last
  %tot = alloca i64
  store i64 2, i64* %tot 

  br label %loop
loop:
  %loop.head.cur = load i64, i64* %cur
  %loop.head.cond = icmp ult i64 %loop.head.cur, %not-greater-than
  br i1 %loop.head.cond, label %loop.body, label %loop.cont
loop.body:
  %loop.body.last = load i64, i64* %last
  %loop.body.added = add i64 %loop.head.cur, %loop.body.last
  store i64 %loop.body.added, i64* %cur
  store i64 %loop.head.cur, i64* %last

  %loop.body.1-mask = and i64 %loop.body.added, 1
  %loop.body.should-add = icmp ne i64 %loop.body.1-mask, 0
  br i1 %loop.body.should-add,
    label %loop.body.if.then,
    label %loop.body.if.cont
loop.body.if.then:
  %loop.body.if.then.tot = load i64, i64* %tot
  %loop.body.if.then.new-tot = add i64 %loop.body.if.then.tot, %loop.body.added
  store i64 %loop.body.if.then.new-tot, i64* %tot
  br label %loop.body.if.cont
loop.body.if.cont:
  br label %loop
loop.cont:
  %final-val = load i64, i64* %tot
  ret i64 %final-val
}

define i32 @main(i32 %argc, i8** %argv) #0 {
  %get-max.cond = icmp ugt i32 %argc, 1
  br i1 %get-max.cond, label %get-max.then, label %get-max.else
get-max.then:
  %get-max.then.max-string.pointer =
    getelementptr inbounds i8*, i8** %argv, i32 1
  %get-max.then.max-string = load i8*, i8** %get-max.then.max-string.pointer
  %get-max.then.max = call i64 (i8*) @atol(i8* %get-max.then.max-string)
  br label %get-max.cont
get-max.else:
  br label %get-max.cont
get-max.cont:
  %not-greater-than = phi i64
    [ %get-max.then.max, %get-max.then ],
    [ 2000000, %get-max.else ]

  %sum = call i64 (i64) @sum-fibs-not-greater-than(i64 %not-greater-than)
  call i32 (i8*, ...) @printf(
    i8* getelementptr inbounds ([4 x i8], [4 x i8]* @print.uint, i32 0, i32 0),
    i64 %sum
  )

  ret i32 0
}

attributes #0 = {
  nounwind
}
