function varargout = DataExampleGui(varargin)
% DATAEXAMPLEGUI MATLAB code for DataExampleGui.fig
%      DATAEXAMPLEGUI, by itself, creates a new DATAEXAMPLEGUI or raises the existing
%      singleton*.
%
%      H = DATAEXAMPLEGUI returns the handle to a new DATAEXAMPLEGUI or the handle to
%      the existing singleton*.
%
%      DATAEXAMPLEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAEXAMPLEGUI.M with the given input arguments.
%
%      DATAEXAMPLEGUI('Property','Value',...) creates a new DATAEXAMPLEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataExampleGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataExampleGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataExampleGui

% Last Modified by GUIDE v2.5 03-Apr-2013 16:52:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DataExampleGui_OpeningFcn, ...
    'gui_OutputFcn',  @DataExampleGui_OutputFcn, ...
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


% --- Executes just before DataExampleGui is made visible.
function DataExampleGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataExampleGui (see VARARGIN)

% Choose default command line output for DataExampleGui
handles.output = hObject;

handles.savefile = varargin{1}
handles.path=varargin{2}
display('loading data...')
handles.Data=load([varargin{2} varargin{1}])
display(['data loaded from ' varargin{1}])


set(handles.text7,'String',varargin{1})
guidata(hObject, handles);

if isfield(handles.Data,'filteredResponse')
    display('filteredReponse found')
    set(handles.checkbox6,'enable','on');
    
end


if isfield(handles.Data,'filteredResponse2')
    display('filteredReponse2 found')
    set(handles.checkbox6,'enable','on');
    
end


if isfield(handles.Data,'RawResponse')
    display('RawResponse found')
    set(handles.checkbox5,'enable','on');
    set(handles.checkbox1,'enable','on');
end

if isfield(handles.Data,'EEG')
    display('EEG found')
    set(handles.checkbox7,'enable','on');
    set(handles.checkbox2,'enable','on');
end

if isfield(handles.Data,'spikeFindingData')
    if isfield(handles.Data.spikeFindingData,'ppms')
        display('ppms found')
    end
    if isfield(handles.Data.spikeFindingData,'spikes')
        if ~isempty(handles.Data.spikeFindingData.spikes)
            display('spikes found')
            set(handles.checkbox9,'enable','on');
        end
    end
end



if isfield(handles.Data,'spikeFindingData2')
    if isfield(handles.Data.spikeFindingData,'ppms')
        display('ppms2 found')
    end
    if isfield(handles.Data.spikeFindingData2,'spikes')
        if ~isempty(handles.Data.spikeFindingData2.spikes)
            display('spikes2 found')
            set(handles.checkbox9,'enable','on');
        end
    end
end


if isfield(handles.Data,'Triggers')
    if isfield(handles.Data.Triggers,'light')
        display('light trigger found')
        set(handles.checkbox8,'enable','on');
        
    end
    
    if isfield(handles.Data.Triggers,'whisker')
        display('whisker trigger found')
        set(handles.checkbox10,'enable','on');
        
    end
end

guidata(hObject, handles);
%handles
% UIWAIT makes DataExampleGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DataExampleGui_OutputFcn(hObject, eventdata, handles)
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

%check which signals can and should be plotted
rawGo= strcmp(get(handles.checkbox5,'enable'),'on') & get(handles.checkbox5,'value')
filtGo=strcmp(get(handles.checkbox6,'enable'),'on') & get(handles.checkbox6,'value')
eegGo=strcmp(get(handles.checkbox7,'enable'),'on') & get(handles.checkbox7,'value')
whiskerGo=strcmp(get(handles.checkbox10,'enable'),'on') & get(handles.checkbox10,'value')
lightGo=strcmp(get(handles.checkbox8,'enable'),'on') & get(handles.checkbox8,'value')
spikesGo=strcmp(get(handles.checkbox9,'enable'),'on') & get(handles.checkbox9,'value')

ppms=handles.Data.spikeFindingData.ppms;

scalebarOn=0;
%assign signals to local variables;
if rawGo,v=handles.Data.RawResponse.data;
    if isfield(handles.Data, 'preprocessedData')
        if isfield(handles.Data.preprocessedData, 'multiplier')
            v=v/handles.Data.preprocessedData.multiplier;
            scalebarOn=1;
            display('scaled raw voltage')
        end
    end
    
    %filter the data?
    filterOn=get(handles.checkbox1,'value') & strcmp(get(handles.checkbox1,'enable'),'on')
    %get filter bandpass
    minHz=str2double(get(handles.edit1,'String'));
    maxHz=str2double(get(handles.edit2,'String'));
    
    %filter if required
    if filterOn
        display('filtering....')
        niqf = ppms*1000/2;
        [b,a] = butter(2,[minHz maxHz]/niqf);
        v=filtfilt(b,a,v);
        display('done filtering')
    end
    
    mv=max(v);
    v=v/mv;
    N=numel(v);
end;


