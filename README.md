## Tksolfege

### Introduction

Tksolfege is a music ear training program implemented in tcl/tk. It contains
numerous exercises for both the beginner and advanced music student. It
includes chord identification, interval identification, rhythmic dictation,
solfege singing and many more. The program was inspired by

  * [Lenmus](http://lenmus.org/mws/noticias)
  * [Gnu Solfege](https://sourceforge.net/projects/solfege/)
  * [musictheory.net](https://www.musictheory.net/)

Detailed description of the program is found
[here](http://tksolfege.sourceforge.net/).

### Requirements

The source code requires a recent version of the tcl/tk 8.5 or 8.6 interpreter
in order to run. Tcl/tk is usually available with Posix (Linux) systems and
can installed for free on Windows operating systems from
<https://www.activestate.com/products/tcl/downloads/>. In addition, you will
need an executable of [fluidsynth version 2](http://www.fluidsynth.org/) which
is available for all platforms, and a soundfont file like TimGM6mb.sf2.

If you are running an executable on Windows, then you can download a win32
executable or an install program which will have tcl/tk embedded and muzic
starkit. Unfortunately, the muzic starkit only works on the 32-bit version of
the tcl/tk interpreter which has been superceded by the 64-bit version.
Fortunately, it is still fairly easy to create a tksolfege executable with the
32-bit tcl/tk interpreter embedded. You can find all of this code on
[sourceforge.net](https://sourceforge.net/projects/tksolfege/).

### Usage

On Windows click on the tksolfege.tcl icon, on Linux or type

    
    
    wish tksolfege.tcl
    

If you need to configure the program to find the fluidsynth executable, the
correct audio driver, and soundfont, type the letter 'a' on your keyboard
while the tksolfege window is in focus. A separate window called advanced
settings will appear.

Tksolfege saves all configuration and program state in a file called
tksolfege.ini. The file is in plain text so it is possible to edit it though
this is not recommended.

The user interface has been translated into French and Brazilian Portuguese.

* * *

This page was last updated on October 19 2020.

