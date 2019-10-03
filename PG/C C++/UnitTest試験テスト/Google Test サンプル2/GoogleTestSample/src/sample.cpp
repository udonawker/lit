#include "sample.h"

int Sample::Add(int lhs, int rhs) const
{
    return lhs + rhs;
}

std::string Sample::GetString() const
{
    return std::string("Sample");
}

bool Sample::True() const
{
    return true;
}

bool Sample::False() const
{
    return false;
}
