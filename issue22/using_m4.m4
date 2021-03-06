<!-- -*- html -*- -->

m4_include(stdlib.m4)

<!-- Copyright (C) 1997 Bob Hepple

This is an example of the use of m4 to pre-process HTML
code. Using the FSF version of m4, you generate HTML from
this file with:

	m4 -P using_m4.m4 >using_m4.html

Please don't be put off by the use of nested quotation marks
in the code examples. This sample is rather an extreme
stress-test of the idea. Normal usage is much simpler.

This program is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public
License along with this program; if not, write to the Free
Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
02139, USA. -->

_HEADER(Mechanical Web Authoring - using _EM(m4) to write HTML.)
<P>
_HEAD1(Contents:)

_Start_TOC

<P><HR><SMALL><CENTER>This page last updated on m4_esyscmd(date)<BR>
$Revision: 1.1.1.1 $</CENTER></SMALL><HR><P>
_H1(`Some limitations of HTML')

It's amazing how easy it is to write simple HTML pages - and
the availability of _EM(WYSIWYG) HTML editors like
_EM(NETSCAPE GOLD) lulls one into a mood of _EM(`"don''`t
worry, be happy"'). However, managing multiple,
interrelated pages of HTML rapidly gets very, very
difficult.  I recently had a slightly complex set of pages
to put together and it started me thinking - _EM(`"there has
to be an easier way"').

<P>

I immediately turned to the WWW and looked up all sorts of
tools - but quite honestly I was rather disappointed. Mostly,
they were what I would call _EM(Typing Aids) - instead of
having to remember arcane incantations like _CODE(&lt;a
href="link"&gt;text&lt;/a&gt;), you are given a button or a
magic keychord like ALT-CTRL-j which remembers the syntax and
does all that nasty typing for you.  

<P>

_EM(Linux) to the rescue! HTML is built as ordinary text
files and therefore the normal _EM(Linux) text management
tools can be used. This includes the revision control tools
such as _EM(RCS) and the text manipulation tools like
_EM(`awk, perl, etc.') These offer significant help in
version control and managing development by multiple users
as well as in automating the process of extracting from a
database and displaying the results (the classic _CODE(`"grep
|sort |awk"') pipeline).

<P>

The use of these tools with HTML is documented elsewhere,
e.g. see Jim Weinrich's article in _EM(Linux Journal) Issue
36, April 1997, "Using Perl to Check Web Links" which I'd
highly recommend as yet another way to really flex those
_EM(Linux) muscles when writing HTML.

<P>

What I will cover here is a little work I've done recently
with using _EM(m4) in maintaining HTML. The ideas can
probably be extended to the more general SGML case very
easily.

<P>
_LINK_TO_LABEL(Contents)
<P>
_H1(`Using _EM(m4)')

I decided to use _EM(m4) after looking at various other
pre-processors including _EM(cpp), the _EM(C)
front-end. While _EM(cpp) is perhaps a little too
_EM(C)-specific to be very useful with HTML, _EM(m4) is a
very generic and clean macro expansion program - and it's
available under most Unices including _EM(Linux).

<P>

Instead of editing _EM(*.html) files, I create
_EM(*.m4) files with my favourite text editor.
These look something like this:

<P>
_CODEQUOTE(``m4_include(stdlib.m4)
_HEADER(`This is my header')
&lt;P>This is some plain text&lt;P>
_HEAD1(`This is a main heading')
&lt;P>This is some more plain text&lt;P>
_TRAILER'')

<P>

The `format' is simple - just HTML code but you can now
`include' files and add macros rather like in _EM(C). I use
a convention that my new macros are in capitals and start
with "_" to make them stand out from HTML language and to
avoid name-space collisions.

<P>

The _EM(m4) file is then processed as follows to create an
_EM(.html) file e.g.

<P>
_CODEQUOTE(m4 -P &lt;file.m4 &gt;file.html)
<P>

This is especially easy if you create a "makefile" to
automate this in the usual way. Something like:

<P>
_CODEQUOTE(.SUFFIXES: .m4 .html
.m4.html:
	m4 -P $*.m4 >$*.html
default: index.html
*.html: stdlib.m4
all: default PROJECT1 PROJECT2
PROJECT1:
	(cd project2; make all)
PROJECT2:
	(cd project2; make all))
<P>

The most useful commands in _EM(m4) include the following
which are very similar to the _EM(cpp) equivalents (shown in
brackets):

<DL>
<DT>_CODE(``m4_include''):
<DD>includes a common file into your HTML (_CODE(`#include'))
<DT>_CODE(``m4_define''):
<DD>defines an _EM(m4) variable (_CODE(`#define'))
<DT>_CODE(``m4_ifdef''):
<DD>a conditional (_CODE(`#ifdef'))
</DL>

<P>

Some other commands which are useful are:

<DL>
<DT>_CODE(``m4_changecom''):
<DD>change the _EM(m4) comment character (normally #)
<DT>_CODE(``m4_debugmode''):
<DD>control error disgnostics
<DT>_CODE(``m4_traceon/off''):
<DD>turn tracing on and off
<DT>_CODE(``m4_dnl''):
<DD>comment
<DT>_CODE(``m4_incr, m4_decr''):
<DD>simple arithmetic
<DT>_CODE(``m4_eval''):
<DD>more general arithmetic
<DT>_CODE(``m4_esyscmd''):
<DD>execute a _EM(Linux) command and use the output
<DT>_CODE(``m4_divert(i)''):

<DD>This is a little complicated, so skip on first reading. It is a
way of storing text for output at the end of normal processing - it
will come in useful later, when we get to automatic numbering of
headings. It sends output from _EM(m4) to a temporary file number
_EM(i). At the end of processing, any text which was diverted is then
output, in the order of the file number _EM(i). File number -1 is the
bit bucket and can be used to comment out chunks of comments. File
number 0 is the normal output stream. Thus, for example, you can
_CODE(``m4_divert'') text to file 1 and it will only be output at the end.

</DL>

<P>

_LINK_TO_LABEL(Contents)
<P>

_H1(`Examples of _EM(m4) macros')
_H2(`Sharing HTML elements across several page')
<P>

In many "nests" of HTML pages, each page shares elements
such as a button bar like this:

<P>
<BLOCKQUOTE>_LINK(nil,[Home]) _LINK(nil,[Next]) _LINK(nil,[Prev]) _LINK(nil,[Index])</BLOCKQUOTE>
<P>

This is fairly easy to create in each page - the trouble is
that if you make a change in the "standard" button-bar then
you then have the tedious job of finding each occurance of
it in every file and then manually make the changes. 

<P>

With _EM(m4) we can more easily do this by putting the
shared elements into an _CODE(m4_include) statement, just like
_EM(C).

<P>

While I'm at it, I might as well also automate the naming of
pages, perhaps by putting the following into an `include'
file, say _CODE("button_bar.m4"):

<P>
_CODEQUOTE(``m4_define(`_BUTTON_BAR', 
	&lt;a href="homepage.html">[Home]&lt;/a>
	&lt;a href="$1">[Next]&lt;/a>
	&lt;a href="$2">[Prev]&lt;/a>
	&lt;a href="indexpage.html">[Index]&lt;/a>)'')
<P>

and then in the document itself:

<P>
_CODEQUOTE(``m4_include button_bar.m4
_BUTTON_BAR(`page_after_this.html', 
	`page_before_this.html')'')

<P>

The $1 and $2 parameters in the macro definition are
replaced by the strings in the macro call.

<P>
_LINK_TO_LABEL(Contents)

<P>

_H2(`Managing HTML elements that often change')

<P>

It is very troublesome to have items change in multiple HTML
pages. For example, if your email address changes then you
will need to change all references to the new
address. Instead, with _EM(m4) you can do something like
this in your _CODE(stdlib.m4) file:

<P>
_CODEQUOTE(``m4_define(`_EMAIL_ADDRESS', `MyName@foo.bar.com')'')
<P>

and then just put _CODE(``_EMAIL_ADDRESS'') in your
_EM(m4) files. 

<P>

A more substantial example comes from building strings up
with multiple components, any of which may change as the
page is developed. If, like me, you develop on one machine,
test out the page and then upload to another machine with a
totally different address then you could use the
_CODE(m4_ifdef) command in your _CODE(stdlib.m4) file (just
like the _CODE(#ifdef) command in _EM(cpp)):

<P>

_CODEQUOTE(``m4_define(`_LOCAL')
.
.
m4_define(`_HOMEPAGE', 
	m4_ifdef(`_LOCAL', `//127.0.0.1/~YourAccount', 
		`http://ISP.com/~YourAccount'))

m4_define(`_PLUG', `&lt;A REF="http://www.ssc.com/linux/">
	&lt;IMG SRC="_HOMEPAGE/gif/powered.gif" 
	ALT="[Linux Information]"> &lt;/A>')'')

<P>

Note the careful use of quotes to prevent the variable
_CODE(``_LOCAL'') from being expanded. _CODE(``_HOMEPAGE'')
takes on different values according to whether the variable
_CODE(``_LOCAL'') is defined or not. This can then ripple
through the entire project as you _EM(make) the pages.

<P>

In this example, _CODE(``_PLUG'') is a macro to advertise
_EM(Linux).  When you are testing your pages, you use the
local version of _CODE(``_HOMEPAGE''). When you are ready to
upload, you can remove or comment out the _CODE(``_LOCAL'')
definition like this:

<P>

_CODEQUOTE(``m4_dnl m4_define(`_LOCAL')'')

<P>

... and then _EM(re-make).

<P>
_LINK_TO_LABEL(Contents)

<P>
_H2(`Creating new text styles')

Styles built into HTML include things like _CODE(&lt;EM>) for emphasis and _CODE(&lt;CITE>) for citations. With _EM(m4) you can define your own, new styles like this:

<P>
_CODEQUOTE(``m4_define(`_MYQUOTE',
	&lt;BLOCKQUOTE>&lt;EM>$1&lt;/EM>&lt;/BLOCKQUOTE>)'')
<P>

If, later, you decide you prefer _CODE(&lt;STRONG>) instead
of _CODE(&lt;EM>) it is a simple matter to change the
definition and then every _CODE(_MYQUOTE) paragraph falls
into line with a quick _CODE(make).

<P>

The classic guides to good HTML writing say things like "It
is strongly recommended that you employ the logical styles
such as _CODE(&lt;EM>...&lt;/EM>) rather than the physical
styles such as _CODE(&lt;I>...&lt;/I>) in your documents."
Curiously, the _EM(WYSIWYG) editors for HTML generate purely
physical styles. Using these _EM(m4) styles may be a good
way to keep on using logical styles.

<P>
_LINK_TO_LABEL(Contents)
<P>

_H2(`Typing and mnemonic aids')
<P>

I don't depend on _EM(WYSIWYG) editing (having been brought
up on _EM(troff)) but all the same I'm not averse to using
help where it's available. There is a choice (and maybe it's
a fine line) to be made between:

<P>
_CODEQUOTE(&lt;BLOCKQUOTE>&lt;PRE>&lt;CODE>Some code you want to display.
&lt;/CODE>&lt;/PRE>&lt;/BLOCKQUOTE>)
<P>
and:
<P>

_CODEQUOTE(``_CODE(Some code you want to display.)'')
<P>

In this case, you would `define' _CODE(``_CODE'') like this:

<P>
_CODEQUOTE(``m4_define(`_CODE',
	 &lt;BLOCKQUOTE>&lt;PRE>&lt;CODE>$1&lt;/CODE>&lt;/PRE>&lt;/BLOCKQUOTE>)'')<P>

Which version you prefer is a matter of taste and convenience
although the _EM(m4) macro certainly saves some typing and
ensures that HTML codes are not interleaved. Another example
I like to use (I can never remember the syntax for links) is:

<P>
_CODEQUOTE(``m4_define(`_LINK', &lt;a href="$1">$2&lt;/a>)'')

<P>

Then, <P>

_CODE(&lt;a href="URL_TO_SOMEWHERE">Click here to get to SOMEWHERE &lt;/a>) <P>

becomes: <P>

_CODE(``_LINK(`URL_TO_SOMEWHERE', `Click here to get to SOMEWHERE')'')

<P>
_LINK_TO_LABEL(Contents)
<P>

_H2(`Automatic numbering')
<P>

_EM(m4) has a simple arithmetic facility with two operators
_CODE(m4_incr) and _CODE(m4_decr) which act as you might
expect - this can be used to create automatic numbering,
perhaps for headings, e.g.:

_CODEQUOTE(``m4_define(_CARDINAL,0)

m4_define(_H, `m4_define(`_CARDINAL',
	m4_incr(_CARDINAL))&lt;H2>_CARDINAL.0 $1&lt;/H2>')

_H(First Heading)
_H(Second Heading)'')

<P>

This produces:

_CODEQUOTE(``&lt;H2>1.0 First Heading&lt;/H2>
&lt;H2>2.0 Second Heading&lt;/H2>'')

<P>
_LINK_TO_LABEL(Contents)
<P>

_H2(`Automatic date stamping')

For simple, datestamping of HTML pages I use the
_CODE(`m4_esyscmd') command to maintain an automatic
timestamp on every page:

<P>
_CODEQUOTE(``This page was updated on m4_esyscmd(date)'')
<P>

which produces:

<P>
This page was last updated on Fri May  9 10:35:03 HKT 1997
<P>

Of course, you could also use the date, revision and other
facilities of revision control systems like _EM(RCS) or
_EM(SCCS), e.g. _CODE(`$Da'`te$').

<P>
_LINK_TO_LABEL(Contents)
<P>

_H2(`Generating Tables of Contents')
<P>

Using _EM(m4) allows you to `define' commonly repeated
phrases and use them consistently - I hate repeating myself
because I am lazy and because I make mistakes, so I find
this feature absolutely key.

<P>

A good example of the power of _EM(m4) is in building a
table of contents in a big page (like this one). This
involves repeating the heading title in the table of
contents and then in the text itself. This is tedious and
error-prone especially when you change the titles. There are
specialised tools for generating tables of contents from
HTML pages but the simple facility provided by _EM(m4) is
irresistable to me. 

<P>
_H3(`Simple to understand TOC')
<P>

The following example is a fairly simple-minded Table of
Contents generator. First, create some useful macros in
_CODE(stdlib.m4):

<P>
_CODEQUOTE(``m4_define(`_LINK_TO_LABEL', &lt;A HREF="#$1">$1&lt;/A>)
m4_define(`_SECTION_HEADER', &lt;A NAME="$1">&lt;H2>$1&lt;/H2>&lt;/A>)'')
<P>

Then `define' all the section headings in a table at the
start of the page body:

<P>
_CODEQUOTE(``m4_define(`_DIFFICULTIES', `The difficulties of HTML')
m4_define(`_USING_M4', `Using &lt;EM>m4&lt;/EM>')
m4_define(`_SHARING', `Sharing HTML Elements Across Several Pages')'')
<P>
Then build the table:

<P>
_CODEQUOTE(``&lt;UL>&lt;P>
	&lt;LI> _LINK_TO_LABEL(_DIFFICULTIES)
	&lt;LI> _LINK_TO_LABEL(_USING_M4)
	&lt;LI> _LINK_TO_LABEL(_SHARING)
&lt;UL>'')
<P>
Finally, write the text:
<P>
_CODEQUOTE(``.
.
_SECTION_HEADER(_DIFFICULTIES)
.
.'')
<P>

The advantages of this approach are that if you change
your headings you only need to change them in one place
and the table of contents is automatically regenerated;
also the links are guaranteed to work.

<P>

Hopefully, that simple version was fairly easy to understand.

<P>
_LINK_TO_LABEL(Contents)

<P>
_H3(`Simple to use TOC')
<P>

The Table of Contents generator that I normally use is a bit
more complex and will require a little more study, but is
much easier to use. It not only builds the Table, but it
also automatically numbers the headings on the fly - up to 4
levels of numbering (e.g. section 3.2.1.3 - although this
can be easily extended). It is very simple to use as
follows:

<P>
<OL>
<LI>Where you want the table to appear, call _CODE(``Start_TOC'')
<LI>at every heading use _CODE(``_H1(`Heading for level 1')'') or _CODE(``_H2(`Heading for level 2')'') as appropriate.
<LI>After the very last HTML code (probably after &lt;/HTML>), call _CODE(``End_TOC'')
<LI> and that's all!
</OL>
<P>

The code for these macros is a little complex, so hold your breath:

_CODEQUOTE(``m4_define(_Start_TOC,`&lt;UL>&lt;P>m4_divert(-1)
  m4_define(`_H1_num',0)
  m4_define(`_H2_num',0)
  m4_define(`_H3_num',0)
  m4_define(`_H4_num',0)
  m4_divert(1)')

m4_define(_H1, `m4_divert(-1)
  m4_define(`_H1_num',m4_incr(_H1_num))
  m4_define(`_H2_num',0)
  m4_define(`_H3_num',0)
  m4_define(`_H4_num',0)
  m4_define(`_TOC_label',`_H1_num. $1')
  m4_divert(0)&lt;LI>&lt;A HREF="#_TOC_label">_TOC_label&lt;/A>
  m4_divert(1)&lt;A NAME="_TOC_label">
	&lt;H2>_TOC_label&lt;/H2>&lt;/A>')
.
.
[definitions for _H2, _H3 and _H4 are similar and are 
in the downloadable version of stdlib.m4]
.
.

m4_define(_End_TOC,`m4_divert(0)&lt;/UL>&lt;P>')'')

<P>

This works by using the _CODE(``m4_divert(1)'') command in
_CODE(``_Start_TOC'') to send all the remaining text from the file to
an (internal) temporary file - _EM(m4) just calls it "file 1".

<P>

From then on, whenever an _CODE(``_H1'') or _CODE(``_H2'') etc command
is reached, the relevant header numbering variables are incremented
(with _CODE(``m4_incr'')) and the Table of Contents entry is sent to
the standard output (diverted to file 0) together with automatically
generated pointers into the main text.

<P>

The diversion to file 1 is then resumed for the regular text and an
automatically generated section heading with pointer target is added.

<P>

The _CODE(``_End_TOC'') statement _EM(must) be placed at the end of
the file. When it is reached the text which was diverted to file 1 is
read back to standard output.

<P>

The net result is that the Table of Contents appears near the start of
the final file, with automatically generated pointers to the correct
section in the later text.

<P>

Of course, if you plan on using the _CODE(``m4_divert'') command in your own
text, you will have to check that it does not clash with the Table of
Contents generator.

<P>
_LINK_TO_LABEL(Contents)
<P>

_H2(`Simple tables')
<P>

Other than Tables of Contents, many browsers support tabular
information. Here are some funky macros as a short cut to
producing these tables. First, an example of their use:

<P>
_CODEQUOTE(``&lt;CENTER>
_Start_Table(BORDER=5)
_Table_Hdr(,Apples, Oranges, Lemons)
_Table_Row(England,100,250,300)
_Table_Row(France,200,500,100)
_Table_Row(Germany,500,50,90)
_Table_Row(Spain,,23,2444)
_Table_Row(Denmark,,,20)
_End_Table
&lt;/CENTER>'')
<P>

<CENTER>
_Start_Table(BORDER=5)
_Table_Hdr(,Apples, Oranges, Lemons)
_Table_Row(England,100,250,300)
_Table_Row(France,200,500,100)
_Table_Row(Germany,500,50,90)
_Table_Row(Spain,,23,2444)
_Table_Row(Denmark,,,20)
_End_Table
</CENTER><P>

...and now the code. Note that this example utilises _EM(m4's)
ability to recurse:


_CODEQUOTE(``m4_dnl _Start_Table(Columns,TABLE parameters)
m4_dnl defaults are BORDER=1 CELLPADDING="1" CELLSPACING="1"
m4_dnl WIDTH="n" pixels or "n%" of screen width
m4_define(_Start_Table,`&lt;TABLE $1>')

m4_define(`_Table_Hdr_Item', `&lt;th>$1&lt;/th>
  m4_ifelse($#,1,,`_Table_Hdr_Item(m4_shift($@))')')

m4_define(`_Table_Row_Item', `&lt;td>$1&lt;/td>
  m4_ifelse($#,1,,`_Table_Row_Item(m4_shift($@))')')

m4_define(`_Table_Hdr',`&lt;tr>_Table_Hdr_Item($@)&lt;/tr>')
m4_define(`_Table_Row',`&lt;tr>_Table_Row_Item($@)&lt;/tr>')

m4_define(`_End_Table',&lt;/TABLE>)'')


<P>
_LINK_TO_LABEL(Contents)
<P>

_H1(`_EM(m4) gotchas')
<P>

Unfortunately, _EM(m4) is not unremitting sweetness and
light - it needs some taming and a little time spent on
familiarisation will pay dividends. Definitive documentation
is available (for example in _EM(emacs' info) documentation
system) but, without being a complete tutorial, here are a
few tips based on my fiddling about with the thing.

<P>
m4_define(_GOTCHA,0)
m4_define(`_GOTCHA', m4_incr(_GOTCHA))
_H2(`Gotcha _GOTCHA - quotes')
<P>

m4_changequote([,])_EM(m4's) quotation characters are the
_EM(grave) accent ` which starts the quote, and the
_EM(acute) accent ' m4_changequote(`,')which ends it. It may
help to put all arguments to macros in quotes, e.g.

<P>
_CODEQUOTE(``_HEAD1(`This is a heading')'')
<P>

The main reason for this is in case there are commas in an
argument to a macro - _EM(m4) uses commas to separate macro
parameters, e.g. _CODE(``_CODE(foo, bar)'') would print the
_CODE(foo) but not the _CODE(bar). _CODE(``_CODE(`foo,
bar')'') works properly.

<P>

This becomes a little complicated when you nest macro
calls as in the _EM(m4) source code for the examples in this
paper - but that is rather an extreme case and normally you
would not have to stoop to that level.

<P>
_LINK_TO_LABEL(Contents)
<P>

m4_define(`_GOTCHA', m4_incr(_GOTCHA))
_H2(`Gotcha _GOTCHA - Word swallowing')
<P>

The worst problem with _EM(m4) is that some versions of
it "swallow" key words that it recognises, such as
"include", "format", "divert", "file", "gnu", "line",
"regexp", "shift", "unix", "builtin" and "define". You
can protect these words by putting them in _EM(m4) quotes,
for example:

<P>

_CODEQUOTE(``Smart people `include' Linux in their list
of computer essentials.'')

<P>

The trouble is, this is a royal pain to do - and you're
likely to forget which words need protecting.  

<P>

Another, safer way to protect keywords (my preference) is to
invoke _EM(m4) with the _CODE(-P) or
_CODE(--prefix-builtins) option. Then, all builtin macro
names are modified so they all start with the prefix
_CODE(m4_) and ordinary words are left alone.  For example,
using this option, one should write _CODE(m4_define) instead
of _CODE(``define'') (as shown in the examples in this
article). 

<P>

The only trouble is that not all versions of
_EM(m4) support this option - notably some PC versions under
M$-DOS. Maybe that's just another reason to steer clear of
hack code on M$-DOS and stay with _EM(Linux!)

<P>
_LINK_TO_LABEL(Contents)
<P>

m4_define(`_GOTCHA', m4_incr(_GOTCHA))
_H2(`Gotcha _GOTCHA - Comments')
<P>

Comments in _EM(m4) are introduced with the `#' character -
everything from the `#' to the end of the line is ignored by
_EM(m4) and simply passed unchanged to the output. If you
want to use `#' in the HTML page then you would need to quote it
like this - ``#''. Another option (my preference) is to
change the _EM(m4) comment character to something exotic
like this: _CODE(``m4_changecom(`[[[[')'') and not have to
worry about ``#'' symbols in your text.

<P>

If you want to use comments in the _EM(m4) file which do not
appear in the final HTML file, then the macro
_CODE(``m4_dnl'') (dnl = _STRONG(D)elete to _STRONG(N)ew _STRONG(L)ine) is for you. This suppresses everything
until the next newline. 
<P>
_CODEQUOTE(``m4_define(_NEWMACRO, `foo bar') m4_dnl This is a comment'')

<P>

Yet another way to have source code ignored is the
_CODE(``m4_divert'') command. The main purpose of
_CODE(``m4_divert'') is to save text in a temporary buffer for
inclusion in the file later on - for example, in building a
table of contents or index. However, if you divert to "-1"
it just goes to limbo-land. This is useful for getting rid
of the whitespace generated by the _CODE(``m4_define'')
command, e.g.:

<P>
_CODEQUOTE(``m4_divert(-1) diversion on
m4_define(this ...)
m4_define(that ...)
m4_divert	diversion turned off'')

<P>
_LINK_TO_LABEL(Contents)
<P>

m4_define(`_GOTCHA', m4_incr(_GOTCHA))
_H2(`Gotcha _GOTCHA - Debugging')
<P>

Another tip for when things go wrong is to increase the
amount of error diagnostics that _EM(m4) emits. The
easiest way to do this is to add the following to your
_EM(m4) file as debugging commands:

<P>
_CODEQUOTE(``m4_debugmode(e)
m4_traceon
.
.
buggy lines
.
.
m4_traceoff'')
<P>

<P>
_LINK_TO_LABEL(Contents)
<P>

_H1(`Conclusion')

"ah ha!", I hear you say. "HTML 3.0 already has an include
statement". Yes it has, and it looks like this:

<P>
_CODEQUOTE(``&lt;!--#include file="junk.html" -->'')
<P>

The problem is that:
<UL>

	<LI> The work of including and interpreting the
include is done on the server-side before downloading and
adds a big overhead as the server has to scan files for
``include'' statements.

	<LI> Consequently most servers (especially public ISP's) deactivate this feature.

	<LI> ``include'' is all you get - no macro
substitution, no parameters to macros, no ifdef, etc, etc.

</UL>

<P>

There are several other features of _EM(m4) that I have not
yet exploited in my HTML ramblings so far, such as regular
expressions and doubtless many others. It might be
interesting to create a "standard" _CODE(stdlib.m4) for
general use with nice macros for general text processing and
HTML functions. By all means download my version of
_CODE(stdlib.m4) as a base for your own hacking. I would be
interested in hearing of useful macros and if there is
enough interest, maybe a Mini-HOWTO could evolve from this
paper.

<P>

There are many additional advantages in using _EM(Linux) to
develop HTML pages, far beyond the simple assistance given
by the typical _EM(Typing Aids) and _EM(WYSIWYG) tools.

<P>

Certainly, this little hacker will go on using _EM(m4) until
HTML catches up - I will then do my last _EM(make) and drop
back to using pure HTML.

<P>

I hope you enjoy these little tricks and encourage you to
contribute your own. Happy hacking!

<P>
_H1(`Files to download')

You can get the HTML and the _EM(m4) source code for this
article here (for the sake of completeness, they're
copylefted under GPL 2):

<P>
_PRE(_FTP(using_m4.html, using_m4.html)	:this file
_FTP(using_m4.m4, using_m4.m4)	:_EM(m4) source
_FTP(stdlib.m4, stdlib.m4)	:Include file
_FTP(makefile, makefile))

<P>
_LINK_TO_LABEL(Contents)
<P>
_H1(`Bob Hepple')

<P>

_EMAILME(Bob Hepple) has been hacking at Unix since 1981
under a variety of excuses and has somehow been paid for it
at least some of the time. It's allowed him to pursue
another interest - living in warm, exotic countries
including Hong Kong, Australia, Qatar, Saudi Arabia, Lesotho
and Singapore. His initial aversion to the cold
was learned in the UK. Ambition - to stop working for the
credit card company and taxman and to get a real job - doing
this, of course!

<P>
_LINK_TO_LABEL(Contents)
<P>

_COUNTER(5, `since March 18th 1998')

<HR>
This page last updated on m4_esyscmd(date)
<P>
<ADDRESS>
_CREDITS
_PLUG
</ADDRESS>
</BODY>
</HTML>
_End_TOC

m4_divert(-1)
<!-- For emacs: -->

<!-- Local Variables: -->
<!-- fill-column: 70 -->
<!-- eval:(setq filename (substring buffer-file-name (string-match "[a-zA-Z0-9_.]+$" buffer-file-name))) -->
<!-- eval:(setq basename (substring filename 0 (string-match "\\." filename))) -->
<!-- eval:(setq compile-command (concat "make -k " basename ".html")) -->
<!-- eval:(setq hm--html-automatic-changed-comment nil) -->
<!-- eval:(setq hm--html-automatic-created-comment nil) -->
<!-- End: -->