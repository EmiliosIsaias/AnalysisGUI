function varargout = findTriggers_gui(varargin)
% FINDTRIGGERS_GUI M-file for findTriggers_gui.fig
%      FINDTRIGGERS_GUI, by itself, creates a new FINDTRIGGERS_GUI or raises the existing
%      singleton*.
%
%      H = FINDTRIGGERS_GUI returns the handle to a new FINDTRIGGERS_GUI or the handle to
%      the existing singleton*.
%
%      FINDTRIGGERS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDTRIGGERS_GUI.M with the given input arguments.
%
%      FINDTRIGGERS_GUI('Property','Value',...) creates a new FINDTRIGGERS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findTriggers_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findTriggers_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findTriggers_gui

% Last Modified by GUIDE v2.5 25-Jan-2018 09:17:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @findTriggers_gui_OpeningFcn, ...
    'gui_OutputFcn',  @findTriggers_gui_OutputFcn, ...
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


% --- Executes just before findTriggers_gui is made visible.
function findTriggers_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findTriggers_gui (see VARARGIN)

% Choose default command line output for findTriggers_gui
handles.output = hObject;
%GET SPIKE DATA, PPMS, SAVEFILE
handles.TRIGGERS=varargin{1};
temp=varargin{2};
handles.PPMS=temp.ppms;
%CALCULATE TIMEBASE IN MS
handles.SAVEFILE=[varargin{3} '.mat'];
%PLOT RAW DATA


if ~isfield(handles.TRIGGERS, 'light') 
    
    handles.TRIGGERS.light=zeros(size(handles.TRIGGERS.whisker));
end

if ~isfield(handles.TRIGGERS, 'whisker') 
    handles.TRIGGERS.whisker=zeros(size(handles.TRIGGERS.light));
end

handles.TIME=[1:numel(handles.TRIGGERS.light)]/handles.PPMS;


try
n=round(numel(handles.TRIGGERS.light)/5);
catch
end

try
n=round(numel(handles.TRIGGERS.whisker)/5);
catch
end




plot(handles.axes1,handles.TIME(1:n)/1000,handles.TRIGGERS.light(1:n),'b',handles.TIME(1:n)/1000,handles.TRIGGERS.whisker(1:n),'g');
axes(handles.axes1);xlabel('Time [s]');title('Whisker and light triggers');
legend('light','whisker');legend boxoff;
set(handles.text5,'string',handles.SAVEFILE);


minStimDistance=50;aboveZero=.05;



tL=[];
tW=[];
if isfield(handles.TRIGGERS, 'light') 
tL=getTriggersNew(handles.TRIGGERS.light,minStimDistance,aboveZero);
tL=tL(1:(numel(tL)-1));
handles.tL=tL;
end

if isfield(handles.TRIGGERS, 'whisker') 
tW=getTriggersNew(handles.TRIGGERS.whisker,minStimDistance,aboveZero);
tW=tW(1:(numel(tW)-1));
handles.tW=tW;
end


hold(handles.axes1,'on');
plot(tL(tL<n)/handles.PPMS/1000,handles.TRIGGERS.light(tL(tL<n)),'o');
plot(tW(tW<n)/handles.PPMS/1000,handles.TRIGGERS.whisker(tW(tW<n)),'go');
l=legend('L','W','Lt','Wt');
box off;
axis tight;
set(l,'location','northoutside','Orientation','horizontal');
set(gca,'ytick',[]);





% Update handles structure
guidata(hObject, handles);

% UIWAIT makes findTriggers_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = findTriggers_gui_OutputFcn(hObject, eventdata, handles)
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

%CALCULATES TRIGGER TIMES
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stimtype=[];
tW=handles.tW;
tL=handles.tL;

include=get(handles.edit17,'string');
eval(['tW=tW(' include ');'])
include=get(handles.edit18,'string');
eval(['tL=tL(' include ');']);

args={};
if get(handles.radiobutton1,'value')
    stimtype='L';
elseif get(handles.radiobutton2,'value')
    stimtype='W';
elseif get(handles.radiobutton3,'value')
    stimtype='Paired';
elseif get(handles.radiobutton4,'value')
     stimtype='Lag';
     args{1}=str2double(get(handles.edit12,'string'))*handles.PPMS;
elseif get(handles.radiobutton6,'value')
    stimtype='Custom';
    args{1}=str2double(get(handles.edit10,'string'));
    args{2}=str2double(get(handles.edit16,'string'));
