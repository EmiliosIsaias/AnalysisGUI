function varargout = findSpikeGUI(varargin)
% FINDSPIKEGUI M-file for findSpikeGUI.fig
%      FINDSPIKEGUI, by itself, creates a new FINDSPIKEGUI or raises the existing
%      singleton*.
%
%      H = FINDSPIKEGUI returns the handle to a new FINDSPIKEGUI or the handle to
%      the existing singleton*.
%
%      FINDSPIKEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDSPIKEGUI.M with the given input arguments.
%
%      FINDSPIKEGUI('Property','Value',...) creates a new FINDSPIKEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findSpikeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findSpikeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findSpikeGUI

% Last Modified by GUIDE v2.5 02-Dec-2010 18:06:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @findSpikeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @findSpikeGUI_OutputFcn, ...
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


% --- Executes just before findSpikeGUI is made visible.
function findSpikeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findSpikeGUI (see VARARGIN)

% Choose default command line output for findSpikeGUI

handles.output = hObject;
plot(handles.axes1,DATA.data)
set(handles.edit1,'string',.5)
set(handles.edit3,'string',1)
set(handles.text1,'string','Threshold for spike detection')
set(handles.text2,'string','Minimum interspike interval [ms]')
handles.DATA=varargin{1};
handles.SPIKES=[];
handles.saveFile{2};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes findSpikeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = findSpikeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
 %hObject    handle to pushbutton1 (see GCBO)
 %eventdata  reserved - to be defined in a future version of MATLAB
 %handles    structure with handles and user data (see GUIDATA)
 
 THRESH=str2double(get(handles.edit1,'String'));
 MINISI=str2double(get(handles.edit3,'string'));
 spikes=getspikes(DATA.data,thresh,MINISI*20); %INDICES!
 
 dTh=[-.5:.1:.5];
% nsp=zeros(size(dTh));
% for i=1:numel(dTh)
%     thresh=THRESH+dTh(i)*THRESH;
%     sp=getspikes(DATA.data,thresh,MINISI*20); %INDICES!
%     nsp(i)=numel(sp);
% end
% 
% plot(handles.axes2, dTh,nsp,'.-');



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display('Spike finding cancelled, no spike times save to data file.')
close(handles.figure1);

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
