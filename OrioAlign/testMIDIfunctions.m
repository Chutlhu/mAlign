scorePathName = 'score\';
[scoreFileName] = uigetfile('*.mid', 'Select the MIDI file',scorePathName);

[score, midireadOutput, midiScore] = parseMidiScore(scorePathName, scoreFileName);
