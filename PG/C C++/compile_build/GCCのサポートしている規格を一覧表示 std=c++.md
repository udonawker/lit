[GCCのサポートしている規格を一覧表示](https://qiita.com/koara-local/items/8c1c6acfc35646f43e3f)<br>

以下を実行すればよいかと思います。<br>
<pre>
$ g++ -v --help 2>/dev/null | grep -E "^\s+\-std=.*$"
</pre>

使用例<br>
<pre>
$ g++ --version
g++ (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ g++ -v --help 2>/dev/null | grep -E "^\s+\-std=.*$"
  -std=<standard>          Assume that the input sources are for <standard>
  -std=f2003                  Conform to the ISO Fortran 2003 standard
  -std=f2008                  Conform to the ISO Fortran 2008 standard
  -std=f2008ts                Conform to the ISO Fortran 2008 standard
  -std=f95                    Conform to the ISO Fortran 95 standard
  -std=gnu                    Conform to nothing in particular
  -std=legacy                 Accept extensions to support legacy code
  -std=c++03                  Conform to the ISO 1998 C++ standard revised by
  -std=c++0x                  Deprecated in favor of -std=c++11
  -std=c++11                  Conform to the ISO 2011 C++ standard
  -std=c++1y                  Conform to the ISO 201y(7?) C++ draft standard
  -std=c++98                  Conform to the ISO 1998 C++ standard revised by
  -std=c11                    Conform to the ISO 2011 C standard (experimental
  -std=c1x                    Deprecated in favor of -std=c11
  -std=c89                    Conform to the ISO 1990 C standard
  -std=c90                    Conform to the ISO 1990 C standard
  -std=c99                    Conform to the ISO 1999 C standard
  -std=c9x                    Deprecated in favor of -std=c99
  -std=gnu++03                Conform to the ISO 1998 C++ standard revised by
  -std=gnu++0x                Deprecated in favor of -std=gnu++11
  -std=gnu++11                Conform to the ISO 2011 C++ standard with GNU
  -std=gnu++1y                Conform to the ISO 201y(7?) C++ draft standard
  -std=gnu++98                Conform to the ISO 1998 C++ standard revised by
  -std=gnu11                  Conform to the ISO 2011 C standard with GNU
  -std=gnu1x                  Deprecated in favor of -std=gnu11
  -std=gnu89                  Conform to the ISO 1990 C standard with GNU
  -std=gnu90                  Conform to the ISO 1990 C standard with GNU
  -std=gnu99                  Conform to the ISO 1999 C standard with GNU
  -std=gnu9x                  Deprecated in favor of -std=gnu99
  -std=iso9899:1990           Conform to the ISO 1990 C standard
  -std=iso9899:199409         Conform to the ISO 1990 C standard as amended in
  -std=iso9899:1999           Conform to the ISO 1999 C standard
  -std=iso9899:199x           Deprecated in favor of -std=iso9899:1999
  -std=iso9899:2011           Conform to the ISO 2011 C standard (experimental
</pre>
