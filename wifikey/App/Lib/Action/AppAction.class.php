<?php
/*
 *@desc 用于收集用户安装的最近使用的app列表。可以判断出用户最喜欢用哪类工具。用于分析用户偏好
 */
Class AppAction extends BaseAction
{
    public function saveAll()
    {
        Log::write("appAction".var_dump($this->postJson(),true),Log::DEBUG);
        $this->ajaxReturn("","ok",true);
    }

    public function saveRecent()
    {
        Log::write("appacton".var_dump($this->postJson(),true),Log::DEBUG);
        $this->ajaxReturn("","ok",true);
    }
}
?>
