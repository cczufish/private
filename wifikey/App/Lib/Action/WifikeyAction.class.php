<?php
Class WifikeyAction extends Action
{
    public function getPwds()
    {
        $this->ajaxReturn(array(),"ok",true);
    }

    public function saveUserSsid()
    {
        $this->ajaxReturn("","ok",true);
    }
}
?>
