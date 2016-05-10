function rtf = midi2rtf(filePath, midiFileName)
    
    file = [filePath, midiFileName];
    [~, rtf] = system(['util/MIDI/midiread.exe ' file]);
    
end
