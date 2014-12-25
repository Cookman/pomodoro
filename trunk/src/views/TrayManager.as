package views {

import flash.desktop.*;
import flash.display.*;
import flash.events.*;

import models.LocalStorage;
import models.MindTimerModel;

import mx.controls.Alert;
import mx.events.FlexEvent;

import spark.components.Group;

public class TrayManager extends Group {
    [Bindable]
    private var model:MindTimerModel = MindTimerModel.getInstance();
    [Embed(source="/assets/stop.png")]
    private var IconStoped:Class;
    [Embed(source="/assets/clock.png")]
    private var IconRunning0:Class;
    [Embed(source="/assets/clock1.png")]
    private var IconRunning1:Class;
    [Embed(source="/assets/clock2.png")]
    private var IconRunning2:Class;
    [Embed(source="/assets/clock3.png")]
    private var IconRunning3:Class;
    [Embed(source="/assets/clock4.png")]
    private var IconRunning4:Class;
    [Embed(source="/assets/clock5.png")]
    private var IconRunning5:Class;
    [Embed(source="/assets/clock6.png")]
    private var IconRunning6:Class;
    [Embed(source="/assets/clock7.png")]
    private var IconRunning7:Class;
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

        if (iconNumber > 7)iconNumber = 0;
            clockClass = this["IconRunning"+iconNumber];



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
    }

    private var iconMenu:NativeMenu;

    private function create_menu():NativeMenu {
        iconMenu = new NativeMenu();

        var settingsItem:NativeMenuItem = new NativeMenuItem(this.resourceManager.getString('resources', 'SETTINGS'));
        var exitItem:NativeMenuItem = new NativeMenuItem(resourceManager.getString('resources', 'EXIT'));

        if (model.showPomodoroStatistic) {
            statisticItem = new NativeMenuItem(countLabel);
            statisticItem.enabled = false;
            iconMenu.addItemAt(statisticItem, 0);
        }
        iconMenu.addItem(settingsItem);
        iconMenu.addItem(exitItem);
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
        if (iconNumber > 7)iconNumber = 0;
        createIcon();
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