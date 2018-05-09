function varargout = FindEPSPs_gui(varargin)
% FINDEPSPS_GUI MATLAB code for FindEPSPs_gui.fig
%      FINDEPSPS_GUI, by itself, creates a new FINDEPSPS_GUI or raises the existing
%      singleton*.
%
%      H = FINDEPSPS_GUI returns the handle to a new FINDEPSPS_GUI or the handle to
%      the existing singleton*.
%
%      FINDEPSPS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDEPSPS_GUI.M with the given input arguments.
%
%      FINDEPSPS_GUI('Property','Value',...) creates a new FINDEPSPS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FindEPSPs_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FindEPSPs_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FindEPSPs_gui

% Last Modified by GUIDE v2.5 31-Jul-2013 13:54:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @FindEPSPs_gui_OpeningFcn, ...
    'gui_OutputFcn',  @FindEPSPs_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FindEPSPs_gui is made visible.
function FindEPSPs_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FindEPSPs_gui (see VARARGIN)

% Choose default command line output for FindEPSPs_gui
handles.output = hObject;
handles.V=varargin{1};
handles.ppms=varargin{2};
handles.savefile=varargin{3};
handles.spikes=varargin{4};
handles.savedir=varargin{5};
handles.EEG=nan(size(varargin{1}));
%Triggers always in 7
if numel(varargin)==7, handles.Triggers=varargin{7};end
%EEG always in 6
if numel(varargin)>=6; handles.EEG=varargin{6};
    %set EEG to nans if not available
    if varargin{6}==0,
        handles.EEG=nan(size(varargin{1}));
    end
end
handles.L=nan(size(varargin{1}));
handles.W=nan(size(varargin{1}));
set(handles.text11,'String',varargin{3})
guidata(hObject, handles);
% load previous analysis results.

display('Loading data...')
load(handles.savefile,'preprocessedData','autoDetectedEPSPs','handSelectedEPSPs','checkedEPSPData', 'finalizedEPSPs','APassociatedEPSPs')
display('Done loading data.')

if exist('preprocessedData')
    handles.preprocessedData=preprocessedData;
    set(handles.checkbox2,'Value',1);
    ppms=handles.ppms;
    %make time vector in ms
    time=[1:numel(preprocessedData.pV)]'/ppms;
    
    
    %set previous processing data
    set(handles.edit4,'String',num2str(preprocessedData.minHz));
    set(handles.edit5,'String',num2str(preprocessedData.maxHz));
    set(handles.edit1,'String',num2str(preprocessedData.multiplier));
    set(handles.edit2,'String',num2str(preprocessedData.ds));
    
    spikes=handles.spikes;
    spikeV=preprocessedData.pV(spikes);
    ds=preprocessedData.ds;
    axes(handles.axes1);hold off
    
    
    plot(handles.axes1,time(ds:ds:end),preprocessedData.pV(ds:ds:end),'k');hold on
    if numel(handles.EEG)<numel(time), handles.EEG=[handles.EEG;zeros(numel(time)-numel(handles.EEG),1)];end
    if numel(handles.EEG)>numel(time), handles.EEG=handles.EEG(1:numel(time));end
    plot(handles.axes1,time(ds:ds:end),handles.EEG(ds:ds:end)-1.5,'color',[.6 .6 .6])
    
    if isfield(handles, 'Triggers')
        Triggers=handles.Triggers;
        if isfield(Triggers,'light')
            L=Triggers.light-Triggers.light(1); L=L/max(abs(L));
            if numel(L)<numel(time) L=[L;zeros(numel(time)-numel(L),1)];end
            if numel(L)>numel(time) L=L(1:numel(time));end
            
            plot(handles.axes1,time(ds:ds:end),L(ds:ds:end)*3-10)
            handles.L=L;
        end
        
        if isfield(Triggers,'whisker')
            W=Triggers.whisker-Triggers.whisker(1);; W=W/max(abs(W));
            %if min(W)<0,W=-W;end
            if numel(W)<numel(time) W=[W;zeros(numel(time)-numel(W),1)];end
            if numel(W)>numel(time) W=W(1:numel(time));end
            
            plot(handles.axes1,time(ds:ds:end),W(ds:ds:end)*100-20,'g')
            handles.W=W;
        end
        
    end
    plot(handles.axes1,spikes/ppms,spikeV,'r.');
    axes(handles.axes1);xlabel('Time [ms]');ylabel('Vmem [mV]')
    xlim([min(time) max(time)]);
    
    set(handles.pushbutton1,'enable','on')
    set(handles.pushbutton7,'enable','on')
    guidata(hObject, handles);
