<pre>
template &lt;typename _Tp, typename... Args&gt;
std::unique_ptr<_Tp> make_unique(Args&&... args)
{
    return std::unique_ptr<_Tp>(new _Tp(std::forward<Args>(args)...));
}
</pre>
