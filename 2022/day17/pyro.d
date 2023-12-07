import std.stdio;
import std.algorithm;
import std.file : readText;
import std.conv;
import std.format;
import std.string;
import std.range;
import std.array;
import std.math;

void main(string[] args)
{
    auto input = readText(args[1]).strip;

    // each byte bits 0 ~ 6 are which pieces have been solidified.
    ubyte[] board; // element 0 is lowest row
    int top = 0;

    ubyte[][] shapes = [
        [0b11110000],
        [0b01000000,
         0b11100000,
         0b01000000],
        [0b11100000, // note this is inverse, because we define the bottom first
         0b00100000,
         0b00100000],
        [0b10000000,
         0b10000000,
         0b10000000,
         0b10000000],
        [0b11000000,
         0b11000000]
    ];

    auto gas = cycle(input);

    struct sim {
        size_t rock = 0;
        size_t offset = 0;
        size_t gasidx;
        ubyte[] board;
        bool fits(ubyte[] rockbits, int x, int y)
        {
            if(x < 0)
                return false;
            if(y < 0)
                return false;
            foreach(i, r; rockbits)
            {
                r >>= x;
                if(r & 1)
                    return false; // hit the right wall
                if(board.length > y + i)
                {
                    if(board[y + i] & r)
                        return false;
                }
            }
            return true;
        }

        void placerock()
        {
            auto r = shapes[rock % shapes.length];
            auto x = 2;
            auto y = cast(int)board.length + 3;
            while(true)
            {
                auto newx = x + (input[gasidx] == '<' ? -1 : 1);
                gasidx = (gasidx + 1) % input.length;
                if(fits(r, newx, y))
                    x = newx;
                if(!fits(r, x, y-1))
                    break;
                --y;
            }

            //writefln("placed rock %s: (%s, %s)", rock, x, y);
            // rock is placed
            foreach(i, rp; r)
            {
                if(y + i >= board.length)
                    board.length = y + i + 1;
                board[y + i] |= rp >> x;
            }

            // fill in all bits that can no longer be filled in
            uint mask = 0xff;
            foreach_reverse(ref m; board)
            {
                mask &= ~(m | 1) & 0xff;
                mask |= (mask << 1) | (mask >> 1);
                mask &= ~(m | 1) & 0xff; // remove all bits already set
                m |= cast(ubyte)~mask;
            }

            while(board.length && board[0] == 0xff)
            {
                board.popFront;
                ++offset;
            }
            ++rock;
        }

        void printboard()
        {
            foreach_reverse(m; board)
            {
                foreach(xp; 0 .. 7)
                {
                    write((m & (1 << (7 - xp))) ? '#' : '.');
                }
                writeln();
            }
        }

        bool opEquals(ref sim other)
        {
            return rock % shapes.length == other.rock % shapes.length && other.gasidx == gasidx && other.board == board;
        }
    }

    sim sim1;
    foreach(rock; 0 .. 2022)
    {
        sim1.placerock;
        /*if(sim1.rock < 5)
            sim1.printboard();*/
    }
    writeln("part1: ", sim1.board.length + sim1.offset);

    // tortoise and hare
    sim sim2;
    sim1 = sim();
    while(true)
    {
        sim1.placerock();
        sim2.placerock;
        sim2.placerock;
        if(sim1 == sim2)
            break;
    }
    // found the loop, now we have to scale
    auto loopsize = sim2.rock - sim1.rock;
    auto loops = (1_000_000_000_000 - sim2.rock) / loopsize;
    sim2.offset += loops * (sim2.offset - sim1.offset);
    sim2.rock += loops * loopsize;
    while(sim2.rock != 1_000_000_000_000)
    {
        sim2.placerock;
    }
    writeln("part2: ", sim2.board.length + sim2.offset);
}
