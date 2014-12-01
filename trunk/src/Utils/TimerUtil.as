package Utils {

import events.TimerTickEvent;

import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import vo.TimeVO;

public class TimerUtil extends EventDispatcher {

    private var timerInstance:Timer = new Timer(1000);

    public function TimerUtil():void {
        timerInstance.addEventListener(TimerEvent.TIMER, timerHandler);
        timerInstance.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
    }

    public function setTimer(timeVo:TimeVO):void {
        timerInstance.reset();
        timerInstance.repeatCount = timeVo.hours * 60 * 60 + timeVo.minutes * 60 + timeVo.seconds;
    }

    public function startTimer():void {
        timerInstance.start();
    }

    public function stopTimer():void {
        timerInstance.stop();
    }

    private function timerCompleteHandler(event:TimerEvent):void {
        dispatchEvent(new TimerTickEvent(TimerTickEvent.TIMER_COMPLETE));
    }

    private function timerHandler(event:TimerEvent):void {
        dispatchEvent(new TimerTickEvent(TimerTickEvent.TIMER_TICK));
    }
}
}