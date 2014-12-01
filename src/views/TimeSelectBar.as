package views {

import models.MindTimerModel;

import mx.controls.ToggleButtonBar;
import mx.events.ItemClickEvent;

import vo.TimeVO;

public class TimeSelectBar extends ToggleButtonBar {
    [Bindable]
    private var model:MindTimerModel = MindTimerModel.getInstance();

    public function TimeSelectBar() {
        super();
        reset();
        this.addEventListener(ItemClickEvent.ITEM_CLICK, itemClickHandler);
    }

    public function reset():void {
        selectedIndex = -1;
    }

    private function itemClickHandler(event:ItemClickEvent):void {
        if (model.timerStatus) {
            model.time = new TimeVO(0, int(event.label), 0);
        }

    }
}
}