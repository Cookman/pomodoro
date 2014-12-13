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
    }

    public function initializeManager():void {
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
        if (statisticItem)
            statisticItem.label = countLabel;
    }

    private function get countLabel():String {
        return LocalStorage.getTodaysCount().toString() + ' ' + resourceManager.getString('resources', 'POMODOROS');
    }

    public function setPomodoroStatistic(value:Boolean):void {
        createIcon();
        gatherStatisticItem.checked = value;
    }

    private var iconMenu:NativeMenu;

    private function create_menu():NativeMenu {
        iconMenu = new NativeMenu();

        var settingsItem:NativeMenuItem = new NativeMenuItem(this.resourceManager.getString('resources', 'SETTINGS'));

        var exitItem:NativeMenuItem = new NativeMenuItem(resourceManager.getString('resources', 'EXIT'));
        gatherStatisticItem = new NativeMenuItem(resourceManager.getString('resources', 'COUNT_POMS'));
        gatherStatisticItem.checked = (model.showPomodoroStatistic);

        statisticItem = new NativeMenuItem(countLabel);
        statisticItem.enabled = false;
        iconMenu.addItemAt(statisticItem, 0);


        iconMenu.addItem(gatherStatisticItem);
        iconMenu.addItem(settingsItem);
        iconMenu.addItem(exitItem);
        gatherStatisticItem.addEventListener(Event.SELECT, gatherStatisticHandler);
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