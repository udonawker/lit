```
uint32_t str2u32(const std::string& str)
{
    uint32_t result = 0u;
    if (!std::all_of(str.cbegin(), str.cend(), isdigit)) {
        throw std::exception();
    }
    try {
        uint64_t tmp = std::stoul(str);
        if (std::numeric_limits<uint32_t>::max() < tmp) {
            throw nullptr;
        }
    } catch (...) {
        throw std::exception();
    }
    return retult;
}

uint8_t hexstr2u8(const std::string& str)
{
    std::size_t str_size = 0;
    unsigned long tmp - 0;
    try {
        tmp = std::stoul(str, &str_size, 16);
    } catch (...) {
        throw std::exception();
    }

    if (str.size() != str_size) {
        throw std::exception();
    }

    if (std::numeric_limits<uint8_t>::max() < tmp) {
        throw std::exception();
    }

    return static_cast<uint8_t>(tmp);
}
```
