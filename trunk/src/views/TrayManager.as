package views {

import flash.desktop.*;
import flash.display.*;
import flash.events.*;

import models.LocalStorage;
import models.MindTimerModel;

import spark.components.Group;

import vo.SettingsVO;

public class TrayManager extends Group {
    [Bindable]
    private var model:MindTimerModel = MindTimerModel.getInstance();
    [Embed(source="/assets/stop.png")]
    private var IconStoped:Class;
    [Embed(source="/assets/clock.png")]
    private var IconRunning:Class;
    [Embed(source="/assets/clock1.png")]
    private var IconRunning1:Class;
    [Embed(source="/assets/clock2.png")]
    private var IconRunning2:Class;
    [Embed(source="/assets/clock3.png")]
    private var IconRunning3:Class;
    private var clockClass:Class = IconStoped;
    [Bindable]
    private var _icon:BitmapData;
    private var trayIcon:SystemTrayIcon;
    private var _iconNumber:int = 0;
    private var statisticItem:NativeMenuItem;
    private var gatherStatisticItem:NativeMenuItem;

    public function TrayManager() {
        super();
        createIcon();
    }

    public function get iconNumber():int {
        return _iconNumber;
    }

    public function set iconNumber(value:int):void {
        _iconNumber = value;
        createIcon()
    }

    private function createIcon():void {
        if (iconNumber == 0)
            clockClass = IconStoped;
        if (iconNumber == 1)
            clockClass = IconRunning;
        if (iconNumber == 2)
            clockClass = IconRunning1;
        if (iconNumber == 3)
            clockClass = IconRunning2;
        if (iconNumber == 4)
            clockClass = IconRunning3;

        _icon = new BitmapData(16, 16, true, 0xFFFFFF);

        _icon.draw(new clockClass);
        NativeApplication.nativeApplication.icon.bitmaps = [_icon];
        trayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
        trayIcon.menu = create_menu();
        trayIcon.addEventListener(MouseEvent.CLICK, undock);
        this.invalidateDisplayList();
    }

    public function hide():void {
        if (stage.nativeWindow.visible) {
            createIcon();
            stage.nativeWindow.minimize();
            stage.nativeWindow.visible = false;
        }
    }

    public function updatePomodorosCount():void {
        statisticItem.label = LocalStorage.getTodaysCount().toString() + " pomodoro(s)";
    }

    public function setPomodoroStatistic(value:Boolean):void {
       gatherStatisticItem.checked = value;
    }

    private function create_menu():NativeMenu {
        var iconMenu:NativeMenu = new NativeMenu();

        var settingsItem:NativeMenuItem = new NativeMenuItem("Settings");
        var showItem:NativeMenuItem = new NativeMenuItem("Show");
        var startItem:NativeMenuItem = new NativeMenuItem("Start");
        var stopItem:NativeMenuItem = new NativeMenuItem("Stop");
        var exitItem:NativeMenuItem = new NativeMenuItem("Exit");
        gatherStatisticItem = new NativeMenuItem("Count poms");
        gatherStatisticItem.checked=(model.showPomodoroStatistic);
        statisticItem = new NativeMenuItem(LocalStorage.getTodaysCount().toString() + " pomodoro(s)");
        statisticItem.enabled = false;


        iconMenu.addItem(statisticItem);
        iconMenu.addItem(gatherStatisticItem);
        iconMenu.addItem(settingsItem);
        iconMenu.addItem(showItem);
        iconMenu.addItem(startItem);
        iconMenu.addItem(stopItem);
        iconMenu.addItem(exitItem);

        gatherStatisticItem.addEventListener(Event.SELECT, gatherStatisticHandler);
        showItem.addEventListener(Event.SELECT, undock);
        startItem.addEventListener(Event.SELECT, startTimer);
        stopItem.addEventListener(Event.SELECT, stopTimer);
        exitItem.addEventListener(Event.SELECT, exitApp);
        settingsItem.addEventListener(Event.SELECT, showSettings)
        return iconMenu;
    }


    public var settingsShown:Boolean;

    private function showSettings(event:Event):void {
        if (settingsShown) return;
        var w:SettingsWindow = new SettingsWindow()
        w.open();
        settingsShown = true;
        hide();
        setPomodoroStatistic(model.showPomodoroStatistic);
    }

    private function startTimer(event:Event):void {
        if (model.time.notNull) {
            iconNumber = 1;
            createIcon();
            model.timerInstance.startTimer();
        }
    }

    private function stopTimer(event:Event):void {
        iconNumber = 0;
        createIcon();
        model.timerInstance.stopTimer();
    }

    public function changeIcon():void {
        iconNumber += 1;
        if (iconNumber > 4)iconNumber = 1;
        createIcon();
    }

    private function gatherStatisticHandler(e:Event):void {
        gatherStatisticItem.checked = !gatherStatisticItem.checked;
        model.showPomodoroStatistic = gatherStatisticItem.checked;
        var settings:SettingsVO = model.settings;
        if (settings) {
            settings.showPomodoroStatistic = gatherStatisticItem.checked;
            LocalStorage.saveSettings(settings);
        }
    }

    private function undock(event:Event):void {
        show();
    }

    public function show():void {
        stage.nativeWindow.visible = true;
        stage.nativeWindow.restore();
    }

    private function exitApp(e:Event):void {
        stage.nativeWindow.close();
    }

    private function onMouseDown(evt:MouseEvent):void {
        stage.nativeWindow.startMove();
    }
}
}