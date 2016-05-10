/* ----------------------------------- */
/* Program to read Standard Midi Files */
/* ----------------------------------- */
#include "midiread.h"

/* ------------------ */
/* Passing parameters */
/* ------------------ */
int Argc;
char **Argv;

/* ----- */
/* Flags */
/* ----- */
int VerboseOn = 0;
int MESigOn = 0;
int METextOn = 0;
int METrackOn = 0;
int HELP = 0;

/* ---------------- */
/* Global constants */
/* ---------------- */
const char *majmin[2]={"maj","min"};
const char *tonality[15]={"Cb","Gb","Db","Ab","Eb","Bb","F","C","G","D","A","E","B","Fd","Cd"};

/* ---------------- */
/* Global variables */
/* ---------------- */
char *fileName;

unsigned char *c;
unsigned long mdindex,lenChunk,timeStamp,sumTimeStamp,prevTimeStamp;
unsigned char event,leftEvent,lastEvent;
unsigned ppqn;
gTracklist *firstTrack, *currTrack;
gTempolist *firstTempo, *currTempo;
int trk, numTempoChanges = 0;

int prevTempo = 0;
int prevTime[2] = {0,0};
signed char prevKey[2] = {10,2};

Notelist memOn[128][16];


/* ------------ */
/* MAIN PROGRAM */
/* ------------ */
int main(int argc,char **argv)
{
  FILE *fid;
  int varLen;

  /* Read options */
  Argc = argc;
  Argv = argv;
  my_getopts();

  if(HELP)
    {
      printf("Usage: midiread [-vhsxt] filename.mid\n");
      printf(" -v: print general information about the midifile\n");
      printf(" -h: print this help\n");
      printf(" -s: print information on key and time signature\n");
      printf(" -x: print all text data in the midifile\n");
      printf(" -t: print text info on midi tracks\n");
    }
  if(*Argv)
    {
      fileName = *Argv;
      if( (fid = fopen(fileName,"rb")) == NULL )
	{
	  fprintf(stderr,"Error: opening %s\n",fileName);
	  return(-1);
	}
    }
  else
    {
      fprintf(stderr,"Usage: midiread [-vhsxt] filename.mid\n");
      return(-1);
    }


/* ------------------- */
/* READ THE SMF HEADER */
/* ------------------- */
  c = (unsigned char*)malloc(14);
  fread(c,14,1,fid);

  /* Check if there is a RIFF header preappended */
  if(*c == 'R' || *(c+1) == 'I' || *(c+2) == 'F' || *(c+3) == 'F')
    {
      fread(c,6,1,fid);
      fread(c,14,1,fid);
    }

  if(*c != 'M' || *(c+1) != 'T' || *(c+2) != 'h' || *(c+3) != 'd')
    {
      fprintf(stderr,"Error: %s is not a Standard MIDI File\n",fileName);
      fclose(fid);
      return(-2);
    }
  lenChunk = ReadFixLen(c,4,4);

  SMFhead.type = (unsigned short) ReadFixLen(c,8,2);
  SMFhead.numChunks = (unsigned short) ReadFixLen(c,10,2);
  SMFhead.division1 = (char) ReadFixLen(c,12,1);
  SMFhead.division2 = (unsigned char) ReadFixLen(c,13,1);

  /* Sets the tempo variable */
  if(SMFhead.division1 >= 0)
    ppqn = SMFhead.division1*256+SMFhead.division2;
  else
    {
      fprintf(stderr,"Error: %s does not have a PPQN time format\n",fileName);
      fclose(fid);
      return(-3);
    }

  /* Shows some informations */
  if (VerboseOn)
    {
      printf("\\filename[]{%s}\n",fileName);
      printf("\\filetype[]{%d}\n",SMFhead.type);
      printf("\\chunks[]{%d}\n",SMFhead.numChunks);
      printf("\\PPQN[]{%d}\n",ppqn);
      printf("\\division[]{%d %d}\n",SMFhead.division1,SMFhead.division2);
    }

  /* Additional info on ppqn and division */
  /* printf("%d\t%d\t%d\t0\t0\t0\t0\n",ppqn,SMFhead.division1,SMFhead.division2); */

  /* In case the file is not standard realigne the reading */
  if(lenChunk > 6)
    {
      fprintf(stderr,"Warning: %s has an MThd length of %ld\n",fileName,lenChunk);
      fread(c,lenChunk-6,1,fid);
    }
  free(c);

/* ------------------- */
/* READ THE SMF TRACKS */
/* ------------------- */
  for(trk = 0; trk < SMFhead.numChunks; ++trk)
   {
     /* Chunk header */
     c = (unsigned char*)malloc(8);
     fread(c,8,1,fid);
     
     if(*c != 'M' || *(c+1) != 'T' || *(c+2) != 'r' || *(c+3) != 'k')
       {
	 fprintf(stderr,"Error: in %s chunk header n.%d is not MTrk\n",fileName,trk);
	 fclose(fid);
	 return(-4);
       }
     lenChunk = ReadFixLen(c,4,4);
     free(c);

     /* Chunk body */
     c = (unsigned char*)malloc(lenChunk);
     fread(c,lenChunk,1,fid);
     mdindex = 0;
     sumTimeStamp = 0;
     AddTrack(trk);
     ClearMemOn();

     if (VerboseOn)
       printf("\\chunkinfo[]{%d %g}\n",trk,(float) lenChunk);

     while(mdindex<lenChunk)
      {
	sumTimeStamp += (timeStamp = ReadVarLen(c,mdindex,&varLen));
      	mdindex += varLen;

	/* When leftmost_bit == 1, the event is the same as the previous */
      	if( *(c+mdindex) & 0x80)
	  event = *(c+mdindex++);
	else
	  event = lastEvent;

	switch(event)
	  {
	  case MetaEvent:
	    PerfMetaEvent();
	    break;

	  /* WWW Take informations about SysEx WWW */
	  case SysEx:
	    PerfSysEx();
	    break;

	  default:
	    /* Takes only the left nibble of the event */
	    lastEvent = event;
	    leftEvent = event & 0xf0;
	    switch(leftEvent)
	      {
	      case NoteOn:
		if(*(c+mdindex+1)>0)
		  PerfNoteOn();
		else
		  PerfNoteOff();
		break;

	      case NoteOff:
		PerfNoteOff();
		break;

	      /* Consider also Control and Program Change signals */
	      case CtrlChange:
		PerfCtrlChange();
		break;
	      case PrgChange:
		PerfPrgChange();
		break;

	      /* All other events are ignored */
	      case AftTchKey:
	      case PitchWheel:
		mdindex+=2;
		break;
	      case AftTchChan:
		mdindex+=1;
		break;
	      default:
		fprintf(stderr,"Warning: %s has misplaced data\n",fileName);
		break;
	      }
	  }
      }
   }
  fclose(fid);
  PrintNotes();

  return 0;
}