elseif get(handles.radiobutton9,'value')
    stimtype='Frequency';
    % Create a function that can be used by the findTriggers_helper
    [fm,cf,tL,tW] = findStimulConditions(handles.TRIGGERS.light,...
        handles.TRIGGERS.whisker);
    args{1} = fm;
    args{2} = cf;
end
Conditions=findTriggers_helper(tL,tW,handles.PPMS,stimtype,args{:});


if get(handles.checkbox6,'value')
    [ff, Conditions]=segregateRepeats(Conditions);
    uiwait(ff);
end

names={};
for i=1:numel(Conditions)
    Conditions{i}
    names{i}=Conditions{i}.name;
end
set(handles.edit13,'string',names');
handles.CONDITIONS=Conditions;
guidata(hObject, handles);

Triggers=handles.TRIGGERS;
dim=ceil(sqrt(numel(Conditions)));

% plot, if option is selected

if get(handles.checkbox7,'value')
    fig=figure;
    for i=1:numel(Conditions)
        subplot(dim, dim,i);
   
        trig=Conditions{i}.Triggers;
        l=[];
        w=[];
    
        BeforeTrig=str2double(get(handles.edit14,'string'))*handles.PPMS;
        AfterTrig=str2double(get(handles.edit15,'string'))*handles.PPMS;
        
        BeforeTrig=round(BeforeTrig);
        AfterTrig=round(AfterTrig);
            t=[-BeforeTrig:AfterTrig]/handles.PPMS;
            if get(handles.radiobutton9,'value')
                for j=1:numel(trig)
                    l=[l Triggers.light((trig(j)-BeforeTrig):(trig(j)+AfterTrig))];
                end
                w = Triggers.whisker((trig(1)-BeforeTrig):(trig(1)+AfterTrig));
            else
                for j=1:numel(trig)
                    l=[l Triggers.light((trig(j)-BeforeTrig):(trig(j)+AfterTrig))];
                    w=[w Triggers.whisker((trig(j)-BeforeTrig):(trig(j)+AfterTrig))];
                end
            end

        plot(l,'b');
     
        aa=plot(t,l);hold on;set(aa,'color','b','linewidth',2);
        a=plot(t,w);hold on; set(a,'color','g','linewidth',2);
        xlabel('ms');
        set(gca,'ytick',[]);
        if get(handles.radiobutton9,'value')
            title([Conditions{i}.name ': n=' num2str(cf(i))]);
        else
            title([Conditions{i}.name ': n=' num2str(numel(trig))]);
        end
    end
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
Conditions=handles.CONDITIONS;
    save(handles.SAVEFILE,'Conditions','-append');
    display(['Conditions and trigger times save to ' handles.SAVEFILE '.']);
    close(gcf);
catch
    display('Conditions not saved. Recalculate and save, or press quit.');
end



%QUITS
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(gcf);
display('Quit gui');

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


% --- Executes on selection change in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns checkbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from checkbox2


% --- Executes on key press with focus on checkbox2 and none of its controls.
function checkbox2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6



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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure wit
Conditions=handles.CONDITIONS;
names=get(handles.edit13,'string');

for i=1:numel(Conditions)
    Conditions{i}.name=names{i};
end

handles.CONDITIONS=Conditions;
guidata(hObject, handles);
display('Stimulation conditions have been renamed:')
for i=1:numel(Conditions)
    display(Conditions{i}.name);
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



hold(handles.axes1,'off');

n=round(numel(handles.TRIGGERS.light)/5);
plot(handles.axes1,handles.TIME(1:n)/1000,handles.TRIGGERS.light(1:n),'b',handles.TIME(1:n)/1000,handles.TRIGGERS.whisker(1:n),'g');
axes(handles.axes1);xlabel('Time [s]');title('Whisker and light triggers');
legend('light','whisker');legend boxoff;

set(handles.text5,'string',handles.SAVEFILE);


minStimDistance=str2double(get(handles.edit5,'string'));aboveZero=str2double(get(handles.edit6,'string'));
tL=getTriggersNew(handles.TRIGGERS.light,minStimDistance,aboveZero);
tW=getTriggersNew(handles.TRIGGERS.whisker,minStimDistance,aboveZero);
handles.tL=tL;
handles.tW=tW;

guidata(hObject, handles);
hold(handles.axes1,'on');
plot(tL(tL<n)/handles.PPMS/1000,handles.TRIGGERS.light(tL(tL<n)),'o');
plot(tW(tW<n)/handles.PPMS/1000,handles.TRIGGERS.whisker(tW(tW<n)),'go');
l=legend('L','W','Lt','Wt');
box off;
axis tight;
set(l,'location','northoutside','Orientation','horizontal');
set(gca,'ytick',[]);


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7



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


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
