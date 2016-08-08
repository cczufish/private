<?php
/*
 *@desc 需要动态变化的如开启广告什么的，由服务端设置。 
 */
Class ConfAction extends Action
{
    public function index()
    {
        $this->ajaxReturn(array(),"ok",true);
    }
}
?>