/* -------------------------- */
/* FUNCTIONS TO HANDLE EVENTS */
/* -------------------------- */
void PerfMetaEvent(void)
{
  unsigned long jump;
  int l, m;
  unsigned int newTempo;
  unsigned char typeMeta;

  /* Kind of metaevent */
  typeMeta = *(c+mdindex++);

  /* Length of the data in the metaevent */
  jump = ReadVarLen(c,mdindex,&l);
  mdindex += l;

  switch(typeMeta)
    {
    case MEtempo:      /* Tempo Changes */
      newTempo = ReadFixLen(c,mdindex,3);
      AddTempo(newTempo,sumTimeStamp);
      if (MESigOn && prevTempo != newTempo)
	{
	  prevTempo = newTempo;
	  printf("\\tempo[%lu]{%d}\n", sumTimeStamp, newTempo);
	}
      break;

    case MEtimesig:    /* Time signature */
      if (MESigOn && !(prevTime[0] == *(c+mdindex) && prevTime[1] == *(c+mdindex+1)))
	{
	  prevTime[0] = *(c+mdindex);
	  prevTime[1] = *(c+mdindex+1);
	  printf("\\timesig[%lu]{%d/%d}\n", sumTimeStamp, prevTime[0], (int) pow((double) 2,(double) prevTime[1]));
	}
      break;

    case MEkeysig:     /* Key signature */
      if (MESigOn && !(prevKey[0] == (signed char) *(c+mdindex) && prevKey[1] == *(c+mdindex+1)) && (signed char) *(c+mdindex) < 8 && (signed char) *(c+mdindex) > -8 && *(c+mdindex+1) < 2)
	{
	  prevKey[0] = (signed char) *(c+mdindex);
	  prevKey[1] = *(c+mdindex+1);
	  printf("\\keysig[%lu]{%s%s}\n", sumTimeStamp, tonality[7+prevKey[0]], majmin[prevKey[1]]);
	}
      break;

    case MEtext:       /* Free text */
    case MEcopy:       /* Copyright informations */
    case MEmarker:     /* A marker: have a look at the meaning */
    case MEcue:        /* A cue: have a look at the meaning */
      if (METextOn)
	{
	  printf("\\text[%lu]{", sumTimeStamp);
	  for(m = 0; m < jump; ++m)
	    if(*(c+mdindex+m)!='{' && *(c+mdindex+m)!='\\' && *(c+mdindex+m)!='}' && *(c+mdindex+m) >=' ' )
	      printf("%c",*(c+mdindex+m));
	  printf("}\n");
	}
      break;

    case MEtrckname:   /* Name of the track */
    case MEtrckinst:   /* Name of the instrument of the track */
      if (METrackOn)
	{
	  printf("\\text[%lu]{", sumTimeStamp);
	  for(m = 0; m < jump; ++m)
	    if(*(c+mdindex+m)!='{' && *(c+mdindex+m)!='\\' && *(c+mdindex+m)!='}' && *(c+mdindex+m)!='\n' )
	      printf("%c",*(c+mdindex+m));
	  printf("}\n");
	}
      break;

    case MEmidichan:   /* Midi channel: ignored */
    case MEmidiport:   /* Midi port: ignored */
      break;

    case MEendtrck:
      if (mdindex != lenChunk)
	{
	  mdindex = lenChunk;
	  fprintf(stderr,"Warning: In %s track %d ends earlier\n",fileName,trk);
	}
      break;

    default:
      break;
    }
  /* Update position in the file */
  mdindex+=jump;
}

