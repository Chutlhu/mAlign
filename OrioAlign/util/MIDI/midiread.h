/* ---------- */
/* MIDIREAD.H */
/* ---------- */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>   /* Needed for function pow() */
#include <limits.h> /* Needed for ULONG_MAX */

/* Global constants */
#define DEFAULT_TEMPO 500000

/* --------------- */
/* Midifile header */
/* --------------- */
struct MThdChunk
{
  unsigned short type;
  unsigned short numChunks;
  char division1;
  unsigned char division2;
} SMFhead;

/* -------------------- */
/* Events to be tracked */
/* -------------------- */

/* Midi events */
#define NoteOff    0x80
#define NoteOn     0x90
#define AftTchKey  0xa0
#define CtrlChange 0xb0
#define PrgChange  0xc0
#define AftTchChan 0xd0
#define PitchWheel 0xe0

#define SysEx      0xf0

/* Meta events */
#define MetaEvent  0xff

#define MEseqnum   0x00 /* */
#define MEtext     0x01
#define MEcopy     0x02
#define MEtrckname 0x03
#define MEtrckinst 0x04
#define MElyric    0x05 /* */
#define MEmarker   0x06
#define MEcue      0x07
#define MEmidichan 0x20
#define MEmidiport 0x21
#define MEendtrck  0x2f
#define MEtempo    0x51
#define MEsmpte    0x54 /* */
#define MEtimesig  0x58
#define MEkeysig   0x59

/* ----------------------------------------- */
/* Structures for the notes and the melodies */
/* ----------------------------------------- */
typedef struct nNode *Notelist;
typedef struct nNode
{
  unsigned long time;    /* onset time */
  unsigned char chan;    /* midi channel */
  unsigned char key;     /* midi note */
  unsigned char vel;     /* velocity */
  unsigned long dur;     /* duration */
  unsigned char acc16;   /* accents */
  unsigned char acc17;
  unsigned char acc18;
  Notelist next;
} gNotelist;

typedef struct tkNode *Tracklist;
typedef struct tkNode
{
  int trk;
  int numNote;
  Tracklist next;
  Notelist firstNote;
  Notelist lastNote;
} gTracklist;

typedef struct tNode *Tempolist;
typedef struct tNode
{
  unsigned long time;
  unsigned int tempo;
  Tempolist next;
} gTempolist;


/* -------------------- */
/* Functions definition */
/* -------------------- */

/* To clear the memo of NoteOns */
void ClearMemOn(void);

/* To read bytes data of fixed and variable length */
unsigned long ReadFixLen(unsigned char*, unsigned long,int);
unsigned long ReadVarLen(unsigned char*, unsigned long,int*);

/* To handle particular events */
void PerfMetaEvent(void);
void PerfSysEx(void);
void PerfNoteOn(void);
void PerfNoteOff(void);
void PerfCtrlChange(void);
void PerfPrgChange(void);

/* To handle lists of events and metaevents */
void AddTrack(int);
void AddTempo(unsigned int, unsigned long);
void AddNote(unsigned char, unsigned char, unsigned char, unsigned long);
void AddDuration(unsigned char, unsigned char, unsigned long);
void AddAccent(unsigned char, unsigned char, unsigned char, unsigned long);
void PrintNotes(void);

/* To handle time conversion between MIDI pulses and milliseconds */
unsigned long ConvertToMsecs(unsigned int, unsigned long);

