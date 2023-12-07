import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;
import std.string;
import std.format;
import std.ascii;

enum Rank {
    highcard,
    onepair,
    twopair,
    threeofakind,
    fullhouse,
    fourofakind,
    fiveofakind
}

Rank getRank(string hand, bool jokers)
{
    int[char] ranks;
    foreach(c; hand)
        ++ranks[c];
    int jokercount;
    if(jokers)
    {
        jokercount = ranks.get('J', 0);
        ranks.remove('J');
    }
    Rank result;
    if(ranks.byValue.canFind(5))
        result = Rank.fiveofakind;
    else if(ranks.byValue.canFind(4))
        result = Rank.fourofakind;
    else if(ranks.byValue.canFind(3))
    {
        if(ranks.byValue.canFind(2))
            result = Rank.fullhouse;
        else
            result = Rank.threeofakind;
    }
    else if(ranks.byValue.count(2) > 1)
        result = Rank.twopair;
    else if(ranks.byValue.canFind(2))
        result = Rank.onepair;
    else
        result = Rank.highcard;

    if(jokers)
    {
        // take into account jokers
        with(Rank) switch(result)
        {
            case highcard:
                switch(jokercount) {
                    case 1:
                        result = onepair;
                        break;
                    case 2:
                        result = threeofakind;
                        break;
                    case 3:
                        result = fourofakind;
                        break;
                    case 4:
                    case 5:
                        result = fiveofakind;
                        break;
                    default:
                        // no jokers
                        break;
                }
                break;
            case onepair:
                switch(jokercount) {
                    case 1:
                        result = threeofakind;
                        break;
                    case 2:
                        result = fourofakind;
                        break;
                    case 3:
                        result = fiveofakind;
                        break;
                    default:
                        // no jokers
                        break;
                }
                break;
            case twopair:
                if(jokercount == 1)
                    result = fullhouse;
                break;
            case threeofakind:
                if(jokercount == 1)
                    result = fourofakind;
                else if(jokercount == 2)
                    result = fiveofakind;
                break;
            case fourofakind:
                if(jokercount == 1)
                    result = fiveofakind;
                break;
            default:
                // no jokers possible for fullhouse or fiveofakind
                break;
        }
    }
    return result;
}

int getCV(char c, bool jokers)
{
    switch(c)
    {
        case '2': .. case '9':
            return c - '0';
        case 'T':
            return 10;
        case 'J':
            return jokers ? 1 : 11;
        case 'Q':
            return 12;
        case 'K':
            return 13;
        case 'A':
            return 14;
        default:
            assert(false);
    }
}

bool comparehands(string s1, string s2, bool jokers)
{
    auto r1 = getRank(s1, jokers);
    auto r2 = getRank(s2, jokers);
    if(r1 == r2)
    {
        foreach(i; 0 .. 5)
        {
            auto cv1 = getCV(s1[i], jokers);
            auto cv2 = getCV(s2[i], jokers);
            if(cv1 < cv2)
                return true;
            else if(cv2 < cv1)
                return false;
        }
        return false;
    }
    return r1 < r2;
}

struct Hand
{
    string cards;
    int bid;
}

void main(string[] args)
{
    auto input = readText(args[1]).splitter('\n').filter!(v => !v.empty).array;
    Hand[] hands;
    foreach(h; input)
    {
        auto v = h.split;
        hands ~= Hand(v[0], v[1].to!int);
    }
    hands.sort!((h1, h2) => comparehands(h1.cards, h2.cards, false));
    //writeln(hands);
    int total;
    foreach(i, h; hands)
        total += h.bid * (i + 1);
    writeln(total);

    // part2 with jokers
    hands.sort!((h1, h2) => comparehands(h1.cards, h2.cards, true));
    //writeln(hands);
    total = 0;
    foreach(i, h; hands)
        total += h.bid * (i + 1);
    writeln(total);

}
