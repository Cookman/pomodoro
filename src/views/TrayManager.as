package views {

import flash.desktop.*;
import flash.display.*;
import flash.events.*;

import models.LocalStorage;
import models.MindTimerModel;

import mx.events.FlexEvent;
import mx.events.ToolTipEvent;

import mx.managers.ToolTipManager;

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
        ToolTipManager.toolTipClass=TimerTooltip;
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

    private var statisticItem:NativeMenuItem;
    private var gatherStatisticItem:NativeMenuItem;

    public function updatePomodorosCount():void {
        statisticItem.label = LocalStorage.getTodaysCount().toString() + " pomodoro(s)";
    }

    public function setPomodoroStatistic():void {
        gatherStatisticItem.checked = model.showPomodoroStatistic;
    }

    private function create_menu():NativeMenu {
        var iconMenu:NativeMenu = new NativeMenu();

        var showItem:NativeMenuItem = new NativeMenuItem("Show");
        var startItem:NativeMenuItem = new NativeMenuItem("Start");
        var stopItem:NativeMenuItem = new NativeMenuItem("Stop");
        var exitItem:NativeMenuItem = new NativeMenuItem("Exit");
        gatherStatisticItem = new NativeMenuItem("Count poms");
        setPomodoroStatistic();
        statisticItem = new NativeMenuItem(LocalStorage.getTodaysCount().toString() + " pomodoro(s)");
        statisticItem.enabled = false;

        iconMenu.addItem(statisticItem);
        iconMenu.addItem(gatherStatisticItem);
        iconMenu.addItem(showItem);
        iconMenu.addItem(startItem);
        iconMenu.addItem(stopItem);
        iconMenu.addItem(exitItem);

        iconMenu.addEventListener(Event.SELECT, gatherStatisticHandler);
        showItem.addEventListener(Event.SELECT, undock);
        startItem.addEventListener(Event.SELECT, startTimer);
        stopItem.addEventListener(Event.SELECT, stopTimer);
        exitItem.addEventListener(Event.SELECT, exitApp);
        return iconMenu;
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
        var settings:SettingsVO = LocalStorage.loadSettings() as SettingsVO;
        if (settings) {
            settings.showPomodoroStatistic = model.showPomodoroStatistic;
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