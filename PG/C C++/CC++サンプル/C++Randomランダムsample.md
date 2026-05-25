
```
class CRamdomGEnerator {
private:
    std::random_device seed_gen_;
    std::default_random_engine engine_;
    std::uniform_int_distribution<> distribution_;

public:
    CRandomGenerator()
    : seed_gen_()
    , engine_(seed_gen_())
    , distribution_(0x00, std::numeric_limits<uint8_t>::max())
    {}

    inline uint8_t get_random()
    {
        return distribution_(engine_);
    }
};
