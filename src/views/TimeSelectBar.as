package views {

import flash.events.Event;

import models.MindTimerModel;

import mx.controls.ToggleButtonBar;
import mx.events.ItemClickEvent;

import spark.components.ButtonBar;

import vo.TimeVO;

public class TimeSelectBar extends ButtonBar {
    [Bindable]
    private var model:MindTimerModel = MindTimerModel.getInstance();

    public function TimeSelectBar() {
        super();
        reset();
        this.addEventListener(Event.CHANGE, itemClickHandler);
    }

    public function reset():void {
        selectedIndex = -1;
    }

    private function itemClickHandler(event:Event):void {
        if (model.timerStatus) {
            model.time = new TimeVO(0, int(event.target.selectedItem), 0);
        }

    }
}
}