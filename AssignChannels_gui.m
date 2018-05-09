function varargout = AssignChannels_gui(varargin)
% ASSIGNCHANNELS_GUI MATLAB code for AssignChannels_gui.fig
%      ASSIGNCHANNELS_GUI, by itself, creates a new ASSIGNCHANNELS_GUI or raises the existing
%      singleton*.
%
%      H = ASSIGNCHANNELS_GUI returns the handle to a new ASSIGNCHANNELS_GUI or the handle to
%      the existing singleton*.
%
%      ASSIGNCHANNELS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASSIGNCHANNELS_GUI.M with the given input arguments.
%
%      ASSIGNCHANNELS_GUI('Property','Value',...) creates a new ASSIGNCHANNELS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AssignChannels_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AssignChannels_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AssignChannels_gui

% Last Modified by GUIDE v2.5 23-May-2013 18:30:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AssignChannels_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @AssignChannels_gui_OutputFcn, ...
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


% --- Executes just before AssignChannels_gui is made visible.
function AssignChannels_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AssignChannels_gui (see VARARGIN)

% Choose default command line output for AssignChannels_gui
handles.output = hObject;
handles.channelNames=varargin{1};
handles.headerNames=varargin{2};
handles.lastKnownAssignments=varargin{3};
handles.lastKnownAssignments=handles.lastKnownAssignments.DATA(:,3  );
DATA=cell(numel(handles.channelNames),3);
handles.channelNames


for i=1:numel(handles.channelNames)
    DATA{i,1}=handles.channelNames{i};
    DATA{i,2}=handles.headerNames{i};
    %DATA{i,3}=handles.lastKnownAssignments{i,3};
    DATA{i,3}='';
end


set(handles.uitable3,'data',DATA);



% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1)

% UIWAIT makes AssignChannels_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AssignChannels_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.uitable3,'data');
varargout{2}=  get(handles.edit1,'String');
varargout{3}=  handles.LFP;
close(handles.figure1);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.checkbox2,'value')
    handles.LFP=get(handles.edit2,'String');
else
    handles.LFP=[];
end

guidata(hObject, handles);
uiresume(handles.figure1)


% Update handles structure


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

DATA=get(handles.uitable3,'data');
lka=handles.lastKnownAssignments;
for i=1:numel(lka)
DATA{i,3}=lka{i};
end
set(handles.uitable3,'data',DATA);
guidata(hObject, handles);



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


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



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
