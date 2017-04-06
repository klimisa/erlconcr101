-module(t15).
-export([server/1,server/0,client/1,server1/0,server2/0]).

rem_punct(String) -> lists:filter(fun (Ch) ->
  not(lists:member(Ch,"\"\'\t\n "))
                                  end,
  String).

to_small(String) -> lists:map(fun(Ch) ->
  case ($A =< Ch andalso Ch =< $Z) of
    true -> Ch+32;
    false -> Ch
  end
                              end,
  String).

palindrome_check(String) ->
  Normalise = to_small(rem_punct(String)),
  lists:reverse(Normalise) == Normalise.

palindrome_checker(String) ->
  case palindrome_check(String) of
    true -> String ++ " " ++ "is a palindrome";
    false -> String ++ " " ++ "is not a palindrome"
end.

server(Pid) ->
  receive
    {check, String} ->
        Pid ! {result, palindrome_checker(String)},
      server(Pid);
    _ -> io:format("stopped")
  end.

server() ->
  receive
    {Pid, Msg} ->
      Pid ! {result, Msg},
      server();
    _ -> io:format("Server Stopped!")
  end.

client(Server) ->
  receive
    {send, Msg} ->
      Server ! Msg,
      client(Server);
    {result, Msg} ->
      io:format("Msg: ~s~n",[Msg]),
      client(Server);
    _ -> io:format("Client Stopped!")
  end.

server1() ->
  receive
    stop -> io:format("Server1 Stopped!");
    Msg ->
      io:format("Server1: ~s~n", [Msg]),
      server()
  end.


server2() ->
  receive
    stop -> io:format("Server2 Stopped!");
    Msg ->
      io:format("Server2: ~s~n", [Msg]),
      server()
  end.