function varargout = findSpikes_gui(varargin)
% FINDSPIKES_GUI M-file for findSpikes_gui.fig
%      FINDSPIKES_GUI, by itself, creates a new FINDSPIKES_GUI or raises the existing
%      singleton*.
%
%      H = FINDSPIKES_GUI returns the handle to a new FINDSPIKES_GUI or the handle to
%      the existing singleton*.
%
%      FINDSPIKES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDSPIKES_GUI.M with the given input arguments.
%
%      FINDSPIKES_GUI('Property','Value',...) creates a new FINDSPIKES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findSpikes_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findSpikes_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findSpikes_gui

% Last Modified by GUIDE v2.5 18-Jan-2011 12:46:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @findSpikes_gui_OpeningFcn, ...
    'gui_OutputFcn',  @findSpikes_gui_OutputFcn, ...
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


% --- Executes just before findSpikes_gui is made visible.
function findSpikes_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findSpikes_gui (see VARARGIN)

% Choose default command line output for findSpikes_gui
handles.output = hObject;
%GET SPIKE DATA, PPMS, SAVEFILE
handles.DATA=varargin{1};

handles.PPMS=1/handles.DATA.header.sampleinterval*1000;
%CALCULATE TIMEBASE IN MS
handles.TIME=[1:numel(handles.DATA.data)]/handles.PPMS;
handles.TMAX=max(handles.TIME);
handles.SPIKES=[];
handles.SAVEFILE=[varargin{2} '.mat'];
handles.dual=varargin{3};


set(handles.text5,'string',handles.SAVEFILE)
get(handles.axes1)%,

axes(handles.axes4);xlabel('normalized threshold');ylabel('spike count');
axes(handles.axes5);xlabel('log_1_0 ISI (ms)');ylabel('P(ISI)');title('ISI distribution');
% Update handles structure
guidata(hObject, handles);

% if -min(handles.DATA.data)>max(handles.DATA.data),handles.DATA.data=-handles.DATA.data;end
% guidata(hObject, handles);

plotdata_gui(hObject, eventdata, handles)
% UIWAIT makes findSpikes_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function plotdata_gui(hObject, eventdata, handles)

%PLOT RAW DATA
DOWN=str2double(get(handles.edit5,'String'));
XMIN=str2double(get(handles.edit6,'String'));
XMAX=str2double(get(handles.edit7,'String'));
indices=find(handles.TIME>(handles.TMAX*XMIN) & (handles.TIME)<handles.TMAX*XMAX);
indices=indices(1:DOWN:end);
time=handles.TIME(indices);
data=handles.DATA.data(indices); 
plot(handles.axes1,time,data,'k');
axes(handles.axes1);xlabel('Time [ms]');title('Data and spike times')
xlim([min(time) max(time)]);

% --- Outputs from this function are returned to the command line.
function varargout = findSpikes_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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

%CALCULATES SPIKE TIMES
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotdata_gui(hObject, eventdata, handles)
hold(handles.axes1,'on')
display('finding spike times...')
%if ~isempty(handles.SPIKEPLOT),delete(handles.SPIKEPLOT),display('deleted');end
THRESH=str2double(get(handles.edit2,'String'));
DOWN=str2double(get(handles.edit5,'String'));
MINISI=str2double(get(handles.edit1,'string'))
SPIKES=getspikes_for_gui(handles.DATA.data,THRESH,MINISI*handles.PPMS); %INDICES!
ISIS=diff(SPIKES/handles.PPMS);
plot(handles.axes1,handles.TIME(SPIKES),handles.DATA.data(SPIKES),'r.')
handles.SPIKES=SPIKES;
hold(handles.axes1,'off')
axes(handles.axes1);xlabel('Time [ms]');title('Data and spike times')

handles.THRESH=THRESH;
handles.MINISI=MINISI;


h = waitbar(0,'Please wait...');
dTh=[-.5:.1:.5];
nsp=zeros(size(dTh));
for i=1:numel(dTh)
    thresh=THRESH+dTh(i)*THRESH;
    sp=getspikes_for_gui(handles.DATA.data,thresh,MINISI*handles.PPMS); %INDICES!
    nsp(i)=numel(sp);
    txt=['Calculating spike times for threshold '  num2str(thresh) '...'];
    % computation here %
    waitbar(i/numel(dTh),h, txt)
    
end
close(h)
plot(handles.axes4, THRESH+dTh*THRESH,nsp,'.-',THRESH,numel(SPIKES),'r*','markersize',20);
axis(handles.axes4, 'tight')
axes(handles.axes4);xlabel('normalized threshold');ylabel('spike count');
set(gca,'fontsize',8)
BINSIZE=str2double(get(handles.edit4,'String'));
BINS=[0:BINSIZE:max(ISIS)];
[isish]=hist(ISIS,BINS);
axes(handles.axes5)
p=semilogx(BINS,isish/numel(ISIS)); set(p,'linewidth',2);
axes(handles.axes5);xlabel('ISI (ms)');ylabel('P(ISI)');title('ISI distribution');
set(gca,'fontsize',8);
set(gca,'xtick',10.^[0:5])
%SAVES SPIKE TIMES AND CONTINUES
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

spikeFindingData={};
THRESH=str2double(get(handles.edit2,'String'));
MINISI=str2double(get(handles.edit1,'string'));
SPIKES=getspikes_for_gui(handles.DATA.data,THRESH,MINISI*handles.PPMS); %INDICES!
spikeFindingData.thresh=THRESH;
spikeFindingData.minISI=MINISI;
spikeFindingData.spikes=SPIKES;
spikeFindingData.ppms=handles.PPMS;
spikeFindingData.timestamp=clock;

if handles.dual
    spikeFindingData2=spikeFindingData;
    save(handles.SAVEFILE,'spikeFindingData2','-append')
    display(['Spike times, threshold, and minimum ISI saved to ' handles.SAVEFILE '.'])
else
    save(handles.SAVEFILE,'spikeFindingData','-append')
    display(['Spike times, threshold, and minimum ISI saved to ' handles.SAVEFILE '.'])
end
    
    
close(gcf)
%QUITS
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf)
display('Quit gui')

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
