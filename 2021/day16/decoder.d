import std.stdio;
import std.file : readText;
import std.algorithm;
import std.string;
import std.conv;
import std.range;
import std.array : array;
import std.format;
struct bitrange
{
    this(string input)
    {
        this.data = input;
        popFront;
    }
    int pos; // 0-3
    int bits;
    string data;
    int front() { return (bits >> pos) & 1; }
    bool empty() { return pos == -1; }
    void popFront()
    {
        assert(!empty, "pop from empty");
        if(--pos == -1)
        {
            if(data.length == 0) return;
            char nv = data[0];
            data = data[1 .. $];
            pos = 3;
            switch(nv)
            {
            case '0': .. case '9':
                bits = nv - '0';
                break;
            case 'A': .. case 'F':
                bits = nv - 'A' + 10;
                break;
            default:
                assert(0, "invalid hex char: " ~ nv);
            }
        }
    }

    size_t length() {
        return data.length * 4 + (pos + 1);
    }

    long get(size_t nbits)
    {
        if(nbits == 0) return 0;
        long result;
        while(nbits--)
        {
            result = result << 1 | front;
            popFront;
        }
        return result;
    }
}

void main(string[] args)
{
    auto input = bitrange(args[1]);
    long p1 = 0;
    long processPacket()
    {
        auto v = input.get(3);
        p1 += v;
        auto t = input.get(3);
        if(t == 4) // literal
        {
            long literal;
            while(true)
            {
                auto flag = input.get(1);
                literal = (literal << 4) + input.get(4);
                if(!flag) break;
            }
            // literal now contains the literal
            writeln("read literal ", literal);
            return literal;
        }
        else
        {
            // operator
            auto flag = input.get(1);
            long[] result;
            if(flag)
            {
                auto npackets = input.get(11);
                foreach(n; 0 .. npackets)
                {
                    result ~= processPacket();
                }
                writeln("finished subgroup of ", npackets, " packets");
            }
            else
            {
                auto nbits = input.get(15);
                auto target = input.length - nbits;
                while(input.length > target)
                {
                    result ~= processPacket();
                }
                assert(input.length == target, format("inconsistent packet! expected %s from %s got %s", target, nbits, input.length));
                writeln("finished subgroup of ", nbits, " bits");
            }
            final switch(t)
            {
            case 0:
                return result.sum;
            case 1:
                return result.fold!((a, b) => a * b);
            case 2:
                return result.fold!((a, b) => min(a, b));
            case 3:
                return result.fold!((a, b) => max(a, b));
            case 5:
                return result[0] > result[1];
            case 6:
                return result[0] < result[1];
            case 7:
                return result[0] == result[1];
            }
        }
    }

    auto p2 = processPacket();
    writeln("part1: ", p1);
    writeln("part2: ", p2);
}
