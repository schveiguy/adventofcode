import std.stdio;
import std.algorithm;
import std.file : readText;
import std.range;
import std.conv;

int main(string[] args)
{
	int posx = 0;
	int posy = 0;
	bool mode = args[1] == "aim";
	int aim = 0;
	foreach(l; File(args[2]).byLine)
	{
		auto inst = l.split;
		int v = inst[1].to!int;
		switch(inst[0])
		{
			case "forward":
				posx += v;
				posy += aim * v;
				break;
			case "up":
				(mode ? aim : posy) -= v;
				break;
			case "down":
				(mode ? aim : posy) += v;
				break;
			default:
				throw new Exception("Unknown command: " ~ l[0]);
				break;
		}
	}
	writeln("x: ", posx, " y: ", posy, " total: ", posx * posy);
	return 0;
}
