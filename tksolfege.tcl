#package provide app-tksolfege 1.0
#!/bin/sh
#next lines restarts using wish \
exec wish "$0" "$@"

#The muzic starkit package does not run in the
#64 bit version of tcl/tk interpreter. Therefore tksolefge
#now runs # with fluidsynth. It is still possible to make a
# win-32 executable which does run with the muzic starkit.
#If you are making such a executable, set starkitversion to 1.

set starkitversion 0

package require Tk
#required to make solfege.kit


# tksolfege.tcl: a program for music ear training

# Copyright (C) 2005-2026 Seymour Shlien


# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# Original page:
#      http://ifdo.ca/~seymour/tksolfege

# Table of Contents

# Part 1.0  lang array
# Part 2.0  setpath, and checks
# Part 3.0  muzic namespace
# Part 4.0  definitions of notes, chords, modes, intervals, ...
# Part 5.0  initialization and ini file support
# Part 6.0  lessons initializations
# Part 7.0  random supports
# Part 8.0  user interface support buttons, menus etc
# Part 9.0  setup drums, figured bass, chords
# Part 10.0 exercise interface
# Part 11.0 Keysig support
# Part 12.0 Keysig support
# Part 13.0 Configuration support
# Part 14.0 lesson selection
# Part 15.0 make lesson
# Part 16.0 stats support 
# Part 17.0 instrument button
# Part 18.0 pick chord, scale, diatonic chord, chromatic chord
# Part 19.0 tests
# Part 20.0 interval test
# Part 21.0 play function
# Part 22.0 repeat
# Part 23.0 confusion matrix support
# Part 24.0 verification
# Part 25.0 reveal answer
# Part 26.0 rhythm support
# Part 27.0 melody dictation
# Part 28.0 draw notation 
# Part 29.0 Play support
# Part 30.0 draw chord
# Part 31.0 chord support
# Part 32.0 start up
# Part 33.0 verification continued
# Part 34.0 key signature support
# Part 35.0 grand staff
# Part 36.0 advance settings
# Part 37.0 drum support
# Part 38.0 Chord progressions
# Part 39.0 Piano keyboard


set error_return [catch {package require starkit} errmsg]
set dirname glyphs
set dirdrumseq drumseq


lappend auto_path ./.

wm protocol . WM_DELETE_WINDOW {
   getGeometryOfAllTopLevels
   write_ini_file tksolfege.ini
   if {$starkitversion == 0} {muzic::close}
   exit}

option add *Font {Arial 10 bold}


set tksolfegeversion "2.00 2026-01-17 20.35"
set tksolfege_title "tksolfege $tksolfegeversion"
wm title . $tksolfege_title

# Part 1.0 lang array

