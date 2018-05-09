function varargout = UDS_gui(varargin)
% UDS_GUI MATLAB code for UDS_gui.fig
%      UDS_GUI, by itself, creates a new UDS_GUI or raises the existing
%      singleton*.
%
%      H = UDS_GUI returns the handle to a new UDS_GUI or the handle to
%      the existing singleton*.
%
%      UDS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UDS_GUI.M with the given input arguments.
%
%      UDS_GUI('Property','Value',...) creates a new UDS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UDS_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UDS_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UDS_gui

% Last Modified by GUIDE v2.5 29-Apr-2013 12:50:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @UDS_gui_OpeningFcn, ...
    'gui_OutputFcn',  @UDS_gui_OutputFcn, ...
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


% --- Executes just before UDS_gui is made visible.
function UDS_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UDS_gui (see VARARGIN)

% Choose default command line output for UDS_gui
handles.output = hObject;

handles.EEG=varargin{1};
%handles.V=varargin{2};
handles.ppms=varargin{2};
handles.savedir=varargin{3}
handles.name=varargin{4};


display('filtering....')
niqf = varargin{2}*1000/2;
[b,a] = butter(2,[.25 1000]/niqf);



handles.filtEEG=filtfilt(b,a,varargin{1});
% Update handles structure
guidata(hObject, handles);
handles.name
set(handles.text21,'String',handles.name);

% if it has been run before, load previous data
try
    load([handles.savedir handles.name],'upT','downT','udsParameters')
    
    
    lf_pfs=udsParameters.lf_pfts;
    hf_pfs=udsParameters.hf_pfs;
    dsf=udsParameters.dsf;
    bb_cf=udsParameters.bb_cf;
    useHF=udsParameters.useHF;
    
    
    set(handles.radiobutton4,'value',useHF)
    if ~useHF,    set(handles.radiobutton5,'value',1)
    end
    set(handles.edit3,'String',num2str(dsf))
    set(handles.edit8,'String',num2str(lf_pfs(1)));
    set(handles.edit10,'String',num2str(lf_pfs(2)));
    
    set(handles.edit9,'String',num2str(hf_pfs(1)));
    set(handles.edit11,'String',num2str(hf_pfs(2)));
    
    set(handles.edit12,'String',num2str(bb_cf(1)));
    set(handles.edit13,'String',num2str(bb_cf(2)));
    
    set(handles.checkbox3,'value',1);
    
    handles.upT=upT;
    handles.downT=downT;
    
catch
end
handles
guidata(hObject, handles);
% UIWAIT makes UDS_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UDS_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% find UDS states
% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

upT=handles.upT;
downT=handles.downT;
udsParameters=handles.udsParameters;
save([handles.savedir handles.name],'upT','downT','udsParameters','-append')
close(handles.figure1)
display('Data saved')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1)
display('Quit UDS analysis!')

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ppms=handles.ppms
timeBefore=100*ppms;
timeAfter=900*ppms;

upTrig=handles.upT;
downTrig=handles.downT;

upTrig=upTrig(find(upTrig>timeBefore & upTrig< numel(handles.EEG)-timeAfter));

downTrig=downTrig(find(downTrig>timeBefore & downTrig< numel(handles.EEG)-timeAfter));

t=[-timeBefore:timeAfter]/ppms/1000;
uptrig_EEG=TriggeredSegments(handles.filtEEG,upTrig,-timeBefore, timeAfter);
downtrig_EEG=TriggeredSegments(handles.filtEEG,downTrig,-timeBefore, timeAfter);

axes(handles.axes1);
hold off
plot(handles.axes1,t,uptrig_EEG,'color',[.7 .7 .7]);hold on
plot(handles.axes1,t,mean(uptrig_EEG'),'linewidth',2)
xlim([min(t) max(t)])

axes(handles.axes2);
hold off
plot(handles.axes2,t,downtrig_EEG,'color',[.7 .7 .7]);hold on
plot(handles.axes2,t,mean(downtrig_EEG'),'r','linewidth',2)
xlim([min(t) max(t)])

downT=handles.downT;
upT=handles.upT;


downT=downT(find(downT>min(upT)));
upT=upT(find(upT<max(downT)));
ends=[];
durUp=zeros(size(upT));
for i=1:numel(upT);
    match=find(downT>upT(i));
    durUp(i)=downT(match(1))-upT(i);
end

durUp=durUp/handles.ppms;

[h bins]=hist(durUp,50)
bar(handles.axes5,bins,h,1);


durDown=zeros(size(downT));
for i=1:numel(downT)-1;
    match=find(upT>downT(i));
    durDown(i)=upT(match(1))-downT(i);
end

durDown=durDown/handles.ppms;

[h bins]=hist(durDown,50)

bar(handles.axes6,bins,h,1,'r');




% FIND TRANSITIONS;
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% run for small number if testing is desired.
if get(handles.checkbox1,'value')
    T=2000000;
else
    T=numel(handles.EEG);
end



useHF=get(handles.radiobutton4,'value')
dsf=str2double(get(handles.edit3,'String'));
lf_pfs=[str2double(get(handles.edit8,'String')) str2double(get(handles.edit10,'String'))];
hf_pfs=[str2double(get(handles.edit9,'String')) str2double(get(handles.edit11,'String'))];
bb_cf=[str2double(get(handles.edit12,'String')) str2double(get(handles.edit13,'String'))];

[upT downT]=UDS_helper(handles.EEG(1:T),handles.ppms,dsf,lf_pfs,hf_pfs,bb_cf,useHF);


udsParameters={};
udsParameters.lf_pfts=lf_pfs;
udsParameters.hf_pfs=hf_pfs;
udsParameters.hf_pfs=hf_pfs;
udsParameters.bb_cf=bb_cf;
udsParameters.useHF=useHF;
udsParameters.dsf=dsf;

udsParameters.timeStamp=now;

handles.upT=upT*dsf;
handles.downT=downT*dsf;
handles.udsParameters=udsParameters;
set(handles.checkbox3,'value',1);
guidata(hObject, handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



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


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4



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


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



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
