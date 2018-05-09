function varargout = CheckClusters_gui(varargin)
% CHECKCLUSTERS_GUI MATLAB code for CheckClusters_gui.fig
%      CHECKCLUSTERS_GUI, by itself, creates a new CHECKCLUSTERS_GUI or raises the existing
%      singleton*.
%
%      H = CHECKCLUSTERS_GUI returns the handle to a new CHECKCLUSTERS_GUI or the handle to
%      the existing singleton*.
%
%      CHECKCLUSTERS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECKCLUSTERS_GUI.M with the given input arguments.
%
%      CHECKCLUSTERS_GUI('Property','Value',...) creates a new CHECKCLUSTERS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CheckClusters_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CheckClusters_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CheckClusters_gui

% Last Modified by GUIDE v2.5 05-Aug-2013 15:03:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CheckClusters_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @CheckClusters_gui_OutputFcn, ...
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


% --- Executes just before CheckClusters_gui is made visible.
function CheckClusters_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CheckClusters_gui (see VARARGIN)

% Choose default command line output for CheckClusters_gui
handles.output = hObject;


handles.mags=varargin{1};
handles.rtime=varargin{2};
handles.vstart=varargin{3};
handles.savefile=varargin{4};
handles.Lat=varargin{5}';
handles.LatType=varargin{6}';
guidata(hObject, handles);
guidata(hObject, handles);
axes(handles.axes1)
s=scatter(handles.mags, handles.rtime,10,handles.vstart);
set(s,'linewidth',2);
xlim([0 max(handles.mags)*1.1])
ylim([0 max(handles.rtime)*1.1])
title(handles.savefile)
ylabel('rise time [ms]')
xlabel('magnitude [mV]')
brush on
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CheckClusters_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CheckClusters_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
hBrushLine = findall(gca,'tag','Brushing');
brushedData = get(hBrushLine, {'Xdata','Ydata'});
exclude = find(~isnan(brushedData{1}))


save(handles.savefile,'exclude','-append')

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1);
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)


if ~strcmp(get(handles.axes1,'yscale'),'log')
set(handles.axes1,'yscale','log','xscale','log')
else
    set(handles.axes1,'yscale','linear','xscale','linear')
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f=figure
set(0,'DefaultTextInterpreter','none')

minRT=str2double(get(handles.edit1,'String'));
maxRT=str2double(get(handles.edit2,'String'));
minLat=str2double(get(handles.edit3,'String'));
maxLat=str2double(get(handles.edit4,'String'));
minMag=str2double(get(handles.edit5,'String'));
maxMag=str2double(get(handles.edit6,'String'));








name=handles.savefile;
indices=strfind(name,'\');
name=name(indices(end-2):end);
name=name(setdiff(1:numel(name),strfind(name,'\')));
if isempty(handles.Lat)
subplot(2,1,1)
goods=find(handles.mags>minMag & handles.mags<maxMag...
           & handles.rtime' > minRT & handles.rtime'<maxRT);
       
  ExcelOutput=[handles.mags(goods) handles.rtime(goods)'];
  excelname=name;
else
subplot(2,2,1)

goods=find(handles.mags > minMag & handles.mags < maxMag...
           & handles.rtime' > minRT & handles.rtime'<maxRT...
            & handles.Lat > minLat & handles.Lat<maxLat);
ExcelOutput=[handles.mags(goods) handles.rtime(goods)' handles.Lat(goods)];
excelname=[name handles.LatType];
end

save(handles.savefile,'minRT', 'maxRT', 'minLat', 'maxLat', 'minMag', 'maxMag', 'goods', 'ExcelOutput', '-append')

s=scatter(handles.mags(goods), handles.rtime(goods),25,handles.vstart(goods));
colorbar
set(s,'linewidth',2);
try
xlim([0 max(handles.mags(goods))*1.1])
ylim([0 max(handles.rtime(goods))*1.1])
catch
end
title(name)
ylabel('rise time [ms]')
xlabel('magnitude [mV]')


if isempty(handles.Lat)
subplot(2,1,2)
else
subplot(2,2,3)
end
bins=[0:.25:25]
h=hist(handles.mags(goods),bins)
bar(bins,h,1)
ylabel('counts')
xlabel('magnitude [mV]')

if ~isempty(handles.Lat)
    subplot(2,2,2)
s=scatter(handles.Lat(goods), handles.mags(goods),25,handles.vstart(goods));
colorbar
set(s,'linewidth',2);
try
    
xlim([0 max(handles.Lat(goods))*1.1])
ylim([0 max(handles.mags(goods))*1.1])
catch
end
xlabel('latency after stim [ms]')
ylabel('magnitude [mV]')


subplot(2,2,4)
ylabel('counts')
xlabel('latency after stim [ms]')
bins=-1:(max(handles.Lat(goods))/20):(max(handles.Lat(goods))*1.2);
h=hist(handles.Lat(goods),bins);
bar(bins,h,1)
ylabel counts
xlabel 'Latency [ms]'
xlim([min(bins) max(bins)])




end

set(gcf, 'PaperPositionmode', 'auto')
set(gcf, 'Paperorientation', 'landscape')
set(gcf,'position',[ 403   246   816   420])
print(f, ['magnitudes_' name], '-dpdf')

[SUCCESS,MESSAGE]=xlswrite(excelname,ExcelOutput)


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
