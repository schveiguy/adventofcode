import std.stdio;
import std.file : readText;
import std.algorithm;
import std.range;
import std.conv;

int main(string[] args)
{
	if(args.length < 3)
	{
		stderr.writefln("usage: %s numwindow depthsfile", args[0]);
		return 1;
	}
	auto ndepths = args[1].to!int;
	auto input = readText(args[2]);
	int increasing = 0;
	auto d = input.splitter.map!(v => v.to!int);
	auto d2 = d.save;
	if(d.popFrontN(ndepths) < ndepths)
	{
		writeln("no windows!");
		return 1;
	}
	while(!d.empty)
	{
		increasing += d.front > d2.front;
		d.popFront;
		d2.popFront;
	}
	writeln(increasing);
	return 0;
}
