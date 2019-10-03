[参照](https://stackoverflow.com/questions/14401528/google-test-gtest-assert-predx-and-class-member-functions) <https://stackoverflow.com/questions/14401528/google-test-gtest-assert-predx-and-class-member-functions) <br/>

## Question

Ok, so I'm using gtest for unit testing, and I've got something I want to do: <br/>

<pre>
class A {
    /* Private members */
public:
    bool function_to_test(int index);
}
</pre>
In the test function, I'd like to use: <br/>

<pre>
A testEntity;
const int b = 40;
ASSERT_PRED1(testEntity.function_to_test, b);
</pre>

This doesn't work as ASSERT_PREDx seems to be designed for global scope functions. I get a message on the lines of <br/>

<pre>
argument of type ‘bool (A::)(int) {aka bool (A::)(int)}’ does not match ‘bool (A::*)(int)’
</pre>

## Anser

The first argument to ASSERT_PRED1(pred1, val1); should be a callable object; a unary-function or functor. <br/>
For example, if you can use C++11 lambdas, you could do: <br/>

<pre>
ASSERT_PRED1([&testEntity](int i) { return testEntity.function_to_test(i); }, b);
</pre>

Or if you want to use a unary function helper: <br/>

<pre>
struct TesterA : public std::unary_function <int, bool> {
  explicit TesterA(A& a) : a_(a) {}
  bool operator()(int i) { return a_.function_to_test(i); }
  A& a_;
};

ASSERT_PRED1(TesterA(testEntity), b);
</pre>