/* System exclusives are ignored */
void PerfSysEx(void)
{
  unsigned long jump;
  int l;

  jump = ReadVarLen(c,mdindex,&l);
  mdindex += jump + l;

  /* printf("%lu\tSysex: \t%lu\t%lu\n",sumTimeStamp,jump,mdindex); */
}

void PerfNoteOn(void)
{
  /* printf("%lu\tNoteOn:\t%d\t%d\t%d\n",sumTimeStamp,(event-leftEvent),*(c+mdindex),*(c+mdindex+1)); */

  AddNote(event-leftEvent,*(c+mdindex)&0x7f,*(c+mdindex+1)&0x7f,sumTimeStamp);
  mdindex += 2;
}

void PerfNoteOff(void)
{
  /* printf("%lu\tNoteOff:\t%d\t%d\t%d\n",sumTimeStamp,(event-leftEvent),*(c+mdindex),*(c+mdindex+1)); */

  AddDuration(event-leftEvent,*(c+mdindex)&0x7f,sumTimeStamp);
  mdindex += 2;
}

void PerfCtrlChange(void)
{
  /* printf("%lu\tCtrlChange:\t%d\t%d\t%d\n",sumTimeStamp,(event-leftEvent),*(c+mdindex),*(c+mdindex+1)); */

  AddAccent(event-leftEvent,*(c+mdindex)&0x7f,*(c+mdindex+1)&0x7f,sumTimeStamp);
  mdindex += 2;
}

void PerfPrgChange(void)
{
  /* printf("%lu\tPrgChange:\t%d\t%d\n",sumTimeStamp,(event-leftEvent),*(c+mdindex)); */

  mdindex += 1;
}

/* ------------------------------------------------------------------ */
/* Functions to handle melodies in different tracks and tempo changes */
/* ------------------------------------------------------------------ */

