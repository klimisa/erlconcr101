-module(t18).
-export([receiver/0,sender/1]).

receiver() ->
%%  timer:sleep(20000),
  receive
    X ->
      case X of
        stop -> io:format("stopped ~n");
        {first, FirstString} ->
          io:format("message ~w~n",[FirstString]),
          receiver();
        {second, SecondString} ->
          io:format("message ~w~n",[SecondString]),
          receiver()
      end
end.

sender(Pid) ->
  Pid ! {first, "FirstString"},
  Pid ! {second, "SecondString"},
  Pid ! {first, "ThirdString"}.