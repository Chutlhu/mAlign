function [score, firstOnset, midiScore] = parseMidiScore(scorePathName, scoreFileName)

    % parseMIDI (function)
    %
    % Function for parsing the .trs file FILENAME, obtained by C function
    % midiread, in directory PATH. When THRS_MSEC is set, short slices are
    % ignored. It outputs the cell array SCORE.
    %
    % INPUT values
    % filePath: the absolute or relative path where the .trs file is
    % midiFileName: the name of the .trs file
    % thrs_msec: threshold in msecs for ignoring short slices
    %
    % OUPUT values
    % score: cell array of polyphonic score slices

    onsetMillisThr = 5; % decimal numbers

    file = [scorePathName scoreFileName];

    % parse the midi file in the following format using MIDItoolbox
    % ||--onset(beats)--|--duration(beats)--|--channel--|--key--|--vel--|--onset(sec)--|--duration(sec)--||
    midiScore = midi2nmat(file);

    % Load scan the standard output and reorganize the score in a integer matrix
    % delete channel 0 (do not know why) // usaully not used
    noteMatrix = midiScore(~midiScore(:, 3) == 0,:);
    nNotes = size(noteMatrix, 1);

    % if midiScore has 7 colums, add zeros columns
    if size(noteMatrix, 2) == 7
        noteMatrix = [noteMatrix zeros(nNotes,3)];
    end

    % ||--note ON--|--key--|--lastMsec--|--3xAccents--||
    noteONs = [ones(nNotes,1), noteMatrix(:,[4,6]), noteMatrix(:,[8,9,10])];

    % ||--note OFF--|--key--|--lastMsecOff--|--3xAccents--||
    noteOFFs = [zeros(nNotes,1), noteMatrix(:,4), noteMatrix(:,6) + noteMatrix(:,7), noteMatrix(:,[8,9,10])];

    % ||--ON/OFF--|--key--|--Time--|--3xAccents--||
    notes = sortrows([noteONs; noteOFFs], [3 1 2]); 

    % Create cell array with data
    % ||--key--|--interOnsetTime--|--Accents--||
    notes(:,3) = round(notes(:,3), onsetMillisThr);
    timeOnsets = unique(notes(:,3));
    interOnsetTime = [diff(timeOnsets); 0];
    score = cell(length(timeOnsets), 3);

    % Initialization
    playingNotes = [];

    % Create time slices
    for indexOnset = 1:length(timeOnsets);
        currentOnset = timeOnsets(indexOnset);
        disactivatedNotes = notes((notes(:,3) == currentOnset) & (notes(:,1) == 0), 2);
        activatedNotes = notes((notes(:,3) == currentOnset) & (notes(:,1) == 1), 2);
        playingNotes = union(setdiff(playingNotes, disactivatedNotes), activatedNotes);
        score{indexOnset, 1} = playingNotes;
        score{indexOnset, 2} = interOnsetTime(indexOnset);
        score{indexOnset, 3} = [0 0 0];
    end

    % time shift:
    firstOnset = timeOnsets(1);

    %% DISPLAY RESULTS
    figure(3)
    pianoroll(noteMatrix, 'num', 'sec'); % <<= ground truth?
    fpos = firstOnset;
    for n = 1:length(score)
        ipos = fpos;
        fpos = ipos + score{n, 2};

        notes = score{n,1};
        for m = 1:length(notes)
            nt = notes(m);
            line([ipos,fpos],[nt,nt],'LineWidth',3,'LineStyle','-','Color',[0 0 0])
        end
    end

    
end