/* Called once for each new tempo message */
void AddTempo(unsigned int tempo, unsigned long tmst)
{
  if (numTempoChanges == 0)
    {
      firstTempo = (Tempolist) malloc(sizeof(gTempolist));
      currTempo = firstTempo;
      currTempo->time = tmst;
      currTempo->tempo = tempo;
      ++numTempoChanges;
    }
  else if (currTempo->tempo != tempo)
    {
      currTempo->next = (Tempolist) malloc(sizeof(gTempolist));
      currTempo = currTempo->next;
      currTempo->time = tmst;
      currTempo->tempo = tempo;
      ++numTempoChanges;
    }
}

void MakeupTempo(void)
{
  gTempolist *tempoTmp;

  if (!firstTempo)
    {
      AddTempo(DEFAULT_TEMPO,0);
    }
  else if (firstTempo->time > 0)
    {
      tempoTmp = firstTempo;
      firstTempo = (Tempolist) malloc(sizeof(gTempolist));
      firstTempo->time = 0;
      firstTempo->tempo = DEFAULT_TEMPO;
      firstTempo->next = tempoTmp;
    }  
  AddTempo(DEFAULT_TEMPO-1,ULONG_MAX);
}

/* Called once for each new miditrack */
void AddTrack(int track)
{
  if(track==0)
    {
      firstTrack = (Tracklist) malloc(sizeof(gTracklist));
      currTrack = firstTrack;
    }
  else
    {
      currTrack->next = (Tracklist) malloc(sizeof(gTracklist));
      currTrack = currTrack->next;
    }
  currTrack->trk = track;
  currTrack->numNote = 0;
  currTrack->next = NULL;
  currTrack->firstNote = NULL;
  currTrack->lastNote = NULL;
}

void AddNote(unsigned char ch, unsigned char key, unsigned char vel, unsigned long tmst)
{
  gNotelist *nTmp;

  if (currTrack->numNote == 0)
    {
      currTrack->firstNote = (Notelist) malloc(sizeof(gNotelist));
      currTrack->numNote = 1;
      nTmp = currTrack->firstNote;
      nTmp->time = tmst;
      nTmp->chan = ch;
      nTmp->key  = key;
      nTmp->vel  = vel;
      nTmp->dur  = 0;
      nTmp->acc16 = 0;
      nTmp->acc17 = 0;
      nTmp->acc18 = 0;
      currTrack->lastNote = nTmp;
    }
  else
    {
      /* Case of subsequent NoteOn of same key and channel */
      if (memOn[key][ch])
	AddDuration(ch, key, tmst);

      nTmp = currTrack->lastNote;
      ++(currTrack->numNote);
      nTmp->next = (Notelist) malloc(sizeof(gNotelist));
      
      nTmp = nTmp->next;
      
      nTmp->time = tmst;
      nTmp->chan = ch;
      nTmp->key  = key;
      nTmp->vel  = vel;
      nTmp->dur  = 0;
      nTmp->acc16 = 0;
      nTmp->acc17 = 0;
      nTmp->acc18 = 0;
      
      currTrack->lastNote = nTmp;
    }
  memOn[key][ch] = currTrack->lastNote;
}

void AddDuration(unsigned char ch, unsigned char key, unsigned long tmst)
{
  gNotelist *nTmp;

  nTmp = memOn[key][ch];
  if (nTmp)
    {
      nTmp->dur = tmst - nTmp->time;
      memOn[key][ch] = NULL;
    }
}

void AddAccent(unsigned char ch, unsigned char acc, unsigned char val, unsigned long tmst)
{
  gNotelist *nTmp;
  int n;

  if ( val > 0 )
    {
      for(n=0; n < 128; ++n)
	{
	  nTmp = memOn[n][ch];
	  if (nTmp && nTmp->time == tmst)
	    {	 
	      switch(acc)
		{
		case 16:
		  nTmp->acc16 = val;
		  break;
		case 17:
		  nTmp->acc17 = val;
		  break;
		case 18:
		  nTmp->acc18 = val;
		  break;
		default:
		  break;
		}
	    }
	}
    }
}

/* ---------------------------------------- */
/* Convert from MIDI pulses to milliseconds */
/* ---------------------------------------- */

unsigned long ConvertToMsecs(unsigned int tempo, unsigned long tmstDiff)
{
  unsigned long msec;

  msec = (tempo * tmstDiff) / (ppqn * 1000);
  return(msec);
}


/* --------------- */
/* Display results */
/* --------------- */