end

if exist('autoDetectedEPSPs')
    set(handles.checkbox3,'Value',1);
    n=size(autoDetectedEPSPs.events,1);
    set(handles.edit7,'String', num2str(n));
    handles.autoDetectedEPSPs=autoDetectedEPSPs;
    set(handles.edit3,'String',num2str(autoDetectedEPSPs.threshold));
    set(handles.edit9,'String',num2str(autoDetectedEPSPs.minMagnitude));
    set(handles.edit8,'String',num2str(autoDetectedEPSPs.maxVoltage));
    guidata(hObject, handles);
    
end

if exist('checkedEPSPData')
    set(handles.checkbox4,'Value',1);
    handles.checkedEPSPData=checkedEPSPData;
    n=sum(checkedEPSPData.goods);
    set(handles.edit13,'String', num2str(n));
end


% load EPSPs already selected, if applicable.
if exist('handSelectedEPSPs')
    handles.handSelectedEPSPs=handSelectedEPSPs;
    set(handles.checkbox5,'Value',1);
    n=size(handSelectedEPSPs.NewEvents,1);
    set(handles.edit15,'String', num2str(n));
end


if exist('APassociatedEPSPs')
    handles.APassociatedEPSPs=APassociatedEPSPs;
    set(handles.checkbox6,'Value',1);
    n=size(APassociatedEPSPs.events,1);
    set(handles.edit16,'String', num2str(n));
end




if exist('finalizedEPSPs')
    handles.handSelectedEPSPs=finalizedEPSPs;
end

guidata(hObject, handles);




% Update handles structure
% UIWAIT makes FindEPSPs_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FindEPSPs_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% DELETE BUTTON:  Deletes all EPSPs, starts over!
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



choice = questdlg('Do you really want to delete all EPSPs and quit?  Please back up the analysis file if you are unsure.', ...
    'Delete warning','Yes, delete all','No','No')


if strcmp('Yes, delete all',choice)
    
    display('Loading data...')
    load(handles.savefile,'autoDetectedEPSPs','handSelectedEPSPs','checkedEPSPData', 'APassociatedEPSPs','finalizedEPSPs')
    display('Done loading data.')
    finalizedEPSPs.events=[];
    handSelectedEPSPs.NewEvents=[];
    autoDetectedEPSPs.events=[];
    checkedEPSPData.goods=[];
    APassociatedEPSPs.events=[];
    save(handles.savefile,'APassociatedEPSPs','autoDetectedEPSPs','handSelectedEPSPs','checkedEPSPData', 'APassociatedEPSPs','finalizedEPSPs','-append')
    close(handles.figure1);
    display('EPSPs deleted')
    
end
% QUIT!!!
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)


% Add EPSPs by hand
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


startpoint=str2double(get(handles.edit17,'String'))


window=str2double(get(handles.edit11,'String'))
OldEvents=[];
events=[];
try
    
    load(handles.savefile,'handSelectedEPSPs');
    OldEvents=handSelectedEPSPs.NewEvents;
    goods=handles.checkedEPSPData.goods;
    goods=find(goods);
    events=handles.autoDetectedEPSPs.events(goods,:);
    
catch
end
checkEvents=get(handles.checkbox9,'Value');

eegMult=str2double(get(handles.edit18,'String'));
AddEPSPs_gui(handles.preprocessedData.pV,events,handles.ppms,handles.savefile,window, OldEvents,startpoint,handles.EEG,checkEvents,eegMult,handles.L,handles.W)
load(handles.savefile,'handSelectedEPSPs');
handles.handSelectedEPSPs=handSelectedEPSPs;
n=size(handSelectedEPSPs.NewEvents,1);
set(handles.edit15,'String', num2str(n));
set(handles.checkbox5,'Value', 1);
guidata(hObject, handles);


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%check automatically extracted EPSPs
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
window=str2double(get(handles.edit12,'String'))
CheckEvents_gui(handles.preprocessedData.pV,handles.autoDetectedEPSPs.events,handles.ppms,handles.savefile,window)




