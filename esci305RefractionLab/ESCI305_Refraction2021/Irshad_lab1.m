%-------------------------------------------------------------------------
% Seismic Lab
% Irshad Ul Ala
%
pickingFlag = 0; % CHANGE THIS TO 1 if you want to pick data.
%-------------------------------------------------------------------------
infile = 'str1u2021'; % Change this to see different shots: str1u2021 str1d2021
%-------------------------------------------------------------------------
plusminusFlag = 0; % Change this once you have your picks and are ready
%-------------------------------------------------------------------------


switch infile
    case 'str1u2021'
        shotloc = 100.00;
    case 'str1d2021'
        shotloc = 148.50;
    otherwise
        disp('File unknown! Check infile parameter')
end


xint = 1; % Geophone spacing
tint = 0.0005; % sampling interval
recordLength = 0.300;
t=0:tint:recordLength; %0:sampleInterval:recordLength
ntraces = 48;
channels=1:1:ntraces;  %linspace function

A = SegYFileReader(strcat('./',infile,'.sgy')); % Get trace headers
[traces,th] = readTraceData(A); % Get data

figure, wiggle(t,channels,traces)
xlabel('Channel Trace')
ylabel('Time (s)')

if pickingFlag == 1
    figh = gcf;

    disp('Pick the first breaks. Pick them all, or press enter to continue.')
    [x,y]=ginputc(ntraces);
    waitfor(figh)

    channel = round(x);

    switch infile
        case 'str1u2021'
            upx = (100 +(channel*xint)) -shotloc;
            upt = y;
            dat = [channel, upx, upt];
            save('./upshotpicks.mat','dat')
        case 'str1d2021'
            downx = (100 +(channel*xint)) -shotloc;
            downt = y;
            dat = [channel,downx, downt];
            save('./downshotpicks.mat','dat')
        otherwise
            disp('Unknown shot')
    end

end




%Plotting our upshotdata

[channel,I] = sort(upshot(:,1));
offset = upshot(I,2);
time = upshot(I,3);
figure, plot(offset,time,'x')
xlabel('Offset')
ylabel('Time (s)')

%Plotting our downshotdata

[channel,I] = sort(downshot(:,1));
offset = downshot(I,2);
time = downshot(I,3);
figure, plot(offset,time,'x')
xlabel('Offset')
ylabel('Time (s)')




%Fitting for upshot
[channel,I] = sort(upshot(:,1));
offset = upshot(I,2);
time = upshot(I,3);
figure, plot(offset,time,'x')
xlabel('Offset')
ylabel('Time (s)')


start =  10;
stop = 48;

[P,S] = polyfit(offset(start:stop),time(start:stop),1);
gcf; hold on
plot(offset(start:stop),polyval(P,offset(start:stop)),'-')
xlabel('Offset')
ylabel('Time')
title(infile)

assignin('base','P',P)  %Assign v1 or v2_upshot to P(1) here





%Fitting for downshot


[channel,I] = sort(downshot(:,1));
offset = downshot(I,2);
time = downshot(I,3);
figure, plot(offset,time,'x')
xlabel('Offset')
ylabel('Time (s)')

start =  7;
stop = 40;

[P,S] = polyfit(offset(start:stop),time(start:stop),1);
gcf; hold on
plot(offset(start:stop),polyval(P,offset(start:stop)),'-')
xlabel('Offset')
ylabel('Time')
title(infile)

assignin('base','P',P)  %Assign v1_upshot to P(1) here