void PrintNotes(void)
{
  int n;
  unsigned long tempoChange, tempoChangeOff, lastPulse, lastPulseOff, lastMsec, lastMsecOff, noteOff;
  unsigned int actTempo, actTempoOff;
  gNotelist *nTmp;
  gTracklist *trackTmp;
  gTempolist *tempoTmp, *tempoTmpOff;

  /* Put Tempolist in a suitable form */
  MakeupTempo();    

  trackTmp = firstTrack;
  do
    {
      lastPulse = 0;
      lastMsec = 0;
      tempoTmp = firstTempo;

      nTmp = trackTmp->firstNote;

      for(n = 0; n < trackTmp->numNote; ++n)
	{
	  /* Note Onset: Check if a tempo change occurred */
	  while (nTmp->time >= (tempoTmp->next)->time)
	    {
	      lastMsec += ConvertToMsecs(tempoTmp->tempo,(tempoTmp->next)->time - lastPulse);
	      lastPulse = (tempoTmp->next)->time;
	      tempoTmp = tempoTmp->next;
	    }
	  lastMsec += ConvertToMsecs(tempoTmp->tempo,nTmp->time - lastPulse);
	  lastPulse = nTmp->time;

	  /* Note Duration: Check if a tempo change will occur */
	  noteOff = lastPulse + nTmp->dur;
	  lastMsecOff = lastMsec;
	  lastPulseOff = lastPulse;
	  actTempoOff = tempoTmp->tempo;
	  tempoChangeOff = (tempoTmp->next)->time;
	  tempoTmpOff = tempoTmp;
	  while (noteOff >= tempoChangeOff)
	    {
	      lastMsecOff += ConvertToMsecs(actTempoOff,tempoChangeOff - lastPulseOff);
	      lastPulseOff = tempoChangeOff;
	      tempoTmpOff = tempoTmpOff->next;
	      tempoChangeOff = (tempoTmpOff->next)->time;
	      actTempoOff = tempoTmpOff->tempo;
	    }
	  lastMsecOff += ConvertToMsecs(actTempoOff,noteOff - lastPulseOff);

	  if (nTmp->dur > 0)
	    printf("%ld\t%ld\t%d\t%d\t%d\t%ld\t%ld\t%d\t%d\t%d\n",
		   nTmp->time,nTmp->dur,
		   nTmp->chan,nTmp->key,nTmp->vel,
		   lastMsec,lastMsecOff-lastMsec,
		   nTmp->acc16,nTmp->acc17,nTmp->acc18);

	  nTmp = nTmp->next;
	}
    }
  while ((trackTmp = trackTmp->next));
}

/* ------------------------------------------------------ */
/* Functions to read Fixed and Variable Lenght Quantities */
/* ------------------------------------------------------ */
unsigned long ReadFixLen(unsigned char* st,unsigned long ind,int len)
{
  unsigned long value=0;
  register int n;
  
  for(n=0;n<len;++n)
    value=(value<<8)+*(st+ind+n);

  return(value);
}

unsigned long ReadVarLen(unsigned char* st,unsigned long ind,int* len)
{
  register unsigned char c;
  unsigned long value;
  
  *len=1;
  value = *(st+ind);
  if( value & 0x80 )
    {
      value &= 0x7F;
      do
	value=(value<<7)+((c=*(st+ind+((*len)++)))&0x7F);
      while(c&0x80);
    }

  return(value);
}

/* Clear memo of NoteOns */
void ClearMemOn(void)
{
  int key, ch;

  for( key = 0; key < 128; ++key )
    for( ch = 0; ch < 16; ++ch )
      memOn[key][ch] = NULL;
}

/* Check options */
my_getopts()
{
  int c;
  extern char *optarg;
  extern int optind;

  while((c = getopt(Argc, Argv, "vhsxt")) != -1)
    {
      switch(c)
	{
	case 'v':
	  VerboseOn = 1;
	  break;
	case 'h':
	  HELP = 1;
	  break;
	case 's':
	  MESigOn = 1;
	  break;
	case 'x':
	  METextOn = 1;
	  break;
	case 't':
	  METrackOn = 1;
	  break;
	case '?':
	default:
	  exit(1);
	}
    }
  Argv += optind;
  Argc += optind;
}