function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% 1. DATA PREPROCESSING
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get raw voltage and ppms
V=handles.V;
ppms=handles.ppms;
%make time vector in ms
time=[1:numel(V)]'/ppms;



%filter the data?
filterOn=get(handles.checkbox1,'value')

%get filter bandpass
minHz=str2double(get(handles.edit4,'String'));
maxHz=str2double(get(handles.edit5,'String'));


multiplier=str2double(get(handles.edit1,'String'))
ds=str2double(get(handles.edit2,'String'))

%1. divide by voltage multiplier
pV=V/multiplier;
try
    eeg=handles.EEG;
catch
end
%2. filter if required
if filterOn
    display('filtering....')
    niqf = ppms*1000/2;
    [b,a] = butter(2,[minHz maxHz]/niqf);
    pV=filtfilt(b,a,pV);
    display('done filtering')
end



spikes=handles.spikes;
spikeV=pV(spikes);



axes(handles.axes1);hold off
plot(handles.axes1,time(ds:ds:end),pV(ds:ds:end),'k');hold on
plot(handles.axes1,spikes/ppms,spikeV,'r.');







try
    if numel(handles.EEG)<numel(time), handles.EEG=[handles.EEG;zeros(numel(time)-numel(handles.EEG),1)];end
    if numel(handles.EEG)>numel(time), handles.EEG=handles.EEG(1:numel(time));end
    plot(handles.axes1,time(ds:ds:end),handles.EEG(ds:ds:end)-1.5,'color',[.6 .6 .6]);hold on
catch
end


if isfield(handles, 'Triggers')
    Triggers=handles.Triggers;
    if isfield(Triggers,'light')
        L=Triggers.light-Triggers.light(1); L=L/max(abs(L));
        
        if numel(L)<numel(time) L=[L;zeros(numel(time)-numel(L),1)];end
        if numel(L)>numel(time) L=L(1:numel(time));end
        
        plot(handles.axes1,time(ds:ds:end),L(ds:ds:end)*3-10)
        handles.L=L;
    end
    
    if isfield(Triggers,'whisker')
        W=Triggers.whisker-Triggers.whisker(1);; W=W/max(abs(W));
        if numel(W)<numel(time) W=[W;zeros(numel(time)-numel(W),1)];end
        if numel(W)>numel(time) W=W(1:numel(time));end
        
        plot(handles.axes1,time(ds:ds:end),W(ds:ds:end)*100-10,'g')
        handles.W=W;
    end
    
end


axes(handles.axes1);xlabel('Time [ms]');ylabel('Vmem [mV]')
xlim([min(time) max(time)]);

%assign new data
preprocessedData={};
preprocessedData.pV=pV;
preprocessedData.minHz=minHz;
preprocessedData.maxHz=maxHz;
preprocessedData.ds=ds;
preprocessedData.multiplier=multiplier;

handles.preprocessedData=preprocessedData;
guidata(hObject, handles);
% to do
display('Saving filtered data...')
display('Filtered data saved.')


%find EPSPs
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pV=handles.preprocessedData.pV;
ds=handles.preprocessedData.ds;
threshold=str2double(get(handles.edit3,'String'))
minMagnitude=str2double(get(handles.edit9,'String'))
maxVoltage=str2double(get(handles.edit8,'String'))
ppms=handles.ppms;
useDV=get(handles.checkbox7,'value'); %do you want to use dV instead of dV2?
[locs peaks]=findIntracellularEPSPs_helper(pV,threshold,ppms,minMagnitude,maxVoltage,handles.spikes,useDV)
set(handles.edit7,'String',num2str(numel(locs)));


%assign new data
autoDetectedEPSPs={};
autoDetectedEPSPs.threshold=threshold;
autoDetectedEPSPs.minMagnitude=minMagnitude;
autoDetectedEPSPs.maxVoltage=maxVoltage;
autoDetectedEPSPs.events=[locs peaks];
handles.autoDetectedEPSPs=autoDetectedEPSPs;

guidata(hObject, handles);
handles

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% save autodetected EPSP data
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