if eegGo,eeg=handles.Data.EEG.data;
    %filter the data?
    filterOn=get(handles.checkbox2,'value') & strcmp(get(handles.checkbox2,'enable'),'on')
    %get filter bandpass
    minHz=str2double(get(handles.edit3,'String'));
    maxHz=str2double(get(handles.edit4,'String'));
    
    %filter if required
    if filterOn
        display('filtering....')
        niqf = ppms*1000/2;
        [b,a] = butter(2,[minHz maxHz]/niqf);
        eeg=filtfilt(b,a,eeg);
        display('done filtering')
    end
    eeg=eeg-min(eeg);
    eeg=eeg/max(eeg);
    N=numel(eeg);
end


if filtGo,fv=handles.Data.filteredResponse.data;
    fv=zscore(fv);fv=fv/max(fv);
    N=numel(fv);
    try
        fv2=handles.Data.filteredResponse2.data;
        fv2=zscore(fv2);fv2=fv2/max(fv2);
    catch
    end
end

if whiskerGo,whisker=handles.Data.Triggers.whisker;
    whisker=abs(whisker);
    whisker=whisker/max(whisker)/2;
    N=numel(whisker);
end;

if lightGo,light=handles.Data.Triggers.light;
    light=light/max(light)/2;
    N=numel(light);
end;

if spikesGo,spikes=handles.Data.spikeFindingData.spikes;
    
    try
        spikes2=handles.Data.spikeFindingData2.spikes
    catch
    end
end


try
    s=median(fv(spikes))
    fv(find(fv>s*3))=s;
    fv(find(fv<-s*3))=-s;
    fv=zscore(fv);fv=fv/max(fv);
    
     s=median(fv2(spikes2))
    fv2(find(fv2>s*3))=s;
    fv2(find(fv2<-s*3))=-s;
    fv2=zscore(fv2);fv2=fv2/max(fv2);
    
catch
end



window=round(str2num(get(handles.edit6,'String'))*ppms);
n=round(str2num(get(handles.edit5,'String')));
spacer=str2num(get(handles.edit8,'String'));
totalshift=round(str2num(get(handles.edit7,'String'))*ppms);

%make indices and time vector (seconds);
indices=[1:window]+totalshift;
pt=[1:window]/ppms/1000;

% make figure;
fig=figure; hold on;

shift=0;


for i=1:n
    if max(indices) <=N
        legstr={};
        if eegGo
            plot(pt,eeg(indices)+shift,'color',[.5 .5 .7],'linewidth',1.5);
            shift=shift+max(eeg(indices))+spacer;
            legstr=[legstr 'LFP'];
        end
        
        
        if lightGo
            plot(pt,light(indices)+shift,'b','linewidth',2);
            if ~whiskerGo
                shift=shift+max(light(indices))+spacer;
            end
            legstr=[legstr 'light'];
        end
        
        if whiskerGo
            plot(pt,whisker(indices)+shift,'color',[0 .5 0],'linewidth',1.5);
            shift=shift+max(whisker(indices))+spacer;
            legstr=[legstr 'whisker'];
        end
        
        
        if rawGo
            plot(pt,v(indices)+shift,'k','linewidth',1);
            shift=shift+max(v(indices))+spacer;
            legstr=[legstr 'raw v'];
        end
        
        if filtGo
            plot(pt,fv(indices)+shift,'k');
            shift=shift+max(fv(indices))+spacer*.1;
            legstr=[legstr 'filt v'];
        end
        
        if spikesGo
            sp=spikes(ismember(spikes,indices))-min(indices)+1;
            plot(sp/ppms/1000, ones(size(sp))*shift,'r.','markersize',15)
            shift=shift+spacer*2;
            legstr=[legstr 'spikes'];
        end
        
        try
            if filtGo
                plot(pt,fv2(indices)+shift,'color', [.5 .5 .5]);
                shift=shift+max(fv2(indices))+spacer*.1;
                legstr=[legstr 'filt v2'];
            end
            
            if spikesGo
                sp=spikes2(ismember(spikes2,indices))-min(indices)+1;
                plot(sp/ppms/1000, ones(size(sp))*shift,'.m','markersize',15)
                shift=shift+spacer;
                legstr=[legstr 'spikes2'];
            end
        catch
        end
        
        
        indices=indices+window;
        shift=shift+2*spacer;
        
        
        if i==1
            l=legend(legstr,'location','southoutside','orientation','horizontal')
            legend boxoff
        end
        
    end
end

axis tight;
xlim([min(pt) max(pt)])
ylim([min(get(gca,'ylim'))-spacer shift])


if scalebarOn
    sblength=10/mv;
    x=round(window)*.01/ppms/1000;
    ys=diff(get(gca,'ylim'))/10;
    
    plot([x x],[ys ys+sblength],'k','linewidth',4)
    t=text(x*1.5, mean([ys ys+sblength]),['10 mV'])
end

if n>1
set(gca,'ytick',[])
end
set(fig, 'PaperPositionmode', 'auto')
set(fig,'paperorientation','landscape')
set(fig,'position',[ 1          41        1366         652])
xlabel('Time [s]')
box off
title([handles.path '\' handles.savefile ' ' datestr(now)],'fontsize',10,'fontname','arial')

l=legend(legstr,'location','southoutside','orientation','horizontal')
legend boxoff


if get(handles.checkbox4,'value')
    figfile=[handles.path '\' handles.savefile(1:(numel(handles.savefile)-4)) '_ExampleData']
    print(fig,figfile,'-dpdf')
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(handles.figure1)
display('Quit plotting gui!')


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


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



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


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9



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
