<pre>
#include &lt;fstream&gt;
#include &lt;iostream&gt;
#include &lt;sstream&gt;
#include &lt;vector&gt;

#include &lt;sys/stat.h&gt;

// g++ -o read_file_2_vector read_file_2_vector.cpp

std::vector&lt;std::uint8_t&gt; ReadFile2Vector(std::string fileName)
{
    std::ifstream ifs(fileName, std::ios::in | std::ios::binary);
    if (!ifs) {
        throw std::runtime_error("failed to open a file.");
    }

    auto size = ifs.seekg(0, std::ios::end).tellg();
    ifs.seekg(0, std::ios::beg);

    // ifs.seekg(0, std::ios::end);
    // auto eofpos = ifs.tellg();
    // ifs.clear();
    // ifs.seekg(0, std::ios::beg);
    // auto begpos = ifs.tellg();
    // auto size = eofpos - begpos;
    
    std::vector&lt;std::uint8_t&gt; buffer(size);
    ifs.read(reinterpret_cast&lt;char *&gt;(buffer.data()), size);
    
    return buffer;
}

std::vector&lt;std::uint8_t&gt; ReadFile2Vector2(std::string fileName)
{
    std::ifstream ifs(fileName, std::ios::in | std::ios::binary);
    if (!ifs) {
        throw std::runtime_error("failed to open a file.");
    }

    struct stat st{};
    
    if (stat(fileName.c_str(), &st) == -1) {
        throw std::runtime_error("failed to stat.");
    }
    
    std::vector&lt;std::uint8_t&gt; buffer(static_cast&lt;std::size_t&gt;(st.st_size));
    ifs.read(reinterpret_cast&lt;char *&gt;(buffer.data()), static_cast&lt;std::streamsize&gt;(st.st_size));
    
    return buffer;
}

std::stringstream ReadFile2SStream(std::string fileName)
{
    std::ifstream ifs(fileName, std::ios::in | std::ios::binary);
    if (!ifs) {
        throw std::runtime_error("failed to open a file.");
    }
    
    std::stringstream ss;
    ss << ifs.rdbuf();
    
    return ss;
}

int main(int argc, char* argv[])
{
    return 0;
}
</pre>
