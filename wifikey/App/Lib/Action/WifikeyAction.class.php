<?php
/*
 *@desc 核心业务，用于收集用户扫描到的热点和下发密码
 */
Class WifikeyAction extends Action
{
    public function getPwds()
    {
        Log::write(var_dump($_REQUEST,true),Log::DEBUG);
        $this->ajaxReturn(array(),"ok",true);
    }

    /*
     * @desc 收集用户扫描到热点。同时里面会包含用户尝试的密码状态。
     * 别名，saveUserSsid, 
     *
     */
    public function s()
    {
        Log::write(var_dump($_REQUEST,true),Log::DEBUG);
        $this->ajaxReturn("","ok",true);
    }
}
?>
