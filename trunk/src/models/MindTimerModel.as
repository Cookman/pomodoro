package models {
import Utils.TimerUtil;

import events.TimerTickEvent;

import flash.display.DisplayObject;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.managers.PopUpManager;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

import views.AlertWindow;
import views.TimeSelectBar;
import views.TrayManager;

import vo.SettingsVO;
import vo.TimeVO;
import vo.TimerStatuses;

[Bindable]
public class MindTimerModel {

    public static const EN_US:String = "en_US";
    public static const RU_RU:String = "ru_RU";

    private static var _instance:MindTimerModel = null;

    public var time:TimeVO = new TimeVO();
    public var timerStatus:Boolean = true;
    public var timerInstance:TimerUtil = new TimerUtil();
    public var trayIt:TrayManager;
    public var timeTemplateBar:TimeSelectBar;

    public var buttonLabel:String;
    public var lastSelectedTime:String;
    public var lastSelectedMinutes:String;


    public var timePresets:ArrayCollection = new ArrayCollection([1, 5, 10, 25]);


    public var playSound:Boolean = false;

    public var showPomodoroStatistic:Boolean = false;

    public var soundModel:SoundModel = new SoundModel();

    private var resourceManager:IResourceManager = ResourceManager.getInstance();

    public function MindTimerModel(se:singletoneEnforcer):void {
        initialize();
    }

    public static function getInstance():MindTimerModel {
        if (MindTimerModel._instance == null) {
            MindTimerModel._instance = new MindTimerModel(new singletoneEnforcer());
        }
        return MindTimerModel._instance;
    }

    private function initialize():void {
        timerInstance.addEventListener(TimerTickEvent.TIMER_COMPLETE, timerCompleteHandler);
        timerInstance.addEventListener(TimerTickEvent.TIMER_TICK, timerTickHandler);
    }

    public function doLocalization(lang:String):void {
        resourceManager.localeChain = [lang]
        resourceManager.initializeLocaleChain([lang]);
        buttonLabel = resourceManager.getString('resources', 'START');
    }

    public var settings:SettingsVO;

    public function loadSettings():void {
        settings = LocalStorage.loadSettings();
        if (settings) {
            playSound = settings.playSound;
            showPomodoroStatistic = settings.showPomodoroStatistic;
            trayIt.setPomodoroStatistic(settings.showPomodoroStatistic);
            timeTemplateBar.dataProvider = settings.templates;
            doLocalization(settings.language);
        }
    }

    public function startTimer():void {
        if (time.notNull) {
            if (timerStatus != TimerStatuses.STARTED) {
                lastSelectedTime = time.toString();
                lastSelectedMinutes = time.minutes.toString();
            }
            timerStatus = TimerStatuses.STARTED;

            timerInstance.setTimer(time);
            buttonLabel = resourceManager.getString('resources', 'HIDE');
            timerInstance.startTimer();
            trayIt.iconNumber = 1;
            trayIt.hide();
        }
    }

    public function stopTimer():void {
        buttonLabel = resourceManager.getString('resources', 'START');
        timerStatus = TimerStatuses.STOPED;
        timerInstance.stopTimer();
        trayIt.iconNumber = 0;
    }

    public function resetTimer():void {
        time = new TimeVO();
        timerStatus = TimerStatuses.STOPED;
        timerInstance.stopTimer();
        buttonLabel = resourceManager.getString('resources', 'START');
        soundModel.stopSound();
    }

    public function updateTimeTemplates():void {
        timeTemplateBar.dataProvider = settings.templates;
    }

    private function timerCompleteHandler(e:TimerTickEvent):void {
        var showAlert:Boolean = showPomodoroStatistic;
        if (settings) {
            if (settings.useFixedPomodoroLength && settings.pomodoroLength.toString() != lastSelectedMinutes) {
                showAlert = false;
            }
        }

        if (showAlert) {
            PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, AlertWindow, true);
        }
        time = new TimeVO();
        buttonLabel = ResourceManager.getInstance().getString('resources', 'START');
        timerStatus = TimerStatuses.STOPED;
        trayIt.show();
        trayIt.iconNumber = 0;
        if (playSound) {
            soundModel.playSound();
        } else {
            soundModel.stopSound();
        }
    }

    private function timerTickHandler(e:TimerTickEvent):void {
        var hours:int = time.hours;
        var minutes:int = time.minutes;
        var seconds:int = time.seconds;

        seconds -= 1;

        if (seconds < 0) {
            minutes -= 1;
            if (minutes < 0) {
                hours -= 1;

                if (hours >= 0) {
                    minutes = 59;
                }
                else {
                    minutes = 0;
                    hours = 0;
                }
            }
            seconds = 59;
        }
        time.updateTime(hours, minutes, seconds);
        trayIt.changeIcon();
    }

    public function savePomodoro():void {
        LocalStorage.savePomodoro(lastSelectedTime);
        trayIt.updatePomodorosCount();
    }

}
}
class singletoneEnforcer {
}