autoDetectedEPSPs=handles.autoDetectedEPSPs;
display('saving detected EPSP data...')
save(handles.savefile,'autoDetectedEPSPs','-append')
display('detected EPSP data saved.')
try
    delete(handles.eventhandle)
catch
end


starts=handles.autoDetectedEPSPs.events(:,1);
startV=handles.preprocessedData.pV(starts);
peaks=handles.autoDetectedEPSPs.events(:,2);
peaksV=handles.preprocessedData.pV(peaks);

eventhandle=plot(handles.axes1,starts/handles.ppms,startV,'co',peaks/handles.ppms,peaksV,'ro')
set(eventhandle, 'linewidth',2);
handles.eventhandle=eventhandle;
set(handles.checkbox3,'Value',1);
set(handles.pushbutton5,'enable','on')
set(handles.pushbutton6,'enable','on')
guidata(hObject, handles);


% save processed data
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

preprocessedData=handles.preprocessedData;
display('saving processed data...')
save(handles.savefile,'preprocessedData','-append')
display('processed data saved.')

set(handles.checkbox2,'Value',1);
set(handles.pushbutton1,'enable','on')
set(handles.pushbutton7,'enable','on')
guidata(hObject, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
range=get(handles.axes1,'xlim')
r=range(2)-range(1);
set(handles.axes1,'xlim',range-r*.6)

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
range=get(handles.axes1,'xlim')
r=range(2)-range(1);
set(handles.axes1,'xlim',range+r*.6)

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ds=str2double(get(handles.edit2,'String'));
dim=numel(handles.V)/handles.ppms;
axes(handles.axes1);xlim([0 dim]);



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load(handles.savefile, 'checkedEPSPData')
goods=checkedEPSPData.goods;

goods=find(goods);

try
    delete(handles.eventhandle)
catch
end
handles.checkedEPSPData=checkedEPSPData;
set(handles.checkbox4,'Value',1);
n=sum(checkedEPSPData.goods);
set(handles.edit13,'String', num2str(n));
guidata(hObject, handles);



starts=handles.autoDetectedEPSPs.events(goods,1);
startV=handles.preprocessedData.pV(starts);
peaks=handles.autoDetectedEPSPs.events(goods,2);
peaksV=handles.preprocessedData.pV(peaks);

eventhandle=plot(handles.axes1,starts/handles.ppms,startV,'co',peaks/handles.ppms,peaksV,'ro')
set(eventhandle, 'linewidth',2);
handles.eventhandle=eventhandle;
guidata(hObject, handles);


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% finalize and combine all EPSPs
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles
goods=handles.checkedEPSPData.goods;goods=find(goods);
events=handles.autoDetectedEPSPs.events(goods,:);
load(handles.savefile,'handSelectedEPSPs')
NewEvents=handSelectedEPSPs.NewEvents;
% ADJUST TO REAL MIN AND MAX;

apevents=[];
load(handles.savefile,'APassociatedEPSPs')



try
    apevents=APassociatedEPSPs.events;
end


events=[events;NewEvents;apevents];

n=size(events,1);
set(handles.edit14,'String', num2str(n));

[B,goods,J] = unique(events(:,1),'first')
events=events(goods,:);

goods=find((events(:,2)-events(:,1))>2);
events=events(goods,:);
events=sortrows(events,1);





    %check events
    starts=events(:,1);ends=events(:,2);
    goods=ones(size(starts));
    ppms=handles.ppms;
for i=1:numel(starts)
    
    indices=find((starts>starts(i)-5*ppms) & starts<(starts(i)+5*ppms))
    for j=indices
        if i~=j
            if starts(i)>starts(j) && starts(i)<starts(j)
                goods(j)=0;
            end
            
            if starts(i)==starts(j) && ends(i)==ends(j)
                goods(i)=0;
            end
            
            eventi=starts(i):ends(i);
            eventj=starts(j):ends(j);          
            if numel(intersect(eventi,eventj))~=0
                if numel(eventi)>numel(eventj)
                    goods(i)=0;
                end
            end
        end 
    end
    if mod(round(i/numel(starts)*100),2)==0
        display(ceil(i/numel(starts)*100))
    end
end
goods=find(goods==1);


v=handles.V;
n=numel(v);
ppms=handles.ppms;
spikes=handles.spikes;
%locs=events(:,1);peaks=events(:,2);
% for jj=1:numel(locs);
%     %window to look for peaks
%     i2=peaks(jj)+0*ppms;
%     sp=find(spikes>locs(jj) & spikes<i2);
%   
%     if isempty(sp)
%         
%         
%         if i2 > n
%             i2=n;
%         end
%         
%         %if event starts are very close together,don't let areas overlap
%         if jj<numel(locs)
%             if i2>locs(jj+1)
%                 i2=locs(jj+1)-1;
%             end
%         end
%         
%         event=v(locs(jj):(i2)); %pull out voltage to look at
%         
%         %     [locs(jj) (i2)]
%         %     numel(event)
%         m1=max(event); %find maximum of event
%         index=find(event==m1);peaks(jj)=index(1)+locs(jj)-1; %find index of max
%     end
% end

%events=[locs peaks];
%events=NewEvents; %THIS IS FOR SAKMANN
ppms=handles.ppms;
v=handles.preprocessedData.pV;
dim=size(events);dim=dim(1);
rtime=[];hwidth=[];
mags=v(events(:,2))-v(events(:,1));
for ii=1:dim
    if events(ii,1)<events(ii,2)
        v1=v(events(ii,1):events(ii,2));
        v1=v1-v1(1);
        mag=v1(end)-v1(1);
        v10=mag*.1;
        v90=mag*.9;
        v50=mag*.50;
        d=abs(v1-v10);
        index10=find(d==min(d));index10=index10(1);
        d=abs(v1-v90);
        index90=find(d==min(d));index90=index90(1);
        d=abs(v1-v50);
        index50=find(d==min(d));index50=index50(1);
        rtime(ii)=(index90-index10)/ppms;
        hwidth(ii)=index50/ppms;
    end
end


goods=find(rtime>0 & mags'>.15);
mags=mags(goods);rtime=rtime(goods);
events=events(goods,:);
vstart=handles.V(events(:,1))/handles.preprocessedData.multiplier;
finalizedEPSPs.events=events;
finalizedEPSPs.mags=mags;
finalizedEPSPs.rtime=rtime;
finalizedEPSPs.vstart=vstart;
finalizedEPSPs.intervals=[events(1,1);diff(events(:,1))];
finalizedEPSPs.LatType='';

handles.finalizedEPSPs=finalizedEPSPs;
guidata(hObject, handles);

try
    delete(handles.eventhandle)
catch
end


starts=events(:,1);
startV=handles.preprocessedData.pV(starts);
peaks=events(:,2);
peaksV=handles.preprocessedData.pV(peaks);
eventhandle=plot(handles.axes1,starts/handles.ppms,startV,'co',peaks/handles.ppms,peaksV,'ro')
set(eventhandle, 'linewidth',2);
handles.eventhandle=eventhandle;



%calculate latencies
onset1=[];
onset2=[]

LatType=[];
if get(handles.checkbox11,'value')==1
    LatType='W'
    W=handles.Triggers.whisker;
    if min(W)<-100
        W=W*-1;
    end
    W=W/max(W);
    D=[0;diff(W)];
    onset1=find(D>.5);
    d=[10000; diff(onset1)];
    onset1=onset1(find(d>1000));
end

if get(handles.checkbox10,'value')==1
    LatType='l'
    
    L=handles.Triggers.light;
    L=L-L(1);
    L=L/max(L);
    D=[0;diff(L)];
    onset2=find(D>.5)
    d=[10000; diff(onset2)];
    onset2=onset2(find(d>1000));
end




trigTime=[onset1;onset2];
e1=finalizedEPSPs.events(:,1);
Lat=[];

if ~isempty(trigTime)
    for i=1:numel(e1)
        thisevent=e1(i);
        t=trigTime(find(trigTime<thisevent));
        t=t(end);
        Lat(i)=thisevent-t;
    end
end
handles.finalizedEPSPs.Lat=Lat/ppms
handles.finalizedEPSPs.LatType=LatType;
guidata(hObject, handles);
finalizedEPSPs=handles.finalizedEPSPs

save(handles.savefile,'finalizedEPSPs','-append')
Lat/ppms
size(onset1)
size(onset2)



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ppms=handles.ppms;
triggers=handles.spikes;
isis=[triggers(1) diff(triggers)];
indices=find(isis>(ppms*20));
triggers=triggers(indices);


goods=handles.checkedEPSPData.goods;goods=find(goods);
events=handles.autoDetectedEPSPs.events(goods,:);
load(handles.savefile,'handSelectedEPSPs')
NewEvents=handSelectedEPSPs.NewEvents;
events=[events;NewEvents];
events=sortrows(events,1);


v=handles.preprocessedData.pV;
dv=[0;diff(v)];
dv2=[0;diff(dv)];
timeBefore=-20*ppms,timeAfter=10*ppms
spV=triggeredSegments(v,triggers-ppms,timeBefore, timeAfter);
spdV=triggeredSegments(dv,triggers-ppms,timeBefore, timeAfter);
spdV2=triggeredSegments(dv2,triggers-ppms,timeBefore, timeAfter);
bistarts=zeros(size(v));bistarts(events(:,1))=1;
biends=zeros(size(v));biends(events(:,2))=1;
trigStart=triggeredSegments(bistarts,triggers-ppms,timeBefore, timeAfter);
trigEnd=triggeredSegments(biends,triggers-ppms,timeBefore, timeAfter);

n=numel(v);
figure
newEvents=[];
for i=(size(newEvents,1)+1):numel(triggers)
    
    
    
    
    plot(spV(:,i));
    hold on
    
    plot(spdV(:,i)*7,'g','linewidth',2)
    starts=find(trigStart(:,i)==1);
    ends=find(trigEnd(:,i)==1);
    hold on
    
    if ~isempty(starts)
        plot(starts,spV(starts,i),'co');
    end
    if ~isempty(ends)
        plot(ends,spV(ends,i),'ro');
    end
    
    %plot(index1,spV(index1,i),'ro')
    title(round(i/numel(triggers)*1000)/10)
    hold off
    
    
    [x y]=ginput
    if mod(numel(x),2)
        
        [x y]=ginput
    end
    
    if mod(numel(x),2)
        
        [x y]=ginput
    end
    
    if mod(numel(x),2)
        
        [x y]=ginput
    end
    
    
    if isempty(x)
        newEvents=[newEvents;[nan nan]]
    else
        
        temp=[round(x(1:2:end)) round(x(2:2:end))]+triggers(i)+timeBefore-ppms;
        newEvents=[newEvents;temp];
    end
    
    handles.apEventsTemp=newEvents;
    guidata(hObject, handles);
end



goods=find(isfinite(newEvents(:,1)));
events=newEvents(goods,:);
APassociatedEPSPs={};
APassociatedEPSPs.events=events;
handles.APassociatedEPSPs=APassociatedEPSPs;
n=size(events,1);
set(handles.edit16,'String', num2str(n));



save(handles.savefile,'APassociatedEPSPs', '-append')
guidata(hObject, handles);


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






h=CheckClusters_gui(handles.finalizedEPSPs.mags,handles.finalizedEPSPs.rtime,handles.finalizedEPSPs.vstart,...
    [handles.savedir handles.savefile],handles.finalizedEPSPs.Lat,handles.finalizedEPSPs.LatType)
uiwait(h)



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% take snapshot
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newsnapshot = round(get(handles.axes1,'xlim'))
time=[1:numel(handles.V)]'/handles.ppms;
i1=round(newsnapshot(1)*handles.ppms);
i2=round(newsnapshot(2)*handles.ppms);

f=figure

v=handles.V(i1:i2)/handles.preprocessedData.multiplier;
m1=min(v)-5;
m2=max(v)+5;
plot(time(i1:i2),v,'k');
title([handles.savefile ' Example Trace t= ' num2str(newsnapshot(1)) ':' num2str(newsnapshot(2)) ' ms'])
xlabel ms
ylabel mV
axis tight
ylim([m1 m2])

x1=newsnapshot(1)+5; x2=x1+50;
hold on
plot([x1 x2],[m1+2 m1+2],'k','linewidth',2)
text(x1, m1+3.5, '50 ms' )
text(x1,m2-2,handles.savedir)
set(gcf, 'PaperPositionmode', 'auto')
ExampleName=[handles.savefile '_' num2str(newsnapshot(1)) '_' num2str(newsnapshot(1))];
print(f,ExampleName,'-dpdf')


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11
