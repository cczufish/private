<?php
/*
 *@desc 扩展Action类。
 */
Class BaseAction extends Action
{

    public function postJson()
    {
        return json_decode(file_get_contents("php://input"));
    }
}
?>