# english texts for tksolfege
array set lang {
    1stinv {first inversion}
    2ndinv {second inversion}
    accent  {beat accent level}
    accuracy {accuracy}
    already {you already have}
    alto	{alto}
    answer  {answer}
    apply	{apply}
    aural	{aurally}
    auton	{auto new}
    automatic {automatic}
    autop	{auto play}
    bars    {bars/trial}
    barstr {bar structure}
    bass	{bass}
    beats   {beats}
    both    {both}
    bpm     {beats/minute}
    beatsperbar {beats/bar}
    browse {browse}
    clef	{clef}
    compound {compound rhythm}
    config	{config}
    correct {correct}
    diatonic {diatonic}
    dor {dorian}
    down	{down}
    drumarrg  {drum arrangement}
    drumseq	{drum sequences}
    drumseqopt  {drum sequence options}
    duple   {simple rhythm}
    duration {note duration}
    either	{either}
    exit	{exit}
    exercise {exercise}
    fast {faster}
    firstpress {first press new}
    flats {flats}
    format {format}
    fontsize {font size}
    from {from}
    harmonic {harmonic}
    help	{help}
    highest	{highest pitch}
    idcad {cadence recognition}
    idchord	{chord identification (chromatic scale)}
    idchorddia {chord identification (diatonic scale)}
    idfigbas {figured bass notation}
    idinterval {interval identification}
    instruct {please go to https://tksolfege.sourceforge.io}
    instrument {instrument}
    idkeysig {key signature identification}
    idscales {scale identification}
    language {language}
    leader {count in}
    lesson	{lesson}
    level {level}
    lyd {lydian}
    lowest	{lowest pitch}
    maj {major}
    melodic {melodic}
    min {minor nat}
    minhar {minor har}
    minmel {minor mel}
    mix {mixolydian}
    mode {mode}
    more    {more beats expected}
    nnotes  {notes/trial}
    new	{new}
    norest  {do not start with a rest}
    notavail {not available}
    numrepeats {number of repeats}
    numstrike {number of strikes}
    pattern {pattern}
    phr {phrygian}
    picklesson {please choose lesson first}
    pitch   {MIDI pitch}
    plain {plain}
    prog {progressions}
    random {random}
    newseed {new seed}
    noteid {note reading}
    resetseed {reset seed}
    repeat	{repeat}
    repeatability {repeatability}
    repeats {repeats}
    repeaton {repeat tonic}
    reset  {reset}
    restart {You need to restart tksolfege}
    rhythmdic {rhythmic dictation}
    rhythminstr {rhythm instrument}
    scaleid {scale identification}
    settings {settings}
    sharps {sharps}
    singi	{sing interval}
    slow {slower}
    smallint {small intervals}
    sofadic {solfege dictation}
    sofabadnote {solfege find wrong note}
    sofasing {solfege singing}
    sofaid {sofa identification}
    soundfont {soundfont}
    stats	{stats}
    submit {submit}
    transpose {transpose}
    treble {treble}
    try    {try again}
    trials {trials}
    up	{up}
    velocity {loudness}
    visual	{visually}
    yourown	{your own}
    so,  so,	si,  si,	le,  le,	la,  la,
    li,  li,	te,  te,	ti,  ti,	do   do
    di   di		ra   ra		re   re		ri   ri
    me   me		mi   mi		fa   fa		fi   fi
    se   se		so   so		si   si		le   le
    la   la		li   li		te   te		ti   ti
    do'  do'	di'  di'        ra'  ra'	re'  re'
    ri'  ri'	me'  me'	mi'  mi'	fa'  fa'
    fi'  fi'	se'  se'	so'  so'
    unison     unison	minor2nd  minor2nd	major2nd  major2nd
    minor3rd   minor3rd     major3rd  major3rd	perfect4th perfect4th
    tritone    tritone	perfect5th perfect5th	minor6th  minor6th
    major6th   major6th	minor7th  minor7th	major7th  major7th
    octave     octave	minor9th  minor9th	major9th  major9th
    minor10th  minor10th	major10th major10th	perfect11th perfect11th
    dim12th   dim12th	perfect12th perfect12th
    A A	B B	C C	 D D
    E E	F F 	G G
    pacn {perfect authentic cadence}
    iacn {imperfect authentic cadence}
    hcn {half cadence}
    pcn {plagal cadence}
    dcn {deceptive cadence}

}

set instructions "tksolfege $tksolfegeversion \n\n\
        $lang(instruct)\n
seymour shlien  email fy733@ncf.ca"

set keysf 0

proc positionWindow {window} {
   global trainer
   if {[string length $trainer($window)] < 1} return
   wm geometry $window $trainer($window)
   }

#


# Part 2.0 setpath, and checks


proc setpath {path_var} {
    global trainer

    set filedir [file dirname $trainer($path_var)]
    set openfile [tk_getOpenFile -initialdir $filedir -title "find fluidsynth executable"]
    if {[string length $openfile] > 0} {
        set trainer($path_var) $openfile
        update
    }
}

proc check_fluidsynth_path {} {
global trainer
global tcl_platform
if {[file exist $trainer(fluidsynth_path)] == 1} {
	return 1
   }
set msg "You are running tksolfege64bit.tcl.\n\n\
This program requires fluidsynth in order to produce\
audio output. Please find the path to the fluidsynth executable\
using browser which will appear after you click ok."
tk_messageBox -message $msg -type ok
set fluidsynthpath [setpath fluidsynth_path]
if {[string length $fluidsynthpath] > 1} {
   set trainer(fluidsynth_path) $fluidsynthpath
   }
return 1
}

proc check_soundfont_path {} {
global trainer
global tcl_platform
if {[file exist $trainer(soundfont)] == 1} {
	return 1
   }
set msg "You are also need to configure fluidsynth\
using the advanced settings. If you are running linux\
use the 'pulseaudio' driver. If you are running Windows 10\
use the 'waveout' driver. You also need to specify a path\
to a suitable soundfont file after you click ok\n
If you are running tksolfege.tcl on Linux, the program\
will load default.sf2 which is rather minimal.
On Linux FluidR3_GM.sf2 usually comes with fluidsynth\
and it is found in /usr/share/sounds/sf2.\n
You can look for soundfonts in
https://musescore.org/en/handbook/soundfonts-and-sfz-files#gm_soundfonts
or
http://www.personalcopy.com/home.htm
"
tk_messageBox -message $msg -type ok
advance_settings_config
return 1
}

if {$starkitversion == 1} {
  set error_return [catch {package require starkit} errmsg]
  if {$error_return} {
      tk_messageBox -type ok\
        -message  "package_require starkit errorreturn = $error_return"
      } else {
      starkit::startup
      set dirname [file join $starkit::topdir glyphs]
      set dirdrumseq [file join $starkit::topdir drumseq]
      set error_return [catch {package require muzic} errmsg]
      if {$error_return} {
         set errmsg "cannot find muzic"
         tk_messageBox -type ok -icon error -message $errmsg
         exit
         }
     }
  } else {
 
# Part 3.0 muzic namespace
# link with fluidsynth
namespace eval muzic {

   variable midihandle

   namespace export init
   proc init {} {
   global trainer
   variable midihandle
   if {[check_fluidsynth_path] && [check_soundfont_path]} {
     set midihandle [open "|$trainer(fluidsynth_path) -j -a  $trainer(audio_driver) $trainer(soundfont)" w+ ]
     fconfigure $midihandle -buffering none
     puts $midihandle "gain 5"
     flush $midihandle
     } else {
     puts "unable to connect with fluidsynth"
     }
  }

   namespace export playnote
   proc playnote {chanl pitch velocity duration} {
   variable midihandle
   set s "noteon $chanl $pitch $velocity"
   puts $midihandle $s
   set s "noteoff $chanl $pitch" 
   after $duration
   puts $midihandle $s
   flush $midihandle
   }

   namespace export playchord
   proc playchord {chanl pitchlist velocity duration} {
   variable midihandle
   foreach pitch $pitchlist {
     set s "noteon $chanl $pitch $velocity"
     puts $midihandle $s
     }
   after $duration
   foreach pitch $pitchlist {
     set s "noteoff $chanl $pitch"
     puts $midihandle $s
     }
   flush $midihandle
   }


   namespace export channel
   proc channel {chan program} {
   variable midihandle
   set s "prog $chan $program"
   puts $midihandle $s
   flush $midihandle
   }

   namespace export close
   proc close {} {
   variable midihandle
   puts $midihandle quit
   flush $midihandle
   }
 }
}

# Part 4.0 definitions of notes, chords, modes, intervals, ...

set sharpnotes {C C# D D# E F F# G G# A A# B}
set maj {0 4 7}
set majinv1 {4 7 12}
set majinv2 {7 12 16}
set min {0 3 7}
set mininv1 {3 7 12}
set mininv2 {7 12 15}
set dim {0 3 6}
set diminv1 {3 6 12}
set diminv2 {6 12 15}
set aug {0 4 8}
set auginv1 {4 8 12}
set auginv2 {8 12 16}
set majmin {0 4 7 10}
set majmininv1 {4 7 10 12}
set majmininv2 {7 10 12 16}
set majmininv3 {10 12 16 19}
set maj7 {0 4 7 11}
set maj7inv1 {4 7 11 12}
set maj7inv2 {7 11 12 16}
set maj7inv3 {11 12 16 19}
set min7 {0 3 7 10}
set min7inv1 {3 7 10 12}
set min7inv2 {7 10 12 15}
set min7inv3 {10 12 15 19}
set halfdim7 {0 3 6 10}
set halfdim7inv1 {3 6 10 12}
set halfdim7inv2 {6 10 12 15}
set halfdim7inv3 {10 12 15 18}
set dim7 {0 3 6 9}
set dim7inv1 {3 6 9 12}
set dim7inv2 {6 9 12 15}
set dim7inv3 {9 12 15 18}
set aug7 {0 4 8 11}
set aug7inv1 {4 8 11 12}
set aug7inv2 {8 11 12 16}
set aug7inv3 {11 12 16 20}

#scales
set basicscales {major natural_minor melodic_minor harmonic_minor}

set majormodes {ionian dorian phrygian lydian mixolydian aeolian locrian harmonic_minor natural_minor melodic_minor}
set ionian {2 2 1 2 2 2 1}
set major {2 2 1 2 2 2 1}
set dorian {2 1 2 2 2 1 2}
set phrygian {1 2 2 2 1 2 2}
set lydian {2 2 2 1 2 2 1}
set mixolydian {2 2 1 2 2 1 2}
set aeolian {2 1 2 2 1 2 2}
set locrian {1 2 2 1 2 2 2}
set harmonic_minor {2 1 2 2 1 3 1}
set natural_minor {2 1 2 2 1 2 2}
set melodic_minor {2 1 2 2 2 2 1}

set exotics {blues bebop hungarian whole_tone pentatonic_maj pentatonic_sus pentatonic_min ritusen man_gong neapolitan}
set blues {3 2 1 1 3 2}
set bebop {2 2 1 2 1 1 2 1}
set hungarian {3 1 2 1 2 1 2}
set whole_tone {2 2 2 2 2 2}
set pentatonic_maj {2 2 3 2 3}
set pentatonic_sus {2 3 2 3 2}
set man_gong {3 2 3 2 2}
set ritusen {2 3 2 2 3}
set pentatonic_min {3 2 2 3 2}
set neapolitan {1 2 2 2 2 2 1}




set allintervals {unison minor2nd major2nd minor3rd major3rd perfect4th
    tritone perfect5th minor6th major6th minor7th major7th
    octave minor9th major9th minor10th major10th perfect11th
    dim12th perfect12th}

set intervalspaces {0 1 1 2 2 3 3 4 5 5 6 6 7 8 8 9 9 10 11 11}


set allchordtypes {maj majinv1 majinv2 min mininv1 mininv2 dim diminv1\
            diminv2 aug auginv1 auginv2 majmin majmininv1 majmininv2 majmininv3\
            maj7 maj7inv1 maj7inv2 maj7inv3 min7 min7inv1 min7inv2 min7inv3\
            halfdim7 halfdim7inv1 halfdim7inv2 halfdim7inv3 dim7 dim7inv1\
            dim7inv2 dim7inv3 aug7 aug7inv1 aug7inv2 aug7inv3}

#A Hard Days Night -Beatles
set tunes(minor2nd,asc) {108 {12 12 12 48 48} {0 1 0 3 3}}
#Fur Elise - Beethoven
set tunes(minor2nd,des) {120 {12 12 12 12 12 12 12} {0 -1 0 -1 0 -4 -2}}
#Silent Night - Christmas Carol
set tunes(major2nd,asc) {60 {18 6 12 24} {0 2 0 -3}}
#Mary Had a Little Lamb - Nursery Rhyme
set tunes(major2nd,des) {80 {24 24 24 24 24 24 48} {0 -2 -4 -2 0 0 0}}
#Greensleeves
set tunes(minor3rd,asc) {110 {24 48 24 36 12 24 48} {0 3 5 7 8 7 5}}
#Star Spangled Banner - U.S.A. Anthem
set tunes(minor3rd,des) {160 {36 12 48 48 48 48} {0 -3 -7 -3 0 5}}
#When the Saints Come Marching In
set tunes(major3rd,asc) {120 {24 24 24 96} {0 4 5 7}}
#Summer Time - Gershwin
set tunes(major3rd,des) {120 {24 24 96} {0 -4 0}}
#Here Comes the Bride
set tunes(perfect4th,asc) {160 {24 24 12 36} {0 5 5 5}}
#Oh Come All You Faithful
set tunes(perfect4th,des) {160 {48 24 24  48 48} {0 -5 0 2 -5}}
#Am I Evil  - Heavy Metal
set tunes(tritone,asc) {120 {24 24 24 24 24 24 24 24} {0 6 5 13 12 18 17 25}}
# Blue Seven (Sonny Rollins)
set tunes(tritone,des) {120 {12 36} {0 -6}}
#Twinkle Twinkle Little Star
set tunes(perfect5th,asc) {160 {24 24 24 24 24 24 48} {0 0 7 7 9 9 7}}
#The Flintstones theme
set tunes(perfect5th,des) {120 {36 60 48 12 12 12 12 36 48} {0 -7 z -7 -5 -4 -7 0 -7}}
#Go Down Moses
set tunes(minor6th,asc) {120 {24 24 24 24 24 12 36 96} {0 8 8 7 7 8 8 5}}
#Please Don't Talk About Me When I'm Gone
set tunes(minor6th,des) {144 {24 24 24 18 6 24 48 24} {0 -8 -5 0 -1 -1 -8 -5}}
#My Bonnie Lies Over the Ocean
set tunes(major6th,asc) {120 {24 24 24 24 24 24 48} {0 9 7 5 7 5 2}}
#Over There
set tunes(major6th,des) {120 {12 1 48 12 12 48} {0 -9 -4 0 -9 -4}}
#Somewhere - West Side Story
set tunes(minor7th,asc) {60 {24 24 18 6 24} {0 10 9 5 2}}
#American in Paris - George Gershwin
set tunes(minor7th,des) {90 {12 12 24 12 12 24} {0 -10 -8 0 -10 -8}}
#Fantasy Island theme
set tunes(major7th,asc) {80 {12 18 6 36 12} { 0 11 12 9 8}}
#I love you (Cole Porter)
set tunes(major7th,des) {120 {12 24 8 4} {0 -11 -2 -3}}
#Somewhere over the Rainbow
set tunes(octave,asc) {120 {48 48 24 12 12 24 24} {0 12 11 7 9 11 12}}
#Willow Weep for Me - Ann Ronell 1932
set tunes(octave,des) {80 {24 12 12 12 12 24} {0 -12 z -10 -7 -10}}

array set chordprogressions {
 0 {I IV I V}
 1 {I IV V I}
 2 {I IV vi V}
 3 {I V I IV}
 4 {I V IV I}
 5 {I V IV V}
 6 {I V vi IV}
 7 {I vi ii V}
 8 {I vi IV V}
 9 {IV V I vi}
10 {vi IV I V}
11 {vi ii V I}
}

#Reference:
#https://www.hooktheory.com/theorytab/common-chord-progressions
#https://en.wikipedia.org/wiki/List_of_chord_progressions
#https://mastering.com/wp-content/uploads/2019/02/Chord-Progression-Cheat-Sheet.pdf





# Part 5.0 initialization and ini file support

proc initialize_trainer_array {} {
global trainer
global tksolfegeversion 
global tcl_platform

if {$tcl_platform(os) == "Linux"} {
	set trainer(fluidsynth_path) /usr/bin/fluidsynth
	set trainer(audio_driver) pulseaudio
        set trainer(browser) "/usr/bin/firefox"
   } else {
    set trainer(fluidsynth_path) fluidsynth.exe
    set trainer(audio_driver) waveout
    set trainer(browser) " C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
    }
set trainer(version) $tksolfegeversion
set trainer(top) ""

set trainer(accent) 5
set trainer(chordtypes) {maj min aug dim}
set trainer(intervaltypes) {major3rd perfect5th octave}
set trainer(keysigtypes) {-3 -2 -1 0 1 2 3}
set trainer(keysf) -1
set trainer(scaletypes) {ionian dorian phrygian aeolian}
set trainer(cadences) {pacn iacn hcn pcn dcn}
set trainer(keysigformat) 0
set trainer(velocity) 80
set trainer(msec) 500
set trainer(minpitch) 36
set trainer(maxpitch) 72
set trainer(lowpitch) 50
set trainer(hipitch) 62
set trainer(instrument) 0
set trainer(playmode) harmonic
set trainer(autonew) 0
set trainer(autoplay) 1
set trainer(autonewdelay) 2000 
set trainer(repeattonic) 1
set trainer(rseed) 0
set trainer(range) [expr $trainer(maxpitch) - $trainer(minpitch)]
set trainer(exercise) chords
set trainer(direction) up
if {$tcl_platform(platform) == "windows"} {
   set trainer(soundfont) none
} else {
   set trainer(soundfont) default.sf2
   }
set trainer(makelog) 0
set trainer(font) {Arial 10 bold}
set trainer(fontsize) 10
set trainer(lang) "none"
set trainer(rhythm_accent) 25
set trainer(rhythm_beats_per_bar) 2
set trainer(rhythm_bars) 2
set trainer(rhythmtypes) {0 1 2 3}
set trainer(leaderinstrument) 115
set trainer(rhythminstrument) 0
set trainer(rhythmpitch) 60
set trainer(rhythmvelocity) 80
set trainer(rhythmbpm) 60 
set trainer(timesigtype) 0
set trainer(norest) 1
set trainer(sofa_notes) 6
set trainer(sofa_tonic) 48
set trainer(smallint) 1
set trainer(sofalesson) "do re mi"
set trainer(lockconfig) 0
# trainer(lockconfig)>0 does not allow writing (overwriting) tksolfege.ini
set trainer(repeatability) 0
set trainer(transpose) 0
set trainer(clefcode) -1
set trainer(melpat) 3
set trainer(testmode) aural
set trainer(mode) maj
set trainer(key) C
set trainer(chordroot) 48
set trainer(chordinversion) 0
set trainer(proglesson) 0
set trainer(shiftedchord) 0
set trainer(xchord) 0
set trainer(dirdrumseq) drumseq
set trainer(drumsrc) file
## random drum trainer state
set trainer(rbeats) 4
set trainer(rres) 4
set trainer(rarrg) 0
set trainer(rndrums) 3
set trainer(rrepeats) 2


#window geometry
set trainer(.) ""
set trainer(.config) ""
set trainer(.ownlesson) ""
set trainer(.stats) ""
set trainer(.help) ""
set trainer(.prog) ""
set trainer(.rhythmselector) ""
set trainer(.sofasel) ""
set trainer(.advance) ""
set trainer(.piano) ""
set trainer(.notebuttons) ""
}

proc getGeometryOfAllTopLevels {} {
global trainer
set toplevellist {"." ".config" ".ownlesson" ".stats" ".help"
   ".prog" ".rhythmselector" ".sofasel" ".advance" ".piano" ".notebuttons"}
foreach top $toplevellist {
    if {[winfo exist $top]} {
      set g [wm geometry $top]
      scan $g "%dx%d+%d+%d" w h x y
      set trainer($top) +$x+$y
      }
    }
}


proc write_ini_file {filename} {
    global trainer
    global tcl_platform
    if {$trainer(lockconfig) > 0} return
    set handle [open $filename "w"]
    puts $handle "version $trainer(version)"
    puts $handle "fluidsynth_path $trainer(fluidsynth_path)"
    puts $handle "audio_driver $trainer(audio_driver)"
    puts $handle "font $trainer(font)"
    puts $handle "fontsize $trainer(fontsize)"
    puts $handle "top $trainer(top)"
    puts $handle "velocity $trainer(velocity)"
    puts $handle "msec  $trainer(msec)"
    puts $handle "minpitch $trainer(minpitch)"
    puts $handle "maxpitch $trainer(maxpitch)"
    puts $handle "lowpitch $trainer(lowpitch)"
    puts $handle "hipitch $trainer(hipitch)"
    puts $handle "range $trainer(range)"
    puts $handle "instrument $trainer(instrument)"
    puts $handle "playmode $trainer(playmode)"
    puts $handle "accent $trainer(accent)"
    puts $handle "autonew $trainer(autonew)"
    puts $handle "autoplay $trainer(autoplay)"
    puts $handle "autonewdelay $trainer(autonewdelay)"
    puts $handle "exercise $trainer(exercise)"
    puts $handle "chordtypes $trainer(chordtypes)"
    puts $handle "intervaltypes $trainer(intervaltypes)"
    puts $handle "key $trainer(key)"
    puts $handle "keysigtypes $trainer(keysigtypes)"
    puts $handle "keysf $trainer(keysf)"
    puts $handle "keysigformat $trainer(keysigformat)"
    puts $handle "direction $trainer(direction)"
    puts $handle "soundfont $trainer(soundfont)"
    puts $handle "lang $trainer(lang)"
    puts $handle "mode $trainer(mode)"
    puts $handle "rhythmtypes $trainer(rhythmtypes)"
    puts $handle "leaderinstrument $trainer(leaderinstrument)"
    puts $handle "rhythminstrument $trainer(rhythminstrument)"
    puts $handle "rhythmpitch $trainer(rhythmpitch)"
    puts $handle "rhythmvelocity $trainer(rhythmvelocity)"
    puts $handle "rhythmbpm $trainer(rhythmbpm)"
    puts $handle "rhythm_beats_per_bar $trainer(rhythm_beats_per_bar)"
    puts $handle "rhythm_bars $trainer(rhythm_bars)"
    puts $handle "rhythm_accent $trainer(rhythm_accent)"
    puts $handle "norest $trainer(norest)"
    puts $handle "scaletypes $trainer(scaletypes)"
    puts $handle "sofa_notes $trainer(sofa_notes)"
    puts $handle "sofa_tonic $trainer(sofa_tonic)"
    puts $handle "smallint $trainer(smallint)"
    puts $handle "sofalesson $trainer(sofalesson)"
    puts $handle "makelog $trainer(makelog)"
    puts $handle "lockconfig $trainer(lockconfig)"
    puts $handle "repeatability $trainer(repeatability)"
    puts $handle "rseed $trainer(rseed)"
    puts $handle "repeattonic $trainer(repeattonic)"
    puts $handle "clefcode $trainer(clefcode)"
    puts $handle "transpose $trainer(transpose)"
    puts $handle "testmode $trainer(testmode)"
    puts $handle "xchord $trainer(xchord)"
    puts $handle "dirdrumseq $trainer(dirdrumseq)"
    puts $handle "drumsrc $trainer(drumsrc)"
    puts $handle "rbeats $trainer(rbeats)"
    puts $handle "rres $trainer(rres)"
    puts $handle "rarrg $trainer(rarrg)"
    puts $handle "rndrums $trainer(rndrums)"
    puts $handle "rrepeats $trainer(rrepeats)"
    puts $handle "chordroot $trainer(chordroot)"
    puts $handle "chordinversion $trainer(chordinversion)"
    puts $handle "proglesson $trainer(proglesson)"
    puts $handle "browser $trainer(browser)"
    puts $handle "shiftedchord $trainer(shiftedchord)"
    puts $handle ". $trainer(.)"
    puts $handle ".config $trainer(.config)"
    puts $handle ".ownlesson $trainer(.ownlesson)"
    puts $handle ".stats $trainer(.stats)"
    puts $handle ".help $trainer(.help)"
    puts $handle ".prog $trainer(.prog)"
    puts $handle ".rhythmselector $trainer(.rhythmselector)"
    puts $handle ".sofasel $trainer(.sofasel)"
    puts $handle ".advance $trainer(.advance)"
    puts $handle ".piano $trainer(.piano)"
    puts $handle ".notebuttons $trainer(.notebuttons)"
    close $handle
}

proc read_tksolfege_ini {} {
    global trainer
    global tksolfegeversion
    set handle [open tksolfege.ini r]
    while {[gets $handle line] >= 0} {
        set error_return [catch {set n [llength $line]} error_out]
        if {$error_return} continue
        set contents ""
        set param [lindex $line 0]
        for {set i 1} {$i < $n} {incr i} {
            set contents [concat $contents [lindex $line $i]]
        }
        #if param is not already a member of the trainer array
        #then we ignore it. This prevents the trainer array filling up
        #with obsolete parameters used in older versions of the program.
        set member [array names trainer $param]
        if [llength $member] { set trainer($param) $contents}
    }
    if {[string range $trainer(version) 0 4] < 0.77} {
        #   puts "resetting intervaltypes"
        set trainer(intervaltypes) {}
        set trainer(exercise) chords
    }
    set trainer(version) $tksolfegeversion
}

proc pick_language_pack {} {
    global trainer lang
    set openfile [tk_getOpenFile -filetypes {{langpack {*.tcl}}}]
    if {[string length $openfile] > 0} {
        set trainer(lang) $openfile
    } else {set trainer(lang) none}
    tk_messageBox -type ok -icon info -message $lang(restart)
}

proc pick_soundfont {} {
global trainer lang
set filedir [file dirname $trainer(soundfont)]
set openfile [tk_getOpenFile -initialdir $filedir -filetypes {{soundfont {*.sf2}}}]
if {[string length $openfile] > 0} {
    set trainer(soundfont) $openfile
  } else {set trainer(soundfont) none}
tk_messageBox -type ok -icon info -message $lang(restart)
}

proc pick_browser {} {
global trainer lang
set filedir [file dirname $trainer(browser)]
set openfile [tk_getOpenFile -initialdir $filedir ]
if {[string length $openfile] > 0} {
    set trainer(browser) $openfile
  } else {set trainer(soundfont) none}
}



initialize_trainer_array



if [file exists tksolfege.ini] {read_tksolfege_ini
   } else {write_ini_file tksolfege.ini;}

# Part 6.0  lessons initializations

# available lessons
set chordlesson(0) {maj min}
set chordlesson(1) {maj aug}
set chordlesson(2) {min dim}
set chordlesson(3) {maj min dim}
set chordlesson(4) {maj min aug}
set chordlesson(5) {maj min dim aug}
set chordlesson(6) {maj majinv1}
set chordlesson(7) {maj majinv2}
set chordlesson(8) {majinv1 majinv2}
set chordlesson(9) {maj majinv1 majinv2}
set chordlesson(10) {min mininv1}
set chordlesson(11) {min mininv2}
set chordlesson(12) {min mininv1 mininv2}
set chordlesson(13) {maj min majinv1 majinv2}

set diatoniclesson(0) {maj min aug dim}
set diatoniclesson(1) {maj min majinv1 mininv1}
set diatoniclesson(2) {maj min majinv2 mininv2}
set diatoniclesson(3) {maj min majinv1 mininv1 majinv2 majinv2}
set diatoniclesson(4) {maj majinv1 min mininv1 majinv2 mininv2}
set diatoniclesson(5) {maj majinv1 majinv2 min mininv1 mininv2 dim diminv1 diminv2 aug auginv1 auginv2}
set diatoniclesson(6) {maj min maj7 min7}
set diatoniclesson(7) {aug dim auginv1 diminv1}
set diatoniclesson(8) {maj maj7 min min7 dim dim7 aug aug7}

set intervallesson(0) {unison perfect5th octave}
set intervallesson(1) {perfect5th octave}
set intervallesson(2) {minor2nd major2nd}
set intervallesson(3) {minor3rd major3rd}
set intervallesson(4) {perfect4th perfect5th}
set intervallesson(5) {perfect4th perfect5th octave}
set intervallesson(6) {major3rd perfect5th octave}
set intervallesson(7) {major3rd perfect4th}
set intervallesson(8) {major3rd perfect4th perfect5th}
set intervallesson(9) {major3rd perfect4th perfect5th octave}
set intervallesson(10) {minor2nd major2nd minor3rd major3rd}
set intervallesson(11) {perfect4th tritone perfect5th}
set intervallesson(12) {perfect5th minor6th}
set intervallesson(13) {major3rd major6th}
set intervallesson(14) {minor3rd major3rd major6th}
set intervallesson(15) {major7th octave}
set intervallesson(16) {major6th major7th}
set intervallesson(17) {major6th minor6th}

set duplerhythmlesson(0) {0 1 4}
set duplerhythmlesson(1) {0 1 2 3}
set duplerhythmlesson(2) {0 1 2 3 4 5 6 7}
set duplerhythmlesson(3) {0 8 9 10 11}
set duplerhythmlesson(4) {0 1 14 16}
set duplerhythmlesson(5) {0 1 2 3 4 5 6 7 8 9 10 11 12}
set duplerhythmlesson(6) {0 1 2 3 4 16 17 18 19 20 21}
set duplerhythmlesson(7) {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14\
            15 16 17 18 19 20 21 }


set compoundrhythmlesson(0) {100 101 102}
set compoundrhythmlesson(1) {100 103 104 105 106 107 108 109}
set compoundrhythmlesson(2) {100 110 111 112 113 114}
set compoundrhythmlesson(3) {100 101 102 103 104 105 106 107\
            108 109 110 111 112 113 114}
set compoundrhythmlesson(4) {100 101 102 103 104 115 116\
            117 118 119}
set compoundrhythmlesson(5) {100 101 102 103 104 105 106 107\
            108 109 110 111 112 113 114 115\
            116 117 118 119}
set compoundrhythmlesson(6) {100 101 102 103 104 105 120 121\
            122}
set compoundrhythmlesson(7) {100 101 102 103 104 105 106 107\
            108 109 110 111 112 113 114 115\
            116 117 118 119 120 121 122}


set sofa_lesson(0) {do re mi}
set sofa_lesson(1) {do re mi fa}
set sofa_lesson(2) {do re mi fa so}
set sofa_lesson(3) {do re mi fa so la}
set sofa_lesson(4) {do re mi fa so la do\'}
set sofa_lesson(5) {do re mi fa so la ti do\'}
set sofa_lesson(6) {ti, do re mi}
set sofa_lesson(7) {la, ti, do re mi}
set sofa_lesson(8) {ti, do re mi fa so}
set sofa_lesson(9) {la, ti, do re mi fa so}
set sofa_lesson(10) {la, ti, do re mi fa so la}

set progression_lesson(0) {0 1 2}
set progression_lesson(1) {0 1 2 3}
set progression_lesson(2) {4 5 6}
set progression_lesson(3) {3 4 5 6}
set progression_lesson(4) {7 8 9}
set progression_lesson(5) {7 8 9 10}
set progression_lesson(6) {9 10 11}
set progression_lesson(7) {0 1 2 3 4 5}
set progression_lesson(8) {6 7 8 9 10 11}
set progression_lesson(9) {0 1 2 3 4 5 6 7 8 9 10 11}

set noteid_lesson(0) "treble"
set noteid_lesson(1) "treble+"
set noteid_lesson(2) "treble-"
set noteid_lesson(3) "bass"
set noteid_lesson(4) "bass+"
set noteid_lesson(5) "bass-"



# Part 7.0  random support

#initialize these variables to some value in
#case the user presses random buttons

set ttype maj
# type of chord or interval picked by the program

set troot 60;
# root of interval or first note of interval

set tdir 1;
# direction for interval

set try 0
# zero after new trial, increments after each guess

set ntrials 0
# number of trials done so far

set total_time 0
# total number of seconds waiting for user to get correct
# answer

set ncorrect 0
# number of correct responses

set chordname maj
set intervalname unison







#source randseed.tcl

proc ValidInt {val} {
    return [ expr {[string is integer $val] || [string match {[-+]} $val]}]
}

proc Validchar {val} {
    if {[string length $val] > 4} {return 0}
    return [string is alnum $val]
}



proc n2alpha {n} {
    #converts a number between 0 and 62 to an alphanumeric
    #character
    if {$n < 10} {
        return [format "%c" [expr 48+$n]]
    }
    if {$n < 36} {
        return [format "%c" [expr 55+$n]]
    }
    return [format "%c" [expr 61 + $n]]
}



proc n2string {n} {
    #converts a number to a 4 character alphanumeric string
    set s ""
    set m [expr $n % 62]
    set s $s[n2alpha $m]
    set n [expr $n / 62]
    set m [expr $n % 62]
    set s $s[n2alpha $m]
    set n [expr $n / 62]
    set m [expr $n % 62]
    set s $s[n2alpha $m]
    set n [expr $n / 62]
    set m [expr $n % 62]
    set s $s[n2alpha $m]
    return $s
}

proc string2n {s} {
    # converts a string to a list of ascii values
    set len [string length $s]
    binary scan $s c$len nlist
    #puts $nlist
    set n 0
    for {set l 3} {$l >= 0} {incr l -1} {
        set code [lindex $nlist $l]
        set val [ascii2num $code]
        #puts "$code $val"
        set n [expr $n*62 + $val]
    }
    return $n
}

proc ascii2num {n} {
    #converts an alphanumeric character to a number between 0 and 61
    if {$n <58} {return [expr $n - 48]}
    if {$n <91} {return [expr $n - 55]}
    if {$n <123} {return [expr $n - 61]}
}


set maxval [expr 62*62*62*62]

proc make_random_seed {} {
    global maxval rseed
    global trainer
    set n [expr int($maxval*rand())]
    set rseed [n2string $n]
    set trainer(rseed) $rseed
    reset_random_seed
}

proc reset_random_seed {} {
    global rseed
    global trainer
    set rseed $trainer(rseed)
    set n [string2n $rseed]
    expr srand($n)
    focus .f
    #.f.rseed configure -textvariable rseed
}

#end or source randseed.tcl



array set modescalechords {0 maj 1 min 2 min 3 maj 4 maj 5 min 6 dim}
array set roman {0 i 1 ii 2 iii 3 iv 4 v 5 vi 6 vii}

# We use the same interface for singing intervals and
# chord identification in order to avoid creating more widgets.
# This makes the code somewhat less elegant as some functions
# (test_interval, verify_interval) are used for two purposes.


# Part 8.0  user interface support buttons, menus etc

proc make_testframe_buttons {} {
    global allintervals
    global lang
    global interval
    set butwidth 16
    # intervals or chords
    if {[winfo exist .w]} return
    frame .w -borderwidth 3 -relief sunken
    pack .w -side bottom -after .f

    set i 0
    foreach intvl $allintervals {
        set interval($intvl) $i
        incr i
        button .w.$intvl -text $lang($intvl) -width 8 -command "verify_interval $intvl"
    }
    button .w.maj -text maj  -command "verify_chord maj" -width $butwidth
    button .w.majinv1 -text "majinv1" -command "verify_chord majinv1" -width $butwidth
    button .w.majinv2 -text "majinv2" -command "verify_chord majinv2" -width $butwidth
    button .w.min -text minor -command "verify_chord min" -width $butwidth
    button .w.mininv1 -text "mininv1" -command "verify_chord mininv1" -width $butwidth
    button .w.mininv2 -text "mininv2" -command "verify_chord mininv2" -width $butwidth
    button .w.aug -text aug -command "verify_chord aug" -width $butwidth
    button .w.auginv1 -text auginv1 -command "verify_chord auginv1" -width $butwidth
    button .w.auginv2 -text auginv2 -command "verify_chord auginv2" -width $butwidth
    button .w.dim -text dim -command "verify_chord dim" -width $butwidth
    button .w.diminv1 -text diminv1 -command "verify_chord diminv1" -width $butwidth
    button .w.diminv2 -text diminv2 -command "verify_chord diminv2" -width $butwidth
    button .w.majmin -text majmin -command "verify_chord majmin" -width $butwidth
    button .w.majmininv1 -text majmininv1 -command "verify_chord majmininv1" -width $butwidth
    button .w.majmininv2 -text majmininv2 -command "verify_chord majmininv2" -width $butwidth
    button .w.majmininv3 -text majmininv3 -command "verify_chord majmininv3" -width $butwidth
    button .w.maj7 -text maj7 -command "verify_chord maj7" -width $butwidth
    button .w.maj7inv1 -text maj7inv1 -command "verify_chord maj7inv1" -width $butwidth
    button .w.maj7inv2 -text maj7inv2 -command "verify_chord maj7inv2" -width $butwidth
    button .w.maj7inv3 -text maj7inv3 -command "verify_chord maj7inv3" -width $butwidth
    button .w.min7 -text min7 -command "verify_chord min7" -width $butwidth
    button .w.min7inv1 -text min7inv1 -command "verify_chord min7inv1" -width $butwidth
    button .w.min7inv2 -text min7inv2 -command "verify_chord min7inv2" -width $butwidth
    button .w.min7inv3 -text min7inv3 -command "verify_chord min7inv3" -width $butwidth
    button .w.halfdim7 -text halfdim7 -command "verify_chord halfdim7" -width $butwidth
    button .w.halfdim7inv1 -text halfdim7inv1 -command "verify_chord halfdim7inv1" -width $butwidth
    button .w.halfdim7inv2 -text halfdim7inv2 -command "verify_chord halfdim7inv2" -width $butwidth
    button .w.halfdim7inv3 -text halfdim7inv3 -command "verify_chord halfdim7inv3" -width $butwidth
    button .w.dim7 -text dim7 -command "verify_chord dim7" -width $butwidth
    button .w.dim7inv1 -text dim7inv1 -command "verify_chord dim7inv1" -width $butwidth
    button .w.dim7inv2 -text dim7inv2 -command "verify_chord dim7inv2" -width $butwidth
    button .w.dim7inv3 -text dim7inv3 -command "verify_chord dim7inv3" -width $butwidth
    button .w.aug7 -text aug7 -command "verify_chord aug7" -width $butwidth
    button .w.aug7inv1 -text aug7inv1 -command "verify_chord aug7inv1" -width $butwidth
    button .w.aug7inv2 -text aug7inv2 -command "verify_chord aug7inv2" -width $butwidth
    button .w.aug7inv3 -text aug7inv3 -command "verify_chord aug7inv3" -width $butwidth

    button .w.ionian -text ionian -command "verify_scale ionian" -width $butwidth
    button .w.major -text "major (ionian)" -command "verify_scale major" -width $butwidth
    button .w.dorian -text dorian -command "verify_scale dorian" -width $butwidth
    button .w.phrygian -text phrygian -command "verify_scale phrygian" -width $butwidth
    button .w.lydian -text lydian -command "verify_scale lydian" -width $butwidth
    button .w.mixolydian -text mixolydian -command "verify_scale mixolydian" -width $butwidth
    button .w.aeolian -text aeolian -command "verify_scale aeolian" -width $butwidth
    button .w.locrian -text locrian -command "verify_scale locrian" -width $butwidth
    button .w.harmonic_minor -text "harmonic minor" -command "verify_scale harmonic_minor" -width $butwidth
    button .w.natural_minor -text "natural minor" -command "verify_scale natural_minor" -width $butwidth
    button .w.melodic_minor -text "melodic minor" -command "verify_scale melodic_minor" -width $butwidth
    button .w.blues -text blues -command "verify_scale blues" -width $butwidth
    button .w.bebop -text bebop -command "verify_scale bebop" -width $butwidth
    button .w.hungarian -text hungarian -command "verify_scale hungarian" -width $butwidth
    button .w.whole_tone -text "whole tone" -command "verify_scale whole_tone" -width $butwidth
    button .w.pentatonic_maj -text "maj pentatonic" -command "verify_scale pentatonic_maj" -width $butwidth
    button .w.pentatonic_sus -text "sus pentatonic" -command "verify_scale pentatonic_sus" -width $butwidth
    button .w.man_gong -text "man gong" -command "verify_scale man_gong" -width $butwidth
    button .w.ritusen -text ritusen -command "verify_scale ritusen" -width $butwidth
    button .w.pentatonic_min -text "min pentatonic" -command "verify_scale pentatonic_min" -width $butwidth
    button .w.neapolitan -text neapolitan -command "verify_scale neapolitan" -width $butwidth

    button .w.pacn -text "perfect authentic" -command "verify_cadence pacn" -width $butwidth
    button .w.iacn -text "imperfect authentic" -command "verify_cadence iacn" -width $butwidth
    button .w.hcn -text "half cadence" -command "verify_cadence hcn" -width $butwidth
    button .w.pcn -text "plagal cadence" -command "verify_cadence pcn" -width $butwidth
    button .w.dcn -text "deceptive cadence" -command "verify_cadence dcn" -width $butwidth
#end of testframe buttons
}


proc make_interface {} {
    global trainer
    global allintervals
    global interval
    global intervalspaces
    global keyspace
    global instructions
    global lang
    global chordlesson intervallesson duplerhythmlesson compoundrhythmlesson
    global progression_lesson
    global diatoniclesson
    global rseed
    global modescalechords roman
    global reducedfont
    global figbas_inv
    global majormodes exotics
    global sofa_lesson
    global noteid_lesson

    set deg "\u00B0"
    set ww {-width 12}
    # control frame
    frame .f -borderwidth 3 -relief sunken
    pack .f -side top
    # setup exercise menubutton
    eval menubutton .f.exercise -text $lang(exercise) -menu .f.exercise.menu\
            -takefocus 0 $ww -padx 8
    set v .f.exercise.menu
    menu $v -tearoff 0
    $v add radiobutton -label $lang(noteid) \
            -command "setup_exercise_interface noteid"
    $v add radiobutton -label $lang(sofaid) \
            -command "setup_exercise_interface sofaid"
    $v add radiobutton -label $lang(sofadic) \
            -command "setup_exercise_interface sofadic"
    $v add radiobutton -label $lang(sofabadnote) \
            -command "setup_exercise_interface sofabadnote"
    $v add radiobutton -label $lang(sofasing) \
            -command "setup_exercise_interface sofasing"
    $v add radiobutton -label $lang(idinterval) \
            -command "setup_exercise_interface intervals"
    $v add radiobutton -label $lang(idchord) \
            -command "setup_exercise_interface chords"
    $v add radiobutton -label $lang(idchorddia) \
            -command "setup_exercise_interface chordsdia"
    $v add radiobutton -label $lang(idfigbas) \
            -command "setup_exercise_interface idfigbas"
    $v add radiobutton -label $lang(prog) \
            -command "setup_exercise_interface prog"
    $v add radiobutton -label $lang(idkeysig) \
            -command "setup_exercise_interface keysigid"
    $v add radiobutton -label $lang(idscales) \
            -command "setup_exercise_interface scalesid"
    $v add radiobutton -label $lang(idcad) \
            -command "setup_exercise_interface idcad"
    $v add radiobutton -label $lang(singi) \
            -command "setup_exercise_interface sing"
    $v add radiobutton -label $lang(rhythmdic) \
            -command "setup_exercise_interface rhythmdic"
    $v add radiobutton -label $lang(drumseq) \
            -command "setup_exercise_interface drumseq"
    $v add radiobutton -label $lang(settings) \
            -command "advance_settings_config"
    
    
    eval button .f.repeat -text $lang(repeat) -command  repeat  -takefocus 0 $ww
    eval button .f.config -text $lang(config) -command make_config \
            -takefocus 0 $ww
    label .f.ans -text ""
    
    
    # create lesson menus
    set v .f.lessmenu.chords
    eval menubutton .f.lessmenu  -menu $v -text $lang(lesson) $ww -padx 8
    menu $v -tearoff 0
    for {set i 0} {$i <14} {incr i} {
        $v add radiobutton -label $chordlesson($i) -command "select_chord_lesson $i"
    }
    $v add radiobutton -label $lang(yourown) -command config_your_own_chord_lesson
    
    # diatonic chords
    set v .f.lessmenu.diatonicchords
    menu $v -tearoff 0
    $v add radiobutton -label "triads only" -command "select_diatonic_lesson 0"
    $v add radiobutton -label "major/minor and first inversion" -command "select_diatonic_lesson 1"
    $v add radiobutton -label "major/minor  and 2nd inversion" -command "select_diatonic_lesson 2"
    $v add radiobutton -label "major/minor and their inversions" -command "select_diatonic_lesson 4"
    $v add radiobutton -label "triads and their inversions" -command "select_diatonic_lesson 5"
    $v add radiobutton -label "major/minor and their 7ths" -command "select_diatonic_lesson 6"
    $v add radiobutton -label "aug dim and 1st inversion" -command "select_diatonic_lesson 7"
    $v add radiobutton -label "maj/min/aug/dim and their 7ths" -command "select_diatonic_lesson 7"
    $v add radiobutton -label $lang(yourown) -command config_your_own_diatonic_lesson
    
    
    
    set v .f.lessmenu.intervals
    menu $v -tearoff 0
    for {set i 0} {$i <18} {incr i} {
        set templesson ""
        foreach t $intervallesson($i) {
            append templesson " $lang($t)" }
        $v add radiobutton -label $templesson -command "select_interval_lesson $i"
    }
    $v add radiobutton -label $lang(yourown) -command config_your_own_interval_lesson
    
    set v .f.lessmenu.duplerhythms
    menu $v -tearoff 0
    for {set i 0} {$i < 8} {incr i} {
        $v add radiobutton -label "$lang(level) $i" -command "select_rhythm_lesson $i"
    }
    $v add radiobutton -label $lang(compound) -command {
        set trainer(timesigtype) 1
        rhythm_switch_type
        switch_rhythm_lesson_menu}
    $v add radiobutton -label $lang(yourown) -command config_your_own_rhythm_lesson
    
    set v .f.lessmenu.compoundrhythms
    menu $v -tearoff 0
        $v add radiobutton -label "$lang(level) $i" -command "select_rhythm_lesson $i"
    $v add radiobutton -label $lang(duple) -command {
        set trainer(timesigtype) 0
        rhythm_switch_type
        switch_rhythm_lesson_menu}
    $v add radiobutton -label $lang(yourown) -command config_your_own_rhythm_lesson
    
    set v .f.lessmenu.melody
    menu $v -tearoff 0
    for {set i 0} {$i < 10} {incr i} {
        $v add radiobutton -label "$sofa_lesson($i)" -command "select_sofa_lesson $i"
    }
    $v add radiobutton -label "$lang(yourown)" -command config_your_own_sofa_lesson

    set v .f.lessmenu.progression
    menu $v -tearoff 0
    for {set i 0} {$i < 10} {incr i} {
        $v add radiobutton -label $progression_lesson($i) -command "select_progression_lesson $i"
        }

    set v .f.lessmenu.scales
    menu $v -tearoff 0
    $v add radiobutton -label "basic scales"  -command "select_scale_lesson basicscales"
    $v add radiobutton -label "major modes"  -command "select_scale_lesson majormodes"
    $v add radiobutton -label "exotic scales" -command "select_scale_lesson exotics"
    $v add radiobutton -label $lang(yourown) -command config_your_own_scale_lesson
    
    set v .f.lessmenu.keysig
    menu $v -tearoff 0
    $v add radiobutton -label "|#,b| < 2" -command "select_keysig_lesson 2"
    $v add radiobutton -label "|#,b| < 3" -command "select_keysig_lesson 3"
    $v add radiobutton -label "|#,b| < 4" -command "select_keysig_lesson 4"
    $v add radiobutton -label "|#,b| < 5" -command "select_keysig_lesson 5"
    $v add radiobutton -label "|#,b| < 6" -command "select_keysig_lesson 6"
    $v add radiobutton -label "|#,b| < 7" -command "select_keysig_lesson 7"
    $v add radiobutton -label "|#,b| < 8" -command "select_keysig_lesson 8"
    $v add radiobutton -label $lang(yourown) -command "config_your_own_keysig"

    set v .f.lessmenu.cadence
    menu $v -tearoff 0
    $v add radiobutton -label major -command "calculate_mode_cadences 0"
    $v add radiobutton -label minor -command "calculate_mode_cadences 5"
    $v add radiobutton -label dorian -command "calculate_mode_cadences 1"

    set v .f.lessmenu.noteid
    menu $v -tearoff 0
    for {set i 0} {$i < 6} {incr i} {
      $v add radiobutton -label $noteid_lesson($i) -command "select_noteid_lesson $noteid_lesson($i)"
      }
    
    switch $trainer(exercise) {
        "chordsdia" { .f.lessmenu configure -menu .f.lessmenu.diatonicchords }
    
        "intervals" -
        "sing"     { .f.lessmenu configure -menu .f.lessmenu.intervals }
    
        "rhythmdic" { if {!$trainer(timesigtype)} {
                      .f.lessmenu configure -menu .f.lessmenu.duplerhythms
                       } else {
                      .f.lessmenu configure -menu .f.lessmenu.compoundrhythms
                       }
                    }
    
        "keysigid" { .f.lessmenu configure -menu .f.lessmenu.keysig }
    

        "scalesid" { .f.lessmenu configure -menu .f.lessmenu.scales }
    
        "idcad" { .f.lessmenu configure -menu .f.lessmenu.cadence }
        "noteid" { .f.lessmenu configure -menu .f.lessmenu.noteid}
        }
 
    button .f.help -text $lang(help) -takefocus 0 -width 12\
            -command helpwindow 
    eval button .f.new -text $lang(new) -command next_test  -takefocus 0 $ww
    eval button .f.stats -text $lang(stats) -takefocus 0 $ww\
            -command make_stats_window
    eval button .f.giveup -text $lang(answer)  -command reveal_chord\
            -takefocus 0 $ww
    eval button .f.exit -text $lang(exit)  -takefocus 0 $ww\
            {-command {write_ini_file tksolfege.ini
                    if {[info exist loghandle]} {close $loghandle}
                    exit}}
    frame .f.response  -borderwidth 2 -relief sunken -borderwidth 2
    label .f.response.1 -text "" -width 1 -width 3
    label .f.response.2 -text "" -width 2 -font $reducedfont
    pack .f.response.1 .f.response.2 -side left
    button .f.submit -text $lang(submit) -takefocus 0 -width 8 -command verify_figbass
    button .f.musicscale -text "$trainer(key) $lang($trainer(mode))" -width 8 \
            -command play_selected_scale

    eval button .f.fast -text $lang(fast) -takefocus 0 $ww\
            {-command fasterdrum}
    eval button .f.slow -text $lang(slow) -takefocus 0 $ww\
            {-command slowerdrum}
    eval button .f.test -text test -takefocus 0 $ww\
            {-command {playdrum_input 0}}
    
    
    grid .f.new .f.repeat .f.giveup
    grid .f.exercise .f.lessmenu .f.config
    grid .f.stats .f.help .f.exit
    grid .f.response .f.submit .f.musicscale -row 3
    
    # test frame
    
    
    foreach intvl $allintervals space $intervalspaces {
        set keyspace($intvl) $space
    }
    
button .f.rseedbut -text $lang(resetseed) -width 12 -command reset_random_seed
entry .f.rseed -width 8 -textvariable rseed -vcmd {Validchar %P} \
                -validate all
button .f.newseed -text $lang(newseed) -command {
         make_random_seed
         reset_random_seed
         }

    if {$trainer(repeatability)} {
        grid .f.rseedbut .f.rseed .f.newseed
        }
    
    grid .f.ans -columnspan 3
    
    frame .b
    for {set i 0} {$i < 7} {incr i} {
        if {$modescalechords($i) == "maj"} {set upper 1} else {set upper 0}
        set fig $roman($i)
        if {$upper} {set fig [string toupper $fig]}
        if {$modescalechords($i) == "dim"} {set fig $fig$deg}
        button .b.$i -text $fig -command "handle_input_figbass $fig $i"
        grid  .b.$i -row 0 -column $i
    }
    
    frame .c
    radiobutton .c.s -text "" -command "update_inv 0" -value "" -variable figbas_inv
    radiobutton .c.sinv1 -text "6\n3" -command "update_inv 6-3" -value inv1 -variable figbas_inv
    radiobutton .c.sinv2 -text "6\n4" -command "update_inv 6-4" -value inv2 -variable figbas_inv
    radiobutton .c.s7  -text "7\n " -command "update_inv 7-0" -value 7 -variable figbas_inv
    radiobutton .c.s7inv1 -text "6\n5" -command "update_inv 6-5" -value 7inv1 -variable figbas_inv
    radiobutton .c.s7inv2 -text "4\n3" -command "update_inv 4-3" -value 7inv2 -variable figbas_inv
    radiobutton .c.s7inv3 -text "4\n2" -command "update_inv 4-2" -value 7inv3 -variable figbas_inv
    grid .c.s .c.sinv1 .c.sinv2 .c.s7 .c.s7inv1 .c.s7inv2 .c.s7inv3
set figbas_inv ""

set v .f.lessmenu.drum
menu $v -tearoff 0
$v add radiobutton -label "from file" -command {set trainer(drumsrc) file
					switch_config_sheet}
$v add radiobutton -label "randomly generated"\
 -command {setup_random_drum_trainer}
}


proc select_noteid_lesson {lesson} {
global trainer
#puts "select_noteid_lesson $lesson"
set midipitchbot [list 62 76 50 46 54 30]
switch $lesson {
  treble {set i 0}
  treble+ {set i 1}
  treble- {set i 2}
  bass {set i 3}
  bass+ {set i 4}
  bass- {set i 5}
  }
set trainer(minpitch) [lindex $midipitchbot $i]
set trainer(maxpitch) [expr $trainer(minpitch) + 12]
if {$i > 2} {set trainer(clefcode) 2
 } else {
        set trainer(clefcode) 0
        }
notelist_interface
#puts "pitch range $trainer(minpitch) $trainer(maxpitch)"
}



# Part 9.0 setup drums, figured bass, chords

proc setup_random_drum_trainer {} {
global trainer
set trainer(drumsrc) random
switch_config_sheet
setdrumstruct $trainer(rbeats) $trainer(rres)
numdrumlines $trainer(rndrums)
setdrumarrg $trainer(rarrg)
}



proc handle_input_figbass {s degree} {
global submitted_figbass root figbas_inv
if {![info exist root]} {
  .f.ans configure -text "First press new button"
  return
  }
.f.response.1 configure -text $s
set submitted_figbass $degree
play_selected_fig_bass
}

proc play_selected_fig_bass {} {
global submitted_figbass
global figbas_inv
global trainer
global scaleoffsets
global modescalechords
if {!$trainer(autoplay) || ($trainer(testmode) == "visual")} return
set midikey [note2midi $trainer(key)]
set range_center [expr $trainer(minpitch) + $trainer(range)/2]
set midikey [expr ($range_center/12)*12 + $midikey]
if {$submitted_figbass > 0} {
  set pitchshift [lindex $scaleoffsets [expr $submitted_figbass -1]] 
  set midipitch [expr $midikey + $pitchshift]} else {
  set midipitch $midikey}
set chordlist [make_chordlist $midipitch $modescalechords($submitted_figbass)$figbas_inv]
playchord $chordlist $trainer(playmode)
}

array set spreaderfunc {0 {0 0 0 1} 1 {0 0 1 1} 2 {0 1 0 1} 3 {0 1 1 1}}

proc pick_spreader {} {
global spreaderfunc
global spreader
set i [random_number 4]
set spreader $spreaderfunc($i)
}

proc chord_spreader {chordlist} {
global spreader
pick_spreader
set newchordlist {}
if {[llength $chordlist] < 4} {set bass [lindex $chordlist 0]
        incr bass 12        
        lappend chordlist $bass
        }
foreach note $chordlist shift $spreader {
  if {$shift > 0} {
     set note [expr $note + $shift*12]
     }
  lappend newchordlist $note
  }
set newchordlist [lsort $newchordlist]
return $newchordlist
}

proc update_inv {s} {
    set s [string map {- \n 0 " "} $s]
    .f.response.2 configure -text $s
}

# Part 10.0 exercise interface

proc setup_exercise_interface {exercise} {
    global trainer
    global lang
    global ntrials ncorrect nrepeats
    global ttype
    global keysf
    .f.ans config -font $trainer(font)
    
    set ttype none
    
    set ntrials 0
    set ncorrect 0
    set nrepeats 0
    
    set trainer(exercise) $exercise
    if {[winfo exist .config]} {switch_config_sheet}
    
    destroy .s
    pack forget .w
    pack forget .b
# scale types for this lesson
    pack forget .c
    pack forget .k
    #pack forget .dorayme
    destroy .dorayme
    destroy .w
    pack forget .doraysing
    pack forget .rhythm
    pack forget .drumenu
    pack forget .drumseq
    #pack forget .pr
    pack forget .proginterface
    destroy .notebuttons

    destroy .msg
    grid forget .f.response .f.submit .f.musicscale
    grid forget .f.fast .f.slow .f.test
    if {[winfo exist .ownlesson]} {destroy .ownlesson}
    deactivate_cmplx_checkbutton 
    make_testframe_buttons 
    remove_scale_buttons
    remove_cadence_buttons
    remove_interval_buttons
    remove_chord_buttons
    if {$trainer(exercise) == "chords" ||
        $trainer(exercise) == "chordsdia"} {
        set n [llength $trainer(chordtypes)]
        set m [expr $n/2]
        if {[expr $n % 2] == 1} {incr m}
        set i 0
        foreach type $trainer(chordtypes) {
            set col [expr $i / $m]
            set row [expr $i % $m]
            grid .w.$type -row $row -column $col
            if {[lsearch {auginv1 auginv2 dim7inv1 dim7inv2 dim7inv3 aug7inv1 aug7inv2 aug7inv3} $type] > -1} {
                if {$trainer(testmode) == "aural"} {
                    .w.$type configure -state disable
                } else {
                    .w.$type configure -state normal
                }
            }
            incr i
        }
        zero_chord_confusion_matrix
        if {[winfo exist .stats]} make_stats_window
        
        .f.giveup configure -command reveal_chord
        .f.lessmenu configure -menu .f.lessmenu.chords
        if {[winfo exist .rhythm]} {pack forget .rhythm}
        pack forget .f
        pack .f -side top
        pack .w -after .f -side bottom
        .f.ans configure -text $lang(idchord)
        if {$trainer(exercise) == "chords"} {deactivate_mode_keysig
                                             set keysf 0}
        activate_cmplx_checkbutton 
    }

    if {$trainer(exercise) == "idcad"} {
       .f.giveup configure -command reveal_cadence
       .f.ans configure -text $lang(idcad)
       .f.lessmenu configure -menu .f.lessmenu.cadence
       set i 0
       foreach type $trainer(cadences) {
            set row [expr $i / 2]
            set col [expr $i % 2]
            grid .w.$type -row $row -column $col
            incr i
         }
       pack forget .f
       pack .f -side top
       pack .w -after .f -side bottom
       zero_cadence_confusion_matrix
     }                 

    
    if {$trainer(exercise) == "chordsdia"} {
        .f.lessmenu configure -menu .f.lessmenu.diatonicchords
        .f.ans configure -text $lang(idchorddia)
        pack .w -after .f -side bottom
        activate_mode_keysig
        initialize_scalenotelist
        select_diatonic_lesson 0
        key_to_sf $trainer(key)
    }
    
    if {$trainer(exercise) == "intervals" ||
        $trainer(exercise) == "sing"} {
        frame .s
        canvas .s.c -width 140 -height 140
        label .s.l  -text ""
        pack .s.c .s.l
        set n [llength $trainer(intervaltypes)]
        set m [expr $n / 3]
        if {[expr $n % 3]} {incr m}
        set i 0
        foreach type $trainer(intervaltypes) {
            set row [expr $i % $m]
            set col [expr $i / $m]
            grid .w.$type -row $row -column $col
            incr i
        }
        zero_interval_confusion_matrix
        if {[winfo exist .stats]} make_stats_window
        #remove_scale_buttons
        .f.giveup configure -command reveal_interval
        .f.lessmenu configure -menu .f.lessmenu.intervals
        if {[winfo exist .rhythm]} {pack forget .rhythm}
        pack forget .f
        pack .f -side top
        pack .w -after .f
        set keysf 0

        if {$trainer(exercise) == "sing"} {
            .f.ans configure -text $lang(singi)
        } else {
            .f.ans configure -text $lang(idinterval)
        }


    }



    if {$trainer(exercise) == "rhythmdic"} {
        .f.giveup configure -command show_rhythm_answer
        pack forget .f
        pack .f -side left
        pack .rhythm
        pack forget .w
        .f.ans configure -text $lang(rhythmdic)
        switch_rhythm_lesson_menu
    }
    
    if {$trainer(exercise) == "sofadic"} {
        .f.giveup configure -command show_sofa_answer
        pack forget .f
        pack forget .w
        pack forget .rhythm
        pack .f -side left
        destroy .dorayme
        startup_sofa_dictation
        .f.ans configure -text $lang($trainer(exercise))
        switch_sofa_lesson_menu
        set ntrials 0
        set ncorrect 0
        set nrepeats 0
        pack .dorayme.ctl.submit
    }

    if {$trainer(exercise) == "sofaid"} {
        .f.giveup configure -command show_sofa_answer
        pack forget .f
        pack forget .w
        pack forget .rhythm
        pack .f -side left
        destroy .dorayme
        startup_sofa_dictation
        .f.ans configure -text $lang($trainer(exercise))
        pack .dorayme.ctl.playscale
        pack forget .dorayme.ctl.submit
        switch_sofa_lesson_menu
        set ntrials 0
        set ncorrect 0
        set nrepeats 0
    }

    if {$trainer(exercise) == "sofabadnote"} {
        .f.giveup configure -command show_sofa_answer
        pack forget .f
        pack forget .w
        pack forget .rhythm
        pack .f -side left
        pack .doraysing -side right
        .f.ans configure -text $lang($trainer(exercise))
        .f.giveup configure -command reveal_sofabadnote
        switch_sofa_lesson_menu
        set ntrials 0
        set ncorrect 0
        set nrepeats 0
        }

    
    if {$trainer(exercise) == "sofasing"} {
        .f.giveup configure\
                -command {show_sing_sofa
                    play_sofa}
        pack forget .f
        pack forget .w
        pack forget .rhythm
        pack .f -side left
        pack .doraysing -side right
        .f.ans configure -text $lang($trainer(exercise))
        switch_sofa_lesson_menu
        .doraysing.msg configure -text "click on new button to start "
        set nrepeats 0}

    if {$trainer(exercise) == "noteid"} {
        .f.giveup configure -command show_note_ids
        pack forget .f
        pack forget .w
        pack forget .rhythm
        pack .f -side left
        pack .doraysing -side right
        .f.ans configure -text $lang($trainer(exercise))
        .f.lessmenu configure -menu .f.lessmenu.noteid
        #switch_sofa_lesson_menu
        test_noteid
        set nrepeats 0}
    
    if {$trainer(exercise) == "keysigid"} {
        pack forget .f
        pack .f -side top
        pack .k -after .f -side bottom
        .f.ans configure -text $lang(idkeysig)
        .f.giveup configure -command reveal_keysig
        set keysf 0
        switch_keysig_lesson_menu
    }

   if {$trainer(exercise) == "scalesid"} {
         #remove_interval_buttons
        .f.giveup configure -command reveal_scale
        #frame .s
        #canvas .s.c -width 140 -height 140
        #pack .s.c
        #pack .s
        set i 0
        foreach type $trainer(scaletypes) {
            set col [expr $i % 2]
            set row [expr $i / 2]
            grid .w.$type -row $row -column $col
            incr i
            }
        pack forget .f
        pack .f -side top
        pack .w -after .f -side bottom
       .f.ans configure -text $lang(scaleid)
       .f.lessmenu configure -menu .f.lessmenu.scales
        zero_scales_confusion_matrix
   }

    if {$trainer(exercise) == "prog"} {
       .f.ans configure -text $lang(prog)
       .f.giveup configure -command reveal_progression
       .f.lessmenu configure -menu .f.lessmenu.progression
       #place_chordprog_buttons 
       place_progressions_buttons 
    }
    
    if {$trainer(exercise) == "idfigbas"} {
        pack forget .f
        pack .f -side top
        pack .b -side top
        pack .c -side top
        frame .s
        canvas .s.c -width 140 -height 140
        label .s.l  -text ""
        pack .s.c .s.l
        .f.ans configure -text $lang(idfigbas)
        .f.lessmenu configure -menu .f.lessmenu.diatonicchords
        activate_mode_keysig
        activate_cmplx_checkbutton 
        initialize_scalenotelist
        update_roman_representation
        key_to_sf $trainer(key)
        zero_figbass_confusion_matrix
        if {[winfo exist .stats]} make_stats_window
        grid .f.response .f.submit .f.musicscale -row 3
    }

   if {$trainer(exercise) == "drumseq"} {
      #pack .drumenu -side right
      grid .f.fast .f.slow .f.test -row 3
      .f.giveup configure -command {plotdrumseq
                              checkdrumseq}
      pack forget .f
      pack .f -side left
      pack .drumseq -side right
     .f.ans configure -text $lang(drumseq)
     .f.lessmenu configure -menu .f.lessmenu.drum
      setup_random_drum_trainer
#     test_drumseq
      drumseq_banner
      }
}


proc switch_rhythm_lesson_menu {} {
    global trainer
    if {$trainer(timesigtype)} {
        .f.lessmenu configure -menu .f.lessmenu.compoundrhythms
        make_rhythm_list
        place_rhythm_buttons
    } else {
        .f.lessmenu configure -menu .f.lessmenu.duplerhythms
        make_rhythm_list
        place_rhythm_buttons
    }
}

proc switch_sofa_lesson_menu {} {
    .f.lessmenu configure -menu .f.lessmenu.melody
}

proc switch_keysig_lesson_menu {} {
    .f.lessmenu configure -menu .f.lessmenu.keysig
}

# Part 11.0 Keysig support

proc label_keysig {key} {
    global majscale
    global trainer
    global scaleoffsets
    global lang
    set w .config.main
    set scaleoffsets [make_scale_midi_offsets $trainer(mode)]
    $w.keysig configure -text $key
    make_scalenotelist $key
    set trainer(key) $key
    .f.musicscale configure -text "$trainer(key) $lang($trainer(mode))"
    key_to_sf $key
    }

proc key_to_sf {key} {
global keysiglist keysf
global trainer
if {![info exist keysiglist]} {make_keysiglist $trainer(mode)}
set keysf [lsearch $keysiglist $key]
if {$keysf < 0} {puts "label_keysig:no such key $"}
incr keysf -7
}


proc modify_keysigmenu {mode} {
    global keysiglist
    global lang
    global scaleoffsets
    global trainer
    set w .config.main
    $w.modebutton configure -text $lang($mode)
    set v $w.keysig.keymenu
    $v delete 0 15
    foreach key $keysiglist {
        $v add radiobutton -label $key -command "label_keysig $key"
    }
    set scaleoffsets [make_scale_midi_offsets $mode]
    update_roman_representation
    .f.musicscale configure -text "$trainer(key) $lang($trainer(mode))"
}

set scaleincrements {2 2 1 2 2 2 1 2 2 1 2 2 2 1}
array set majorminchords {0 maj 1 min 2 min 3 maj 4 maj 5 min 6 dim
    7 maj 8 min 9 min 10 maj 11 maj 12 min}


# The order of tones and semitones in a diatonic scale depends
# upon the mode and is stored in the list midi_offsets.
proc make_scale_midi_offsets {mode} {
    global scaleincrements
    global majorminchords
    global modescalechords
    set shift [lsearch {maj dor phr lyd mix min minhar minmel} $mode]
    if {$shift == 6 || $shift == 7} {set shift 5}
    if {$shift < 0} {puts "no such mode $mode"
        return -1;}
    set i0 $shift
    set i1 [expr $shift + 5]
    set offsetlists [lrange $scaleincrements $i0 $i1]
    for {set j 0} {$j < 7} {incr j} {
        set modescalechords($j) $majorminchords([expr $j + $shift])
    }
    if {$mode == "minhar"} {
        set modescalechords(2) aug
        set modescalechords(4) maj
        set modescalechords(6) dim
        set offsetlists [lreplace $offsetlists 5 5 3 ]
    } elseif {$mode == "minmel"} {
        array set modescalechords {
            1 min 2 aug 3 maj 4 maj 5 dim 6 dim}
        set offsetlists [lreplace $offsetlists 4 5 2 2]
    }
    set midi_offsets {}
    set offset 0
    foreach elem $offsetlists {
        incr offset $elem
        lappend midi_offsets $offset
    }
    return $midi_offsets
}

# Part 12.0 Figured Bass support

# The Figured Bass representation needs to be updated any
# time the key signature mode is changed.
proc update_roman_representation {} {
    global modescalechords roman
    global figbass_symbol root
    set deg "\u00B0"
    set plus "+"
    for {set i 0} {$i < 7} {incr i} {
        set upper 0
        if {$modescalechords($i) == "maj"} {set upper 1}
        if {$modescalechords($i) == "aug"} {set upper 1}
        set fig $roman($i)
        if {$upper} {set fig [string toupper $fig]}
        if {$modescalechords($i) == "dim"} {set fig $fig$deg}
        if {$modescalechords($i) == "aug"} {set fig $fig$plus}
        .b.$i configure -text $fig -command "handle_input_figbass $fig $i"
        set figbass_symbol($i) $fig
    }
}

# Whenever the user changes the mode or key of the key signature
# it is necessary to update diatonicscalelist so that a new
# test chord can be selected correctly. This is done by adding
# offsets to the tonic note from the list scaleoffsets. The
# scaleoffsets depends upon the mode (major, minor, etc.) so
# it has to be updated any time the mode is changed using the
# procedure make_scale_midi_offsets (see above).
proc make_scalenotelist {tonic} {
    global diatonicscalelist
    global scaleoffsets
    set miditonic [note2midi $tonic]
    set diatonicscalelist $miditonic
    foreach note $scaleoffsets {
        set nextnote [expr ($miditonic + $note) % 12]
        lappend diatonicscalelist $nextnote
    }
    return $diatonicscalelist
}

proc initialize_scalenotelist {} {
    global trainer
    global majscale
    global diatonicscalelist
    global scaleoffsets
    set miditonic [note2midi $trainer(key)]
    set diatonicscalelist $miditonic
    foreach note $scaleoffsets {
        set nextnote [expr ($miditonic + $note) % 12]
        lappend diatonicscalelist $nextnote
    }
}

# Part 13.0 Configuration support


# This procedure creates all the configuration windows used
# by tksolfege. Configuration windows are switched using
# the procedure switch_config_sheet.

proc make_config {} {
    global trainer
    global patches
    global lang
    global keysiglist
    
    
    if {[winfo exist .config]} return
    set w .config
    toplevel .config
    positionWindow .config
    frame .config.main
    set w .config.main
    label $w.instrlab -text $lang(instrument)
    
    button $w.instrbut -text $patches($trainer(instrument)) \
            -command main_prog_dialog
    
    label $w.vellab -text $lang(velocity)
    scale $w.velsca -from 0 -to 100 -variable trainer(velocity)\
            -length 128 -orient hor -width 10
    label $w.lowpitchlab -text $lang(lowest)
    scale $w.lowpitchsca -from 11 -to 120 -variable trainer(minpitch)\
            -length 128 -orient hor -width 10 -command change_range
    set lowpitch [midi2notename $trainer(minpitch)]
    label $w.lowpitchname -text $lowpitch -width 3
    label $w.highpitchlab -text $lang(highest)
    scale $w.highpitchsca -from 11 -to 120 -variable trainer(maxpitch)\
            -length 128 -orient hor -width 10 -command change_range
    set highpitch [midi2notename $trainer(maxpitch)]
    label $w.highpitchname -text $highpitch -width 3
    label $w.notedurlab -text $lang(duration)
    scale $w.notedursca -from 100 -to 1500 -variable trainer(msec)\
            -length 128 -orient hor -width 10
    checkbutton $w.autonew -variable trainer(autonew) -text $lang(auton)
    checkbutton $w.autoplay -variable trainer(autoplay) -text $lang(autop)
    
    radiobutton $w.up -text $lang(up) -value up -variable trainer(direction) \
            -takefocus 0
    radiobutton $w.down -text $lang(down) -value down \
            -variable trainer(direction) -takefocus 0
    radiobutton $w.either -text $lang(either) -value either \
            -takefocus 0 -variable trainer(direction)
    
    
    radiobutton  $w.melodic -text $lang(melodic)  -variable trainer(playmode) \
            -value melodic
    radiobutton $w.harmonic -text $lang(harmonic)  -variable trainer(playmode) \
            -value harmonic
    radiobutton $w.both     -text $lang(both)  -variable trainer(playmode)\
            -value  both
    
    radiobutton $w.aural -text $lang(aural) -variable trainer(testmode)\
            -value aural -command {pack forget .s
                enable_disable_aug_dim
            }
    radiobutton $w.visual -text $lang(visual) -variable trainer(testmode)\
            -value visual -command enable_disable_aug_dim
    radiobutton $w.2ways -text $lang(both) -variable trainer(testmode)\
            -value both -command enable_disable_aug_dim
    
    
    menubutton $w.modebutton  -menu $w.modebutton.modemenu -text $lang($trainer(mode))\
            -width 12
    set v $w.modebutton.modemenu
    menu $v -tearoff 0
    $v add radiobutton -label $lang(maj) -command {make_keysiglist maj
        modify_keysigmenu maj}
    $v add radiobutton -label $lang(dor) -command {make_keysiglist dor
        modify_keysigmenu dor}
    $v add radiobutton -label $lang(phr) -command {make_keysiglist phr
        modify_keysigmenu phr}
    $v add radiobutton -label $lang(lyd) -command {make_keysiglist lyd
        modify_keysigmenu lyd}
    $v add radiobutton -label $lang(mix) -command {make_keysiglist mix
        modify_keysigmenu mix}
    $v add radiobutton -label $lang(min) -command {make_keysiglist min
        modify_keysigmenu min}
    $v add radiobutton -label $lang(minhar) -command {make_keysiglist minhar
        modify_keysigmenu minhar}
    $v add radiobutton -label $lang(minmel) -command {make_keysiglist minmel
        modify_keysigmenu minmel}
    
    eval menubutton $w.keysig -menu $w.keysig.keymenu -text C -width 4
    set v $w.keysig.keymenu
    menu $v -tearoff 0
    foreach key $keysiglist {
        $v add radiobutton -label $key -command "label_keysig $key"
    }
    checkbutton $w.cmplx -text "complex chord" -variable trainer(xchord)
    
    grid $w.instrlab $w.instrbut
    grid $w.vellab $w.velsca
    grid $w.lowpitchlab $w.lowpitchsca $w.lowpitchname
    grid $w.highpitchlab $w.highpitchsca $w.highpitchname
    grid $w.notedurlab $w.notedursca
    grid $w.up $w.down $w.either -sticky w
    grid $w.melodic $w.harmonic $w.both -sticky w
    grid $w.autonew $w.autoplay -sticky w
    grid $w.aural $w.visual $w.2ways -sticky w
    
    grid $w.modebutton $w.keysig $w.cmplx
    
    make_config_rhythm
    make_config_sofa
    make_config_sofasing
    make_config_keysig
    make_config_file_drumseq
    make_config_random_drumseq
    make_config_sofa_id
    make_config_progression 
    make_config_notation
    label_keysig $trainer(key)
    
    switch_config_sheet
}

proc set_max_bars {n} {
    global trainer
    set maxbars [expr 18/$n]
    .config.rhythm.barsca configure  -to $maxbars
    reset_rhythm_melody_stats
}

proc make_config_rhythm {} {
    global lang trainer patches
    set w .config.rhythm
    frame $w
    pack $w
    label $w.bpm -text $lang(bpm)
    scale $w.bpmsca -from 20 -to 120 -variable trainer(rhythmbpm)\
            -length 128 -orient hor -width 10
    
    label $w.beatsperbar -text $lang(beatsperbar)
    scale $w.beatsbarsca -from 1 -to 4 -variable trainer(rhythm_beats_per_bar)\
            -length 128 -orient hor -width 10 -command set_max_bars
    
    label $w.bars -text $lang(bars)
    scale $w.barsca -from 1 -to 4 -variable trainer(rhythm_bars)\
            -length 128 -orient hor -width 10 -command reset_rhythm_melody_stats
    
    label $w.norest -text $lang(norest)
    checkbutton $w.norestbut -variable trainer(norest)
    
    button $w.leadinstrbut -text $patches($trainer(leaderinstrument)) \
            -command leader_prog_dialog
    label $w.leader -text $lang(leader)
    
    button $w.rhyminstrbut -text $patches($trainer(rhythminstrument)) \
            -command rhythm_prog_dialog
    label $w.rhythm -text $lang(rhythminstr)
    
    label $w.pitch -text $lang(pitch)
    scale $w.pitchsca -from 0 -to 127 -variable trainer(rhythmpitch)\
            -length 128 -orient hor -width 10 -command reset_rhythm_melody_stats
    
    label $w.velocity -text $lang(velocity)
    scale $w.midivol -from 0 -to 100 -variable trainer(rhythmvelocity)\
            -length 128 -orient hor -width 10
    
    label $w.accent -text $lang(accent)
    scale $w.accsca -from 0 -to 50 -variable trainer(rhythm_accent)\
            -length 128 -orient hor -width 10 -command reset_rhythm_melody_stats
    
    
    grid $w.bpm $w.bpmsca
    grid $w.beatsperbar $w.beatsbarsca
    grid $w.bars $w.barsca
    grid $w.leader $w.leadinstrbut
    grid $w.rhythm $w.rhyminstrbut
    grid $w.pitch $w.pitchsca
    grid $w.velocity $w.midivol
    grid $w.accent $w.accsca
    grid $w.norest $w.norestbut
}


proc make_config_sofa {} {
    global lang trainer
    global patches
    set w .config.sofa
    frame $w
    label $w.nnotes -text $lang(nnotes)
    scale $w.nnotesca -from 1 -to 16 -variable trainer(sofa_notes)\
            -length 128 -orient hor -width 10 -command reset_rhythm_melody_stats
    label $w.pitch -text $lang(pitch)
    scale $w.pitchsca -from 0 -to 127 -variable trainer(sofa_tonic)\
            -length 128 -orient hor -width 10 -command update_note_label
    set note [midi2notename $trainer(sofa_tonic)]
    label $w.pitchval -text $note -width 4
    label $w.tonic -text $lang(smallint)
    checkbutton $w.toniccheck -variable trainer(smallint)
    label $w.instrlab -text $lang(instrument)
    button $w.instrbut -text $patches($trainer(instrument)) \
            -command sofa_prog_dialog
    label $w.vellab -text $lang(velocity)
    scale $w.velsca -from 0 -to 100 -variable trainer(velocity)\
            -length 128 -orient hor -width 10
    label $w.notedurlab -text $lang(duration)
    scale $w.notedursca -from 100 -to 1500 -variable trainer(msec)\
            -length 128 -orient hor -width 10

    
    grid $w.nnotes $w.nnotesca
    grid $w.pitch $w.pitchsca $w.pitchval
    grid $w.tonic $w.toniccheck
    grid $w.instrlab $w.instrbut
    grid $w.vellab $w.velsca
    grid $w.notedurlab $w.notedursca
}

proc make_config_sofa_id {} {
    global lang trainer
    global patches
    set w .config.sofaid
    frame $w

    label $w.playtoniclab -text "play tonic"
    checkbutton $w.playtonic -variable trainer(repeattonic) -text $lang(repeaton)
    label $w.pitch -text $lang(pitch)
    scale $w.pitchsca -from 0 -to 127 -variable trainer(sofa_tonic)\
            -length 128 -orient hor -width 10 -command update_note_label
    set note [midi2notename $trainer(sofa_tonic)]
    label $w.pitchval -text $note -width 4
    label $w.instrlab -text $lang(instrument)
    button $w.instrbut -text $patches($trainer(instrument)) \
            -pady 2 -command sofa_id_prog_dialog
    label $w.vellab -text $lang(velocity)
    scale $w.velsca -from 0 -to 100 -variable trainer(velocity)\
            -length 128 -orient hor -width 10
    label $w.notedurlab -text $lang(duration)
    scale $w.notedursca -from 100 -to 1500 -variable trainer(msec)\
            -length 128 -orient hor -width 10
    checkbutton $w.autonew -variable trainer(autonew) -text $lang(auton)
    grid $w.pitch $w.pitchsca $w.pitchval
    grid $w.vellab $w.velsca
    grid $w.notedurlab $w.notedursca
    grid $w.instrlab $w.instrbut
    grid $w.autonew $w.playtonic
  }

proc make_config_sofasing {} {
global lang trainer
global patches
set w .config.sofasing

frame $w
label $w.nnotes -text $lang(nnotes)
scale $w.nnotesca -from 1 -to 16 -variable trainer(sofa_notes)\
        -length 128 -orient hor -width 10 -command reset_rhythm_melody_stats
grid $w.nnotes $w.nnotesca
label $w.instrlab -text $lang(instrument)
button $w.instrbut -text $patches($trainer(instrument)) \
        -pady 2 -command sofa_id_prog_dialog
grid $w.instrlab $w.instrbut
label $w.vellab -text $lang(velocity)
scale $w.velsca -from 0 -to 100 -variable trainer(velocity)\
        -length 128 -orient hor -width 10
grid $w.vellab $w.velsca
label $w.notedurlab -text $lang(duration)
scale $w.notedursca -from 100 -to 1500 -variable trainer(msec)\
        -length 128 -orient hor -width 10
grid $w.notedurlab $w.notedursca
label $w.clef -text $lang(clef)
eval menubutton $w.clefbutton  -menu $w.clefbutton.clefmenu -text $lang(automatic)
set v $w.clefbutton.clefmenu
menu $v -tearoff 0
  $v add radiobutton -label automatic -command "select_clef -1"
  $v add radiobutton -label $lang(treble) -command "select_clef 0"
  $v add radiobutton -label $lang(alto) -command "select_clef 1"
  $v add radiobutton -label $lang(bass) -command "select_clef 2"
grid  $w.clef $w.clefbutton 
 
eval menubutton $w.pattern -menu $w.pattern.menu -text 0213
    set v $w.pattern.menu
    menu $v -tearoff 0
    $v add radiobutton -label 0123 -command "select_pat 0"
    $v add radiobutton -label 0102 -command "select_pat 1"
    $v add radiobutton -label 0121 -command "select_pat 2"
    $v add radiobutton -label 0213 -command "select_pat 3"
    $v add radiobutton -label 0314 -command "select_pat 4"
    $v add radiobutton -label 0321 -command "select_pat 5"
label $w.patternlab -text "pattern"
grid $w.patternlab $w.pattern 
label $w.transpose -text $lang(transpose)
scale $w.transca -from -12 -to 12 -variable trainer(transpose) -orient hor -width 10
grid $w.transpose $w.transca
}

proc make_config_notation {} {
global lang trainer
global patches
set w .config.notate
frame $w
#label $w.nnotes -text $lang(nnotes)
#scale $w.nnotesca -from 1 -to 10 -variable trainer(sofa_notes)\
        -length 128 -orient hor -width 10 -command reset_rhythm_melody_stats
#grid $w.nnotes $w.nnotesca
#label $w.instrlab -text $lang(instrument)
#button $w.instrbut -text $patches($trainer(instrument)) \
#        -pady 2 -command sofa_id_prog_dialog
#grid $w.instrlab $w.instrbut
#label $w.vellab -text $lang(velocity)
#scale $w.velsca -from 0 -to 100 -variable trainer(velocity)\
#        -length 128 -orient hor -width 10
#grid $w.vellab $w.velsca
#label $w.notedurlab -text $lang(duration)
#scale $w.notedursca -from 100 -to 1500 -variable trainer(msec)\
#        -length 128 -orient hor -width 10
#grid $w.notedurlab $w.notedursca
label $w.lowpitchlab -text $lang(lowest)
set lowpitch [midi2notename $trainer(minpitch)]
label $w.lowpitchname -text $lowpitch -width 3
scale $w.lowpitchsca -from 11 -to 120 -variable trainer(minpitch)\
        -length 128 -orient hor -width 10 -command change_range
grid $w.lowpitchlab $w.lowpitchsca $w.lowpitchname
label $w.highpitchlab -text $lang(highest)
set highpitch [midi2notename $trainer(maxpitch)]
label $w.highpitchname -text $highpitch -width 3
scale $w.highpitchsca -from 11 -to 120 -variable trainer(maxpitch)\
        -length 128 -orient hor -width 10 -command change_range
grid $w.highpitchlab $w.highpitchsca $w.highpitchname
label $w.clef -text $lang(clef)
eval menubutton $w.clefbutton  -menu $w.clefbutton.clefmenu -text $lang(automatic)
set v $w.clefbutton.clefmenu
menu $v -tearoff 0
  $v add radiobutton -label automatic -command "select_clef -1"
  $v add radiobutton -label $lang(treble) -command "select_clef 0"
  $v add radiobutton -label $lang(alto) -command "select_clef 1"
  $v add radiobutton -label $lang(bass) -command "select_clef 2"
grid  $w.clef $w.clefbutton 
radiobutton $w.usesharps -text "use sharps" -value 0 -variable trainer(keysf)
radiobutton $w.useflats -text "use flats" -value -1 -variable trainer(keysf)
grid $w.useflats $w.usesharps
checkbutton $w.autonew -variable trainer(autonew) -text $lang(auton)
grid $w.autonew
}





proc make_config_progression {} {
    global lang trainer
    global patches
    set w .config.progression
    frame $w
    label $w.instrlab -text $lang(instrument)
    button $w.instrbut -text $patches($trainer(instrument)) \
            -pady 2 -command sofa_id_prog_dialog
    label $w.vellab -text $lang(velocity)
    scale $w.velsca -from 0 -to 100 -variable trainer(velocity)\
            -length 128 -orient hor -width 10
    label $w.pitch -text $lang(pitch)
    scale $w.pitchsca -from 40 -to 60 -variable trainer(chordroot) -orient hor -width 10
    label $w.notedurlab -text $lang(duration)
    scale $w.notedursca -from 100 -to 1500 -variable trainer(msec)\
            -length 128 -orient hor -width 10
    radiobutton $w.aural -text $lang(aural) -variable trainer(testmode)\
            -value aural
    radiobutton $w.visual -text $lang(visual) -variable trainer(testmode)\
            -value visual 
    radiobutton $w.2ways -text $lang(both) -variable trainer(testmode)\
            -value both
    radiobutton $w.plain -text $lang(plain) -variable trainer(chordinversion)\
            -value 0
    radiobutton $w.inv1 -text $lang(1stinv) -variable trainer(chordinversion)\
            -value 1 
    radiobutton $w.inv2 -text $lang(2ndinv) -variable trainer(chordinversion)\
            -value 2
    radiobutton  $w.melodic -text $lang(melodic)  -variable trainer(playmode) \
            -value melodic
    radiobutton $w.harmonic -text $lang(harmonic)  -variable trainer(playmode) \
            -value harmonic
    radiobutton $w.both     -text $lang(both)  -variable trainer(playmode)\
            -value  both
    checkbutton $w.shift -text "shift chord" -variable trainer(shiftedchord)
    checkbutton $w.autonew -variable trainer(autonew) -text $lang(auton)
    grid $w.instrlab $w.instrbut
    grid $w.pitch $w.pitchsca 
    grid $w.instrlab $w.instrbut
    grid $w.vellab $w.velsca
    grid $w.notedurlab $w.notedursca
    grid $w.harmonic $w.melodic $w.both
    grid $w.shift $w.autonew
    grid $w.aural $w.visual $w.2ways
    grid $w.plain $w.inv1 $w.inv2
    }



proc update_note_label {pitch} {
    set note [midi2notename $pitch]
    .config.sofa.pitchval configure -text $note
    .config.sofaid.pitchval configure -text $note
}


proc select_clef {clefcode} {
    global lang
    global trainer melodylist
    if {$trainer(exercise) == "sofadic" || $trainer(exercise) == "sofaid"} {return}

    set v .config.sofasing.clefbutton
    switch -- $clefcode {
        -1 {$v config -text $lang(automatic)}
        0 {$v config -text $lang(treble)}
        1 {$v config -text $lang(alto)}
        2 {$v config -text $lang(bass)}
    }
    set trainer(clefcode) $clefcode
    if {$clefcode < 0} {
        if {$trainer(sofa_tonic) < 60} {set clefcode 2
        } else          {set clefcode 0}
    }
    if {![info exist melodylist]} return
    notate_sofa $trainer(sofa_tonic) $clefcode
}

proc deactivate_mode_keysig {} {
    if {![winfo exist .config.main]} return
    .config.main.modebutton configure -state disable
    .config.main.keysig configure -state disable
}

proc activate_mode_keysig {} {
    if {![winfo exist .config.main]} return
    .config.main.modebutton configure -state normal
    .config.main.keysig configure -state normal
}

proc deactivate_cmplx_checkbutton {} {
    if {[winfo exist .config.main]} {
      .config.main.cmplx configure -state disable}
}
   
proc activate_cmplx_checkbutton {} {
    if {[winfo exist .config.main]} {
      .config.main.cmplx configure -state normal}
}

proc switch_config_sheet {} {
    global trainer
    if {![winfo exist .config]} return
    pack forget .config.main
    pack forget .config.sofa
    pack forget .config.sofasing
    pack forget .config.sofaid
    pack forget .config.rhythm
    pack forget .config.keysig
    pack forget .config.scale_id
    pack forget .config.drumseq
    pack forget .config.rdrumseq
    pack forget .config.progression
    pack forget .config.notate
    switch $trainer(exercise) {
      "rhythmdic" {pack .config.rhythm}
      "sofadic" {pack .config.sofa}
      "sofabadnote" {pack .config.sofa}
      "sofasing" {pack .config.sofasing}
      "sofaid" {pack .config.sofaid}
      "keysig" {pack .config.keysig}
      "prog" {pack .config.progression}
      "noteid" {pack .config.notate}
      "drumseq" {switch_to_drumseq_config}
      default {
        pack .config.main
        if {$trainer(exercise) == "chordsdia" ||
            $trainer(exercise) == "idfigbas"} {
            activate_mode_keysig} else {
            deactivate_mode_keysig
            }
        }
    }
}

proc switch_to_drumseq_config {} {
global trainer
if {$trainer(drumsrc) == "file"} {
      pack .config.drumseq
      } else {
      pack .config.rdrumseq
      }
}



proc change_range {dummy} {
    global trainer
    if {$trainer(maxpitch) < $trainer(minpitch)} {
        .config.main.lowpitchsca set $trainer(maxpitch)}
    if {$trainer(minpitch) > $trainer(maxpitch)} {
        .config.main.highpitchsca set $trainer(minpitch)}
    set trainer(range) [expr $trainer(maxpitch) - $trainer(minpitch)]
    .config.main.lowpitchname config -text [midi2notename $trainer(minpitch)]
    .config.main.highpitchname config -text [midi2notename $trainer(maxpitch)]
}


proc change_instrument {dummy} {
    global trainer
    muzic::channel 0 $trainer(instrument)
}

# Part 14.0 lesson selection

proc select_chord_lesson {num} {
    global chordlesson
    global trainer
    foreach type $trainer(chordtypes) {
        grid forget .w.$type }
    set trainer(chordtypes) $chordlesson($num)
    set n [llength $trainer(chordtypes)]
    set m [expr $n/2]
    if {[expr $n % 2] == 1} {incr m}
    set i 0
    foreach type $trainer(chordtypes) {
        set row [expr $i % $m]
        set col [expr $i / $m]
        grid .w.$type -row $row -column $col
        incr i
    }
    if {[winfo exist .ownlesson]} {config_your_own_chord_lesson}
    zero_chord_confusion_matrix
    if {[winfo exist .stats]} {make_stats_window}
}


proc select_diatonic_lesson {num} {
    global diatoniclesson
    global trainer
    clear_own_diatonic_lessons 
    foreach type $trainer(chordtypes) {
        grid forget .w.$type }
    set trainer(chordtypes) $diatoniclesson($num)
    set n [llength $trainer(chordtypes)]
    set m [expr $n/2]
    if {[expr $n % 2] == 1} {incr m}
    set i 0
    foreach type $trainer(chordtypes) {
        set row [expr $i % $m]
        set col [expr $i / $m]
        grid .w.$type -row $row -column $col
        incr i
    }
    zero_chord_confusion_matrix
    if {[winfo exist .stats]} {make_stats_window}
}


proc select_interval_lesson {num} {
    global intervallesson
    global trainer
    foreach type $trainer(intervaltypes) {
        grid forget .w.$type }
    set trainer(intervaltypes) $intervallesson($num)
    set n [llength $trainer(intervaltypes)]
    set m [expr $n / 3]
    if {[expr $n % 3]} {incr m}
    set i 0
    foreach type $trainer(intervaltypes) {
        set row [expr $i % $m]
        set col [expr $i / $m]
        grid .w.$type -row $row -column $col
        incr i
    }
    zero_interval_confusion_matrix
    if {[winfo exist .stats]} {make_stats_window}
    if {[winfo exist .ownlesson]} config_your_own_interval_lesson
}

proc select_scale_lesson {scales} {
global trainer
global exotics
global majormodes
global basicscales
foreach type $trainer(scaletypes) {
   grid forget .w.$type }
set trainer(scaletypes) [set $scales]
set i 0
set m 2
foreach type $trainer(scaletypes) {
   set col [expr $i % $m]
   set row [expr $i / $m]
   grid .w.$type -row $row -column $col
   incr i
   }
if {[winfo exist .ownlesson]} config_your_own_scale_lesson
}

proc config_your_own_scale_lesson {} {
    global trainer
    global lang
    global exotics majormodes
    global modesel
    global allmodes
    set allmodes [concat $majormodes $exotics]
    if {[winfo exist .ownlesson]} {destroy .ownlesson}
    set w .ownlesson
    toplevel $w
    positionWindow .ownlesson
    set i 0
    foreach mode $allmodes {
        if {[lsearch $trainer(scaletypes) $mode] != -1} {
            set modesel($mode) 1} else {
            set modesel($mode) 0}
        checkbutton $w.$mode -text $mode -variable modesel($mode) \
                 -command make_scale_lesson
        set row [expr $i /2]
        set col [expr $i % 2]
        grid $w.$mode -row $row -column $col -sticky w
        incr i
    }
}

proc config_your_own_diatonic_lesson {} {
global lang
global figtypecode 
global enlargedfont
global tcl_platform
if {[winfo exist .ownlesson]} {destroy .ownlesson}
set w .ownlesson
toplevel $w
positionWindow .ownlesson
foreach chordtype {"" inv1 inv2 7 7inv1 7inv2 7inv3} {
        checkbutton $w.$chordtype -text "$chordtype \($figtypecode($chordtype)\)"\
         -variable diatonictype($chordtype) -command make_diatonic_lesson
        if {$tcl_platform(platform) == "windows"} {
            $w.$chordtype config -font $enlargedfont}
        grid $w.$chordtype -sticky w
	}
}

proc config_your_own_chord_lesson {} {
    global allchordtypes;
    global chordsel
    global lang
    global trainer
    if {[winfo exist .ownlesson]} {destroy .ownlesson}
    set w .ownlesson
    positionWindow .ownlesson
    toplevel $w
    set i 0
    foreach type $allchordtypes {
        checkbutton $w.$type -text $type -variable chordsel($type) \
                -command make_chord_lesson
        if {[lsearch $trainer(chordtypes) $type] != -1} {
            set chordsel($type) 1} else {
            set chordsel($type) 0}
        incr i
    }
    grid $w.maj $w.majinv1 $w.majinv2 -sticky w
    grid $w.min $w.mininv1 $w.mininv2 -sticky w
    grid $w.dim $w.diminv1 $w.diminv2 -sticky w
    grid $w.aug $w.auginv1 $w.auginv2 -sticky w
    grid $w.majmin $w.majmininv1 $w.majmininv2 $w.majmininv3 -sticky w
    grid $w.maj7 $w.maj7inv1 $w.maj7inv2 $w.maj7inv3 -sticky w
    grid $w.min7 $w.min7inv1 $w.min7inv2 $w.min7inv3 -sticky w
    grid $w.halfdim7 $w.halfdim7inv1 $w.halfdim7inv2 $w.halfdim7inv3 -sticky w
    grid $w.dim7 $w.dim7inv1 $w.dim7inv2 $w.dim7inv3 -sticky w
    grid $w.aug7 $w.aug7inv1 $w.aug7inv2 $w.aug7inv3 -sticky w
    
    if {[winfo exist .stats]} {make_stats_window}
    enable_disable_aug_dim
}

proc enable_disable_aug_dim {} {
    global trainer
    set w .ownlesson
    if {[winfo exist .ownlesson.dim7inv1]} {
        if {$trainer(testmode) == "aural"} {
            $w.dim7inv1 configure -state disable
            $w.dim7inv2 configure -state disable
            $w.dim7inv3 configure -state disable
            $w.auginv1 configure -state disable
            $w.auginv2 configure -state disable
            $w.aug7inv1 configure -state disable
            $w.aug7inv2 configure -state disable
            $w.aug7inv3 configure -state disable
        } else {
            $w.dim7inv1 configure -state normal
            $w.dim7inv2 configure -state normal
            $w.dim7inv3 configure -state normal
            $w.auginv1 configure -state normal
            $w.auginv2 configure -state normal
            $w.aug7inv1 configure -state normal
            $w.aug7inv2 configure -state normal
            $w.aug7inv3 configure -state normal
        }
    }
    foreach type $trainer(chordtypes) {
        if {[lsearch {auginv1 auginv2 dim7inv1 dim7inv2 dim7inv3} $type] > -1} {
            if {$trainer(testmode) == "aural"} {
                .w.$type configure -state disable
            } else {
                .w.$type configure -state normal
            }
        }
    }
}


proc config_your_own_interval_lesson {} {
    global allintervals;
    global intervalsel
    global trainer
    global lang
    if {[winfo exist .ownlesson]} {destroy .ownlesson}
    set w .ownlesson
    toplevel $w
    positionWindow .ownlesson
    set i 0
    set nhalf [expr [llength $allintervals] /2]
    foreach type $allintervals {
        checkbutton $w.$i -text $lang($type) -variable intervalsel($i) \
                -command make_interval_lesson
        if {[lsearch $trainer(intervaltypes) $type] != -1} {
            set intervalsel($i) 1} else {
            set intervalsel($i) 0}
        set r [expr $i % $nhalf]
        set c [expr $i / $nhalf]
        grid $w.$i -sticky w -row $r -column $c
        incr i
    }
    if {[winfo exist .stats]} {make_stats_window}
}

proc config_your_own_rhythm_lesson {} {
    make_duple_compound_interface
    rhythm_switch_type
}

# Part 15.0 make lesson

proc make_chord_lesson {} {
    global chordsel
    global trainer
    global allchordtypes
    remove_chord_buttons
    set trainer(chordtypes) ""
    foreach type $allchordtypes {
        if {$chordsel($type)} {lappend trainer(chordtypes) $type}
    }
    set n [llength $trainer(chordtypes)]
    set m [expr $n/2]
    if {[expr $n % 2] == 1} {incr m}
    set i 0
    foreach type $trainer(chordtypes) {
        set col [expr $i / $m]
        set row [expr $i % $m]
        grid .w.$type -row $row -column $col
        if {[lsearch {auginv1 auginv2 dim7inv1 dim7inv2 dim7inv3} $type] > -1} {
            if {$trainer(testmode) == "aural"} {
                .w.$type configure -state disable
            } else {
                .w.$type configure -state normal
            }
        }
        incr i
    }
    zero_chord_confusion_matrix
    if {[winfo exist .stats]} {make_stats_window}
}


proc make_interval_lesson {} {
    global intervalsel
    global trainer
    global allintervals
    set n [llength $allintervals]
    set i 0
    remove_interval_buttons
    set trainer(intervaltypes) ""
    foreach type $allintervals {
        if {$intervalsel($i)} {lappend trainer(intervaltypes) $type}
        incr i
    }
    set n [llength $trainer(intervaltypes)]
    set m [expr $n / 3]
    if {[expr $n % 3]} {incr m}
    set i 0
    foreach type $trainer(intervaltypes) {
        set row [expr $i % $m]
        set col [expr $i / $m]
        grid .w.$type -row $row -column $col
        incr i
    }
    zero_interval_confusion_matrix
    if {[winfo exist .stats]} {make_stats_window}
}

proc make_diatonic_lesson {} {
global diatonictype
global trainer
disable_all_inverse_buttons
foreach type $trainer(chordtypes) {
        grid forget .w.$type }
set trainer(chordtypes) ""
foreach chordtype {"" inv1 inv2 7 7inv1 7inv2 7inv3} {
    if {$diatonictype($chordtype)} {
      .c.s$chordtype configure -state normal
      lappend trainer(chordtypes) maj$chordtype
      lappend trainer(chordtypes) min$chordtype
      lappend trainer(chordtypes) dim$chordtype
      lappend trainer(chordtypes) aug$chordtype
      }
   }
set n [llength $trainer(chordtypes)]
set m [expr $n/2]
if {[expr $n % 2] == 1} {incr m}
set i 0
foreach type $trainer(chordtypes) {
     set row [expr $i % $m]
     set col [expr $i / $m]
     grid .w.$type -row $row -column $col
     incr i
    }
}

proc make_scale_lesson {} {
global trainer
global modesel
global allmodes
foreach type $trainer(scaletypes) {
        grid forget .w.$type }
set trainer(scaletypes) ""
foreach mode $allmodes {
  if {$modesel($mode)} {lappend trainer(scaletypes) $mode}
 }
set i 0
foreach mode $trainer(scaletypes) {
     set col [expr $i % 2]
     set row [expr $i / 2]
     grid .w.$mode -row $row -column $col
     incr i
    }
}

proc clear_own_diatonic_lessons {} {
global diatonictype
if {[winfo exist .ownlesson] == 0} return
foreach type {"" inv1 inv2 7 7inv1 7inv2 7inv3} {
  set diatonictype($type) 0
  }
}

proc disable_all_inverse_buttons {} {
foreach chordtype {"" inv1 inv2 7 7inv1 7inv2 7inv3} {
    .c.s$chordtype configure -state disable
     }
}


proc remove_chord_buttons {} {
    global trainer
    foreach type $trainer(chordtypes) {
        grid forget .w.$type }
}

proc remove_scale_buttons {} {
    global trainer
    foreach type $trainer(scaletypes) {
        grid forget .w.$type }
}


proc remove_interval_buttons {} {
    global trainer
    foreach type $trainer(intervaltypes) {
        grid forget .w.$type }
}

proc remove_cadence_buttons {} {
   global trainer
   foreach type $trainer(cadences) {
     grid forget .w.$type }
}

# Part 16.0 stats support 

proc make_stats_window {} {
    global trainer
    global cmatrix
    global ntrials total_time ncorrect
    global lang
    global nrepeats
    
    if {[winfo exist .stats]} {foreach w [winfo children .stats] {
        destroy $w}} else {
                  toplevel .stats
                  positionWindow .stats}
    frame .stats.m
    grid .stats.m
    display_empty_stats
    switch $trainer(exercise) {
       "chords" -
       "chordsdia" {display_chord_stats}
       "intervals" {display_interval_stats}
       "rhythmdic" -
       "sofadic" {display_rhythm_melody_stats}
       "keysigid" {display_keysig_stats}
       "idfigbas" {display_figbass_stats}
       "scalesid" {display_scale_stats}
       "sofaid" {display_sofaid_stats}
       "idcad" {display_cadence_stats}
       "drumseq" {display_drum_stats}
       "sofabadnote" {display_badnote_stats}
       "prog" {display_prog_stats}
       }
}

proc display_empty_stats {} {
    label .stats.lab -text "                               "
    grid .stats.lab
}

proc display_chord_stats {} {
    global trainer
    global cmatrix
    global lang
    global ncorrect ntrials
    set r 0
    set c 1
    button .stats.m.0 -text $lang(reset) -command zero_chord_confusion_matrix
    grid .stats.m.0 -row 0 -column 0
    foreach item $trainer(chordtypes) {
        label .stats.m.0-$item -text $item
        grid .stats.m.0-$item -row 0 -column $c
        incr c
    }
    foreach item1 $trainer(chordtypes) {
        incr r
        set c 0
        label .stats.m."$r"-0 -text $item1
        grid .stats.m."$r"-0 -row $r -column 0
        foreach item2 $trainer(chordtypes) {
            incr c
            set field [set item1]-[set item2]
            label .stats.m.$field -text $cmatrix($item1-$item2)
            grid .stats.m.$field -row $r -column $c
        }
    }
}

proc display_figbass_stats {} {
    global trainer
    global cmatrix
    global lang
    global figbass_symbol
    set r 0
    set c 1
    button .stats.m.0 -text $lang(reset) -command zero_figbass_confusion_matrix
    grid .stats.m.0 -row 0 -column 0
    for {set i 0} {$i < 7} {incr i} {
      set item $figbass_symbol($i)
        label .stats.m.0-$item -text $item
        grid .stats.m.0-$item -row 0 -column $c
        incr c
    }
    for {set i1 0} {$i1 < 7} {incr i1} {
        set item1 $figbass_symbol($i1)
        incr r
        set c 0
        label .stats.m."$r"-0 -text $item1
        grid .stats.m."$r"-0 -row $r -column 0
            for {set i2 0} {$i2 < 7} {incr i2} {
            incr c
            label .stats.m.$i1-$i2 -text $cmatrix($i1-$i2)
            grid .stats.m.$i1-$i2 -row $r -column $c
        }
    }
}


proc display_interval_stats {} {
    global trainer
    global cmatrix
    global lang
    set r 0
    set c 1
    button .stats.m.0 -text $lang(reset) -command zero_interval_confusion_matrix
    grid .stats.m.0 -row 0 -column 0
    foreach item $trainer(intervaltypes) {
        label .stats.m.0$c -text $item
        grid .stats.m.0$c -row 0 -column $c
        incr c
    }
    foreach item1 $trainer(intervaltypes) {
        incr r
        set c 0
        label .stats.m."$r"0 -text $item1
        grid .stats.m."$r"0 -row $r -column 0
        foreach item2 $trainer(intervaltypes) {
            incr c
            set field [set item1]-[set item2]
            label .stats.m.$field -text $cmatrix($item1-$item2)
            grid .stats.m.$field -row $r -column $c
        }
    }
}

proc display_sofaid_stats {} {
    global trainer
    global cmatrix
    global lang
    global sofas
    set r 0
    set c 1
    button .stats.m.0 -text $lang(reset) -command zero_sofaid_confusion_matrix
    grid .stats.m.0 -row 0 -column 0
    foreach item $trainer(sofalesson) {
        label .stats.m.0$c -text $item
        grid .stats.m.0$c -row 0 -column $c
        incr c
    }
    foreach item1 $trainer(sofalesson) {
        incr r
        set c 0
        label .stats.m."$r"0 -text $item1
        grid .stats.m."$r"0 -row $r -column 0
        foreach item2 $trainer(sofalesson) {
            incr c
            set field [set item1]-[set item2]
            label .stats.m.$field -text $cmatrix($item1-$item2)
            grid .stats.m.$field -row $r -column $c
        }
    }
}

proc display_rhythm_melody_stats {} {
    global lang ntrials accuracy
    set w .stats
    label $w.trialslab -text $lang(trials)
    label $w.accuracylab -text $lang(accuracy)
    label $w.repeatslab -text $lang(repeats)
    label $w.accuracy
    label $w.repeats
    label $w.trials -text $ntrials
    grid  $w.trialslab $w.accuracylab $w.repeatslab -sticky w
    grid  $w.trials $w.accuracy $w.repeats -sticky w
    update_sofa_rhythm_stats
}

proc display_scale_stats {} {
    global trainer
    global cmatrix
    global lang
    global ntrials ncorrect
    #puts [array get cmatrix]
    set r 0
    set c 1
    button .stats.m.0 -text $lang(reset) -command zero_scales_confusion_matrix
    grid .stats.m.0 -row 0 -column 0
    foreach item $trainer(scaletypes) {
        label .stats.m.0-$item -text $item
        grid .stats.m.0-$item -row 0 -column $c
        incr c
    }
    foreach item1 $trainer(scaletypes) {
        incr r
        set c 0
        label .stats.m."$r"-0 -text $item1
        grid .stats.m."$r"-0 -row $r -column 0
        foreach item2 $trainer(scaletypes) {
            incr c
            set field [set item1]-[set item2]
            label .stats.m.$field -text $cmatrix($item1-$item2)
            grid .stats.m.$field -row $r -column $c
        }
    }
    if {$ntrials < 1} return
    set accuracy [expr 100.0*$ncorrect/double($ntrials)]
    set accuracy [format "%5.2f" $accuracy]
    set outstr [format "accuracy %5.2f %% from %d trials" $accuracy $ntrials]
    if {![winfo exist .stats.lab]} {
        label .stats.lab -text $outstr
        grid .stats.lab
     }
}

proc display_cadence_stats {} {
    global trainer
    global cmatrix
    global lang
    global ntrials ncorrect
    #puts [array get cmatrix]
    set r 0
    set c 1
    button .stats.m.0 -text $lang(reset) -command zero_cadence_confusion_matrix
    grid .stats.m.0 -row 0 -column 0
    foreach item $trainer(cadences) {
        label .stats.m.0-$item -text $item
        grid .stats.m.0-$item -row 0 -column $c
        incr c
    }
    foreach item1 $trainer(cadences) {
        incr r
        set c 0
        label .stats.m."$r"-0 -text $item1
        grid .stats.m."$r"-0 -row $r -column 0
        foreach item2 $trainer(cadences) {
            incr c
            set field [set item1]-[set item2]
            label .stats.m.$field -text $cmatrix($item1-$item2)
            grid .stats.m.$field -row $r -column $c
        }
    }
}

proc display_drum_stats {} {
  global total_correct total_strikes
  global total_time ntestchecks
  label .stats.m1 -text $total_correct -width 5
  label .stats.n1 -text "correct drum strikes"
  grid .stats.m1 .stats.n1 -sticky w
  label .stats.m2 -text $total_strikes -width 5
  label .stats.n2 -text "total drum strikes"
  grid .stats.m2 .stats.n2 -sticky w
  label .stats.m3 -text $total_time -width 5
  label .stats.n3 -text "elapsed time"
  grid .stats.m3 .stats.n3 -sticky w
  label .stats.m4 -text $ntestchecks -width 5
  label .stats.n4 -text "test checks"
  grid .stats.m4 .stats.n4 -sticky w
  }


proc display_prog_stats {} {
global cmatrix
global trainer
global progression_lesson
global chordprogressions
#puts "display_prog_stats"
#puts [array get cmatrix]
set les $progression_lesson($trainer(proglesson))
#puts $trainer(proglesson)
set lles [llength $les]
#puts "les = $les"
for {set j 0} {$j < $lles} {incr j} {
  set j0 [lindex $les $j]
  #label .stats.m.c$j -text $j0
  label .stats.m.c$j -text "$chordprogressions($j0) "
  grid .stats.m.c$j -row 0 -column [expr $j + 1]
  }
  
for {set i 0} {$i < $lles} {incr i} {
  set i0 [lindex $les $i]
  label .stats.m.r$i -text $chordprogressions($i0)
  grid .stats.m.r$i -row [expr $i + 1] -column 0
 for {set j 0} {$j < $lles} {incr j} {
  set i0 [lindex $les $i]
  set j0 [lindex $les $j]
  set field $i0-$j0
  label .stats.m.$field -text $cmatrix($field)
  grid .stats.m.$field -row [expr $i + 1] -column [expr $j + 1]
  }
 }
}



proc reset_rhythm_melody_stats {{dummy 0}} {
    global ntrials ncorrect
    set ntrials 0
    set ncorrect 0
}

proc helpwindow {} {
   global trainer
   global instructions
   if { [file exist $trainer(browser)]} {
        set cmd "exec [list $trainer(browser)] https://tksolfege.sourceforge.io"
        eval $cmd
        } else {
    if {[winfo exists .help] != 0} {
        destroy .help
    }
    toplevel .help
    positionWindow .help
    text .help.t -width 50 -height 10 -wrap word -yscrollcommand {.help.ysbar set}
    scrollbar .help.ysbar -orient vertical -command {.help.t yview}
    pack .help.ysbar -side right -fill y -in .help
    pack .help.t -in .help
    .help.t insert end $instructions
    .help.t configure -state disabled
    }
}



# Setup patches array for cfg window

global patches

proc read_patch_names {} {
    global patches
    array set patches {
        0 "Acoustic Grand" 1 "Bright Acoustic" 2 "Electric Grand" 3 "Honky-Tonk"
        4 "Electric Piano 1" 5 "Electric Piano 2" 6 "Harpsichord" 7 "Clav"
        8 "Celesta" 9 "Glockenspiel" 10 "Music Box" 11 "Vibraphone"
        12 "Marimba" 13 "Xylophone" 14 "Tubular Bells" 15 "Dulcimer"
        16 "Drawbar Organ" 17 "Percussive Organ" 18 "Rock Organ" 19 "Church Organ"
        20 "Reed Organ" 21 "Accordian" 22 "Harmonica" 23 "Tango Accordian"
        24 "Acoustic Guitar (nylon)" 25 "Acoustic Guitar (steel)"
        26 "Electric Guitar (jazz)" 27 "Electric Guitar (clean)"
        28 "Electric Guitar (muted)" 29 "Overdriven Guitar" 30 "Distortion Guitar"
        31 "Guitar Harmonics" 32 "Acoustic Bass" 33 "Electric Bass (finger)"
        34 "Electric Bass (pick)" 35 "Fretless Bass" 36 "Slap Bass 1"
        37 "Slap Bass 2" 38 "Synth Bass 1" 39 "Synth Bass 2" 40 "Violin"
        41 "Viola" 42 "Cello" 43 "Contrabass" 44 "Tremolo Strings"
        45 "Pizzicato Strings" 46 "Orchestral Strings" 47 "Timpani"
        48 "String Ensemble 1" 49 "String Ensemble 2" 50 "SynthStrings 1"
        51 "SynthStrings 2" 52 "Choir Aahs" 53 "Voice Oohs"
        54 "Synth Voice" 55 "Orchestra Hit" 56 "Trumpet"
        57 "Trombone" 58 "Tuba" 59 "Muted Trumpet" 60 "French Horn"
        61 "Brass Section" 62 "SynthBrass 1" 63 "SynthBrass 2" 64 "Soprano Sax"
        65 "Alto Sax" 66 "Tenor Sax" 67 "Baritone Sax" 68 "Oboe"
        69 "English Horn" 70 "Bassoon" 71 "Clarinet" 72 "Piccolo"
        73 "Flute" 74 "Recorder" 75 "Pan Flute" 76 "Blown Bottle"
        77 "Skakuhachi" 78 "Whistle" 79 "Ocarina" 80 "Lead 1 (square)"
        81 "Lead 2 (sawtooth)" 82 "Lead 3 (calliope)" 83 "Lead 4 (chiff)"
        84 "Lead 5 (charang)" 85 "Lead 6 (voice)" 86 "Lead 7 (fifths)"
        87 "Lead 8 (bass+lead)" 88 "Pad 1 (new age)" 89 "Pad 2 (warm)"
        90 "Pad 3 (polysynth)" 91 "Pad 4 (choir)" 92 "Pad 5 (bowed)"
        93 "Pad 6 (metallic)" 94 "Pad 7 (halo)" 95 "Pad 8 (sweep)"
        96 "FX 1 (rain)" 97 "(soundtrack)" 98 "FX 3 (crystal)"
        99 "FX 4 (atmosphere)" 100 "FX 5 (brightness)" 101 "FX 6 (goblins)"
        102 "FX 7 (echoes)" 103 "FX 8 (sci-fi)" 104 "Sitar" 105 "Banjo"
        106 "Shamisen" 107 "Koto" 108 "Kalimba" 109 "Bagpipe"
        110 "Fiddle" 111 "Shanai" 112 "Tinkle Bell" 113 "Agogo"
        114 "Steel Drums" 115 "Woodblock" 116 "Taiko Drum" 117 "Melodic Tom"
        118 "Synth Drum" 119 "Reverse Cymbal" 120 "Guitar Fret Noise"
        121 "Breath Noise" 122 "Seashore" 123 "Bird Tweet" 124 "Telephone ring"
        125 "Helicopter" 126 "Applause" 127 "Gunshot" }
}

# Part 17.0 instrument button

proc main_prog_dialog {} {
    global instrumentbut
    set instrumentbut .config.main.instrbut
    change_prog_dialog
}

proc leader_prog_dialog {} {
    global instrumentbut
    set instrumentbut .config.rhythm.leadinstrbut
    change_prog_dialog
}

proc rhythm_prog_dialog {} {
    global instrumentbut
    set instrumentbut .config.rhythm.rhyminstrbut
    change_prog_dialog
}

proc sofa_prog_dialog {} {
    global instrumentbut
    set instrumentbut .config.sofa.instrbut
    change_prog_dialog
}

proc sofa_id_prog_dialog {} {
    global instrumentbut
    set instrumentbut .config.sofaid.instrbut
    change_prog_dialog
}

proc change_prog_dialog {} {
    #create a dialog window for changing the program assignment
    #(channel to instrument mapping). Display a list box with
    #scroll bars with a list of all the General Midi instruments.
    global patches trainer
    set w .prog
    if {[winfo exists .prog] == 0} {
        toplevel $w
        positionWindow .prog
        label $w.sel -text $patches($trainer(instrument))  -relief sunken
        scrollbar $w.scroll -command "$w.list yview"
        listbox $w.list -yscroll "$w.scroll set" -setgrid 1 -height 10\
                -selectmode single
        pack $w.scroll -side right -fill y
        pack $w.sel
        pack $w.list -side top -expand 1 -fill both
        bind $w.list <Button> {select_program [.prog.list nearest %y]}
        for {set i 0} {$i < 128} {incr i} {
            $w.list insert end $patches($i)
        }
    } {
        focus $w
        raise $w .
    }
}


proc select_program {p} {
    global patches trainer
    global instrumentbut
    .prog.sel configure -text $patches($p)
    $instrumentbut configure -text $patches($p)
    set buttype [lindex [split $instrumentbut .] 3]
    if {$buttype == "instrbut"} {
        set trainer(instrument) $p
    } elseif {$buttype == "leadinstrbut"} {
        set trainer(leaderinstrument) $p
    } elseif {$buttype == "rhyminstrbut"} {
        set trainer(rhythminstrument) $p
    }
}



### end of GUI #####

proc pick_interval {} {
    global intervals
    global trainer
    global intervalname
    global sharpnotes
    global loghandle
    set nintervals [llength $trainer(intervaltypes)]
    switch $trainer(direction) {
        up {set dir 1}
        down {set dir -1}
        either {set r [expr rand() -0.5]
            set dir 1
            if {$r < 0.0} {set dir -1}
        }
    }
    set n [random_number $trainer(range)]
    set root [expr $trainer(minpitch) + $n]
    set n [random_number $nintervals]
    set ntype [random_number $nintervals]
    set intervalname [lindex $trainer(intervaltypes) $ntype]
    set rootkey [lindex $sharpnotes [expr $root % 12]][expr $root/12]
    set intervalcode $rootkey-$intervalname
    if {[info exist loghandle]} {puts $loghandle $intervalcode
        flush $loghandle}
    return "$root $intervalname $dir"
}


proc remove_augdim_inv {chordtypes} {
    set chordlist $chordtypes
    foreach chord {auginv1 auginv2 dim7inv1 dim7inv2 dim7inv3} {
        set index [lsearch $chordlist $chord]
        if {$index != -1} {
            set chordlist [lreplace $chordlist $index $index]
        }
    }
    return $chordlist
}

# Part 18.0 pick chord, scale, diatonic chord, chromatic chord

# The chord identification chromatic and diatonic share much
# of the same code. The main difference is the way the test
# chord is selected. For the latter (diatonic), the root is
# selected from one of the diatonic notes in the particular
# scale (eg F major). Once the root is selected, only minor
# major chord types are allowed. Here is a description of
# implementation.
# Pick_chord choses pick_diatonic_chord for the exercises
# chord id diatonic or figured bass. Pick_diatonic_chord gets
# the root and chord by calling find_diatonic_root_and_chords.


proc pick_chord {} {
    global trainer
    if {$trainer(exercise) == "chordsdia" ||
        $trainer(exercise) == "idfigbas"} {
        pick_diatonic_chord
    } else {
        pick_chromatic_chord
    }
}

proc pick_scale {} {
   global trainer
   global ttype
   global ionian dorian phrygian lydian mixolydian aeolian locrian major
   global natural_minor harmonic_minor melodic_minor
   global blues hungarian whole_tone pentatonic_maj pentatonic_sus pentatonic_min man_gong neapolitan ritusen bebop
   set n [llength $trainer(scaletypes)]
   set m [random_number $n]
   set random_scale [lindex $trainer(scaletypes) $m] 
   set ttype $random_scale
   return [set $random_scale]
   }

proc pick_chromatic_chord {} {
    global ntype sharpnotes
    global chordname
    global trainer
    global loghandle
    set chordtypes $trainer(chordtypes)
    if {$trainer(testmode) == "aural"} {
        set chordtypes [remove_augdim_inv $chordtypes]
    }
    set nchords [llength $chordtypes]
    set n [random_number $trainer(range)]
    set root [expr $trainer(minpitch) + $n]
    set ntype [random_number $nchords]
    set rootkey [midi2notename $root]
    set type [lindex $chordtypes $ntype]
    set chordname $rootkey-$type
    if {[info exist loghandle]} {puts $loghandle $chordname; flush $loghandle}
    #puts "rootkey=$rootkey type=$type chordname=$chordname"
    return "$root $type"
}


proc make_chord_associates {chord} {
    set ass $chord
    foreach suffix {inv1 inv2 7 7inv1 7inv2 7inv3} {
        set chordmod $chord$suffix
        lappend ass $chordmod
    }
    return $ass
}


# find_diatonic_root_and_chords picks a root from the
# range of MIDI notes specified in the configuration
# screen. It checks whether it is a diatonic note by
# looking for it in the list diatonicscalelist. If
# it is not there, it keeps on picking another note
# until it is found. (After 10 tries it automatically,
# expands the range of notes. It aborts after 30 tries.)
# The position of the note in the diatonicscalelist
# determines its scale degree (eg I, ii, iii etc.)
# Based on its scale degree, the allowable chord type
# major, minor or diminished is found through the table
# modescalechords(). This list is augmented with 7ths
# and inversions by the procedure make_chord_associates
# and placed in chordlist. The chordlist is then trimmed
# based on the particular lesson chosen using the list
# trainer(chordtypes). A random chord is chosen from
# chordlist.
# It is necessary to maintain the table diatoniscalelist
# whenever the diatonic key signature is changed in the
# configuration menu. This is done by another set of procedures
# starting with make_scalenotelist which is part of the
# configuration support functions.

proc find_diatonic_root_and_chords {} {
    global trainer
    global diatonicscalelist
    global modescalechords
    global chordname
    global figbass_index
    global root
    for {set k 0} {$k < 30} {incr k} {
        set n [random_number $trainer(range)]
        set root [expr $trainer(minpitch) + $n]
        set root12 [expr $root % 12]
        set indx [lsearch $diatonicscalelist $root12]
        if {$indx >= 0} {
            set figbass_index $indx
            set chord $modescalechords($indx)
            set chordlist [make_chord_associates $chord]
            #puts "find_diatonic_root_and_chords:  chordlist = $chordlist for $chord indx=$indx for root12 = $root12"
            set chordlist [intersect_two_lists $trainer(chordtypes) $chordlist]
            if {[llength $chordlist] < 1} continue
            set ntype [random_number [llength $chordlist]]
            set chord [lindex $chordlist $ntype]
            set rootkey [midi2notename $root]
            set chordname $rootkey-$chord
            return "$root $chord"
        }
        if {$k > 10} {incr trainer(range)}
    }
    puts "cannot find diatonic note in range root= $root12 diatonicscalelist = $diatonicscalelist"
}

proc pick_diatonic_chord {} {
    global ntype sharpnotes
    global chordname root
    global trainer
    global loghandle
    set rootchord [find_diatonic_root_and_chords]
    set root [lindex $rootchord 0]
    set type [lindex $rootchord 1]
    return "$root $type"
}

proc intersect_two_lists {a b} {
    if {[llength $a] < [llength $b]} {
        set small $a
        set large $b } else {
        set small $b
        set large $a}
    set intersect {}
    foreach elem $small {
        if {[lsearch $large $elem] >= 0} {
            lappend intersect $elem
        }
    }
    return $intersect
}


set cadence(0) {pacn {5 1}}
set cadence(1) {pacn {7 1}}
set cadence(2) {iacn {5 1}}
set cadence(3) {iacn {5 1}}
set cadence(4) {hcn {1 5}}
set cadence(5) {hcn {2 5}}
set cadence(6) {hcn {4 5}}
set cadence(7) {pcn {4 1}}
set cadence(8) {dcn {5 2}}
set cadence(9) {dcn {5 6}}

##array set modescalechords {0 maj 1 min 2 min 3 maj 4 maj 5 min 6 dim}

proc calculate_mode_cadences {mode} {
global cadence
global modescalechords
global trainer
for {set i 0} {$i < 10} {incr i} {
 set cadence($i) [lrange $cadence($i) 0 1]
 set scalelist [lindex $cadence($i) 1]
 set scale1 [lindex $scalelist 0]
 set scale2 [lindex $scalelist 1]
 set scaledx1 [expr ($scale1 - 1 + $mode) % 7]
 set scaledx2 [expr ($scale2 - 1 + $mode) % 7]
 set chrd1 $modescalechords($scaledx1)
 set chrd2 $modescalechords($scaledx2)
 if {$i == 2} {append chrd1 inv1}
 if {$i == 3} {append chrd2 inv1}
 lappend cadence($i) $chrd1
 lappend cadence($i) $chrd2
# puts $cadence($i)
 }
# set scaleoffsets [make_scale_midi_offsets $trainer(mode)]
switch $mode {
 0 {set scaleoffsets [make_scale_midi_offsets maj]
    set trainer(cadence_scale) ionian}
 5 {set scaleoffsets [make_scale_midi_offsets min]
    set trainer(cadence_scale) aeolian}
 1 {set scaleoffsets [make_scale_midi_offsets dor]
    set trainer(cadence_scale) dorian}
 }
}

calculate_mode_cadences 0


# Part 19.0 tests

proc random_number {top} {
    set n [expr int(rand()*$top)]
    return $n
}

proc random_element {givenlist} {
set l [llength $givenlist]
set n [random_number $l]
return [lindex $givenlist $n]
}

proc next_test {} {
    global trainer
    global nrepeats
    global try
    set try 0
   .f.ans configure -text ""
    switch $trainer(exercise) {
        noteid {test_noteid}
	rhythmdic {test_rhythm}
	chords {test_chord}
	chordsdia {test_chord}
	sofaid {test_sofaid}
	sofadic {test_sofadic}
	sofasing {test_sofasing 0}
        sofabadnote {test_sofabadnote 0}
	keysigid {test_keysig}
	scalesid {test_scalesid}
	idfigbas {test_chord}
	idcad {test_cadence}
	drumseq {test_drumseq}
        prog {test_progression}
	default {test_interval}
        }
	
}

proc make_chordlist {troot ttype} {
    global maj min aug dim majmin maj7 min7
    global majinv1 majinv2 mininv1 mininv2
    global halfdim7 dim7
    global auginv1 auginv2 diminv1 diminv2
    global maj7inv1 maj7inv2 maj7inv3
    global majmininv1 majmininv2 majmininv3
    global min7inv1 min7inv2 min7inv3
    global halfdim7inv1 halfdim7inv2 halfdim7inv3
    global dim7inv1 dim7inv2 dim7inv3
    set chordlist {}
    foreach elem [set $ttype] {
        lappend chordlist [expr $elem+$troot]
    }
    return $chordlist
 }


proc test_chord {} {
    global troot ttype
    global trainer
    global try test_time ntrials
    global chordseq
    set trial [pick_chord]
    set troot [lindex $trial 0]
    set ttype [lindex $trial 1]
    set try 0
    set chordseq [make_chordlist $troot $ttype]
    if {$trainer(xchord)} {
          set chordseq [chord_spreader $chordseq]}
    #pack forget .s
    .f.ans configure -text ""
    update
    if {$trainer(testmode) == "visual" || $trainer(testmode) == "both"} {
        show_testchord}
    if {$trainer(testmode) == "aural" || $trainer(testmode) == "both"} {
        playchord $chordseq  $trainer(playmode)}
    set test_time [clock seconds]
}

proc make_inversion {progchordlist} {
  set newprogchordlist [list]
  foreach chord $progchordlist {
    set ichord {}
    for {set i 1} {$i < 3} {incr i} {
      lappend ichord [lindex $chord $i]
      }
    lappend ichord [expr 12 + [lindex $chord 0]]
    lappend newprogchordlist $ichord
    }
  return $newprogchordlist
 } 

proc test_progression {} {
global chordprogressions
global pickedprogression
global progchordlist
global progression_lesson
global trainer
global pickedn
set pickedn [random_element $progression_lesson($trainer(proglesson))]
set pickedprogression $chordprogressions($pickedn)
set progchordlist [makeprogression $pickedprogression $trainer(chordroot)]
#puts "trainer(chordinversion) = $trainer(chordinversion)"
if {$trainer(chordinversion) > 0} {
   set progchordlist [make_inversion $progchordlist]
   }
if {$trainer(chordinversion) > 1} {
   set progchordlist [make_inversion $progchordlist]
   }
if {$trainer(testmode) == "visual" || $trainer(testmode) == "both"} {
        draw_progression $progchordlist}
if {$trainer(testmode) == "aural" || $trainer(testmode) == "both"} {
        playprogression $progchordlist }
if {$trainer(testmode) == "aural"} {destroy .s}
#draw_progression $progchordlist
#playprogression $progchordlist
clear_selected_progressions 
}

proc test_scalesid {} {
  global trainer
  global scalelist
  global troot
  global test_time
  global try
  set scalelist [pick_scale]
  set n [random_number $trainer(range)]
  set troot [expr $trainer(minpitch) + $n]
  destroy .msg
  if {$trainer(testmode) == "visual" || $trainer(testmode) == "both"} {
      show_scale $scalelist}
  if {$trainer(testmode) == "aural" || $trainer(testmode) == "both"} {
      playscale $troot $scalelist}
  set test_time [clock seconds]
  set try 0
  }

proc test_cadence {} {
  global trainer
  global cadence
  global troot
  global test_cadence
  set cadencenum [random_number 10]
  set test_cadence $cadence($cadencenum)
  set n [random_number $trainer(range)]
  set troot [expr $trainer(minpitch) + $n]
  playcadence $troot $test_cadence
  }

# Part 20.0 interval test

#source show_testintv.tcl

proc show_interval {troot ttype tdir} {
    global interval keyspace
    set note1 [midi2notename $troot]
    set semis $interval($ttype)
    set notedif $keyspace($ttype)
    #puts "troot = $troot $note1"
    #puts "ttype = $ttype $semis $notedif"
    #puts "tdir  = $tdir"
    if {$tdir < 0} {set notedif [expr - $notedif]}
    set note2 [shift_note $note1 $notedif]
    set actual_semis [notedifference $note2 $note1]
    #puts "actual_semis semis $actual_semis $semis"
    set dif [expr $actual_semis - $semis*$tdir]
    #puts "dif = $dif"
    if {$dif > 0} {
        if {$tdir > 0} {
            #  puts "flatten $note2"
            set note2 [flatten $note2 0]
        } else {
            #  puts "flatten $note2"
            set note2 [flatten $note2 0]}
    }
    if {$dif < 0} {
        if {$tdir < 0} {
            #  puts "sharpen $note2"
            set note2 [sharpen $note2 0]
        } else {
            #  puts "sharpen $note2"
            set note2 [sharpen $note2 0]}
    }
    if {$tdir > 0} {set avgmidi [expr $troot + $semis/2]
    } else       {set avgmidi [expr $troot - $semis/2]}
    if {$avgmidi < 60} {set clefcode 2
    } else          {set clefcode 0}
    draw_interval $note1 $note2 $clefcode
}

proc draw_interval {note1 note2 clefcode} {
set chordsym ""
if {![winfo exist .s]} {
    frame .s
    canvas .s.c -width 140 -height 140
 }
pack .s.c -anchor nw
pack .s -side top -anchor nw
grand_canvas_redraw .s.c 130
show_chord_in_grand_staff "$note1 $note2"
}

proc shift_note {note shift} {
    set notescale CDEFGAB
    set barenote [string index $note 0]
    set accid ""
    if {[string length $note] > 2} {
        set octave [string index $note 2]
        set accid [string index $note 1]
    } else {
        set octave [string index $note 1]}
    set pos [string first $barenote $notescale]
    #puts "shift_note $pos $shift"
    set pos [expr $pos + $shift]
    if {$pos > 6} {incr octave
        if {$pos > 13} {incr octave}
        set pos [expr $pos % 7]}
    if {$pos < 0} {incr octave -1
        if {$pos < -7} {incr octave -1}
        set pos [expr ($pos + 14) % 7]}
    set newnote [string index $notescale $pos]
    if {$accid != ""} {return $newnote$accid$octave}
    return $newnote$octave
}

proc notedifference {note1 note2} {
    global reversenotearray
    #puts "note1 note2 $note1 $note2"
    if {[string length $note1] > 2} {
        set bnote1 [string range $note1 0 1]
        set oct1 [string index $note1 2]
    } else {
        set bnote1 [string index $note1 0]
        set oct1 [string index $note1 1]
    }
    
    if {[string length $note2] > 2} {
        set bnote2 [string range $note2 0 1]
        set oct2 [string index $note2 2]
    } else {
        set bnote2 [string index $note2 0]
        set oct2 [string index $note2 1]
    }
    set semi1 [expr $reversenotearray($bnote1) + 12*($oct1+1)]
    set semi2 [expr $reversenotearray($bnote2) + 12*($oct2+1)]
    #puts "midi $semi1 $semi2"
    return [expr $semi1 - $semi2]
}

# end of show_testintv.tcl


proc test_interval {} {
    global troot ttype tdir
    global trainer lang
    global try test_time
    global ntrials
    set dir(1) up
    set dir(-1) down
    set try 0
    set trial [pick_interval]
    set troot [lindex $trial 0]
    set ttype [lindex $trial 1]
    set tdir  [lindex $trial 2]
    .f.ans configure -text "$lang(singi) $lang($dir($tdir))"
    if {$trainer(exercise) == "sing"} {playroot $troot
        if {$trainer(testmode) == "visual" || $trainer(testmode) == "both"} {
            pack .s -side bottom -after .f
            grand_canvas_redraw .s.c 90
            set note1 [midi2notename $troot]
            show_chord_in_grand_staff "$note1"}
    } else {
        .f.ans configure -text ""
        if {$try} {incr ntrials}
        update
        if {$trainer(testmode) == "visual" || $trainer(testmode) == "both"} {
            show_interval $troot $ttype $tdir}
        if {$trainer(testmode) == "aural" || $trainer(testmode) == "both"} {
            playinterval $troot $ttype $tdir $trainer(playmode)}
        set test_time [clock seconds]
    }
}

# Part 21.0 play function

proc playchord {chordseq  mode} {
    global trainer
    if {$mode == "both"} {
        playchord_action $chordseq harmonic
        after $trainer(msec)
        playchord_action $chordseq  melodic
    } else {
       playchord_action $chordseq $mode
       }
}

proc playchord_with_keyboard {chordseq  mode} {
    global trainer
    if {$mode == "both"} {
        playchord_action_with_keyboard $chordseq harmonic
        after $trainer(msec)
        playchord_action_with_keyboard $chordseq  melodic
    } else {
       playchord_action_with_keyboard $chordseq $mode
       }
}


proc reverselist {mlist} {
    #reverses the order of elements of a list
    set outlist {}
    foreach elem $mlist {
        set outlist [linsert $outlist 0 $elem]
    }
    set outlist
}


proc playchord_action {chordseq mode} {
    global trainer
    global starkitversion
    muzic::channel 0 $trainer(instrument)
    if {[string equal $trainer(direction) down]} {
        set chordseq [reverselist $chordseq]}
    if {$mode == "melodic"} {
      set i 0
      foreach note $chordseq {
        set k $note
        if {$i == 0} {
           muzic::playnote 0 $k [expr $trainer(velocity) + $trainer(accent)] $trainer(msec)
          } else {
           muzic::playnote 0 $k [expr $trainer(velocity)] $trainer(msec)
          }
        incr i
        after $trainer(msec)
        }
    } else {
      if {$starkitversion} {
        playchord_for_muzic_starkit $chordseq
        } else {
        muzic::playchord 0 $chordseq $trainer(velocity) $trainer(msec)
        }
      }
  }

proc playchord_action_with_keyboard {chordseq mode} {
    global trainer
    global starkitversion
    global midi2id
    global id2shade
    if {![winfo exists .piano]} keyboard
    muzic::channel 0 $trainer(instrument)
    if {[string equal $trainer(direction) down]} {
        set chordseq [reverselist $chordseq]}
    if {$mode == "melodic"} {
      set i 0
      foreach note $chordseq {
        set k $note
        set id $midi2id($k)
        .piano.c itemconfigure $id -fill red
        update
        if {$i == 0} {
           muzic::playnote 0 $k [expr $trainer(velocity) + $trainer(accent)] $trainer(msec)
          } else {
           muzic::playnote 0 $k [expr $trainer(velocity)] $trainer(msec)
          }
        incr i
        after $trainer(msec)
        .piano.c itemconfigure $id -fill $id2shade($id)
        }
    } else {
      if {$starkitversion} {
        playchord_for_muzic_starkit $chordseq
        } else {
        foreach note $chordseq {
          set k $note
          set id $midi2id($k)
          .piano.c itemconfigure $id -fill red
          }
          update

        muzic::playchord 0 $chordseq $trainer(velocity) $trainer(msec)

        foreach note $chordseq {
          set k $note
          set id $midi2id($k)
          .piano.c itemconfigure $id -fill $id2shade($id)
          }
          update
        }
      }
}

proc playchord_for_muzic_starkit {chordseq} {
 global trainer
 muzic::channel 0 $trainer(instrument)
 foreach note $chordseq {
   muzic::playnote 0 $note $trainer(velocity) $trainer(msec)
   }
 }

proc playinterval {root type dir mode} {
    global trainer
    if {$mode == "both"} {
        playinterval_action $root $type $dir harmonic
        after $trainer(msec)
        after 500
        playinterval_action $root $type $dir melodic
    } else {playinterval_action $root $type $dir $mode}
}

proc playcadence {troot tcadence} {
global scaleoffsets
global trainer
global scalelist
global ionian aeolian dorian
global cadencename
#puts "play $troot $tcadence"
set cadencename [lindex $tcadence 0]
set keyseq [lindex $tcadence 1]
set key1 [lindex $keyseq 0]
set key2 [lindex $keyseq 1]
set chord1 [lindex $tcadence 2]
set chord2 [lindex $tcadence 3]
#puts "key 1 = $key1"
#puts "key 2 = $key2"
#puts "chord1 = $chord1"
#puts "chord2 = $chord2" 
#puts "name = $cadencename"
#puts "scaleoffset = $scaleoffsets"
set base1 $troot
set base2 $troot
if {$key1 > 1} {set base1 [expr [lindex $scaleoffsets [expr $key1 -1]] + $troot]}
if {$key2 > 1} {set base2 [expr [lindex $scaleoffsets [expr $key2 - 1]] + $troot]}
#puts "base1 base2 = $base1 $base2"
set chordlist1 [make_chordlist $base1 $chord1]
#puts "chordlist1 = $chordlist1"
set chordlist2 [make_chordlist $base2 $chord2]
#puts "chordlist1 = $chordlist2"
playscale $troot [set $trainer(cadence_scale)]
after 300
playchord $chordlist1 $trainer(playmode)
after 500
playchord $chordlist2 $trainer(playmode)
}


proc show_scale {scalelist} {
if {![winfo exist .msg]} {
  label .msg -text ""
  pack .msg -side bottom
  }
.msg configure -text $scalelist
}

proc playscale {root scalelist} {
    global trainer
    muzic::channel 0 $trainer(instrument)
    muzic::playnote 0 $root $trainer(velocity) $trainer(msec)
    after $trainer(msec)
    muzic::playnote 0 $root 0 10
    set note $root   
    if {$trainer(direction) == "up"} {
      foreach interval $scalelist {
        set note [expr $note + $interval]
        muzic::playnote 0 $note $trainer(velocity) $trainer(msec)
        after $trainer(msec)
        muzic::playnote 0 $note 0 10
        }
      } else {
       set rscalelist [reverselist $scalelist]
       foreach interval $rscalelist {
        set note [expr $note - $interval]
        muzic::playnote 0 $note $trainer(velocity) $trainer(msec)
        after $trainer(msec)
        muzic::playnote 0 $note 0 10
        }
     }
    }


proc playinterval_action {root type dir mode} {
    global interval
    global trainer
    global starkitversion
    #puts "playinterval_action $root $type $dir $mode"
    muzic::channel 0 $trainer(instrument)
    if {$mode == "melodic"} {#after $trainer(msec)
        muzic::playnote 0 $root $trainer(velocity) $trainer(msec)
        #muzic::playnote 0 $root 0 10
    }
    set note [expr $root + $dir*$interval($type)]
    if {$mode == "melodic"} {after $trainer(msec)
        #muzic::playnote 0 $note 0 10
        muzic::playnote 0 $note $trainer(velocity) $trainer(msec)
    }
    if {$mode == "harmonic"} {
    #    puts "harmonic"
      if {$starkitversion} {
        muzic::playnote 0 $root $trainer(velocity) $trainer(msec)
        muzic::playnote 0 $note $trainer(velocity) $trainer(msec)
        } else {
        muzic::playchord 0 [list $root $note] $trainer(velocity) $trainer(msec)
        }
        #after $trainer(msec)
    }
  # puts "playinterval_action done"
 
    #puts "playnote 0 $note $trainer(velocity)"
}

proc playroot {root} {
    global trainer
    muzic::channel 0 $trainer(instrument)
    muzic::playnote 0 $root $trainer(velocity) $trainer(msec)
}

proc playothernote {root type dir} {
    global trainer
    global interval
    set note [expr $root + $dir*$interval($type)]
    muzic::playnote 0 $note $trainer(velocity) $trainer(msec)
}

# Part 22.0 repeat


proc repeat {} {
    global troot ttype tdir
    global scalelist
    global trainer
    global nrepeats
    global chordseq
    global test_cadence
    global progchordlist
    incr nrepeats
    switch $trainer(exercise) {
    "rhythmdic" {
                 play_leader
                 play_rhythm}
    "sofadic"  {play_sofa}
    "sofaid" {play_sofa}
    "sofabadnote"  {play_sofa}
    "sofasing" {
        playsofa_action_1 [expr $trainer(sofa_tonic) + $trainer(transpose)]}
    "chords" -
    "chordsdia" -
    "idfigbas" { playchord $chordseq $trainer(playmode)}
    "intervals" {playinterval $troot $ttype $tdir $trainer(playmode)}
    "sing" { playroot $troot }
    "scalesid" { playscale $troot  $scalelist }
    "idcad"  { if {[info exist test_cadence]} {
        playcadence $troot  $test_cadence }
        }
    "drumseq" start_playseq
    "prog" {
           if {[winfo exists .piano]} {
             playprogression_with_keyboard $progchordlist
             } else {playprogression $progchordlist
             }
           }
     }
}

# Part 23.0 confusion matrix support

proc zero_chord_confusion_matrix {} {
    global trainer
    global cmatrix
    global ncorrect total_time ntrials
    global try
    set try -1; # to signal that pick_chord not done
    set ncorrect 0
    set total_time 0
    set ntrials 0
    if {[info exist cmatrix]} {unset cmatrix}
    foreach item1 $trainer(chordtypes) {
        foreach item2 $trainer(chordtypes) {
            set field [set item1]-[set item2]
            set cmatrix($field) 0
            if {[winfo exist .stats.m.$field]} {
                .stats.m.$field configure -text $cmatrix($field)
            }
        }
    }
    if {[winfo exist .stats]} {.stats.lab configure -text ""}
}

proc zero_interval_confusion_matrix {} {
    global trainer
    global cmatrix
    global ncorrect ntrials total_time
    global try
    set try -1; # to signal that pick_interval not done
    set ncorrect 0
    set total_time 0
    set ntrials 0
    if {[info exist cmatrix]} {unset cmatrix}
    foreach item1 $trainer(intervaltypes) {
        foreach item2 $trainer(intervaltypes) {
            set field [set item1]-[set item2]
            set cmatrix($field) 0
            if {[winfo exist .stats.m.$field]} {
                .stats.m.$field configure -text $cmatrix($field)
            }
        }
    }
    if {[winfo exist .stats.lab]} {.stats.lab configure -text ""}
}

proc zero_figbass_confusion_matrix {} {
    global trainer
    global cmatrix
    global ncorrect ntrials total_time
    global figbass_symbol
    global try
    set try -1; # to signal that pick_interval not done
    set ncorrect 0
    set total_time 0
    set ntrials 0
    if {[info exist cmatrix]} {unset cmatrix}
    for {set i1 0} {$i1 < 7} {incr i1} {
      set item1 $figbass_symbol($i1)
      for {set i2 0} {$i2 < 7} {incr i2} {
          set item2 $figbass_symbol($i2)
          set field $i1-$i2
          set cmatrix($field) 0
          if {[winfo exist .stats.m.$field]} {
              .stats.m.$field configure -text $cmatrix($field)
            }
        }
      }
    if {[winfo exist .stats.lab]} {.stats.lab configure -text ""}
}

proc zero_scales_confusion_matrix {} {
    global trainer
    global cmatrix
    global ncorrect total_time ntrials
    global try
    set try 0; # to signal that pick_scale not done
    set ncorrect 0
    set total_time 0
    set ntrials 0
    if {[info exist cmatrix]} {unset cmatrix}
    foreach item1 $trainer(scaletypes) {
        foreach item2 $trainer(scaletypes) {
            set field [set item1]-[set item2]
            set cmatrix($field) 0
            if {[winfo exist .stats.m.$field]} {
                .stats.m.$field configure -text $cmatrix($field)
            }
        }
    }
    if {[winfo exist .stats]} {.stats.lab configure -text ""}
}

proc zero_cadence_confusion_matrix {} {
    global trainer
    global cmatrix
    global ncorrect total_time ntrials
    global try
    set try 0; # to signal that pick_scale not done
    set ncorrect 0
    set total_time 0
    set ntrials 0
    if {[info exist cmatrix]} {unset cmatrix}
    foreach item1 $trainer(cadences) {
        foreach item2 $trainer(cadences) {
            set field [set item1]-[set item2]
            set cmatrix($field) 0
            if {[winfo exist .stats.m.$field]} {
                .stats.m.$field configure -text $cmatrix($field)
            }
        }
    }
    if {[winfo exist .stats]} {.stats.lab configure -text ""}
}

proc zero_sofaid_confusion_matrix {} {
    global trainer
    global cmatrix
    global ncorrect total_time ntrials
    global try
    set try 0; # to signal that pick_scale not done
    set ncorrect 0
    set total_time 0
    foreach item1 $trainer(sofalesson) {
      foreach item2 $trainer(sofalesson) {
        set field [set item1]-[set item2]
        set cmatrix($field) 0
        if {[winfo exist .stats.m.$field]} {
            .stats.m.$field configure -text $cmatrix($field)
           }
        }
      }
}

proc zero_prog_confusion_matrix {} {
    global trainer
    global cmatrix
    global progression_lesson
    set les $progression_lesson($trainer(proglesson))
    foreach i $les {
      foreach j $les {
        set cmatrix($i-$j) 0
        }
      } 
    }

# Part 24.0 verification

proc verify_chord {ntype} {
    global troot ttype
    global trainer
    global cmatrix
    global try test_time total_time ntrials
    global ncorrect
    global loghandle
    global lang
    global chordseq
    global ntrials
    global chordname
    
    #don't count other guesses
    incr try
    if {$try > 0} {incr ntrials}
    if {![info exist test_time] || $try < 0} {
        .f.ans config -text $lang(firstpress)
        return
    }
    set response_time [expr [clock seconds] - $test_time]
    if {[info exist loghandle]} {puts $loghandle "   $response_time $ntype"
        flush $loghandle}
    if {$try > 0} {
    }
    if {$ntype == $ttype} {
        .f.ans configure -text "$lang(correct) $chordname"
        if {$try == 1} {incr ncorrect
                       incr cmatrix($ttype-$ntype)}
        update
        incr total_time $response_time
        #puts $response_time
        if {$trainer(autonew)} {
            after $trainer(autonewdelay)
            next_test
        } 
    } else {
        incr cmatrix($ttype-$ntype)
        set chordlist [make_chordlist $troot $ntype]
        if {$trainer(autoplay) && $trainer(testmode) != "visual"} {playchord $chordlist  $trainer(playmode)}
        .f.ans configure -text $lang(try)
        }
   if {[winfo exist .stats]} {
      if {$ntrials > 1 } {
         set field [set ttype]-[set ntype]
         .stats.m.$field configure -text $cmatrix($ttype-$ntype)
          set accuracy [expr 100.0 * double($ncorrect)/$ntrials]
          set accuracy [format "%6.2f %% correct for %d trials "  $accuracy $ntrials]
          set meantime [expr double($total_time)/$ntrials]
          set meantime [format "average time %5.2f sec" $meantime]
          .stats.lab configure -text $accuracy\n$meantime
          #puts "$ntrials $total_time"
            }
        }
}

proc verify_interval {ntype} {
    global trainer
    global troot ttype tdir
    if {$trainer(exercise) == "intervals"} {
        verify_interval_id $ntype
    } else {
        if {$trainer(testmode) == "visual" || $trainer(testmode) == "both"} {
            show_interval $troot $ntype $tdir}
        playothernote $troot $ntype $tdir}
}

proc verify_interval_id {ntype} {
    global ttype tdir
    global trainer
    global cmatrix
    global try test_time total_time ntrials
    global ncorrect
    global loghandle
    global intervalname troot lang
    
    if {![info exist test_time] || $try == -1} {
        .f.ans config -text $lang(firstpress)"
        return
    }
    incr try
    set response_time [expr [clock seconds] - $test_time]
    if {[info exist loghandle]} {puts $loghandle "   $response_time $ntype"
        flush $loghandle}
    if {$try == 1} {
        incr cmatrix($ttype-$ntype)
        if {[winfo exist .stats]} {
            set field [set ttype]-[set ntype]
            .stats.m.$field configure -text $cmatrix($ttype-$ntype)
        }
    }
    if {$ntype == $ttype} {
        if {$try == 1} {incr ncorrect}
         set rootnote [midi2notename $troot]
        .f.ans configure -text "$lang(correct) $lang($intervalname) $lang(from) $rootnote"
        incr total_time $response_time
        if {[winfo exist .stats]} {
            if {$ntrials > 1 } {
                set accuracy [expr 100.0 * double($ncorrect)/$ntrials]
                set accuracy [format "%6.2f %% $lang(correct)  "  $accuracy]
                set meantime [expr double($total_time)/$ntrials]
                set meantime [format "%5.2f sec" $meantime]
                .stats.lab configure -text $accuracy$meantime
                #puts "$ntrials $total_time"
            }
        }
        update
        if {$trainer(autonew)} {
            after $trainer(autonewdelay)
            next_test
        } else {
            if {$trainer(autoplay) && ($trainer(testmode) != "visual")} {playinterval $troot $ntype $tdir $trainer(playmode)}
        }
    } else {
        if {$trainer(autoplay) && ($trainer(testmode) != "visual")} {playinterval $troot $ntype $tdir $trainer(playmode)}
        .f.ans configure -text $lang(try)
    }
}

proc verify_figbass {} {
global figbass_index chordname
global figbass_symbol submitted_figbass
global lang
global cmatrix
global try test_time total_time ntrials
#puts "submitted_figbass = $submitted_figbass figbass_index = $figbass_index chordname = $chordname"
if {![info exist test_time] || $try == -1} {
     .f.ans config -text $lang(firstpress)"
      return
   }
 incr try
 set response_time [expr [clock seconds] - $test_time]
 if {[info exist loghandle]} {puts $loghandle "   $response_time $ntype"
      flush $loghandle}
 if {$try == 1} {
        incr cmatrix($figbass_index-$submitted_figbass)
        set field [set figbass_index]-[set submitted_figbass]
        if {[winfo exist .stats]} {
           .stats.m.$field configure -text $cmatrix($figbass_index-$submitted_figbass)
            }
       }
if {$submitted_figbass ==  $figbass_index} {
  .f.ans configure -text $lang(correct) } else {
  .f.ans configure -text $lang(try)}
}

array set figtypecode {
"" "  "
inv1 \u2076\u2083
inv2 \u2076\u2084
7 \u2077
7inv1 \u2076\u2085
7inv2 \u2074\u2083 
7inv3 \u2074\u2082
}

# Part 25.0 reveal answer

proc reveal_chord {} {
    global try
    global chordname
    global tcl_platform
    global trainer
    global figbass_index
    global roman
    global figtypecode
    global enlargedfont
    set try 2
    set deg "\u00B0"
    if {$trainer(exercise) == "idfigbas"} {
         if {$tcl_platform(platform) == "windows"} {
            .f.ans config -font $enlargedfont}
         set chordtype [lindex [split $chordname -] 1]
        if {[string first "maj" $chordtype] >= 0} {set upper 1} else {set upper 0}
        set fig $roman($figbass_index)
        if {$upper} {set fig [string toupper $fig]}
        if {[string first "dim" $chordtype] >= 0} {set fig $fig$deg}
         if {[string first "7inv1" $chordname] > 0} {
            set figtype $figtypecode(7inv1) } elseif {
             [string first "7inv2" $chordname] > 0} {
            set figtype $figtypecode(7inv2) } elseif {
             [string first "7inv3" $chordname] > 0} {
            set figtype $figtypecode(7inv3) } elseif {
             [string first "inv2" $chordname] > 0} {
            set figtype $figtypecode(inv2) } elseif {
             [string first "inv1" $chordname] > 0} {
            set figtype $figtypecode(inv1) } elseif {
             [string first "7" $chordname] > 0} {
            set figtype $figtypecode(7) } else {set figtype ""}
         .f.ans configure -text "$fig$figtype    $chordname"
         } else {
        .f.ans configure -text $chordname
         }
}

proc reveal_interval {} {
    global intervalname troot lang
    set rootnote [midi2notename $troot]
    .f.ans configure -text "$lang($intervalname) $lang(from) $rootnote"
}

proc reveal_scale {} {
global ttype
global try
set try 2
.f.ans configure -text $ttype
}

proc reveal_cadence {} {
global lang
global cadencename
.f.ans configure -text $lang($cadencename)
}

proc reveal_progression {} {
global pickedprogression
.f.ans configure -text $pickedprogression
}
# Part 26.0 rhythm support


#rhythmd.tcl


#simple time
array set rhythmicpattern {
    0 {24}         1 {12 12}      2 {6 18}     3  {18 6}
    4 {6 6 6 6}    5 {6 6 12}     6 {12 6 6}   7  {6 12 6}
    8 {-12 12}     9 {-6 18}     10 {-12 6 6}  11 {-6 6 6 6}
    12 {-24}      13 {-18 6}     14 {-6 6 12}  15 {-6 12 6}
    16 {8 8 8}    17 {16 8}      18 {8 16}     19 {8 8 -8}
    20 {8 -8 8}   21 {-8 8 8}    22 {12 24 12} 23 {6 6 18 12 6}
    24 {18 12 18} 25 {6 6 6 12 6 6 6} 26 {8 8 16 8 8} 27 {6 6 24 6 6}
    28 {6 12 12 6 12}
    
    100 {12 12 12}   101 {12 24}        102 {24 12}      103 {6 6 12 12}
    104 {12 6 6 12}  105 {12 12 6 6}    106 {6 6 6 6 12} 107 {6 6 12 6 6}
    108 {12 6 6 6 6} 109 {6 6 6 6 6 6}  110 {18 6 12}    111 {6 18 12}
    112 {12 18 6}    113 {12 6 18}      114 {18 18}      115 {-12 12 12}
    116 {12 -12 12}  117 {12 12 -12}    118 {-24 12}     119 {-6 12 18}
    120 {-12 6 18}   121 {-18 18}       122 {-6 12 6 6 6} 123 {-12 6 12 6}
    124 {48 12 12}   125 {48 24}        126 {12 36 24}   127 {12 12 24 12 12}
    128 {24 24 24}
}

array set rhythmicglyph {
    0 G4         1 G2G2       2 GG3           3 G3G
    4 GGGG       5 GGG2       6 G2GG          7 GG2G
    8 z2G2       9 zG3       10 z2GG         11 zGGG
    12 z4       13 z3G       14 zGG2         15 zG2G
    16 (3G2G2G2 17 (3G2G2-G2 18 (3G2-G2G2    19 (3G2G2z2
    20 (3G2z2G2 21 (3z2G2G2  22 "G2G2- G2G2" 23 "GGG2- GG2G"
    24 "G3G- GG3" 25 "GGGG- GGGG" 26 "(3G2G2G2- (3G2G2G2"
    27 "GGG2- G2GG" 28 "GG2G- GGG2"
    
    100 G2G2G2    101 G2G4     102 G4G2        103 GGG2G2
    104 G2GGG2    105 G2G2GG   106 GGGGG2      107 GGG2GG
    108 G2GGGG    109 GGGGGG   110 G3GG2       111 GG3G2
    112 G2G3G     113 G2GG3    114 G3G3        115 z2G2G2
    116 G2z2G2    117 G2G2z2   118 z4G2        119 zG2G3
    120 z2GG3     121 z3G3     122 zG2GGG      123 z2GG2G
    124 G6-G2G2G2 125 G6-G2G4  126 G2G4-G2G4   127 G2G2G2-G2G2G2
    128 G4G2-G2G4
}

###bug the glyph for 26 (3G2G2G2- (3G2G2G2 does not much
##audio output. The glyph suggests only one beat not two.
##Two beat glyphs are no longer in use, see comment below.

set restlist {8 9 10 11 12 13 14 15 21 115 118 119 120 121 122 123}

#note rhythm patterns 22-28 and 124-128 are no longer used
#since they add one or more extra beats to the exercise
#and create a lot of confusion. They are left here temporaly
#to avoid incompatibilities between this tksolfege version
#and versions older than 0.71.


array set rhythm_accents {
    1 0
    2 {2 0}
    3 {2 0 0}
    4 {2 0 1 0}
}

proc substitute_parenthesis {notes} {
    set first  1
    while {$first > -1} {
        set first [string first "(" $notes)]
        if {$first != -1} {
            set notes [string replace $notes $first $first t]}
        set first [string first " " $notes)]
        if {$first != -1} {
            set notes [string replace $notes $first $first ]}
    }
    return $notes
}


proc load_all_glyphs {} {
    global im rhythmicglyph starkitversion dirname
    for {set i 0} {$i <= 28} {incr i} {
        set im($i) [image create photo]
        set name [substitute_parenthesis $rhythmicglyph($i)]
        if {$starkitversion} {
            $im($i) read $dirname/$name.gif
        } else {$im($i) read glyphs/$name.gif}
    }
    for {set i 100} {$i <= 128} {incr i} {
        set im($i) [image create photo]
        set name [substitute_parenthesis $rhythmicglyph($i)]
        if {$starkitversion} {
            $im($i) read $dirname/$name.gif
        } else {$im($i) read glyphs/$name.gif}
    }
}


proc make_duple_compound_interface {} {
    global rhythmsel
    global im
    if {![winfo exist .rhythmselector]} {
        toplevel .rhythmselector
        positionWindow .rhythmselector
        set w .rhythmselector.sel
        frame .rhythmselector.sel
        pack .rhythmselector.sel
        radiobutton $w.duple -text "simple time" -variable trainer(timesigtype) -value 0 \
                -command rhythm_switch_type
        radiobutton $w.compound -text "compound time" -variable trainer(timesigtype) -value 1\
                -command rhythm_switch_type
        pack $w.duple $w.compound -side left
        
        # duple interface
        set w  .rhythmselector.2
        frame $w
        pack $w
        for {set i 0} {$i <= 21} {incr i} {
            checkbutton $w.$i -image $im($i) -variable rhythmsel($i) \
                    -command make_rhythm_lesson
            set k [expr $i % 5]
            set r [expr $i / 5]
            grid $w.$i -row $r -column $k -sticky w
        }
        incr r
        
        #compound interface
        set w  .rhythmselector.3
        frame $w
        for {set i 100} {$i <= 123} {incr i} {
            checkbutton $w.$i -image $im($i) -variable rhythmsel($i) \
                    -command make_rhythm_lesson
            set k [expr $i % 5]
            set r [expr $i / 5]
            grid $w.$i -row $r -column $k -sticky w
        }
    }
}


proc set_rhythmsel {} {
    global rhythmsel
    global rhythmlist
    for {set i 0} {$i < 29} {incr i} {set rhythmsel($i) 0}
    for {set i 100} {$i < 129} {incr i } {set rhythmsel($i) 0}
    foreach item $rhythmlist {
        set rhythmsel($item) 1}
}



proc make_rhythm_buttons {} {
    global im
    set w .rhythm.t1
    for {set i 0} {$i <= 28} {incr i} {
        button .rhythm.t1.$i -image $im($i) -command "addrhythm $i"
    }
    for {set i 100} {$i <= 128} {incr i} {
        button .rhythm.t1.$i -image $im($i) -command "addrhythm $i"
    }
}


proc select_rhythm_lesson {num} {
    global trainer
    global rhythmlist
    global duplerhythmlesson compoundrhythmlesson
    clear_rhythm_buttons
    set w .rhythm.t1
    if {$trainer(timesigtype)} {
        set trainer(rhythmtypes) $compoundrhythmlesson($num)
    } else {
        set trainer(rhythmtypes) $duplerhythmlesson($num)
    }
    set rhythmlist $trainer(rhythmtypes)
    set_rhythmsel
    place_rhythm_buttons
}


proc make_rhythm_lesson {} {
    global trainer
    global rhythmlist
    clear_rhythm_buttons
    make_rhythm_list
    set trainer(rhythmtypes) $rhythmlist
    place_rhythm_buttons
    
}



proc place_rhythm_buttons {} {
    global rhythmlist
    global im
    set i 0
    set c 0
    set r 0
    .rhythm.t1 configure -width 400 -height 42
    foreach item $rhythmlist {
        set creq [expr [image width $im($item)] + 6]
        #  grid .rhythm.t1.$item -column $c -row $r -columnspan $creq -sticky w
        place .rhythm.t1.$item  -in .rhythm.t1 -x $c -y $r
        set c [expr $c + $creq]
        if {$c > 300} {set c 0
            incr r 37
            .rhythm.t1 configure -height [expr $r +40]}
    }
    set c [expr $c +30]
    set rest [expr 315 - $c]
    if {$rest <1} {set rest 1}
}


proc clear_rhythm_buttons {} {
    global rhythmlist
    if {[info exist rhythmlist] == 0} return
    foreach item $rhythmlist {
        place forget .rhythm.t1.$item
    }
}


proc addrhythm {item} {
    global usersbeats im beats
    global backup_index
    global lang
    set n [llength $usersbeats]
    if {![info exist beats]} {
        .f.ans configure -text $lang(firstpress)
        return}
    set m [llength $beats]
    if {$n == $backup_index} {
        if {$n >= $m} {.f.ans configure -text "$lang(already) $m $lang(beats)"
            return}
        lappend usersbeats $item
        label .rhythm.rhythmresponse.$n -image $im($item)
        bind .rhythm.rhythmresponse.$n <Button> "toggle_rhythm_element $n"
        pack .rhythm.rhythmresponse.$n -side left -anchor w
        incr backup_index
    } else {
        set i $backup_index
        set usersbeats [lreplace $usersbeats $backup_index $backup_index $item]
        .rhythm.rhythmresponse.$backup_index configure -image $im($item)
    }
}


proc clear_rhythm_response {} {
    global usersbeats
    if {![info exist usersbeats]} return
    set i 0
    foreach item $usersbeats {
        pack forget .rhythm.rhythmresponse.$i
        destroy .rhythm.rhythmresponse.$i
        incr i
    }
}

proc highlight_rhythm_element {i status} {
    if {$status} {
        .rhythm.rhythmresponse.$i configure -relief raised -borderwidth 5
    } else {
        .rhythm.rhythmresponse.$i configure -relief flat -borderwidth 2
    }
}


proc toggle_rhythm_element {m} {
    global usersbeats backup_index
    set n [llength $usersbeats]
    if {$backup_index >= $n} {
        set backup_index $m
        highlight_rhythm_element $backup_index 1
    } elseif {$backup_index == $m} {
        highlight_rhythm_element $backup_index 0
        set backup_index $n
    } else {
        highlight_rhythm_element $backup_index 0
        set backup_index $m
        highlight_rhythm_element $backup_index 1
    }
}



proc make_rhythm_list {} {
    global rhythmsel
    global rhythmlist
    global trainer
    set rhythmlist {}
    
    if {$trainer(timesigtype)} {
        for {set i 100} {$i <= 128} {incr i} {
            if {$rhythmsel($i)} {
                lappend rhythmlist $i }
        }
    } else {
        for {set i 0} {$i <= 28} {incr i} {
            if {$rhythmsel($i)} {
                lappend rhythmlist $i }
        }
    }
}


proc make_norest_rhythmlist {} {
    global rhythmlist norest_rhythmlist
    global restlist
    set norest_rhythmlist {}
    foreach item $rhythmlist {
        if {[lsearch $restlist $item] < 0} {
            lappend norest_rhythmlist $item}
    }
}


proc make_random_rhythm {nbeats} {
    global rhythmlist
    global trainer norest_rhythmlist
    global lang
    if {$trainer(norest)} {
        make_norest_rhythmlist
        set lnorest [llength $norest_rhythmlist]
    }
    set patlist {}
    if {[llength $rhythmlist] < 1} {.f.ans configure -text $lang(picklesson)
        return}
    set length [llength $rhythmlist]
    for {set i 0} {$i < $nbeats} {incr i} {
        if {$i == 0 && $trainer(norest) && $lnorest >0} {
            set n [expr $lnorest * rand()]
            set n [expr int($n)]
            set mubol [lindex $norest_rhythmlist $n]
            if {$mubol >= 22 && $trainer(timesigtype) == 0} {incr i}
            if {$mubol >= 123 && $trainer(timesigtype) == 1} {incr i}
            lappend patlist $mubol
        } else {
            set n [expr $length * rand() ]
            set n [expr int($n)]
            set mubol [lindex $rhythmlist $n]
            #    if {$mubol >= 22 && $trainer(timesigtype) == 0} {incr i}
            #    if {$mubol >= 123 && $trainer(timesigtype) == 1} {incr i}
            lappend patlist $mubol
        }
    }
    return $patlist
}


proc make_velocity_pattern {beat m} {
    # The accent depends on the numerator of the time signature
    # and the beat number in the measure (m). Only the first
    # note in the beat is accented.
    global trainer
    global rhythm_accents
    set pat {}
    set i 0
    set n $trainer(rhythm_beats_per_bar)
    set j [expr $m % $n]
    set pattern $rhythm_accents($n)
    set multiplier [lindex $pattern $j]
    #puts $beat
    foreach elem $beat {
        if {$elem < 0} {lappend pat 0}
        if {$i == 0} {
            set elem [expr $trainer(rhythmvelocity) +$multiplier*$trainer(rhythm_accent)]
            if {$elem > 100} {set elem 100}
        } else {
            set elem  $trainer(rhythmvelocity)
        }
        incr i
        lappend pat $elem
    }
    return $pat
}


proc make_accented_velocities {nbeats} {
    #used to make pattern for leader
    global rhythm_accents
    global trainer
    set velocities {}
    foreach elem $rhythm_accents($nbeats) {
        set accent [expr $elem * $trainer(rhythm_accent)]
        set vel [expr $trainer(rhythmvelocity) + $trainer(rhythm_accent)]
        if {$vel > 100} {set vel 100}
        lappend velocities $vel
    }
    return $velocities
}


proc make_sound_sequence {beats} {
    global rhythmicpattern
    set seq {}
    set velocity_pattern {}
    set i 0
    foreach beat $beats {
        set seq [concat $seq $rhythmicpattern($beat)]
        set pat [make_velocity_pattern $rhythmicpattern($beat) $i]
        set velocity_pattern [concat $velocity_pattern $pat]
        incr i
    }
    #puts $seq
    return [list $seq $velocity_pattern]
}


proc convert_sound_sequence {eventlist} {
    global trainer
    set mslist {}
    set accumulated_time 0.0
    set bpmfactor [expr 60000.0/($trainer(rhythmbpm)*24.0)]
    foreach timeunit $eventlist {
        set accumulated_time [expr $accumulated_time + abs($timeunit)*$bpmfactor]
        set actime [expr int(round($accumulated_time))]
        if {$timeunit < 0} {lappend mslist z}
        lappend mslist $actime
    }
    return $mslist
}

proc play_eventlist {rhythmsequence velocitysequence} {
    global trainer
    set fromtime 0.0
    set silent 0
    
    
    foreach note $rhythmsequence vol $velocitysequence {
        if {$note == "z"} {set silent 1
            continue}
        set msec [expr int($note - $fromtime)]
        set fromtime $note
        if {$silent} {
            muzic::playnote 0 $trainer(rhythmpitch) 0 $msec
        } else {
            muzic::playnote 0 $trainer(rhythmpitch) $vol $msec
        }
        after $msec set proceed 1
        vwait proceed
        set silent 0
    }
}


proc play_rhythm {} {
    global beats
    global trainer
    global lang
    if {![info exist beats]} {.f.ans configure -text $lang(firstpress)
        return}
    set seqlist [make_sound_sequence $beats]
    set mlist [convert_sound_sequence [lindex $seqlist 0]]
    set loudpat [lindex $seqlist 1]
    muzic::channel 0 $trainer(rhythminstrument)
    play_eventlist $mlist $loudpat
}

proc play_leader {} {
    global beatleader velocityleader
    global trainer
    set mlist [convert_sound_sequence $beatleader]
    muzic::channel 0 $trainer(leaderinstrument)
    play_eventlist $mlist $velocityleader
}


proc play_rhythm_leader {} {
    global beatleader velocityleader
    global trainer
    set nbeats $trainer(rhythm_beats_per_bar)
    if {$nbeats < 2} {set nbeats 4}
    set velocityleader [make_accented_velocities $nbeats]
    if {$trainer(timesigtype) == 0} {
        set beatleader {}
        for {set i 0} {$i < $nbeats} {incr i} {
            lappend beatleader 24
        }
    } else {
        set beatleader {}
        for {set i 0} {$i < $nbeats} {incr i} {
            lappend beatleader 36
        }
    }
    play_leader
}


proc test_rhythm {} {
    global beats trainer;
    global trainer usersbeats
    global backup_index
    global answer_exposed
    global rhythmnbeats
    set rhythmnbeats [expr $trainer(rhythm_bars)*$trainer(rhythm_beats_per_bar)]
    .f.ans configure -text ""
    clear_rhythm_answer
    clear_rhythm_response
    set usersbeats {}
    set backup_index 0
    set answer_exposed 0
    #make_rhythm_list
    set beats [make_random_rhythm $rhythmnbeats]
    play_rhythm_leader
    play_rhythm
}



proc show_rhythm_answer {} {
    global beats
    global im
    global lang
    global answer_exposed
    global ntrials
    global answerlength
    set i 0
    if {![info exist beats]} {.f.ans configure -text $lang(firstpress)
        return}
    incr ntrials
    if {[check_rhythm_response] <0 || $answer_exposed} return
    foreach item $beats {
        label .rhythm.rhythmans.$i -image $im($item)
        pack .rhythm.rhythmans.$i -side left -anchor w
        incr i
    }
    set answer_exposed 1
    if {[winfo exist .stats.trials]} {.stats.trials configure -text $ntrials}
    set answerlength $i
}


proc clear_rhythm_answer {} {
    global trainer
    global rhythmnbeats
    global answerlength;
    if {![info exist answerlength]} return
    if {![winfo exist .rhythm.rhytmans.0] && [info exist rhythmnbeats]} {
        for {set i 0} {$i < $answerlength} {incr i} {
            pack forget .rhythm.rhythmans.$i
            destroy .rhythm.rhythmans.$i
        }
    }
    set answerlength 0
}

proc check_rhythm_response {} {
    global usersbeats
    global beats
    global lang
    global ncorrect
    global ntrials
    global mnotes
    global answer_exposed
    set lbeats [llength $beats]
    set ubeats [llength $usersbeats]
    if {$ubeats == 0} {return 0}
    set dif [expr $lbeats - $ubeats]
    if {$dif !=0} {.f.ans configure -text "$dif $lang(more)"
        return -1}
    set k 0
    foreach user $usersbeats ans $beats {
        if {$user == $ans} {incr k}
    }
    .f.ans config -text "$k/$lbeats $lang(correct)"
    if {!$answer_exposed} {set ncorrect [expr $ncorrect + $k]}
    set mnotes $ubeats
    update_sofa_rhythm_stats
    return $k
}


proc rhythm_switch_type {} {
    global rhythmlist
    global backup_index usersbeats
    global trainer
    set backup_index 0
    clear_rhythm_answer
    clear_rhythm_response
    set usersbeats {}
    set rhythmtypes ""
    #set rhythmlist $trainer(rhythmtypes)
    clear_rhythm_buttons
    if {![winfo exist .rhythmselector]} return
    if {$trainer(timesigtype) == 0} {pack forget .rhythmselector.3;
        pack .rhythmselector.2
        .f.lessmenu configure -menu .f.lessmenu.duplerhythms
        make_rhythm_list
        place_rhythm_buttons
    } else {pack forget .rhythmselector.2;
        .f.lessmenu configure -menu .f.lessmenu.compoundrhythms
        make_rhythm_list
        place_rhythm_buttons
        pack .rhythmselector.3}
}



proc startup_rhythm_dictation {} {
    
    global rhythmlesson
    global usersbeats backup_index
    global rhythmlist
    global trainer
    
    set rhythmlist $trainer(rhythmtypes)
    load_all_glyphs
    
    set w .rhythm
    frame $w
    #frame .rhythm.control
    #pack .rhythm.control -side top
    
    #set w .rhythm.control
    set w .rhythm.t1
    frame .rhythm.t1 -borderwidth 3 -relief groove
    pack .rhythm.t1 -side top
    
    
    make_rhythm_buttons
    set_rhythmsel
    place_rhythm_buttons
    
    
    pack $w -side top
    set w .rhythm.rhythmresponse
    frame $w
    pack $w -anchor w -side top
    frame .rhythm.rhythmans
    pack .rhythm.rhythmans -anchor w
    set usersbeats {}
    set backup_index 0
}

# Part 27.0 melody dictation

#source mel.tcl

array set sofapitch {
    so, -5		si, -4		le, -4		la, -3
    li, -2		te, -2		ti, -1		do   0
    di   1		ra  1		re   2		ri   3
    me   3		mi  4		fa   5		fi   6
    se   6		so  7		si   8		le   8
    la   9		li  10		te  10		ti   11
    do'  12	di' 13		ra' 13		re'  14
    ri'  15	me' 15		mi' 16		fa'  17
    fi'  18	se' 18		so' 19}

set sofas {so, si, le, la, li, te, ti, do  di  ra
    re  ri  me  mi  fa  fi  se  so  si  le
    la  li  te  ti  do' di' ra' re' ri' me'
    mi' fa' fi' se' so'}


proc startup_sofa_dictation {} {
    global sofasel
    global usersnotes
    global backup_index
    global lang
    global trainer

    set usersnotes {}
    set backup_index 0
    set w .dorayme
    pack propagate . 1
    frame .dorayme 
    pack .dorayme -side top

    set w .dorayme.ctl
    frame $w
    pack $w -anchor nw
    button $w.submit -text $lang(submit) -command check_sofa_response
    pack $w.submit  -anchor nw -side left
    button $w.playscale -text scale  -command {playsofa_notes $trainer(sofa_tonic)}

    set w .dorayme.sel
    frame $w
    pack $w -anchor nw
    set w .dorayme.sel2
    frame $w
    pack $w -anchor w
    set w .dorayme.sel3
    frame $w
    pack $w -anchor w
    
    
    set w .dorayme.response
    frame $w
    pack $w -anchor w
    
    set w .dorayme.ans
    frame $w
    pack $w -side top -anchor w
    
    set_sofa_lesson
    if {$trainer(exercise) == "sofaid"} {
      place_sofa_id_buttons
    } else {
      place_sofa_buttons 
    }

}


proc startup_sofa_sing {} {
    global sofasel
    global usersnotes
    global backup_index
    global trainer
    set usersnotes {}
    set backup_index 0
    set w .doraysing
    frame $w
    
    set width [expr 120 + 25*$trainer(sofa_notes)]
    set sofacanvas .doraysing.c
    canvas $sofacanvas -height 140 -width $width
    pack $sofacanvas
    
    set w .doraysing.msg
    label $w -text "   "
    pack $w
    
    set_sofa_lesson
}



proc make_sofa_buttons {} {
    global sofas
    global lang
    set w .sofasel
    if {[winfo exist $w]} return
    toplevel $w
    positionWindow .sofasel
    foreach n $sofas {
        checkbutton $w.$n -text $lang($n) -variable sofasel($n) -command make_sofa_lesson
    }
    grid $w.so, -stick w
    grid $w.si, -row 0 -column 2 -stick w
    grid $w.la, $w.le, $w.li, -stick w
    grid $w.ti, $w.te, -stick w
    grid $w.do -stick w
    grid $w.di -row 3 -column 2 -stick w
    grid $w.re $w.ra $w.ri -stick w
    grid $w.mi $w.me -stick w
    grid $w.fa -stick w
    grid $w.fi -row 6 -column 2 -stick w
    grid $w.so $w.se $w.si -stick w
    grid $w.la $w.le $w.li -stick w
    grid $w.ti $w.te -stick w
    grid $w.do' -stick w
    grid $w.di' -row 10 -column 2 -stick w
    grid $w.re' $w.ra' $w.ri' -stick w
    grid $w.mi' $w.me' -stick w
    grid $w.fa' -stick w
    grid $w.fi' -row 13 -column 2 -stick w
    grid $w.so' $w.se'  -stick w
}


proc place_sofa_buttons {} {
    global sofasel sofas
    global sofanotes
    global trainer
    global lang
    #puts "play_sofa_buttons:"
    set i 0
    set sofanotes {}
    set w .dorayme.sel
    foreach note $sofas {
        if {$sofasel($note)} {
            button $w.$i -text $lang($note) -command "addsofa_response $note"
            pack $w.$i -side left -anchor w
            lappend sofanotes $note
            incr i
            if {$i > 11} {set w .dorayme.sel2}
            if {$i > 23} {set w .dorayme.sel3}
        }
    }
    set trainer(sofalesson) $sofanotes
    set trainer(sofalesson) $sofanotes
}

proc place_sofa_id_buttons {} {
    global sofasel sofas
    global sofanotes
    global trainer
    global lang
    set i 0
    set sofanotes {}
    set w .dorayme.sel
    foreach note $sofas {
        if {$sofasel($note)} {
            button $w.$i -text $lang($note) -command "verify_sofa $note"
            pack $w.$i -side left -anchor w
            lappend sofanotes $note
            incr i
            if {$i > 11} {set w .dorayme.sel2}
            if {$i > 23} {set w .dorayme.sel3}
        }
    }
    set trainer(sofalesson) $sofanotes
    zero_sofaid_confusion_matrix
}

proc clear_sofa_buttons {} {
    set w .dorayme.sel
    for {set i 0} {$i <35} {incr i} {
        if {$i > 11} {set w .dorayme.sel2}
        if {$i > 23} {set w .dorayme.sel3}
        destroy $w.$i
    }
}

proc make_sofa_lesson {} {
    global trainer lang
    clear_sofa_buttons
    if {$trainer(exercise) == "sofaid"} {
      place_sofa_id_buttons
    } else {
      place_sofa_buttons
    }
}

proc make_sofa_response {} {
global melodylist
set n 0
foreach note $melodylist {
  button .dorayme.response.$n -text "  " -bd 1 -padx 0 -pady 0
  pack .dorayme.response.$n -side left -anchor w
  incr n
  }
}

proc activate_sofa_editor {} {
global trainer
for {set n 1} {$n < $trainer(sofa_notes)} {incr n} {
  .dorayme.response.$n configure -command "toggle_sofa_note $n"
  }
}


proc addsofa_response {note} {
    global usersnotes
    global melodylist
    global lang
    global backup_index
    if {![info exist melodylist]} {
        .f.ans config -text $lang(firstpress)
        return
    }
    set n [llength $usersnotes]
    set m [llength $melodylist]
    if {$n == $backup_index} {
        if {$n >= $m} {.f.ans configure -text "$lang(already) $m $lang(beats)"
            return}
    }
    if {$backup_index == $n} {
        lappend usersnotes $note
        incr backup_index
        .dorayme.response.$n configure -text $lang($note) 
        incr n
        if {$n == $m} {activate_sofa_editor}
    } else {
        .dorayme.response.$backup_index configure -text $lang($note)
        set usersnotes [lreplace $usersnotes $backup_index $backup_index $note]
    }
}


proc highlight_sofa_element {i status} {
    if {$status} {
        .dorayme.response.$i configure -fg darkblue
    } else {
        .dorayme.response.$i configure -fg black
    }
}


proc toggle_sofa_note {m} {
    global usersnotes backup_index
    set n [llength $usersnotes]
    if {$backup_index >= $n} {
        set backup_index $m
        highlight_sofa_element $backup_index 1
    } elseif {$backup_index == $m} {
        highlight_sofa_element $backup_index 0
        set backup_index $n
    } else {
        highlight_sofa_element $backup_index 0
        set backup_index $m
        highlight_sofa_element $backup_index 1
    }
}

proc clear_sofa_response {} {
    global trainer
    global backup_index
    global usersnotes
    set backup_index 0
    foreach but [pack slaves .dorayme.response] {
        destroy $but
        }
    set usersnotes {}
}


proc clear_sofa_answer {} {
    global trainer
    global answerlength;
    if {![info exist answerlength]} return
    if {[winfo exist .dorayme.ans.0]} {
        for {set i 0} {$i < $answerlength} {incr i} {
            pack forget .dorayme.ans.$i
            destroy .dorayme.ans.$i
        }
    }
    set answerlength 0
}

proc show_sofa_answer {} {
    global lang
    global answer_exposed
    global answerlength
    global melodylist
    global ntrials
    global trainer
    
    if {$trainer(exercise) == "sofadic"} {
        if {[check_sofa_response] < 0} return
    }
    if {![info exist melodylist]} {
        .f.ans configure -text $lang(firstpress)
        return}
    set i 0
    clear_sofa_answer
    foreach note $melodylist {
        label .dorayme.ans.$i -text $lang($note)
        pack .dorayme.ans.$i -side left -anchor w
        incr i
    }
    set answer_exposed 1
    set answerlength $i
}


proc check_sofa_response {} {
    global melodylist usersnotes
    global answer_exposed lang
    global ncorrect nrepeats mnotes
    global sofapitch
    global ntrials
    set k 0
    incr ntrials
    set unotes [llength $usersnotes]
    if {![info exist melodylist]} {return -1}
    set mnotes [llength $melodylist]
    set dif [expr $mnotes - $unotes]
    if {$dif != 0} {
        .f.ans configure -text "$dif $lang(more)"
        return -1
    }
    set n 0
    foreach user $usersnotes ans $melodylist {
        if {$sofapitch($user) == $sofapitch($ans)} {incr k
           .dorayme.response.$n configure -fg black
           } else {
           .dorayme.response.$n configure -fg red
           }
        incr n
    }
    .f.ans configure -text "$k/$mnotes $lang(correct)"
    if {!$answer_exposed} {set ncorrect [expr $ncorrect + $k]}
    set answer_exposed 1
    update_sofa_rhythm_stats
    return k
}

proc update_sofa_rhythm_stats {} {
    global ncorrect nrepeats mnotes
    global ntrials
    if {![info exist mnotes]} return
    set tnotes [expr $mnotes*$ntrials]
    set accuracy [expr 100.0*$ncorrect/double($tnotes)]
    set accuracy [format "%5.2f" $accuracy]
    set arepeats [expr $nrepeats/double($ntrials)]
    set arepeats [format "%5.2f" $arepeats]
    if {[winfo exist .stats.trials]} {
        .stats.trials configure -text $ntrials
        .stats.repeats configure -text $arepeats
        .stats.accuracy configure -text "$ncorrect/$tnotes = $accuracy %"}
}


proc select_sofa_lesson {n} {
    global sofa_lesson
    global sofas
    global trainer
    global sofas
    global sofasel
    if {$n < 10} {
        set trainer(sofalesson) $sofa_lesson($n)
    } else {
        set trainer(sofalesson) $sofas
    }
    set_sofa_lesson
    clear_sofa_buttons
    switch $trainer(exercise) {
      sofadic -
      sofaid {place_sofa_id_buttons}
      } 
}

proc set_sofa_lesson {} {
    global trainer
    global sofas sofasel
    foreach note $sofas {
        set sofasel($note) 0}
    foreach note $trainer(sofalesson) {
        set sofasel($note) 1}
}


proc test_sofadic {} {
    global melodylist
    global answer_exposed
    global lang
    global test_time
    clear_sofa_response
    clear_sofa_answer
    update
    make_melody_list
    make_sofa_response
    set first [lindex $melodylist 0]
    addsofa_response $first
    update
    #puts $melodylist
    play_sofa
    set answer_exposed 0
    set test_time [clock seconds]
}

proc test_sofaid {} {
    global melodylist
    global answer_exposed
    global lang
    global test_time
    clear_sofa_response
    clear_sofa_answer
    update
    make_sofa_note
    set first [lindex $melodylist 0]
    update
    #puts $melodylist
    play_sofa
    set answer_exposed 0
    set test_time [clock seconds]
}



proc shift_octave {note dir} {
    set octave [string index $note 1]
    if {[string is integer $octave]} {
        set pitchclass [string index $note 0]} else {
        set octave [string index $note 2]
        set pitchclass [string range $note 0 1 ]
    }
    incr octave $dir
    set note $pitchclass$octave
    return $note
}




proc setup_sofa2note {root} {
    # sets up the translator from MIDI pitch notation to
    # note name notation. Based on the tonic of the
    # major scale, the program decides whether to use
    # flats or sharps in the notation.
    global sharpnotesarray flatnotesarray notename
    global majseq sofa2note
    global default_sofa2note
    set vocalizations {do re mi fa so la ti do\'}
    set midipitch $root
    set root [expr $root % 12]
    #puts "setup_sofa2note $root"
    if {[lsearch  "5 10 3 8 1" $root] != -1} {
        foreach increm $majseq note $vocalizations {
            set root [expr ($root + $increm) % 12]
            set midipitch [expr $midipitch + $increm]
            set octave [expr $midipitch/12 - 1]
            set pitchclass $flatnotesarray($root)
            if {[string length $pitchclass] == 1} {
                set sofa2note($note) $pitchclass=$octave
            } else {
                set sofa2note($note) $pitchclass$octave
            }
            #     puts "$note $sofa2note($note)"
        }
    } else {
        foreach increm $majseq note $vocalizations {
            set root [expr ($root + $increm) % 12]
            set midipitch [expr $midipitch + $increm]
            set octave [expr $midipitch/12 - 1]
            set pitchclass $sharpnotesarray($root)
            if {[string length $pitchclass] == 1} {
                set sofa2note($note) $pitchclass=$octave
            } else {
                set sofa2note($note) $pitchclass$octave
            }
            #      puts "$note $sofa2note($note)"
        }
    }
    set sofa2note(di) [sharpen $sofa2note(do) 1]
    set sofa2note(ra) [flatten $sofa2note(re) 1]
    set sofa2note(ri) [sharpen $sofa2note(re) 1]
    set sofa2note(me) [flatten $sofa2note(mi) 1]
    set sofa2note(fi) [sharpen $sofa2note(fa) 1]
    set sofa2note(se) [flatten $sofa2note(so) 1]
    set sofa2note(si) [sharpen $sofa2note(so) 1]
    set sofa2note(le) [flatten $sofa2note(la) 1]
    set sofa2note(li) [sharpen $sofa2note(la) 1]
    set sofa2note(te) [flatten $sofa2note(ti) 1]
    
    set sofa2note(so,) [shift_octave $sofa2note(so) -1]
    set sofa2note(si,) [shift_octave $sofa2note(si) -1]
    set sofa2note(le,) [shift_octave $sofa2note(le) -1]
    set sofa2note(la,) [shift_octave $sofa2note(la) -1]
    set sofa2note(li,) [shift_octave $sofa2note(li) -1]
    set sofa2note(te,) [shift_octave $sofa2note(te) -1]
    set sofa2note(ti,) [shift_octave $sofa2note(ti) -1]
    
    set sofa2note(do') [shift_octave $sofa2note(do) 1]
    set sofa2note(di') [shift_octave $sofa2note(di) 1]
    set sofa2note(ra') [shift_octave $sofa2note(ra) 1]
    set sofa2note(re') [shift_octave $sofa2note(re) 1]
    set sofa2note(ri') [shift_octave $sofa2note(ri) 1]
    set sofa2note(mi') [shift_octave $sofa2note(mi) 1]
    set sofa2note(me') [shift_octave $sofa2note(me) 1]
    set sofa2note(fa') [shift_octave $sofa2note(fa) 1]
    set sofa2note(fi') [shift_octave $sofa2note(fi) 1]
    set sofa2note(so') [shift_octave $sofa2note(so) 1]
    set sofa2note(se') [shift_octave $sofa2note(se) 1]
    array set default_sofa2note [array get sofa2note]
    remove_accidentals_from_major_scale
}

proc restore_sofa2note {sofa} {
    global sofa2note default_sofa2note
    global sofas
    set k [string index $sofa 0]
    foreach voc $sofas {
        if {[string index $voc 0] == $k} {
            set sofa2note($voc) $default_sofa2note($voc)
            #    puts "$voc to $default_sofa2note($voc)"
        }
    }
}


proc drop_accidental {sofa} {
    global sofa2note
    set note $sofa2note($sofa)
    if {[string length $note] < 3} return
    set k [string index $note 0]
    set octave [string index $note 2]
    set note $k$octave
    set sofa2note($sofa) $note
}

proc remove_accidentals_from_major_scale {} {
    # because they are presumed from the key signature
    set scale {so, la, ti, do re mi fa so la ti do' re' mi' fa'}
    foreach note $scale {
        drop_accidental $note
    }
}

proc test_noteid {} {
    global melodylist
    global trainer
    global notelist
    clear_sofa_answer
    .doraysing.msg config -text ""
    #set width [expr $trainer(sofa_notes)*20+70]
    set width 120
    .doraysing.c configure  -width $width
    set clefcode $trainer(clefcode)
    #set seq [makemidiseq $trainer(sofa_notes)]
    set seq [makemidiseq 1]
    set notelist [midiseq2notelist_chromatic $seq]
    notelist_interface
    notate_sofa 48 $trainer(clefcode)
    update
}

  

proc test_sofasing {first_time} {
    global melodylist
    global trainer
    global notelist
    #clear_sofa_response
    #clear_sofa_answer
    .doraysing.msg config -text ""
    if {$first_time} make_melody_pattern else make_melody_list
    set width [expr $trainer(sofa_notes)*20+70]
    .doraysing.c configure  -width $width
    set clefcode $trainer(clefcode)
    if {$clefcode < 0} {
        if {$trainer(sofa_tonic) < 60} {set clefcode 2
        } else          {set clefcode 0}
    }
    setup_sofa2note $trainer(sofa_tonic)
    set notelist [sofa2notelist $melodylist]
    notate_sofa $trainer(sofa_tonic) $clefcode
    update
    set first [lindex $melodylist 0]
    playsofa_action_1 [expr $trainer(sofa_tonic) + $trainer(transpose)]
}

proc test_sofabadnote {first_time} {
    global melodylist
    global notelist
    global trainer
    global melody_varlist
    global try
    global ntrials
    incr ntrials
    set try -1
    .doraysing.msg config -text ""
    if {$first_time} make_melody_pattern else make_melody_list
    make_melody_var_list
    setup_sofa2note $trainer(sofa_tonic)
    set notelist [sofa2notelist $melody_varlist]
    set width [expr $trainer(sofa_notes)*20+70]
    .doraysing.c configure  -width $width
    set clefcode $trainer(clefcode)
    if {$clefcode < 0} {
        if {$trainer(sofa_tonic) < 60} {set clefcode 2
        } else          {set clefcode 0}
    } 
    notate_sofa $trainer(sofa_tonic) $clefcode
    .doraysing.msg configure -text "click on the wrong note"
    update
    playsofa_action [expr $trainer(sofa_tonic) + $trainer(transpose)]
}


proc sofa2notelist {sequence} {
    # converts MIDI pitch notation to note name representation,
    global sofa2note
    #puts "sofa2notelist $sequence"
    set notelist ""
    foreach sofa $sequence {
        set note $sofa2note($sofa)
        lappend notelist $note
        restore_sofa2note $sofa
        drop_accidental $sofa
    }
    #puts "sofa2notelist $notelist"
    return $notelist
}

proc make_melody_list {} {
    global trainer
    global melodylist
    global sofanotes
    global melodyplacelist
    set melodylist {}
    set melodyplacelist {}
    set size [llength $sofanotes]
    set place [expr int($size*rand())]
    for {set i 0} {$i < $trainer(sofa_notes)} {incr i} {
        lappend melodylist [lindex $sofanotes $place]
        lappend melodyplacelist $place
        set newplace [expr int($size*rand())]
        set dplace [expr $newplace - $place]
        set adplace [expr abs($dplace)]
        if {$adplace > 2 && $trainer(smallint)} {
            if {$dplace >0} {set newplace [expr $place+1]
            } else {set newplace [expr $place -1]}
        }
        set place $newplace
    }
}

proc make_sofa_note {} {
    global trainer
    global sofanotes
    global melodylist
    set size [llength $sofanotes]
    set place [expr int($size*rand())]
    set note [lindex $sofanotes $place]
    #puts "make_sofa_note $note"
    set melodylist [list $note]
}

proc make_melody_var_list {} {
# the function copies melodylist to
# melody_varlist making a single random
# change.
    global melody_varlist
    global melodylist
    global melodyplacelist 
    global sofanotes
    global badnote
#   decide where to make a random change
    set nnotes [llength $melodyplacelist]
    set badnote [random_number $nnotes]    

#   replace the contents of badnote with an element in sofanotes
#   which is either before or after the current note in sofanotes
    set place [lindex $melodyplacelist $badnote]
    set nplace $place
    if {[expr rand()] > 0.5} {incr nplace} else {
       incr nplace -1}

    set size [llength $sofanotes]
    if {$nplace < 0} {set nplace [expr $size -1]}
    if {$nplace >= $size} {set nplace 0}

    set melody_varlist {}
    set i 0
    foreach n $melodylist {
       if {$i == $badnote} {
          lappend melody_varlist [lindex $sofanotes $nplace]
          }  else {
          lappend melody_varlist $n
          }
       incr i
       }
    #puts $melodylist
    #puts $badnote
    #puts $melody_varlist  
}


array set melodypat {
    0 {0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15}
    1 {0  1  0  2  0  3  0  4  0  5  0  6  0  7  0  8}
    2 {0  1  2  1  2  3  2  3  4  3  4  5  4  5  6  5}
    3 {0  2  1  3  2  4  3  5  4  6  5  7  6  8  7  9}
    4 {0  3  1  4  2  5  3  6  4  7  5  8  6  9  7 10}
    5 {0  3  2  1  4  3  2  5  4  3  6  5  4  7  6  5}
}

proc make_melody_pattern {} {
    global trainer
    global melodypat
    global melodylist
    global sofanotes
    set melodylist {}
    set size [llength $sofanotes]
    set size2 [expr $size*2 -1]
    for {set i 0} {$i < $trainer(sofa_notes)} {incr i} {
        set pos [lindex $melodypat($trainer(melpat)) $i]
        set place [expr $pos % $size2]
        if {$place >= $size} {set place [expr $size2 - $place]}
        lappend melodylist [lindex $sofanotes $place]
    }
}


proc select_pat {pat} {
    global lang
    global trainer
    array set melpats {
        0 0123 1 0102 2 0123 3 0213 4 0314 5 0321}
    set v .config.sofasing.pattern
    $v config -text $melpats($pat)
    set trainer(melpat) $pat
    test_sofasing 1
}

proc play_sofa {} {
    global trainer
    if {$trainer(exercise) == "sofasing"} {
        playsofa_action [expr $trainer(sofa_tonic) + $trainer(transpose)]
    } elseif {$trainer(exercise) == "sofaid"} {
        playsofa_action_2 $trainer(sofa_tonic)
    } else {
        playsofa_action $trainer(sofa_tonic)
       } 
}


proc playsofa_action {root} {
    global melodylist
    global trainer lang
    global sofapitch
    if {![info exist melodylist]} {
        .f.ans configure -text $lang(firstpress)
        return}
    muzic::channel 0 $trainer(instrument)
    foreach note $melodylist {
        set k [expr $sofapitch($note) + $root]
        muzic::playnote 0 $k $trainer(velocity) $trainer(msec)
        #after $trainer(msec)
        muzic::playnote 0 $k 0 $trainer(msec)
    }
}

proc playsofa_action_1 {root} {
    #plays the first note of melodylist
    global melodylist
    global trainer lang
    global sofapitch
    if {![info exist melodylist]} {
        .f.ans configure -text $lang(firstpress)
        return}
    muzic::channel 0 $trainer(instrument)
    set note [lindex $melodylist 0]
    set k [expr $sofapitch($note) + $root]
    muzic::playnote 0 $k $trainer(velocity) $trainer(msec)
    after $trainer(msec)
    muzic::playnote 0 $k 0 $trainer(msec)
}

proc playsofa_action_2 {root} {
    #plays the first note of melodylist
    global melodylist
    global trainer lang
    global sofapitch
    if {![info exist melodylist]} {
        .f.ans configure -text $lang(firstpress)
        return}
    muzic::channel 0 $trainer(instrument)
    set note [lindex $melodylist 0]
    set k [expr $sofapitch($note) + $root]
    if {$trainer(repeattonic)} { 
      muzic::playnote 0 $root $trainer(velocity) $trainer(msec)
      }
    muzic::playnote 0 $k $trainer(velocity) $trainer(msec)
    #after $trainer(msec)
    muzic::playnote 0 $k 0 $trainer(msec)
}


proc playsofa_notes {root} {
    global sofanotes
    global trainer lang
    global sofapitch
    muzic::channel 0 $trainer(instrument)
    foreach note $sofanotes {
        set k [expr $sofapitch($note) + $root]
        muzic::playnote 0 $k $trainer(velocity) $trainer(msec)
        #after $trainer(msec)
        muzic::playnote 0 $k 0 $trainer(msec)
    }
}

proc play_selected_scale {} {
    global trainer
    global scaleoffsets
    set midikey [note2midi $trainer(key)]
    set range_center [expr $trainer(minpitch) + $trainer(range)/2]
    set midikey [expr ($range_center/12)*12 + $midikey]
    muzic::channel 0 $trainer(instrument)
    set midipitch $midikey
    muzic::playnote 0 $midipitch $trainer(velocity) $trainer(msec)
    after $trainer(msec)
    muzic::playnote 0 $midipitch 0 $trainer(msec)
    foreach pitch $scaleoffsets {
        set midipitch [expr $midikey + $pitch]
        muzic::playnote 0 $midipitch $trainer(velocity) $trainer(msec)
        after $trainer(msec)
        muzic::playnote 0 $midipitch 0 $trainer(msec)
    }
    set midipitch [expr $midikey+12]
    muzic::playnote 0 $midipitch $trainer(velocity) $trainer(msec)
    after $trainer(msec)
}

proc show_note_ids {} {
global notelist
.doraysing.msg configure -text $notelist
}

proc show_sing_sofa {} {
    global melodylist
    global lang
    set trans_melodylist {}
    foreach note $melodylist {
        lappend trans_melodylist $lang($note)
    }
    .doraysing.msg config -text $trans_melodylist
    update
}


proc config_your_own_sofa_lesson {} {
    make_sofa_buttons
}

#end of source mel.tcl

# Part 28.0 draw notation 

# tknotate.tcl
#
# Most of this code was borrowed with simplification from
# tkabc.tcl in the tclabc package that was developed by
# Jef Moine.
# http://moinejf.free.fr/tclabc-1.0.9.tar.gz.


proc canvas_redraw {musicframe width} {
    # redraw the first elements of the canvas
    global score
    # clear the canvas
    $musicframe delete all
    # create the voice rectangle, the staves and the cursor rectangle
    set voicerect [$musicframe create rectangle 5 10 \
            $width [expr {$score(height) - 10}] \
            -fill white -outline {}]
    set yoffset 40
    set y $yoffset
    for {set i 0} {$i < 5} {incr i} {
        $musicframe create line 10 $y [expr {$width}] $y
        incr y 6
    }
    incr yoffset $score(height)
}



proc note-draw {sym vclef xoffset yoffset  musicframe id} {
    # draw a note (or chord). Unlike tkabc, sym does
    # not contain the word 'note' or the note length representation.
    # All notes are assumed to be quarter notes.
    # get upper and lower note pitchlinees
    foreach [list yy_up yy_down] [note_ext $sym] break
    set deltav [expr {39 - 2 * $vclef}]
    set yy_up [expr {$deltav - $yy_up}]
    set yy_down [expr {$deltav - $yy_down}]
    
    set stem_up [expr {($yy_up + $yy_down) / 2  > 17}]
    if {$stem_up} {set flipper(1) 1}
    
    array set flipper {0 0 1 0 2 0 3 0 4 0}
    # check for flipped note
    set nnotes [expr [llength $sym] -2]
    #   puts $sym
    set shiftacc 0
    set j 0
    for {set i 0} {$i < $nnotes} {incr i} {
        set i2 [expr $i + 2]
        set pitchdif [expr [lindex $sym $i2] - [lindex $sym $i]]
        if {$pitchdif == 1} {
            if {$stem_up == 0} {set flipper($j) -1
                set shiftacc 6} else {
                set flipper([expr $j+1]) 1}
        }
        incr i
        incr j
    }
    # normal note
    # loop on each note of the chord
    set i 0
    foreach [list pitchline acc] [lrange $sym 0 end] {
        #fixme: clef may have changed in the line
        set yy [expr {$deltav - $pitchline}]
        set yoffset2 [expr {$yy * 3 + $yoffset}]
        #fixme: shift when notes are too close
        # note
        set flip $flipper($i)
        switch  --  $flip {
            0 {$musicframe create image $xoffset [expr {$yoffset2 + 2}] \
                        -image note1 -anchor w -tag note$id
                         } 
            1 {$musicframe create image [expr $xoffset+6] [expr {$yoffset2 + 2}] \
                        -image note1 -anchor w -tag note$id} 
            -1 {$musicframe create image [expr $xoffset-6] [expr {$yoffset2 + 2}] \
                        -image note1 -anchor w -tag note$id}
        }
        incr i
        
        # accidentals
        if {$acc != 0} {
            if {$acc > 5} {
                if {[llength [info commands acc$acc]] == 0} {
                    set acc [expr {$acc & 0x07}]
                }
            }
            $musicframe create image [expr {$xoffset - 1 -$shiftacc}] [expr {$yoffset2 + 1}] \
                    -image acc$acc -anchor e -tag $id-acc$acc
            set shiftacc [expr $shiftacc + 6]
        }
    }
    # extra lines
    for {set i [expr {$yy_up / 2}]} {$i < 6} {incr i} {
        set yoffset2 [expr {$i * 6 + $yoffset + 5}]
        $musicframe create line [expr {$xoffset - 3}] $yoffset2 \
                [expr {$xoffset + 9}] $yoffset2
    }
    for {set i [expr {($yy_down - 1) / 2}]} {$i > 10} {incr i -1} {
        set yoffset2 [expr {$i * 6 + $yoffset + 5}]
        $musicframe create line [expr {$xoffset - 3}] $yoffset2 \
                [expr {$xoffset + 9}] $yoffset2
    }
    # stems and flags
    
    stem-draw $xoffset $yoffset $stem_up $yy_down $yy_up 0 $musicframe $id
    return 0
}

proc note_ext {sym} {
    # return the max and min pitchlines for a given chord.
    set up [lindex $sym 0]
    set down $up
    foreach [list pitchline acc] [lrange $sym 2 end] {
        if {$pitchline > $up} {
            set up $pitchline
        }
        if {$pitchline < $down} {
            set down $pitchline
        }
    }
    return [list $up $down]
}



proc stem-draw {xoffset yoffset stem_up yy_down yy_up nflags musicframe id} {
    # draw the stem and flags of a note
    set yoffs_up [expr {$yy_up * 3 + $yoffset}]
    set yoffs_down [expr {$yy_down * 3 + $yoffset}]
    if {$stem_up} {
        incr xoffset 6
        $musicframe create line $xoffset $yoffs_down \
                $xoffset [expr {$yoffs_up - 16}] -tag $id-s
        incr xoffset 3
    } else {
        $musicframe create line $xoffset [expr {$yoffs_up + 1}] \
                $xoffset [expr {$yoffs_down + 19}] -tag $id-s
        incr xoffset 3
    }
}


array set sfTab {
    sharp {0 9 -3 6 15 3 12}
    flat {12 3 15 6 18 9 21}
}


proc key_signature {sf yoffset xoffset clefcode musicframe} {
    # draws key signature and sharp/flat pattern
    global sfTab
    if {$sf > 0} {
        set key acc1
        set keytab $sfTab(sharp)
    } else {
        set key acc3
        set keytab $sfTab(flat)
    }
    switch -- $clefcode {
        0 {set y [expr $yoffset+40]}
        1 {set y [expr $yoffset +42]}
        2 {set y [expr $yoffset +46]}
    }
    for {set i 0} {$i < [expr {abs($sf)}]} {incr i} {
        $musicframe create image [expr {$xoffset + $i * 6}] \
                [expr {$y + [lindex $keytab $i]}] \
                -image $key -anchor w -tag keysig
    }
}

array set pitchindex {
    C 0
    D 1
    E 2
    F 3
    G 4
    A 5
    B 6
}

proc note2sym {note} {
    #note  to pitchline accidental representation
    #example, C#1 to {8 1}, C2 to {15 0}
    global pitchindex
    set line $pitchindex([string index $note 0])
    set n [string index $note 1]
    if {[string is digit $n]} {return "[expr $line+($n-2)*7+2] 0"}
    set acc $n
    set n [string index $note 2]
    set pitchline [expr $line+($n-2)*7+2]
    switch $acc {
        \# {return "$pitchline 1"}
        = {return "$pitchline 2"}
        b  {return "$pitchline 3"}
        d  {return "$pitchline 4"}
        v  {return "$pitchline 5"}
    }
    return error
}

array set sharpnotesarray {
    0 C 1 C# 2 D 3 D# 4 E 5 F 6 F# 7 G 8 G# 9 A 10 A# 11 B}

array set flatnotesarray {
    0 C 1 Db 2 D 3 Eb 4 E 5 F 6 Gb 7 G 8 Ab 9 A 10 Bb 11 B}

array set reversenotearray {
    Cb -1 C 0 C# 1 Db 1 D 2 D# 3 Eb 3 E 4 Fb 4 E# 4 F 5 F# 6 Gb 6 G 7 G# 8
    Ab 8 A 9 A# 10 Bb 10 B 11  B# 12}


set majseq {0 2 2 1 2 2 2 1}

array set root2sf {0 0 1 -5 2 2 3 -3 4 4 5 -1 6 6 7 1 8 -4 9 3 10 -2 11 5}
# maps tonic of major scale (in MIDI pitch units) to number of
# sharps or flats (negative).


proc note2midi {note} {
    global reversenotearray
    return $reversenotearray($note)
}

proc setup_midi_note_translator {root} {
    # sets up the translator from MIDI pitch notation to
    # note name notation. Based on the tonic of the
    # major scale, the program decides whether to use
    # flats or sharps in the notation.
    global sharpnotesarray flatnotesarray notename
    global majseq
    if {[lsearch  "5 10 3 8 1" $root] != -1} {
        foreach increm $majseq {
            set root [expr ($root + $increm) % 12]
            if {[string length $flatnotesarray($root)]>1} {
                set root1 [expr ($root + 1) % 12]
                set notename($root) $flatnotesarray($root1)
                set notename($root1) $flatnotesarray($root1)=
            } else {
                set root1 [expr ($root + 11) % 12]
                set notename($root) $flatnotesarray($root)
                set s1 [string index $notename($root) 0]
                set s2 [string index $flatnotesarray($root1) 0]
                if {$s1 == $s2} {set notename($root1) $flatnotesarray($root1)}
            }
        }
    } else {
        foreach increm $majseq {
            set root [expr ($root + $increm) % 12]
            if {[string length $sharpnotesarray($root)]>1} {
                set root1 [expr ($root + 11) % 12]
                set notename($root) $sharpnotesarray($root1)
                set notename($root1) $sharpnotesarray($root1)=
            } else {
                set root1 [expr ($root + 1) % 12]
                set notename($root) $sharpnotesarray($root)
                set notename($root1) $sharpnotesarray($root1)
            }
        }
    }
    #for {set i 0} {$i < 12} {incr i} {
    #  puts "$i $notename($i)"}
}

proc midi2note {midipitch propagate} {
    # converts a specific MIDI pitch to note name representation.
    global notename
    if {![info exist notename]} {setup_midi_note_translator 60}
    # sets up the translator from MIDI pitch notation to
    set octave [expr $midipitch/12 - 1]
    set norm_midipitch [expr $midipitch % 12]
    set pitchclass $notename($norm_midipitch)
    #puts "midi2note: $norm_midipitch $pitchclass"
    if {!$propagate} {return $pitchclass$octave}
    # propagate sharps and flats
    if {[string index $pitchclass 1] == "#"} {
        set notename($norm_midipitch) [string index $notename($norm_midipitch) 0]
        set norm_midipitch1 [expr ($norm_midipitch +11) % 12]
        set notename($norm_midipitch1) [append notename($norm_midipitch1) "="]
        return $pitchclass$octave
    }
    if {[string index $pitchclass 1] == "="} {
        set notename($norm_midipitch) [string index $notename($norm_midipitch) 0]
        set bare  [string index $notename($norm_midipitch) 0]
        set norm_midipitch1 [expr ($norm_midipitch + 11) % 12]
        set bare1 [string index $notename($norm_midipitch1) 0]
        if {![string compare $bare1 $bare]} {
            set notename($norm_midipitch1) [append bare "b"]
            return $pitchclass$octave
        }
        set norm_midipitch1 [expr ($norm_midipitch +1 ) % 12]
        set bare1 [string index $notename($norm_midipitch1) 0]
        if {![string compare $bare1 $bare]} {
            set notename($norm_midipitch1) [append bare "#"]
            return $pitchclass$octave
        }
        
        return $pitchclass$octave
    }
    return $pitchclass$octave
}

proc midi2notename {midipitch} {
    global sharpnotesarray flatnotesarray
    global trainer
    set octave [expr $midipitch/12 - 1]
    set pitchclass [expr $midipitch % 12]
    if {$trainer(keysf) < 0} {
        set pitchclass $flatnotesarray($pitchclass)
    } else {
        set pitchclass $sharpnotesarray($pitchclass)
    }
    return $pitchclass$octave
}

proc midiseq2notelist {sequence} {
    # converts MIDI pitch notation to note name representation,
    set notelist ""
    foreach pitch $sequence {
        set note [midi2note $pitch 0]
        lappend notelist $note
    }
    return $notelist
}

proc midiseq2notelist_chromatic {sequence} {
    # converts MIDI pitch notation to note name representation,
    set notelist ""
    foreach pitch $sequence {
        set note [midi2notename $pitch]
        lappend notelist $note
    }
    return $notelist
}

proc makemidiseq {nmidis} {
   global trainer
   set npitches [expr $trainer(maxpitch) - $trainer(minpitch) + 1]
   set seq [list]
   for {set i 0} {$i < $nmidis} {incr i} {
    set j [random_number $npitches]
    set j [expr $j + $trainer(minpitch)]
    lappend seq $j
    } 
   #puts "makemidiseq $seq"
   return $seq
}


proc show_notelist {notelist clefcode musicframe} {
    # draws notes on staff for a given clef.
    global last_highlight_index
    set last_highlight_index 0
    set x 70
    set i 1
    foreach note $notelist {
        set sym [note2sym $note]
        set id $i
        switch $clefcode {
            0 {note-draw $sym 0 $x 0  $musicframe $id}
            1 {note-draw $sym 3 $x 0  $musicframe $id}
            2 {note-draw $sym 6 $x 0  $musicframe $id}
        }
        incr x 20
        incr i
    }
}





array set score {
    height 140
    width 460
    update 0
}



array set sfTab {
    sharp {0 9 -3 6 15 3 12}
    flat {12 3 15 6 18 9 21}
}
# [] | || |] [| |: :| :: : - !! see abcparse.h for values !!
set bartypes [list 35 1 17 19 49 20 65 68 4]


# create the images
# - the bitmaps were created using 'bitmap'.
# - the photos were created using 'xpaint' and are base64 encoded.
# !! the accidental numbers are the ones in abcparse.h !!
# no accidental
image create bitmap acc0 -data {
    #define acc0_width 8
    #define acc0_height 18
    static unsigned char acc0_bits[] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x4b, 0xab, 0xad, 0xad, 0x49,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
}
# sharp
image create bitmap acc1 -data {
    #define sh_width 8
    #define sh_height 18
    static unsigned char sh_bits[] = {
        0x40, 0x48, 0x48, 0x48, 0x48, 0xe8, 0xfc, 0x5c, 0x48, 0x48, 0x48, 0xe8,
        0xfc, 0x5c, 0x48, 0x48, 0x48, 0x08};
}

# red sharp
image create bitmap acc1r -data {
    #define sh_width 8
    #define sh_height 18
    static unsigned char sh_bits[] = {
        0x40, 0x48, 0x48, 0x48, 0x48, 0xe8, 0xfc, 0x5c, 0x48, 0x48, 0x48, 0xe8,
        0xfc, 0x5c, 0x48, 0x48, 0x48, 0x08};
}
acc1r configure -foreground red


# natural
image create bitmap acc2 -data {
    #define nt_width 8
    #define nt_height 18
    static unsigned char nt_bits[] = {
        0x00, 0x00, 0x08, 0x08, 0x08, 0x88, 0xe8, 0xf8, 0x98, 0x88, 0x88, 0xe8,
        0xf8, 0xb8, 0x88, 0x80, 0x80, 0x80};
}

# red natural
image create bitmap acc2r -data {
    #define nt_width 8
    #define nt_height 18
    static unsigned char nt_bits[] = {
        0x00, 0x00, 0x08, 0x08, 0x08, 0x88, 0xe8, 0xf8, 0x98, 0x88, 0x88, 0xe8,
        0xf8, 0xb8, 0x88, 0x80, 0x80, 0x80};
}
acc2r configure -foreground red

# flat
image create bitmap acc3 -data {
    #define fl_width 8
    #define fl_height 18
    static unsigned char fl_bits[] = {
        0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x68, 0xd8, 0x88, 0xc8, 0x68, 0x18,
        0x08, 0x00, 0x00, 0x00, 0x00, 0x00};
}

# red flat
image create bitmap acc3r -data {
    #define fl_width 8
    #define fl_height 18
    static unsigned char fl_bits[] = {
        0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x68, 0xd8, 0x88, 0xc8, 0x68, 0x18,
        0x08, 0x00, 0x00, 0x00, 0x00, 0x00};
}

acc3r configure -foreground red


# double sharp
image create bitmap acc4 -data {
    #define dsh_width 8
    #define dsh_height 18
    static unsigned char dsh_bits[] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc6, 0xee, 0x38, 0x10, 0x38, 0xee,
        0xc6, 0x00, 0x00, 0x00, 0x00, 0x00};
}
# double flat
image create bitmap acc5 -data {
    #define dft_width 8
    #define dfl_height 18
    static unsigned char dft_bits[] = {
        0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x55, 0xbb, 0x99, 0xdd, 0x55, 0x33,
        0x11, 0x00, 0x00, 0x00, 0x00, 0x00};
}
# notes
# white
image create bitmap note0 -data {
    #define note0_width 7
    #define note0_height 6
    static char note0_bits[] = {
        0x38,0x4e,0x43,0x61,0x39,0x0e};
}


# black
image create bitmap note1 -data {
    #define note1_width 7
    #define note1_height 6
    static char note1_bits[] = {
        0x38,0x7e,0x7f,0x7f,0x3f,0x0e};
}

# black coloured red
image create bitmap note1r -data {
    #define note1_width 7
    #define note1_height 6
    static char note1r_bits[] = {
        0x38,0x7e,0x7f,0x7f,0x3f,0x0e};
}
note1r configure -foreground red

# stemless white
image create bitmap note2 -data {
    #define note2_width 7
    #define note2_height 6
    static unsigned char note2_bits[] = {
        0x1e, 0x79, 0x61, 0x43, 0x4f, 0x3c};
}



# clefs
# - treble
image create bitmap clef0 -data {
    #define key0_width 18
    #define key0_height 42
    static unsigned char key0_bits[] = {
        0x00, 0x06, 0x00, 0x00, 0x0f, 0x00, 0x00, 0x0f, 0x00, 0x80, 0x1f, 0x00,
        0x80, 0x1b, 0x00, 0x80, 0x13, 0x00, 0x80, 0x11, 0x00, 0x80, 0x19, 0x00,
        0x80, 0x1c, 0x00, 0x80, 0x1c, 0x00, 0x80, 0x1c, 0x00, 0x80, 0x0f, 0x00,
        0x80, 0x0f, 0x00, 0x80, 0x07, 0x00, 0xc0, 0x03, 0x00, 0xe0, 0x03, 0x00,
        0xf0, 0x03, 0x00, 0xf8, 0x02, 0x00, 0x78, 0x02, 0x00, 0x3c, 0x02, 0x00,
        0x1e, 0x3f, 0x00, 0x9e, 0x7f, 0x00, 0xce, 0x7f, 0x00, 0xce, 0xf5, 0x00,
        0xce, 0xe4, 0x00, 0xce, 0xc4, 0x00, 0xde, 0xc4, 0x00, 0x9c, 0xc8, 0x00,
        0x18, 0x49, 0x00, 0x30, 0x68, 0x00, 0xe0, 0x38, 0x00, 0x80, 0x1f, 0x00,
        0x00, 0x08, 0x00, 0x00, 0x08, 0x00, 0x00, 0x10, 0x00, 0xc0, 0x11, 0x00,
        0xe0, 0x13, 0x00, 0xe0, 0x13, 0x00, 0xe0, 0x13, 0x00, 0xe0, 0x11, 0x00,
        0xc0, 0x08, 0x00, 0x80, 0x07, 0x00};
}
# - alto
image create bitmap clef1 -data {
    #define key1_width 18
    #define key1_height 38
    static unsigned char key1_bits[] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x5c, 0xf8, 0x00, 0x5c, 0xcc, 0x01, 0x5c, 0x9e, 0x03, 0x5c, 0x9e, 0x03,
        0x5c, 0x8c, 0x03, 0x5c, 0x80, 0x03, 0x5c, 0x80, 0x03, 0x5c, 0x84, 0x03,
        0x5c, 0x84, 0x01, 0x5c, 0xcc, 0x01, 0x5c, 0x7e, 0x00, 0x5c, 0x07, 0x00,
        0x5c, 0x07, 0x00, 0x5c, 0x07, 0x00, 0x5c, 0x7e, 0x00, 0x5c, 0xcc, 0x01,
        0x5c, 0x84, 0x01, 0x5c, 0x84, 0x03, 0x5c, 0x80, 0x03, 0x5c, 0x80, 0x03,
        0x5c, 0x8c, 0x03, 0x5c, 0x9e, 0x03, 0x5c, 0x9e, 0x03, 0x5c, 0xcc, 0x01,
        0x5c, 0xf8, 0x00, 0x00, 0x00, 0x00};
}
# - bass
image create bitmap clef2 -data {
    #define key2_width 18
    #define key2_height 39
    static unsigned char key2_bits[] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x03, 0x00,
        0x18, 0x87, 0x01, 0x0c, 0xce, 0x03, 0x1e, 0x8e, 0x01, 0x3e, 0x1c, 0x00,
        0x3e, 0x1c, 0x00, 0x3e, 0x1c, 0x00, 0x1c, 0x9c, 0x01, 0x00, 0xdc, 0x03,
        0x00, 0x9e, 0x01, 0x00, 0x0e, 0x00, 0x00, 0x0f, 0x00, 0x00, 0x0f, 0x00,
        0x80, 0x07, 0x00, 0xc0, 0x03, 0x00, 0xe0, 0x01, 0x00, 0xf0, 0x00, 0x00,
        0x38, 0x00, 0x00, 0x1e, 0x00, 0x00, 0x03, 0x00, 0x00};
}
# - perc
image create bitmap clef3 -data {
    #define key3_width 18
    #define key3_height 38
    static unsigned char key3_bits[] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0xe0, 0x1f, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00,
        0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00,
        0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00,
        0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00,
        0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0x20, 0x10, 0x00, 0xe0, 0x1f, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
}

proc notate_sofa {root clefcode} {
    # the function places the notes in melodylist (given
    # in midi pitches) on a staff.
    global notelist
    global sofapitch
    global root2sf
    global trainer
    set rootclass [expr $root % 12]
    set sf $root2sf($rootclass)
    .doraysing.c delete all
    if {$trainer(exercise) == "sofabadnote"} {
        bind .doraysing.c  <Button-1> {
            set wrong_note [expr (%x - 60)/20]
            highlight_note $wrong_note
            verify_badnote $wrong_note
            }
       } else {bind .doraysing.c <Button-1> {}}
    
    set width [expr $trainer(sofa_notes)*20+70]
    canvas_redraw .doraysing.c $width
    if {$clefcode < 0} {set clefcode 0}
    put_clef $clefcode .doraysing.c
    key_signature $sf 0 30 $clefcode .doraysing.c
    #puts $notelist
    show_notelist $notelist $clefcode .doraysing.c
}


proc verify_sofa {note} {
global melodylist
global lang
global trainer
global test_time
global ncorrect
global ntrials
global cmatrix

set response_time [expr [clock seconds] - $test_time]
set actual_note [lindex $melodylist 0]
if {$note == $actual_note} {
        .f.ans configure -text $lang(correct)
        incr correct
        update
         if {$trainer(autonew)} {
            after $trainer(autonewdelay)
            next_test
        } 
   } else {
        .f.ans configure -text $lang(try)
        incr ntrials
        }
   incr cmatrix($actual_note-$note)
}

proc verify_badnote {wrong_note} {
   global badnote
   global try
   global ncorrect
   incr try
   if {$badnote == $wrong_note} {
        .doraysing.msg configure -text "you are correct"
        if {$try == 0} {incr ncorrect}
         } else {
        .doraysing.msg configure -text "no, that note is good"
         }
}

proc reveal_sofabadnote {} {
    global badnote
    global try
    incr try
    highlight_note $badnote
}


proc display_badnote_stats {} {
  global ncorrect ntrials nrepeats
  set accuracy [expr (100.0*$ncorrect)/double($ntrials)]
  set accuracy [format "%5.2f" $accuracy]
  set outstr [format "accuracy %5.2f %% from %d trials\n%d repeats" $accuracy $ntrials $nrepeats]
  if {![winfo exist .stats.lab]} {
      label .stats.lab -text $outstr
      grid .stats.lab
      }
 .stats.lab configure -text $outstr
}


proc put_clef {clefcode musicframe} {
    global clef0 clef1 clef2
    set xoffset 10
    set yoffset 40
    switch $clefcode {
        0 {set line 2}
        1 {set line 3}
        2 {set line 4}
    }
    set y [expr {25 - $line * 6 + $yoffset}]
    $musicframe create image $xoffset $y -image clef$clefcode -anchor w -tag clef
}

proc highlight_note {note_index} {
global last_highlight_index
incr note_index
if {$last_highlight_index != 0} {
  .doraysing.c itemconfigure note$last_highlight_index -image note1
  .doraysing.c itemconfigure $last_highlight_index-acc1 -image acc1
  .doraysing.c itemconfigure $last_highlight_index-acc2 -image acc2
  .doraysing.c itemconfigure $last_highlight_index-acc3 -image acc3
  .doraysing.c itemconfigure $last_highlight_index-s -fill black 
  }
.doraysing.c  itemconfigure note$note_index -image note1r
.doraysing.c itemconfigure $note_index-acc1 -image acc1r
.doraysing.c itemconfigure $note_index-acc2 -image acc2r
.doraysing.c itemconfigure $note_index-acc3 -image acc3r
.doraysing.c itemconfigure $note_index-s -fill red
set last_highlight_index $note_index
}


# end of tknotate.tcl

# Part 29.0 Play support

#source playtune.tcl

proc convert_to_msec {eventlist bpm} {
    global trainer
    set mslist {}
    set accumulated_time 0.0
    set bpmfactor [expr 60000.0/($bpm*24.0)]
    foreach timeunit $eventlist {
        set delta_time [expr abs($timeunit)*$bpmfactor]
        set actime [expr int(round($delta_time))]
        lappend mslist $actime
    }
    return $mslist
}

proc playtune {} {
    global tunes
    global ttype tdir troot
    global trainer lang
    set silent 0
    if {$tdir == -1} {set name "$ttype,des"
    } else {set name "$ttype,asc"}
    #puts $name
    if {![info exist tunes($name)]} {
        .f.ans config -text $lang(notavail)
        return}
    muzic::channel 0 $trainer(instrument)
    set noteseq [lindex $tunes($name) 2]
    set bpm [lindex $tunes($name) 0]
    set mlist [convert_to_msec [lindex $tunes($name) 1] $bpm]
    set vol $trainer(velocity)
    set fromtime 0
    foreach note $noteseq pause $mlist {
        if {$note == "z"} {set k 0
            set silent 1
            continue
        } else              {set k [expr $note + $troot]
            set silent 0 }
        if {!$silent} {
            muzic::playnote 0 $k $trainer(velocity) $pause
        } else {
            muzic::playnote 0 0 0 $pause
        }
        
        after $pause set proceed 1
        vwait proceed
    }
}

bind . <h> {playtune}
#end of source playtune.tcl

# Part 30.0 draw chord


proc show_chord {notelist clefcode musicframe} {
    # draws notes on staff for a given clef.
    set x 70
    set i 1
    set chordsym {}
    set tagid "chord"
    foreach note $notelist {
        set sym [note2sym $note]
        set chordsym [concat $chordsym  $sym]
    }
    if {$clefcode == 0} {note-draw $chordsym 0 $x 0  $musicframe $tagid
    } else              {note-draw $chordsym 6 $x 0  $musicframe $tagid
    }
}

#frame .s -borderwidth 0
#canvas .s.c -width 140 -height 160
#label .s.l -text "" -width 16
#pack .s.c .s.l -side left

set sharpnatural {F# F F F= C# C C C= G# G G G= D# D D D= A# A A A= E# E E E= B# B B B=}
set flatnatural {Bb B Bv Bv B B= Eb E E E= Ab A A A= Db D D D= Gb G G G= Cb C C= Fb F F F=}

proc propagate_accidentals {notelist} {
global sharpnatural flatnatural
global keysf
if {$keysf == 0} {return $notelist}
set newlist ""
if {$keysf > 0} {
   set mapper [lrange $sharpnatural 0 [expr $keysf*4 -1]]
   foreach note $notelist {
     set note [string map $mapper $note]
     lappend newlist $note
     }
   return $newlist
   } else {
   set mapper [lrange $flatnatural 0 [expr -$keysf*4 +1]]
   foreach note $notelist {
     set note [string map $mapper $note]
     lappend newlist $note
     }
   return $newlist
   }
}


proc show_testchord {} {
    global trainer
    global ttype troot
    grand_canvas_redraw .s.c 160
    set testchord [spell_chord $ttype $troot]
    if {$trainer(xchord)} {
             set testchord [visual_chord_spreader $testchord]}
    if {$troot < 60} {set clefcode 2
    } else          {set clefcode 0}
    
    pack .s -side bottom -after .f
    .s.l configure -text [translate_chord $testchord]
    set testchord [propagate_accidentals $testchord]
    show_chord_in_grand_staff $testchord
}

proc translate_chord {chord} {
    # replaces v with double flat and
    # d with double sharp
    set mapper {b "\u266D" # "\u266F"}
    set fixed_chord {}
    foreach note $chord {
        set loc [string first "d" $note ]
        if {$loc > 0} {
            set note [string replace $note $loc $loc "##"]
        }
        set loc [string first "v" $note ]
        if {$loc > 0} {
            set note [string replace $note $loc $loc "bb"]
        }
        lappend fixed_chord $note
    }
    set fixed_chord [string map $mapper $fixed_chord]
    return $fixed_chord
}

proc note_octave_up {note octaveshift} {
    set octave [string index $note 1]
    if {[string is integer $octave]} {
        incr octave $octaveshift
        set note [string replace $note 1 1 $octave]} else {
        set octave [string index $note 2]
        incr octave $octaveshift
        set note [string replace $note 2 2 $octave]
       }
    return $note
}

proc visual_chord_spreader {chord} {
global spreader 
set newchord {}
if {[llength $chord] < 4} {set bass [lindex $chord 0]
        set bass [note_octave_up $bass 1]
        lappend chord $bass
        }
foreach note $chord shift $spreader {
  if {$shift > 0} {
     set newnote [note_octave_up $note $shift]
     } else {
     set newnote $note}
  lappend newchord $newnote
  }
return $newchord
}
#end of source show_testchord.tcl

# Part 31.0 chord support


#source chordseq.tcl
# v -- double flat
# d -- double sharp


# arrays of major and minor thirds
array set maj3 {Cb Eb	C E	C# E#	Cd Ed
    Db F	D F#	D# Fd
    Eb G	E G#	E# Gd
    Fv Av	Fb Ab	F A	F# A#	Fd Ad
    Gv Bv	Gb Bb	G B	G# B#	Gd Bd
    Ab C	A C#	A# Cd
    Bb D	B D#	B# Dd
}

array set min3 {Cb Ev	C Eb	C# E	Cd E#
    Dv Fv	Db Fb	D F	D# F#	Dd Fd
    Ev Gv	Eb Gb	E G	E# G#
    Fb Av	F Ab	F# A	Fd A#
    Gb Bv	G Bb	G# B	Gd B#
    Av Cv	Ab Cb	A C	A# C#
    Bv Dv	Bb Db	B D	B# D#
}


set def(maj) {M m}
set def(min) {m M}
set def(dim) {m m}
set def(aug) {M M}
set def(M7) {M m M}
set def(Mm7) {M m m}
set def(m7) {m M m}
set def(hdim7) {m m m}
set def(dim7) {m m m}

array set chord_def {
    maj maj	majinv1 maj	majinv2 maj
    min min	mininv1 min	mininv2 min
    dim dim	diminv1 dim	diminv2 dim
    aug aug	auginv1 aug	auginv2 aug
    majmin Mm7	majmininv1 Mm7	majmininv2 Mm7	majmininv3 Mm7
    maj7 M7	maj7inv1 M7	maj7inv2 M7	maj7inv3  M7
    min7 m7	min7inv1 m7	min7inv2 m7	min7inv3 m7
    halfdim7 hdim7	halfdim7inv1 hdim7	 halfdim7inv2 hdim7  halfdim7inv3 hdim7
    dim7 dim7	dim7inv1 dim7	dim7inv2 dim7	dim7inv3 dim7}



proc flatten {note natural} {
    set octave [string index $note 1]
    if {[string is integer $octave]} {
        set key [string index $note 0]} else {
        set octave [string index $note 2]
        set key [string range $note 0 1]
    }
    if {[string length $key] == 1} {
        append  key b} else {
        set barenote [string index $key 0]
        set accidental [string index $key 1]
        if {$accidental == "="} {set key [append barenote b]}
        if {$accidental == "#"} {
            if {$natural} {set key [append barenote =]
            } else {set key $barenote}
        }
        if {$accidental == "d"} {set key [append barenote #]}
        if {$accidental == "b"} {set key [append barenote v]}
    }
    return $key$octave
}

proc sharpen {note natural} {
    set octave [string index $note 1]
    if {[string is integer $octave]} {
        set key [string index $note 0]} else {
        set octave [string index $note 2]
        set key [string range $note 0 1]
    }
    if {[string length $key] == 1} {
        append  key #} else {
        set barenote [string index $key 0]
        set accidental [string index $key 1]
        if {$accidental == "v"} {set key [append barenote b]}
        if {$accidental == "b"} {
            if {$natural} {set key [append barenote =]
            } else {set key $barenote}
        }
        if {$accidental == "="} {set key [append barenote #]}
        if {$accidental == "#"} {set key [append barenote d]}
    }
    #  puts "$key$octave"
    return $key$octave
}


proc compose_chord {root type} {
    global def maj3 min3
    set seq $def($type)
    set octave [string index $root 1]
    if {[string is integer $octave]} {
        set note [string index $root 0]} else {
        set octave [string index $root 2]
        set note [string range $root 0 1]
    }
    set chord $root
    foreach elem $seq {
        if {$elem == "M"} {
            set note $maj3($note)
        } else {set note $min3($note) }
        set barenote [string index $note 0]
        if {$barenote == "C" || $barenote == "D"} {incr octave}
        set noteout $note$octave
        if {$type == "dim7" && [llength $chord] == 3} {
            set noteout [flatten $noteout 0]}
        lappend chord $noteout
    }
    return $chord
}

proc invert_chord {chord num} {
    for {set i 0} {$i < $num} {incr i} {
        set front [lindex $chord 0]
        set octave [string index $front 1]
        if {[string is integer $octave]} {
            set note [string index $front 0]} else {
            set octave [string index $front 2]
            set note [string range $front 0 1 ]
        }
        incr octave
        set note $note$octave
        set newchord [lrange $chord 1 end]
        set chord [lappend newchord $note]
    }
    return $chord
}

proc spell_chord {chordname root} {
    global chord_def
    set rootnote [midi2notename $root]
    set noteseq [compose_chord $rootnote $chord_def($chordname)]
    if {[string first inv $chordname] == -1} {return $noteseq}
    if {[string first inv1 $chordname] >1} {
        return [invert_chord $noteseq 1]}
    if {[string first inv2 $chordname] >1} {
        return [invert_chord $noteseq 2]}
    if {[string first inv3 $chordname] >1} {
        return [invert_chord $noteseq 3]}
    return $noteseq
}

#end of chordseq.tcl

# Part 32.0 start up

if {[file exist "$trainer(lang)"] ==1} {source "$trainer(lang)"
    set instructions "tksolfege $tksolfegeversion \n\n\
            $lang(instruct)
    http://ifdo.ca/~seymour/tksolfege\n\n\
            fy733@ncf.ca"
}

option add *Font $trainer(font)
set fontsize [lindex $trainer(font) 1]
incr fontsize -3
set reducedfont "Arial $fontsize bold"
incr fontsize 8
set enlargedfont "Arial $fontsize bold"

if {$trainer(soundfont) != "none"} {
    set error_return [catch {muzic::soundfont $trainer(soundfont)} errmsg]
    if {$errmsg < 0} {
        tk_messageBox -type ok -icon error -message "Cannot load soundfont $trainer(soundfont)"
    }
}
#     muzic::soundfont $trainer(soundfont)}



#make trainer(timesigtype) consistent with trainer(rhythmtypes)
if {[lindex $trainer(rhythmtypes) 0] >= 100} {
    set trainer(timesigtype) 1
} else {set trainer(timesigtype) 0}

make_interface
read_patch_names
startup_rhythm_dictation
# required for sofa sing
startup_sofa_dictation
startup_sofa_sing
set scaleoffsets [make_scale_midi_offsets $trainer(mode)]

bind . <a> {advance_settings_config}

frame .k
set modes {maj dor phr lyd mix min}

proc make_keysig_buttons {} {
    global lang trainer
    set keys {c d e f g a b }
    set mode maj
    if {$trainer(keysigformat) == 0} {
        foreach key $keys {
            set K [string toupper $key]
            button .k.$key -text "$K $mode" -width 8
            set a #
            button .k.$key$a -text "$K$a $mode" -width 8
            set b b
            button .k.$key$b -text "$K$b $mode" -width 8
            grid .k.$key$b .k.$key .k.$key$a
        }
    } else {
        foreach key $keys {
            set K [string toupper $key]
            button .k.$key -text "$lang($K) $mode" -width 8
            set a #
            button .k.$key$a -text "$lang($K)$a $mode" -width 8
            set b b
            button .k.$key$b -text "$lang($K)$b $mode" -width 8
            grid .k.$key$b .k.$key .k.$key$a
        }
    }
}

proc modify_keysig_buttons {mode} {
    global lang trainer
    set keys {c d e f g a b }
    set modetext [string range $lang($mode) 0 2]
    set trainer(mode) $mode
    if {$trainer(keysigformat) == 0} {
        foreach key $keys {
            set K [string toupper $key]
            .k.$key configure -text "$K $modetext" -command "verify_keysig $K$mode"
            set a #
            .k.$key$a configure -text "$K$a $modetext" -command "verify_keysig $K$a$mode"
            set b b
            .k.$key$b configure -text "$K$b $modetext" -command "verify_keysig $K$b$mode"
        }
    } else {
        foreach key $keys {
            set K [string toupper $key]
            .k.$key configure -text "$lang($K) $modetext" -command "verify_keysig $K$mode"
            set a #
            .k.$key$a configure -text "$lang($K)$a $modetext" -command "verify_keysig $K$a$mode"
            set b b
            .k.$key$b configure -text "$lang($K)$b $modetext" -command "verify_keysig $K$b$mode"
        }
    }
}

# Part 33.0 verification continued

proc verify_cadence {selected_cadence} {
global test_cadence
global lang
global cmatrix try ncorrect ntrials
if {![info exist test_cadence]}  {
      .f.ans config -text $lang(firstpress)
      return
    }
incr try
if {$try > 0} {incr ntrials}
set cadencename [lindex $test_cadence 0]
#puts "$cadencename $selected_cadence"
if {$cadencename == $selected_cadence} {
    .f.ans configure -text $lang(correct)
    if {$try == 1} {incr ncorrect
      incr cmatrix($cadencename-$selected_cadence)
      update
      }
    } else {
    .f.ans configure -text $lang(try)
    incr cmatrix($cadencename-$selected_cadence)
    }
if {$ntrials > 0} {
        if {[winfo exist .stats]} {
            set field [set cadencename]-[set selected_cadence]
            .stats.m.$field configure -text $cmatrix($cadencename-$selected_cadence)
            }
        }
}

proc verify_scale {selected_scale} {
global ttype
global lang
global ntrials ncorrect
global trainer
global cmatrix
global troot
global try
global test_time
global ionian dorian phrygian lydian mixolydian aeolian locrian major
global natural_minor harmonic_minor melodic_minor
global blues hungarian whole_tone pentatonic_maj pentatonic_sus pentatonic_min man_gong neapolitan ritusen bebop

if {![info exist ttype] || $ttype == "none" } {
      .f.ans config -text $lang(firstpress)
      return
    }
incr try
if {$try > 0} {incr ntrials}
set response_time [expr [clock seconds] - $test_time]
incr total_time $response_time
if {$ttype == $selected_scale} {
    .f.ans configure -text $lang(correct)
    if {$try == 1} {incr ncorrect
      incr cmatrix($ttype-$selected_scale)
      update
      }
    if {$trainer(autonew)} {
        after $trainer(autonewdelay)
        next_test
      }
   } else {
       incr cmatrix($ttype-$selected_scale)
      .f.ans configure -text $lang(try)
      if {$trainer(autoplay) && ($trainer(testmode) != "visual")} {
             set scalelist [set $selected_scale]
             playscale $troot  $scalelist}
    }
if {$ntrials > 0} {
        if {[winfo exist .stats]} {
            set field [set ttype]-[set selected_scale]
            .stats.m.$field configure -text $cmatrix($ttype-$selected_scale)
          set accuracy [expr (100.0*$ncorrect)/double($ntrials)]
          set accuracy [format "%5.2f" $accuracy]
          set outstr [format "accuracy %5.2f %% from %d trials" $accuracy $ntrials]
          if {![winfo exist .stats.lab]} {
            label .stats.lab -text $outstr
            grid .stats.lab
          }
          .stats.lab configure -text $outstr
        }
      }
}

# Part 34.0 key signature support

proc verify_keysig {key} {
    global keysigtest lang
    global trainer
    global ncorrect
    global try
    incr try
    if {![info exist keysigtest]} {
        .f.ans config -text $lang(firstpress)
        return
    }
    if {$key == $keysigtest} {
        if {$try == 1} {incr ncorrect}
        .f.ans configure -text $lang(correct)
        update
        if {$trainer(autonew)} {
            after $trainer(autonewdelay)
            next_test
        }
    } else {
        .f.ans configure -text $lang(try)
    }
    if {[winfo exist .stats]} display_keysig_stats
}

make_keysig_buttons

proc make_keysiglist {mode} {
    global keysiglist keymode lang
    global ncorrect ntrials
    set circle_of_fifths {E A D Cb Gb Db Ab Eb Bb F C G D A E B F# C# D# A# F C G}
    array set keycentre {maj 10 min 13 minhar 13 minmel 13 dor 12 phr 14 lyd 9 mix 11}
    set centre $keycentre($mode)
    set i0 [expr $centre - 7]
    set i1 [expr $centre +7]
    set keysiglist [lrange $circle_of_fifths $i0 $i1]
    set keymode $mode
    modify_keysig_buttons $mode
    #puts $keysiglist
    if {[winfo exist .config.keysig]} {
        .config.keysig.modebutton  config -text $lang($mode)
    }
    set ncorrect 0
    set ntrials 0
}


proc draw_keysig {sf clefcode} {
if {![winfo exist .s]} {
    frame .s
    canvas .s.c -width 140 -height 80
    label .s.l
    pack .s.c -anchor nw
    pack .s .s.l -side top -anchor nw
 }
    canvas_redraw .s.c 90
    put_clef $clefcode .s.c
    key_signature $sf 0 30 $clefcode .s.c
}

proc select_keysig_lesson n {
    global trainer
    global keysigsel
    global ntrials ncorrect
    set ntrials 0
    set ncorrect 0
    set i1 [expr - $n + 1]
    set keysigtypes {}
    for {set i 1} {$i < 8} {incr i} {
        set keysigsel($i) 0
        set j [expr -$i]
        set keysigsel($j) 0
    }
    for {set i $i1} {$i < $n} {incr i} {
        lappend keysigtypes $i
        set keysigsel($i) 1
    }
    set trainer(keysigtypes) $keysigtypes
}

proc make_keysig_lesson {} {
    global keysigsel
    global keysigtypes
    global trainer
    global ntrials ncorrect
    set ntrials 0
    set ncorrect 0
    set keysigtypes {}
    for {set i 1} {$i < 8} {incr i} {
        set j [expr -$i]
        if {$keysigsel($i)} {lappend keysigtypes $i}
        if {$keysigsel($j)} {lappend keysigtypes $j}
    }
    set trainer(keysigtypes) $keysigtypes
}


proc test_keysig {} {
    global keysiglist keymode keysigclefcode
    global trainer lang
    global keysigtest keysigtestans
    global ntrials
    global keysigsf
    global try
    if {$try > 0} {incr ntrials}
    set try 0
    set n [llength $trainer(keysigtypes)]
    set i [random_number $n]
    set keysigsf [lindex $trainer(keysigtypes) $i]
    draw_keysig $keysigsf $keysigclefcode
    set ans [lindex $keysiglist [expr $keysigsf + 7]]
    set keysigtest "$ans$keymode"
    set K [string index $ans 0]
    if {[string length $ans] > 0} {
        set a [string index $ans 1]
        set ans $lang($K)$a
    } else {set ans $lang($K) }
    set keysigtestans "$ans $lang($keymode)"
    .f.ans configure -text ""
}


proc reveal_keysig {} {
    global keysigtestans
    if {[info exist keysigtestans]} {
        .f.ans configure -text $keysigtestans}
}

proc display_keysig_stats {} {
    global ncorrect ntrials
    if {$ntrials < 1} return
    set accuracy [expr 100.0*$ncorrect/double($ntrials)]
    set accuracy [format "%5.2f" $accuracy]
    set outstr [format "accuracy %5.2f from %d trials" $accuracy $ntrials]
    if {![winfo exist .stats.results]} {
        label .stats.results -text $outstr
        grid .stats.results
    } else {.stats.results configure -text $outstr}
}

proc config_your_own_keysig {} {
    global keysigsel lang
    if {[winfo exist .ownlesson]} {
        foreach w [winfo children .ownlesson] {
           destroy $w}} else {
         toplevel .ownlesson
         positionWindow .ownlesson
         }
    set w .ownlesson
    for {set i 1} {$i < 8} {incr i} {
        set one $w.$i
        set two $one
        set j [expr - $i]
        append one 1
        append two 2
        checkbutton $one -text "$i $lang(flats)" -variable keysigsel($j) \
                -command make_keysig_lesson
        checkbutton $two -text "$i $lang(sharps)" -variable keysigsel($i) \
                -command make_keysig_lesson
        grid $one $two
    }
}


proc make_config_keysig {} {
    global lang trainer
    set w .config.keysig
    frame $w
    pack $w
    label $w.clef -text $lang(clef) -width 10
    eval menubutton $w.clefbutton  -menu $w.clefbutton.clefmenu -text [list $lang(treble)]\
            -width 15
    set v $w.clefbutton.clefmenu
    menu $v -tearoff 0
    $v add radiobutton -label $lang(treble) -command "select_keysigclef 0"
    $v add radiobutton -label $lang(alto) -command "select_keysigclef 1"
    $v add radiobutton -label $lang(bass) -command "select_keysigclef 2"
    
    label $w.mode -text $lang(mode) -width 10
    eval menubutton $w.modebutton  -menu $w.modebutton.modemenu -text $lang(maj)\
            -width 12
    set v $w.modebutton.modemenu
    menu $v -tearoff 0
    $v add radiobutton -label $lang(maj) -command "make_keysiglist maj"
    $v add radiobutton -label $lang(min) -command "make_keysiglist min"
    $v add radiobutton -label $lang(dor) -command "make_keysiglist dor"
    $v add radiobutton -label $lang(phr) -command "make_keysiglist phr"
    $v add radiobutton -label $lang(lyd) -command "make_keysiglist lyd"
    $v add radiobutton -label $lang(mix) -command "make_keysiglist mix"
    label $w.format -text $lang(format) -width 10
    eval menubutton $w.formbutton -menu $w.formbutton.formmenu -text "C,D,E"\
            -width 12
    set v $w.formbutton.formmenu
    menu $v -tearoff 0
    $v add radiobutton -label "C,D,E" -command "select_keysigformat 0"
    $v add radiobutton -label "do,re,me" -command "select_keysigformat 1"
    select_keysigformat $trainer(keysigformat)
    
    grid $w.clef $w.clefbutton
    grid $w.mode $w.modebutton
    if {$trainer(lang) != "none"} {grid $w.format $w.formbutton}
}

proc select_keysigclef {code} {
    global keysigclefcode lang
    global trainer
    global keysigsf
    set keysigclefcode $code
    if {![winfo exist .config.keysig]} return
    set v .config.keysig.clefbutton
    switch -- $keysigclefcode {
        0 {$v config -text $lang(treble)}
        1 {$v config -text $lang(alto)}
        2 {$v config -text $lang(bass)}
    }
    canvas_redraw .s.c 90
    put_clef $keysigclefcode .s.c
    if {[info exist keysigsf]} {
      key_signature $keysigsf 0 30 $keysigclefcode .s.c}
}

proc select_keysigformat {code} {
    global trainer
    if {![winfo exist .config.keysig]} return
    if {$code == 0} {
        .config.keysig.formbutton config -text "C,D,E"
        set trainer(keysigformat) 0
        modify_keysig_buttons $trainer(mode)
    } else {
        .config.keysig.formbutton config -text "do,re,me"
        set trainer(keysigformat) 1
        modify_keysig_buttons $trainer(mode)
    }
}

make_keysiglist $trainer(mode)
select_keysigclef 0

#end of keysig.tcl

# Part 35.0 grand staff

#grandstaff.tcl
proc grand_canvas_redraw {musicframe width} {
    # redraw the first elements of the canvas
    global score
    # clear the canvas
if {![winfo exist .s]} {
    frame .s
    canvas .s.c -width 140 -height 120
    label .s.l
    pack .s.c -anchor nw
    pack .s .s.l -side top -anchor nw
 }
    $musicframe delete all
    # create the voice rectangle, the staves and the cursor rectangle
    set voicerect [$musicframe create rectangle 5 10 \
            $width 140 -fill white -outline {}]
    set yoffset 40
    set y $yoffset
    for {set i 0} {$i < 12} {incr i} {
        if {$i < 5 || $i > 6} {
            $musicframe create line 10 $y [expr {$width}] $y}
        incr y 6
    }
    incr yoffset $score(height)
    set line 2
    set y 55
    $musicframe create image 10 $y -image clef0 -anchor w -tag clef
    set y 83
    $musicframe create image 10 $y -image clef2 -anchor w -tag clef

    add_keysignature_to_grandstaff $musicframe

}

proc add_keysignature_to_grandstaff {musicframe} {
global keysf 
key_signature $keysf 0 30 0 $musicframe
key_signature $keysf 46 30 1 $musicframe
}


proc split_chord {chord} {
    set basschord {}
    set treblechord {}
    foreach note $chord {
        set n [string index $note 1]
        if {![string is digit $n]} {set n [string index $note 2]}
        if {$n < 4} {lappend basschord $note
        } else      {lappend treblechord $note}
    }
    return [list $treblechord $basschord]
}



proc show_chord_in_grand_staff {chord} {
    set splitchord [split_chord $chord]
    set basschord [lindex $splitchord 1]
    set treblechord [lindex $splitchord 0]
    set chordsym ""
    set tagid "chord"
    foreach note $basschord {
        set sym [note2sym $note]
        set chordsym [concat $chordsym  $sym]
    }
    if {[string length $chordsym] > 0} {note-draw $chordsym 6 100 42  .s.c $tagid}
    set chordsym ""
    foreach note $treblechord {
        set sym [note2sym $note]
        set chordsym [concat $chordsym  $sym]
    }
    if {[string length $chordsym] > 0} {note-draw $chordsym 0 100 0  .s.c $tagid}
}


#key_signature 3 0 30 0 .c
#key_signature 3 48 30 0 .c
#end of grandstaff.tcl

# Part 36.0 advance settings

proc advance_settings_config {} {
global trainer lang
set sizelist {8 9 10 11 12 13 14 15 16}
if {![winfo exist .advanced]} {toplevel .advance
   positionWindow .advance
   wm title .advance "advanced settings"
   set w .advance
   label $w.fluidlab -text "fluidsynth path"
   entry $w.fluidpath -textvariable trainer(fluidsynth_path) -width 40
   label $w.audiolab -text "audio driver"
   entry $w.audiodrv -textvariable trainer(audio_driver) -width 40
   button $w.sf -text $lang(soundfont) -command pick_soundfont
   entry $w.sfe -textvar trainer(soundfont) -width 40
   button $w.brlab -text browser -command pick_browser
   entry $w.bre -textvar trainer(browser) -width 40
   button $w.langb -text $lang(language) -command pick_language_pack
   label $w.rep -text $lang(repeatability)
   checkbutton $w.repchk  -variable trainer(repeatability) -command restart
   label $w.fontsizelab -text $lang(fontsize)
   ttk::combobox $w.fontsize -width 8  -textvariable trainer(fontsize)\
         -values $sizelist
   bind $w.fontsize <<ComboboxSelected>> {changeFontSize}

  
   label $w.msg -text ""

   grid $w.fluidlab $w.fluidpath
   grid $w.audiolab $w.audiodrv
   grid $w.sf $w.sfe
   grid $w.brlab $w.bre
   grid $w.langb
   grid $w.rep $w.repchk
   grid $w.fontsizelab $w.fontsize
   grid $w.msg -columnspan 2
   bind $w.sfe <Return> restart
   }
 }
 
proc changeFontSize {} {
global trainer
global lang
set font "Arial $trainer(fontsize) bold"
set trainer(font) $font
.advance.msg config -text $lang(restart)
}


proc restart {} {
    global lang
    .advance.msg config -text $lang(restart)
}

# Part 37.0 drum support

#drumseq.tcl

set drumpatches {
    {35	B,,,	{Acoustic Bass Drum}}
    {36	C,,	{Bass Drum 1}}
    {37	^C,,	{Side Stick}}
    {38	D,,	{Acoustic Snare}}
    {39	^D,,	{Hand Clap}}
    {40	E,,	{Electric Snare}}
    {41	F,,	{Low Floor Tom}}
    {42	^F,,	{Closed Hi Hat}}
    {43	G,,	{High Floor Tom}}
    {44	^G,,	{Pedal Hi-Hat}}
    {45	A,,	{Low Tom}}
    {46	^A,,	{Open Hi-Hat}}
    {47	B,,	{Low-Mid Tom}}
    {48	C,	{Hi Mid Tom}}
    {49	^C,	{Crash Cymbal 1}}
    {50	D,	{High Tom}}
    {51	^D,	{Ride Cymbal 1}}
    {52	E,	{Chinese Cymbal}}
    {53	F,	{Ride Bell}}
    {54	^F,	Tambourine}
    {55	G,	{Splash Cymbal}}
    {56	^G,	Cowbell}
    {57	A,	{Crash Cymbal 2}}
    {58	^A,	Vibraslap}
    {59	B,	{Ride Cymbal 2}}
    {60	C	{Hi Bongo}}
    {61	^C	{Low Bongo}}
    {62	D	{Mute Hi Conga}}
    {63	^D	{Open Hi Conga}}
    {64 	E	{Low Conga}}
    {65 	F	{High Timbale}}
    {66	^F	{Low Timbale}}
    {67	G	{High Agogo}}
    {68	^G	{Low Agogo}}
    {69	A	Cabasa}
    {70	^A	Maracas}
    {71	B	{Short Whistle}}
    {72	c	{Long Whistle}}
    {73	^c	{Short Guiro}}
    {74	d	{Long Guiro}}
    {75	^d	{Claves}}
    {76	e	{Hi Wood Block}}
    {77	f	{Low Wood Block}}
    {78	^f	{Mute Cuica}}
    {79	g	{Open Cuica}}
    {80	^g	{Mute Triangle}}
    {81	a	{Open Triangle}}
}




#set ndrums 3
set drumvol(1) 70
set drumvol(2) 70
set drumvol(3) 70
set drum(1) 39
set drum(2) 45
set drum(3) 42
set drumresolution 4


proc savedruminfo {outfile} {
 global drumseq seqlength drum drumvol
 global drumresolution
 global ndrums drumduration
 global drumlmax
 global ndrumhits
 global drumhits 
 set outfile [tk_getSaveFile -filetypes {{{drum files} (*.drum}}]
 if {$outfile == ""} return
 set handle [open $outfile w]
 puts $handle "ndrums $ndrums"
 for {set i 1} {$i <= $ndrums} {incr i} {
   puts $handle "drum($i) $drum($i)"
   }
 for {set i 1} {$i <= $ndrums} {incr i} {
   puts $handle "drumvol($i) $drumvol($i)"
   }
 for {set i 1} {$i <= $ndrums} {incr i} {
   puts $handle "drumseq($i) [list $drumseq($i)]"
   }
 puts $handle "drumresolution $drumresolution"
 puts $handle "drumduration $drumduration"
}


proc loaddruminfo {infile} {
 global drumseq seqlength drum drumvol
 global drumresolution
 global ndrums drumduration
 global drumlmax
 global ndrumhits
 global drumhits 
 set handle [open $infile r]
 puts $infile
 while {[gets $handle line] >= 0} {
        set error_return [catch {set n [llength $line]} error_out]
        if {$error_return} continue
        set contents ""
        set param [lindex $line 0]
        for {set i 1} {$i < $n} {incr i} {
            set contents [concat $contents [lindex $line $i]]
        }
        set $param $contents 
#        puts "$param $contents"
    }
  set drumlmax 0
  for {set k 1} {$k <= $ndrums} {incr k} {
    set seqlength($k) [llength $drumseq($k)]
    if {$seqlength($k) > $drumlmax} {set drumlmax $seqlength($k)}
    if {![info exist drumvol($k)]} {set drumvol($k) 80}
  }
set ndrumhits [count_drum_hits]
set drumhits 0
#puts "ndrumhits = $ndrumhits"
}



proc startup_drumseq {} {
global drumcanheight drumcanwidth

  frame .drumenu
  set p .drumenu
  button $p.fast -text faster -command fasterdrum
  button $p.slow -text slower -command slowerdrum
  button $p.stop -text stop -command {set stopdrum 1}
  button $p.test -text test -command {playdrum_input 0}
  #button $p.submit -text submit -command {plotdrumseq
  #					checkdrumseq}
  pack $p.fast $p.slow $p.stop $p.test -side left


  set p .drumseq
  frame $p
  canvas $p.can -width $drumcanwidth -height $drumcanheight
  canvas $p.cany -width 150 -height $drumcanheight
  pack $p.cany $p.can -side left
}

proc drumseq_banner {} {
global total_time ntestchecks
global total_strikes total_correct
.drumseq.cany create text 10 100 -width 400 -anchor w -text "Drum Sequence test\nTo start press 'new'"
set total_time 0
set ntestchecks 0
set total_correct 0
set total_strikes 0
}



proc drumseqgrid {} {
# the procedure draws vertical gray stripes corresponding
# to the beats and divides the beats into subbeats using
# dashed lines based on the drumresolution. Horizontal
# dashed lines are added to separate the different drums.
global drumpatches
global drum
global drumresolution dspacing
global drumnbeats
global ndrums drumlmax
global spacing dspacing
global vspacing
global drumcanheight drumcanwidth
set drumcanheight [expr $ndrums*25 ]
set drumcanwidth [expr $drumlmax*18]
set vspacing 25
set p .drumseq
$p.can configure -width  $drumcanwidth
$p.can configure -height [expr $drumcanheight + $vspacing*2]
$p.cany configure -height [expr $drumcanheight + $vspacing*2]
set dspacing 18
if {[llength $drumresolution] == 1} {
 set drumnbeats [expr $drumlmax/$drumresolution]
 } else {
 set drumnbeats [llength $drumresolution]
 }
$p.can delete "all"
$p.cany delete "all"
set ix2 0
# draw the vertical stripes
for {set i 0} {$i < $drumnbeats} {incr i} {
    if {[llength $drumresolution] == 1} {
      set spacing  [expr $dspacing * $drumresolution]
      } else {
      set spacing  [expr $dspacing * [lindex $drumresolution $i]]
      }
    set ix1 $ix2
    set ix2 [expr $ix1 + $spacing]
    if {[expr $i % 2] == 0} {
      $p.can create rect $ix1 0 $ix2 $drumcanheight -fill gray40 
      } else {
      $p.can create rect $ix1 0 $ix2 $drumcanheight -fill gray70
      }
# draw vertical dashed lines separating the subbeats
    if {[llength $drumresolution] == 1} {
      set ind 0} else {set ind $i}
    for {set j 0} {$j < [lindex $drumresolution $ind]} {incr j} {
       set jx1 [expr $j * $dspacing + $ix1]
       $p.can create line $jx1 0 $jx1 $drumcanheight -dash {2 2}
       }
    }
# draw dashed lines and label the drums
for {set j 0} {$j < $ndrums} {incr j} {
    set jy [expr $j*$vspacing + 25]
    $p.can create line 0 $jy $drumcanwidth $jy -dash {1 1}
    set j1 [expr $j + 1]
    set drumname [lindex [lindex $drumpatches [expr $drum($j1) -35] 2]]
    $p.cany create text 10 [expr 10 + $vspacing*$j] -text $drumname -anchor w
    }
update
} 


proc drumbuttons {} {
global drumnbeats
global drumresolution
global ndrums
global spacing dspacing
global drumbut
global vspacing
set ix0 0
set kol 0
for {set i 0} {$i < $drumnbeats} {incr i} {
  if {[llength $drumresolution] == 1} {
    set res $drumresolution
    set spacing  [expr $dspacing * $drumresolution]
    } else {
    set res [lindex $drumresolution $i]
    set spacing  [expr $dspacing * [lindex $drumresolution $i]]
    }
  for {set j 0} {$j <  $res} {incr j} {
    for {set k 0} {$k < $ndrums} {incr k} {
      set ix1 [expr $ix0 + $j*$dspacing + 3]
      set ix2 [expr $ix1 + 12]
      set iy1 [expr $k*$vspacing + 3]
      set iy2 [expr $iy1 + 20]
      set col c[expr $kol + $j]
      set row r[expr $k+1]
      .drumseq.can create rect $ix1 $iy1 $ix2 $iy2 -fill darkblue -tag $row$col
      .drumseq.can bind $row$col <1> "flipcolor $row$col"
       set drumbut($row$col) 0
      }
    }
   set ix0 [expr $ix0 + $spacing]
   incr kol $res
  }  
}


proc flipcolor {tagid} {
global drumbut
global drum drumvol
global drumhits ndrumhits ndrums
global vspacing
set drumbut($tagid) [expr 1 - $drumbut($tagid)]
scan $tagid "r%d" k
if {$drumbut($tagid)} {
 if {$drumhits >= $ndrumhits} {
     .drumseq.can create text 10 [expr ($ndrums+1)*$vspacing]\
        -text "too many hits" -tag toomany -fill red -anchor w
      set drumbut($tagid) [expr 1 - $drumbut($tagid)]
      return
      }
  incr drumhits
  .drumseq.can itemconfigure $tagid -fill lightblue
  muzic::playnote 9 $drum($k) $drumvol($k) 100
  } else {
  .drumseq.can itemconfigure $tagid -fill darkblue
  .drumseq.can delete -tag toomany
   incr drumhits -1
  }
}


proc checkdrumseq {} {
global drumbut drumtrk
global ndrums
global drumlmax
global total_time test_time
global total_correct total_strikes
set response_time [expr [clock seconds] - $test_time]
incr total_time $response_time
set hits 0
set correct 0
for {set i 0} {$i < $drumlmax} {incr i} {
  for {set k 1} {$k <= $ndrums} {incr k} {
    set row r$k
    set col c$i
    if {$drumtrk($row$col)} {incr hits}
    if {$drumtrk($row$col) == $drumbut($row$col) && $drumtrk($row$col)} {
	incr correct}
    }
  }
incr total_correct $correct
incr total_strikes $hits
.f.ans configure -text "$correct/$hits correct"
if {[winfo exist .stats]} make_stats_window
}

set drumplaying 0

proc start_playseq {} {
global stopdrum
global drumplaying
if {$drumplaying} return
set stopdrum 0
playseq 0
}

proc playseq {i} {
  global drumseq seqlength drumlmax
  global drum ndrums drumvol
  global stopdrum
  global drumduration
  global drumplaying
  global trainer
  if {$i == 0} {incr drumplaying}
  if {$drumplaying > $trainer(rrepeats)} {set stopdrum 1}
  if {$stopdrum} {set drumplaying 0
                  return
                 }
  
  for {set k 1} {$k <= $ndrums} {incr k} {
    set e [lindex $drumseq($k) [expr $i % $seqlength($k)]]
    if {$e} {muzic::playnote 9 $drum($k) $drumvol($k) 100}
    } 
  incr i
  if {$i == $drumlmax} {set i 0}
  after $drumduration [list playseq $i]
  }

proc count_drum_hits {} {
global ndrums seqlength drumlmax drumseq
set count 0
for {set i 0} {$i < $drumlmax} {incr i} {
  for {set k 1} {$k <= $ndrums} {incr k} {
    set e [lindex $drumseq($k) [expr $i % $seqlength($k)]]
    if {$e} {incr count}
    }
  }
return $count
}


proc playdrum_input {i} {
global drumbut 
global ndrums drum drumvol
global drumlmax
global drumduration
global ntestchecks
if {$i == 0} {incr ntestchecks}
for {set k 1} {$k <= $ndrums} {incr k} {
   set row r$k
   set col c$i
   if {$drumbut($row$col)} {
     #puts "$drum($k) $drumvol($k)"
     muzic::playnote 9 $drum($k) $drumvol($k) 100}
    }
 incr i
 if {$i != $drumlmax} {
   after $drumduration [list playdrum_input $i]
  }
}

proc fasterdrum {} {
global drumduration
set delta [expr $drumduration/10]
incr drumduration -$delta
.f.ans configure -text "$drumduration milliseconds"
update
}

proc slowerdrum {} {
global drumduration
set delta [expr $drumduration/10]
incr drumduration $delta
.f.ans configure -text "$drumduration milliseconds"
update
}

proc plotdrumseq {} {
  global drum ndrums
  global drumseq seqlength drumlmax
  global dspacing drumtrk vspacing
  for {set j 1} {$j <= $ndrums} {incr j} {
    for {set i 0} {$i < $drumlmax} {incr i} {
      set e [lindex $drumseq($j) [expr $i % $seqlength($j)]]
      set iy1 [expr $j*$vspacing -15]
      set iy2 [expr $j*$vspacing -10]
      set col c$i
      set row r$j
      set drumtrk($row$col) 0
      if {$e} {
         set drumtrk($row$col) 1
         set ix1 [expr $i*$dspacing+7]
         set ix2 [expr $i*$dspacing +10]
         .drumseq.can create oval $ix1 $iy1 $ix2 $iy2 -fill red
         }
     }
   }
update
} 

set drumlmax 16
set nhits 8
#set drumduration 150
set drumcanheight  150
set drumcanwidth 288         
set drumarrangement(0) {35 37 56}
set drumarrangement(1) {35 48 54}
set drumarrangement(2) {48 60 61}
set drumarrangement(3) {37 76 77}
set drumarrangement(4) {40 46 57}
set drumarrangement(5) {60 57 63}
set drumarrangement(6) {49 57 38}


proc test_drumseq {} {
global trainer
global test_time
set test_time [clock seconds]
if {$trainer(drumsrc) == "file"} {
  test_drumseq_from_file} else {
  test_random_drumseq}
}


proc test_drumseq_from_file {} {
global drumfiles
set nfiles [llength $drumfiles]
set x [random_number $nfiles]
test_drum_file $x
}

proc test_drum_file {x} {
global drumfiles
set tfile [lindex $drumfiles $x]
loaddruminfo $tfile
drumseqgrid
drumbuttons
#puts $tfile
.f.ans configure -text $tfile
start_playseq
}


proc test_random_drumseq {} {
global drumlmax drumresolution
global nhits ndrums
global drumhits ndrumhits
if {$nhits >= $drumlmax} {set nhits [expr $drumlmax -3]}
set ratio [expr $nhits / double($drumlmax)]
if {$ratio > 0.7} {
  make_dense_random_drum_seq $drumlmax $nhits
  } else {
  create_drum_hit_distribution $drumlmax $drumresolution
  make_random_drum_seq $drumresolution $nhits $drumlmax
 }
make_random_drumseq_array $ndrums $drumlmax
#dump_drumseq_for_debugging $ndrums
.f.ans configure -text random
set ndrumhits [count_drum_hits]
set drumhits 0
drumseqgrid
drumbuttons
start_playseq
}


proc make_config_file_drumseq {} {
    global lang trainer
    global drumfiles
    set w .config.drumseq
    frame $w
    pack $w
    set i 0
    foreach filename $drumfiles {
      set sname [file tail $filename]
      button $w.$i -text $sname -width 20 -command "test_drum_file $i"
      incr i
      }
    set nfiles $i
    for {set i 0} {$i < $nfiles} {incr i 2} {
      set i1 [expr $i+1]
      grid $w.$i $w.$i1
      }
    }

proc make_config_random_drumseq {} {
  global nhits
  global trainer
  global lang
  set w .config.rdrumseq
  frame $w
  pack $w
  label $w.title  -text $lang(drumseqopt)
  grid $w.title  -columnspan 2
  set wf .config.rdrumseq
  label $wf.barlab -text "$trainer(rbeats) by $trainer(rres)"
  menubutton $wf.structmenu  -menu $wf.structmenu.bar -text $lang(barstr)\
            -width 12 
  set v $wf.structmenu.bar
  menu $v -tearoff 0
  $v add radiobutton -label "4 beats 4 subunits" -command "setdrumstruct 4 4"
  $v add radiobutton -label "3 beats 4 subunits" -command "setdrumstruct 3 4"
  $v add radiobutton -label "2 beats 4 subunits" -command "setdrumstruct 2 4"
  $v add radiobutton -label "4 beats 2 subunits" -command "setdrumstruct 4 2"
  $v add radiobutton -label "3 beats 2 subunits" -command "setdrumstruct 3 2"
  $v add radiobutton -label "4 beats 3 subunits" -command "setdrumstruct 4 3"
  $v add radiobutton -label "3 beats 3 subunits" -command "setdrumstruct 3 3"
  $v add radiobutton -label "2 beats 3 subunits" -command "setdrumstruct 2 3"
  grid $wf.structmenu $wf.barlab 

  menubutton $wf.menubutton  -menu $wf.menubutton.num -text "number of drums"

  set v $wf.menubutton.num
  menu $v -tearoff 0
  $v add radiobutton -label 1 -command "numdrumlines 1"
  $v add radiobutton -label 2 -command "numdrumlines 2"
  $v add radiobutton -label 3 -command "numdrumlines 3"
  label $wf.labdrm -text "$trainer(rndrums) drum lines"
  grid $wf.menubutton $wf.labdrm 

  entry $wf.strkent -width 3 -textvariable nhits
  bind $wf.strkent <Return> {focus .config}
  label $wf.strklab -text $lang(numstrike)
  grid $wf.strklab $wf.strkent 

  menubutton $wf.arrgmenu  -menu $wf.arrgmenu.num -text $lang(drumarrg)
  set v $wf.arrgmenu.num
  menu $v -tearoff 0
  for {set i 0} {$i < 7} {incr i} {
    set names [expand_drum_arrangement $i]
    $v add radiobutton -label $names -command "setdrumarrg $i"
    }
  label $wf.arrglab -text ""
  grid $wf.arrgmenu $wf.arrglab 

  entry $wf.ent -width 3 -textvariable trainer(rrepeats)
  bind $wf.ent <Return> {focus .config}
  label $wf.replab -text $lang(numrepeats)
  grid $wf.replab $wf.ent  

}

proc setdrumarrg {i} {
 global drumarrangement
 global drumpatches
 global drum drumvol
 global trainer
 set labelinfo $drumarrangement($i)
 for {set j 0} {$j < [llength $drumarrangement($i)]} {incr j} {
   set j1 [expr $j+1]
   set drum($j1) [lindex $drumarrangement($i) $j]
   set drumvol($j1) 70
   }
if {[winfo exist .config.rdrumseq]} {
   .config.rdrumseq.arrglab configure -text $labelinfo
   }
if {[winfo exist .drumseq]} { drumseqgrid
                              drumbuttons}
set trainer(rarrg) $i
}


proc expand_drum_arrangement {i} {
global drumarrangement
global drumpatches 
set drumname ""
foreach j $drumarrangement($i) {
  set name [lindex [lindex $drumpatches [expr $j -35]] 2]
  append drumname " $name,"
  }
return $drumname
}

proc setdrumstruct {beats res} {
global  drumlmax drumresolution drumvol
global drumduration
global drumlmax
global seqlength
global trainer
set drumduration 180
set drumlmax [expr $beats * $res]
set seqlength(1) $drumlmax
set seqlength(2) $drumlmax
set seqlength(3) $drumlmax
set drumresolution $res
if {[winfo exist .config.rdrumseq]} {
  .config.rdrumseq.barlab configure -text "$beats by $res"
  }
set trainer(rbeats) $beats
set trainer(rres) $res
}


proc numdrumlines {n} {
global ndrums drum drumvol trainer
set ndrums $n
if {[winfo exist .config.rdrumseq]} {
  .config.rdrumseq.labdrm configure -text "$n drum lines"}
set trainer(rndrums) $ndrums
}

proc make_random_drumseq_array {ndrums size} {
#given drumstat compute the ndrums drumseq
global drumstat drumseq
for {set j 1} {$j <= $ndrums} {incr j} {
    set drumseq($j) ""}
for {set i 0} {$i < $size} {incr i} {
  if {$drumstat($i) != 0} {
    set k [expr int(rand()*$ndrums) + 1]
   } else {
    set k 0
  }
  for {set j 1} {$j <= $ndrums} {incr j} {
    if {$j == $k} {
      lappend drumseq($j) 1
      } else {
      lappend drumseq($j) 0
    }
  }
 }
}
     
proc dump_drumseq_for_debugging {ndrums} {
global drumseq
 for {set n 1} {$n <= $ndrums} {incr n} {
   puts $drumseq($n)
 }
} 



proc make_dense_random_drum_seq {size nhits} {
#compute drumstat when nhits is comparable to size
global drumstat
set n [expr $size - $nhits]
if {$n < 0} {puts "nhits $nhits > $size"
             return 0
            }
for {set i 0} {$i < $size} {incr i} {
  set drumstat($i) 1}
while {$n > 0} {
 set k [expr int($size*rand())]
 if {$drumstat($k) == 1} {
    set drumstat($k) 0
    incr n -1
    }
 }
}

 

proc make_random_drum_seq {resolution nhits size} {
global drumstat
set n 0
for {set i 0} {$i < $size} {incr i} {
  set drumstat($i) 0}

while {$n < $nhits} {
  set r [expr rand()]
  set segno [map_r_to_drum_segment $r $size]
  if {$drumstat($segno) == 0} {
    set drumstat($segno) 1
    incr n
    }
  }
set drumstat(0) 1
}

proc create_drum_hit_distribution {size res} {
global cprob
for {set i 1} {$i < $size} {incr i} {
if {[expr $i % $res] == 0} {set cprob($i) 0.5} else {
   set cprob($i) 0.2}
  }
# integrate and normalize
for {set i 2} {$i < $size} {incr i} {
  set i1 [expr $i - 1]
  set cprob($i) [expr $cprob($i) + $cprob($i1)]
  }
set size1 [expr $size -1]
set total $cprob($size1)
for {set i 1} {$i < $size} {incr i} {
  set cprob($i) [expr $cprob($i)/$total]}
}


proc map_r_to_drum_segment {r size} {
global cprob
for {set i 1} {$i < $size} {incr i} {
  if {$r < $cprob($i) } {
     return $i
     }
  }
return -1
}





set drumfiles [glob -directory $dirdrumseq *.drum]


startup_drumseq
#pack .drumenu -side left -anchor w
#pack .drumseq -side left
set stopdrum 1

bind .drumseq.can  <Button> {set stopdrum 1}
bind .drumseq.can  <Button-3> start_playseq


#end of drumseq.tcl

# Part 38.0 Chord progressions
array set romansymbols2midi {
I 0 ii 2 iii 4 IV 5 V 7 vi 9 vii 11
}

set romansymbolslist {I ii iii IV V vi vii}

#puts "make_chordlist 60 maj: [make_chordlist 60 maj]"
#puts  "make_scalenotelist C: [make_scalenotelist C]"

proc roman2chordlist {roman root} {
global romansymbols2midi
set shift $romansymbols2midi($roman)
if {[string is lower [string index $roman 0]]} {
   make_chordlist [expr $root + $shift] min
} else {
   make_chordlist [expr $root + $shift] maj
  } 
}

proc makeprogression {progr root} {
set progchordlist {}
global romansymbols2midi
global trainer
#puts "makeprogression: progr = $progr root = $root"
foreach roman $progr {
  set shift $romansymbols2midi($roman)
  #puts "makeprogression roman = $roman shift = $shift"
  set octaveshift 12
  if {$shift >= 5 && $trainer(shiftedchord)} {
    set shiftedroot [expr $root - $octaveshift]
  } else {
    set shiftedroot $root
  }
  set chordlist [roman2chordlist $roman $shiftedroot]
  #puts "$roman $chordlist $octaveshift"
  lappend progchordlist $chordlist
  }
#puts "progchordlist = $progchordlist"
return $progchordlist
}

proc show_progression_in_grand_staff {progression} {
set xoffset 0
foreach chord $progression {
    set splitchord [split_chord $chord]
    set basschord [lindex $splitchord 1]
    set treblechord [lindex $splitchord 0]
    set chordsym ""
    set tagid "chord"
    foreach note $basschord {
        set sym [note2sym $note]
        set chordsym [concat $chordsym  $sym]
    }
    if {[string length $chordsym] > 0} {note-draw $chordsym 6 [expr $xoffset + 50] 42  .s.c $tagid}
    set chordsym ""
    foreach note $treblechord {
        set sym [note2sym $note]
        set chordsym [concat $chordsym  $sym]
    }
    if {[string length $chordsym] > 0} {note-draw $chordsym 0 [expr $xoffset + 50]  0  .s.c $tagid  }
  incr xoffset 25
  }
}


proc draw_progression {progchordlist} {
if {![winfo exist .s]} {
    frame .s
    canvas .s.c -width 140 -height 140
    pack .s.c -anchor nw
    pack .s -side top -anchor nw
 }
set keyprogression [list]
foreach prog $progchordlist {
  set keychord [list]
  foreach midi $prog {
    set key [midi2notename $midi]
    lappend keychord $key
    }
  lappend keyprogression $keychord
  }
  grand_canvas_redraw .s.c 160
  pack .s.c
  pack .s
  show_progression_in_grand_staff $keyprogression
}   

proc playprogression {progchordlist} {
global trainer
foreach prog $progchordlist {
   playchord $prog $trainer(playmode)
  }
}

proc playprogression_with_keyboard {progchordlist} {
global trainer
foreach prog $progchordlist {
   playchord_with_keyboard $prog $trainer(playmode)
  }
}

global romanresponse


proc place_progressions_buttons {} {
global chordprogressions
global progression_lesson
global trainer
set p .proginterface
destroy $p 
frame $p
pack $p -side top
set nprogs 12
set progex $progression_lesson($trainer(proglesson))
set j 0
for {set i 0} {$i < $nprogs} {incr i } {
  if {[lsearch $progex $i] < 0} continue
  button $p.$j -text  $chordprogressions($i) -command "verify_progression $j"
  set c [expr $j % 4] 
  set r [expr $j/4]
  grid $p.$j -column $c -row $r
  incr j
  }
add_progression_functions 
zero_prog_confusion_matrix
}

proc display_progression {} {
global selectedprogression
global trainer
set progchordlist [makeprogression $selectedprogression $trainer(chordroot)]
if {$trainer(chordinversion) > 0} {
   set progchordlist [make_inversion $progchordlist]
   }
if {$trainer(chordinversion) > 1} {
   set progchordlist [make_inversion $progchordlist]
   }
draw_progression $progchordlist
}

proc play_selectedprogression {method} {
global selectedprogression
global trainer

if {![info exist selectedprogression]} {
  .f.ans configure -text "first select one of the progressions"
  return
  }
set progchordlist [makeprogression $selectedprogression $trainer(chordroot)]
if {$trainer(chordinversion) > 0} {
   set progchordlist [make_inversion $progchordlist]
   }
if {$trainer(chordinversion) > 1} {
   set progchordlist [make_inversion $progchordlist]
   }
#playprogression $progchordlist 
if {$method == 1} {
  playprogression_with_keyboard $progchordlist 
 } else {
  playprogression $progchordlist }
}

proc add_progression_functions {} {
set p .proginterface
button $p.display -text display -width 7 -command display_progression
button $p.play -text play -width 7 -command {play_selectedprogression 0}
button $p.kbplay -text "kb play" -width 7 -command {play_selectedprogression 1}
grid  $p.display $p.play $p.kbplay
}

proc clear_selected_progressions {} {
set p .proginterface
for {set i 0} {$i < 12} {incr i} {
  if {![winfo exist $p.$i] } break
  $p.$i configure -bd 1
  }
}


proc verify_progression {j} {
global lang
global pickedprogression
global chordprogressions
global selectedprogression
global progression_lesson
global trainer
global proglesson
global cmatrix
global pickedn
if {![info exist pickedprogression]}  {
        .f.ans config -text $lang(firstpress)
        return
    }
set p .proginterface
set progex $progression_lesson($trainer(proglesson))
set i [lindex $progex $j]
clear_selected_progressions
incr cmatrix($pickedn-$i)
$p.$j configure -bd 5
set selectedprogression $chordprogressions($i)
#puts "pickedprogression = $pickedprogression selectedprogression = $selectedprogression"
if {$chordprogressions($i) == $pickedprogression} {
  .f.ans configure -text  $lang(correct)
  update
  if {$trainer(autonew)} {
       after $trainer(autonewdelay)
       next_test
       } 
  } else {
  .f.ans configure -text $lang(try) 
  }
}

proc select_progression_lesson {j} {
global progression_lesson
global trainer
set trainer(proglesson) $j
place_progressions_buttons 
}

#end of Part 38.0

#Part 39.0
# Piano keyboard

proc keyboard {} {
toplevel .piano
positionWindow .piano
canvas .piano.c -width 660 -height 80
set midipitch 24 
set k .piano.c
pack $k
set leftkey "5 0 5 30 0 30 0 50 17 50 17 0"
set rightkey "0 0 0 50 17 50 17 30 12 30 12 0"
set middlekey "0 0 0 50 17 50 17 0"
set blackkey "0 0 0 30 8 30 8 0"
for {set i 0} {$i < 36} {incr i} {
  set j [expr $i % 7]
  set ix [expr $i*17 + 1]
  switch $j {
    0 -
    3 {
     set midipitch [drawkey $ix $rightkey beige $midipitch]
     set midipitch [drawkey [expr $ix + 13] $blackkey grey $midipitch]
       }
    1 -
    4 -
    5 {
      set midipitch [drawkey $ix $leftkey beige $midipitch]
      set midipitch [drawkey [expr $ix + 13] $blackkey grey $midipitch]
      } 
    2 -
    6 {
      set midipitch [drawkey $ix $leftkey beige $midipitch]
       }
    2 {
      set midipitch [drawkey $ix $middlekey beige $midipitch]
      }
    }
  }
update
}

proc drawkey {ix key shade midipitch} {
global midi2id
global id2midi
global id2shade
set id [.piano.c create polygon $key -fill $shade -outline black]
.piano.c move $id $ix 0
set midi2id($midipitch) $id
set id2midi($id) $midipitch
set id2shade($id) $shade
#puts "id=$id key=$key midipitch=$midipitch"
incr midipitch
.piano.c bind $id <Button-1> "pianoclicked $id"
return $midipitch
}
 
proc pianoclicked {item} {
global id2midi
global id2shade
global trainer
set pitch $id2midi($item)
#puts "pianoclicked $item $pitch"
.piano.c itemconfigure $item -fill red
update
muzic::playnote 0 $pitch $trainer(velocity) $trainer(msec)
.piano.c itemconfigure $item -fill $id2shade($item)
}



proc playkeyboard {midipitches} {
global id2midi
global midi2id
global id2shade
global trainer
muzic::init
foreach pitch $midipitches {
  set id  $midi2id($pitch)
 .piano.c itemconfigure $id -fill red
  update
  muzic::playnote 0 $pitch $trainer(velocity) $trainer(msec)
 .piano.c itemconfigure $id -fill $id2shade($id)
  update
 }
}

#keyboard
#playkeyboard {25 26 27 30 42}
   
proc notelist_interface {} {
global trainer
global nresponse
set f .notebuttons.f
set t .notebuttons.t
if {![winfo exists .notebuttons]} {
  toplevel .notebuttons
  positionWindow .notebuttons
  frame $f
  frame $t
  pack $f
  pack $t
  label $t.l 
  pack $t.l
  } 
set nresponse ""
set m 0
for {set j $trainer(minpitch)} {$j <= $trainer(maxpitch)} {incr j} {
  set pitch $j
  set note [midi2notename $pitch]
  set k [expr $m % 6]
  set i [expr $m / 6]
  if {[winfo exists $f.$j]} {destroy $f.$j}
  button $f.$j -text $note -command "verify_note $j"
  grid $f.$j -row $i -column $k
  incr m
  }
update
}

proc verify_note {p} {
global nresponse
global notelist
global trainer
set note [midi2notename $p]
set nresponse $note
.notebuttons.t.l configure -text $nresponse
if {[lindex $notelist 0] == $nresponse} {
  .doraysing.msg configure -text correct
  update
  if {$trainer(autonew)} {
        after $trainer(autonewdelay)
        next_test
       } 
  } else {
  .doraysing.msg configure -text "should be [lindex $notelist 0]"
  }
}

set error_return [catch {muzic::init} errmsg]
if {$error_return} {
  tk_messageBox -type ok -icon error -message $errmsg
  exit
  }


bind . <a> {advance_settings_config}


setup_exercise_interface $trainer(exercise)


if {$trainer(exercise) == "intervals"} {set ttype unison};

if {$trainer(makelog)} {set loghandle [open "tksolfege.log" "w"]}

if {$trainer(repeatability) == 1} {
  reset_random_seed
  }

positionWindow .
focus .f
bind . <r> repeat
bind . <n> next_test
bind . <S> "savedruminfo stdio"

bind . <Alt-l> pick_language_pack

