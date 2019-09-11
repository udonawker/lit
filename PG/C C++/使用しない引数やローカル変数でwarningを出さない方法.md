
<pre>
{
    int v = 0;
    static_cast<void>(v);
}
</pre>

<pre>
void foo(int v)
{
    static_cast<void>(v);
}
</pre>

<pre>
template <class T>
void UNUSE(T v)
{
    static_cast<void>(v);
    return;
}

void foo(int v)
{
    UNUSE(v);
}
</pre>
